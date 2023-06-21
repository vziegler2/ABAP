REPORT zzone_cv035.
****************************************************************
* Class Definition
****************************************************************
CLASS lcl_events DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: on_added_function FOR EVENT added_function OF cl_salv_events_table,
      on_double_click   FOR EVENT double_click   OF cl_salv_events_table IMPORTING row.
ENDCLASS.
****************************************************************
* Variables
****************************************************************
TABLES: draw, zcv23doc.

TYPES: BEGIN OF gty_outtab,
         runtime  TYPE i,
         sstgrp   TYPE zcv23doc-sstgrp,
         outnr    TYPE zcv23out-outnr,
         subnr    TYPE zcv23out-subnr,
         indatum  TYPE zcv23doc-indatum,
         inzeit   TYPE zcv23doc-inzeit,
         outdatum TYPE zcv23out-outdatum,
         outzeit  TYPE zcv23out-outzeit,
         dokar    TYPE zcv23out-dokar,
         doknr    TYPE zcv23out-doknr,
         dokvr    TYPE zcv23out-dokvr,
         doktl    TYPE zcv23out-doktl,
         message  TYPE zcv23out-message,
       END OF gty_outtab,
       gty_outtab_t TYPE STANDARD TABLE OF gty_outtab WITH DEFAULT KEY.

DATA: gt_outtab  TYPE gty_outtab_t ##NEEDED,
      gs_outtab  TYPE gty_outtab ##NEEDED,
      gv_intime  TYPE timestampl ##NEEDED,
      gv_outtime TYPE timestampl ##NEEDED.
****************************************************************
* Initialization
****************************************************************
* Dieses Programm muss bis spätestens am 19.06.2024 gelöscht werden.
INITIALIZATION.
  CHECK sy-datum GT '20240619'.
  MESSAGE e065(zs).
****************************************************************
* Selection-Screen
****************************************************************
  SELECT-OPTIONS: so_indat FOR zcv23doc-indatum,
                  so_dokar FOR draw-dokar.

  PARAMETERS: pa_rtime TYPE i.
****************************************************************
* START-OF-SELECTION
****************************************************************
START-OF-SELECTION.
  MESSAGE i068(zs) WITH '19.06.2024'.
****************************************************************
* SELECT-Statement
****************************************************************
  SELECT 0 AS runtime,
         a~sstgrp,
         b~outnr,
         b~subnr,
         a~indatum,
         a~inzeit,
         b~outdatum,
         b~outzeit,
         b~dokar,
         b~doknr,
         b~dokvr,
         b~doktl,
         b~message
  FROM zcv23doc AS a
  JOIN zcv23out AS b ON a~sstgrp   = b~sstgrp AND
                        a~innummer = b~outnr
  WHERE a~indatum IN @so_indat AND
        b~dokar   IN @so_dokar
  ORDER BY outnr,
           subnr DESCENDING
  INTO @gs_outtab.
* Calculate runtime
    gv_intime = |{ gs_outtab-indatum }{ gs_outtab-inzeit }|.
    gv_outtime = |{ gs_outtab-outdatum }{ gs_outtab-outzeit }|.
    gs_outtab-runtime = cl_abap_tstmp=>subtract( tstmp1 = gv_outtime
                                                 tstmp2 = gv_intime ).
    IF gs_outtab-runtime >= pa_rtime.
      APPEND gs_outtab TO gt_outtab.
    ENDIF.
  ENDSELECT.
* Delete every line in the output table which includes not the maximum subnr
  DELETE ADJACENT DUPLICATES FROM gt_outtab COMPARING sstgrp outnr.
****************************************************************
* SALV-Table
****************************************************************
  TRY.
      DATA: go_salv TYPE REF TO cl_salv_table ##NEEDED.
      DATA(go_events) = NEW lcl_events(  ) ##NEEDED.
      cl_salv_table=>factory( EXPORTING r_container  = cl_gui_container=>default_screen
                              IMPORTING r_salv_table = go_salv
                              CHANGING  t_table      = gt_outtab ).

      go_salv->get_functions( )->set_all( abap_true ).
      go_salv->get_functions( )->add_function( name     = 'DOKUMENT'
                                               icon     = |{ icon_ws_plane }|
                                               text     = 'Dokument' ##NO_TEXT
                                               tooltip  = 'Gewählten Dokumentinfosatz anzeigen' ##NO_TEXT
                                               position = if_salv_c_function_position=>right_of_salv_functions ).

      SET HANDLER go_events->on_added_function FOR go_salv->get_event( ).
      SET HANDLER go_events->on_double_click FOR go_salv->get_event(  ).

      go_salv->get_display_settings( )->set_list_header( |Verarbeitungszeiten ({ lines( gt_outtab ) })| ) ##NO_TEXT.
      go_salv->get_display_settings( )->set_striped_pattern( abap_true ).
      go_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
      go_salv->get_sorts(  )->add_sort( columnname = 'RUNTIME' sequence = if_salv_c_sort=>sort_down ).
      go_salv->get_columns( )->set_optimize( abap_true ).
      LOOP AT go_salv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<gv_column>) ##NEEDED.
        DATA(go_col2) = <gv_column>-r_column ##NEEDED.
        go_col2->set_alignment( if_salv_c_alignment=>centered ).
        IF <gv_column>-columnname = 'RUNTIME'.
          go_col2->set_long_text( 'Laufzeit' ) ##NO_TEXT.
          go_col2->set_medium_text( 'Laufzeit' ) ##NO_TEXT.
          go_col2->set_short_text( 'Laufzeit' ) ##NO_TEXT.
        ENDIF.
      ENDLOOP.

      go_salv->display( ).
      WRITE: space.
    CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found cx_salv_wrong_call INTO DATA(cx_error) ##NEEDED.
      MESSAGE i435(00) WITH |{ cx_error->get_text( ) }|.
  ENDTRY.
****************************************************************
* Class Implementation
****************************************************************
CLASS lcl_events IMPLEMENTATION.
  METHOD on_added_function.
    DATA(lt_sel_rows) = go_salv->get_selections( )->get_selected_rows( ).

    IF lines( lt_sel_rows ) <> 1.
      MESSAGE i435(00) WITH 'Bitte genau eine Zeile auswählen.' ##NO_TEXT.
    ELSE.
      READ TABLE gt_outtab INTO DATA(ls_outtab) INDEX lt_sel_rows[ 1 ].

      SET PARAMETER ID 'CV1' FIELD ls_outtab-doknr.
      SET PARAMETER ID 'CV2' FIELD ls_outtab-dokar.
      SET PARAMETER ID 'CV3' FIELD ls_outtab-dokvr.
      SET PARAMETER ID 'CV4' FIELD ls_outtab-doktl.

      CALL TRANSACTION 'CV03N' WITHOUT AUTHORITY-CHECK AND SKIP FIRST SCREEN.
    ENDIF.
  ENDMETHOD.

  METHOD on_double_click.
    READ TABLE gt_outtab INTO DATA(ls_outtab) INDEX row.

    SET PARAMETER ID 'CV1' FIELD ls_outtab-doknr.
    SET PARAMETER ID 'CV2' FIELD ls_outtab-dokar.
    SET PARAMETER ID 'CV3' FIELD ls_outtab-dokvr.
    SET PARAMETER ID 'CV4' FIELD ls_outtab-doktl.

    CALL TRANSACTION 'CV03N' WITHOUT AUTHORITY-CHECK AND SKIP FIRST SCREEN.
  ENDMETHOD.
ENDCLASS.