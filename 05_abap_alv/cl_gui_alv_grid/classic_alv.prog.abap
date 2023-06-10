****************************************************************
* Übersprungen:
*
*  - S. 24-30 Drag and Drop, Tree Control
*  - S. 32 Zelle einfärben
*  - S. 34 Zelle als Pushbutton
*  - S. 38 table_refresh fehlt (s. Lesezeichen)
*  - S. 40 Conversion Exit
*  - S. 42 ALV in Netzwerken, Mini/Midi-ALV und Methoden
*
****************************************************************
REPORT zcvvz_002.

TABLES: zcvvz_st_03.

TYPES: BEGIN OF gty_draw.
         INCLUDE STRUCTURE draw.
TYPES:   light     TYPE i,
         linecolor TYPE char4,
         " ct        TYPE lvc_t_scol, "Zelle einfärben
         " ct        TYPE lvc_t_drdr, "Zelle als Pushbutton
         hl_fname  TYPE int4,
       END OF gty_draw,
       gty_draw_t TYPE STANDARD TABLE OF zcvvz_st_03 WITH EMPTY KEY.

DATA: go_cc         TYPE REF TO cl_gui_custom_container,
      go_alv        TYPE REF TO cl_gui_alv_grid,
      gs_disvariant TYPE disvariant,
      gs_layout     TYPE lvc_s_layo,
      gt_outtab     TYPE gty_draw_t,
      gt_fieldcat   TYPE lvc_t_fcat,
      gs_fieldcat   TYPE lvc_s_fcat,
      gt_hypetab    TYPE lvc_t_hype,
      gs_hype       TYPE lvc_s_hype.

DATA(gt_fgtexts) = VALUE lvc_t_sgrp( ( sp_group = 1 text = 'Main' )
                                     ( sp_group = 2 text = 'Additional' ) ).

gs_disvariant-report = sy-repid.
gs_layout-grid_title = 'Dokumentinfosätze'.
gs_layout-excp_fname = 'LIGHT'.
gs_layout-excp_led   = 'X'.
gs_layout-info_fname = 'LINECOLOR'.
*gs_layout-ctab_fname = 'COLOR'.

CLASS lcl_event_receiver DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object
                                                                           e_interactive
                                                                           sender,
      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm
                                                                              sender,
      handle_context_menu FOR EVENT context_menu_request OF cl_gui_alv_grid IMPORTING e_object
                                                                                      sender,
      handle_menu_button FOR EVENT menu_button OF cl_gui_alv_grid IMPORTING e_object
                                                                            e_ucomm
                                                                            sender.
  PRIVATE SECTION.
    DATA: lt_std_fcodes TYPE ui_functions,
          lt_own_fcodes TYPE ui_functions.
ENDCLASS.

CLASS lcl_event_receiver IMPLEMENTATION.
  METHOD handle_toolbar.
    APPEND VALUE stb_button( butn_type = 3 ) TO e_object->mt_toolbar.

    APPEND VALUE stb_button( butn_type = 2
                             function = 'EXPORT'
                             icon = icon_ws_plane
                             quickinfo = 'Daten importieren'
                             text = 'Export'
                             disabled = ' ' ) TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN 'EXCEL'.
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Excel-Buttoneintrag funktioniert'.
      WHEN 'PDF'.
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'PDF-Buttoneintrag funktioniert'.
      WHEN 'DEL'.
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Kontextmenü-Eintrag funktioniert'.
      WHEN 'COL'.
        go_alv->refresh_table_display(  ).
    ENDCASE.
  ENDMETHOD.

  METHOD handle_context_menu.
    DATA: lv_sel_col TYPE i,
          lt_fcodes  TYPE ui_functions.

    CLEAR lt_fcodes.
    APPEND cl_gui_alv_grid=>mc_fc_col_optimize TO lt_fcodes.

    IF lt_own_fcodes IS INITIAL.
      APPEND 'DEL' TO lt_own_fcodes.
    ENDIF.

    e_object->add_function( fcode = 'DEL'
                            text  = 'Löschen' ).

    go_alv->get_current_cell( IMPORTING e_col = lv_sel_col ).

    IF lv_sel_col <> 1.
      e_object->hide_functions( fcodes = lt_own_fcodes ). "show_functions to undo
      e_object->disable_functions( fcodes = lt_fcodes ).  "enable_functions to undo
    ENDIF.
  ENDMETHOD.

  METHOD handle_menu_button.
    IF e_ucomm = 'EXPORT'.
      e_object->add_function( fcode = 'EXCEL'
                              text  = 'Excel').
      e_object->add_function( fcode = 'PDF'
                              text  = 'PDF').
    ENDIF.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  CALL SCREEN 100.

  INCLUDE zcvvz_002_status_0100o01.

  INCLUDE zcvvz_002_user_command_0100i01.