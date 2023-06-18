****************************************************************
* Description.......: Compares the processing times of documents
*                     and displays a table of high times
* Realized by.......: Vikram Ziegler (Academic Work)
*---------------------------------------------------------------
* Change History....: Finished v1.0.0 (16.06.2023)
****************************************************************
REPORT zzone_cv035.
****************************************************************
* Class Definition
****************************************************************
CLASS lcl_events DEFINITION.
  PUBLIC SECTION.
    METHODS: on_added_function FOR EVENT added_function OF cl_salv_events_table IMPORTING e_salv_function
                                                                                          sender,
             on_double_click   FOR EVENT double_click   OF cl_salv_events_table IMPORTING column
                                                                                          row
                                                                                          sender.
ENDCLASS.
****************************************************************
* Variables
****************************************************************
TABLES: zcv23doc, zcv23out.

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

DATA: gt_outtab  TYPE gty_outtab_t,
      gv_intime  TYPE timestampl,
      gv_outtime TYPE timestampl.
****************************************************************
* Selection-Screen
****************************************************************
SELECTION-SCREEN BEGIN OF BLOCK bl0 WITH FRAME TITLE TEXT-000.
  SELECT-OPTIONS: so_indat FOR zcv23doc-indatum,
                  so_dokar FOR zcv23out-dokar.

  PARAMETERS: pa_rtime TYPE i.
SELECTION-SCREEN END OF BLOCK bl0.
****************************************************************
* SELECT-Statement
****************************************************************
SELECT *
FROM zcv23doc AS a
JOIN zcv23out AS b ON a~sstgrp = b~sstgrp AND a~innummer = b~outnr
WHERE a~indatum IN @so_indat AND b~dokar IN @so_dokar
INTO CORRESPONDING FIELDS OF TABLE @gt_outtab.
****************************************************************
* Calculate runtime and delete unnecessary lines
****************************************************************
LOOP AT gt_outtab ASSIGNING FIELD-SYMBOL(<gs_outtab>).
  gv_intime = |{ gt_outtab[ sy-tabix ]-indatum }{ gt_outtab[ sy-tabix ]-inzeit }|.
  gv_outtime = |{ gt_outtab[ sy-tabix ]-outdatum }{ gt_outtab[ sy-tabix ]-outzeit }|.
  <gs_outtab>-runtime = cl_abap_tstmp=>subtract( tstmp1 = gv_outtime
                                                 tstmp2 = gv_intime ).
* Delete every line with a smaller runtime then the parameter
  IF <gs_outtab>-runtime < pa_rtime.
    DELETE gt_outtab INDEX sy-tabix.
  ENDIF.
ENDLOOP.
* Copy the output table and delete every line with only one subnr
DATA(gt_outtab2) = gt_outtab.
SORT gt_outtab2 BY subnr DESCENDING.
DELETE gt_outtab2 WHERE subnr = 1.
* Delete every line in the output table which includes not the maximum subnr
LOOP AT gt_outtab2 ASSIGNING FIELD-SYMBOL(<gs_outtab2>).
  DELETE gt_outtab WHERE sstgrp = <gs_outtab2>-sstgrp AND outnr = <gs_outtab2>-outnr AND subnr < <gs_outtab2>-subnr.
ENDLOOP.
****************************************************************
* SALV-Table
****************************************************************
TRY.
    DATA: go_salv TYPE REF TO cl_salv_table.
    DATA(go_events) = NEW lcl_events(  ).
    cl_salv_table=>factory( EXPORTING r_container  = cl_gui_container=>default_screen
                            IMPORTING r_salv_table = go_salv
                            CHANGING  t_table      = gt_outtab ).

    go_salv->get_functions( )->set_all( abap_true ).
    go_salv->get_functions( )->add_function( name     = |DOKUMENT|
                                             icon     = |{ icon_ws_plane }|
                                             text     = |Dokument|
                                             tooltip  = |Gewählten Dokumentinfosatz anzeigen|
                                             position = if_salv_c_function_position=>right_of_salv_functions ).

    SET HANDLER go_events->on_added_function FOR go_salv->get_event( ).
    SET HANDLER go_events->on_double_click FOR go_salv->get_event(  ).

    go_salv->get_display_settings( )->set_list_header( |Verarbeitungszeiten ({ lines( gt_outtab ) })| ).
    go_salv->get_display_settings( )->set_striped_pattern( abap_true ).
    go_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
    go_salv->get_sorts(  )->add_sort( columnname = 'RUNTIME' sequence = if_salv_c_sort=>sort_down ).
    go_salv->get_columns( )->set_optimize( abap_true ).
    LOOP AT go_salv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<c>).
      DATA(o_col2) = <c>-r_column.
      o_col2->set_alignment( if_salv_c_alignment=>centered ).
    ENDLOOP.

    go_salv->display( ).
    WRITE: space.
  CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found cx_salv_wrong_call INTO DATA(cx_error).
    MESSAGE i435(00) WITH |{ cx_error->get_text( ) }|.
ENDTRY.
****************************************************************
* Class Implementation
****************************************************************
CLASS lcl_events IMPLEMENTATION.
  METHOD on_added_function.
    DATA(lt_sel_rows) = go_salv->get_selections( )->get_selected_rows( ).

    IF lines( lt_sel_rows ) <> 1.
      MESSAGE i435(00) WITH |Bitte genau eine Zeile auswählen.|.
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