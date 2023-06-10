REPORT zcvvz_000.

*CLASS lcl_events DEFINITION.
*
*  PUBLIC SECTION.
*    CLASS-METHODS: on_toolbar_click FOR EVENT added_function OF cl_salv_events_table IMPORTING e_salv_function
*                                                                                               sender.
*  PROTECTED SECTION.
*  PRIVATE SECTION.
*
*ENDCLASS.
*
*CLASS lcl_events IMPLEMENTATION.
*  METHOD on_toolbar_click.
*    CASE e_salv_function.
*      WHEN 'EXPORT'.
*        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Export-Button funktioniert'.
*      WHEN 'IMPORT'.
*        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Import-Button funktioniert'.
*    ENDCASE.
*  ENDMETHOD.
*
*ENDCLASS.

CLASS lcl_events DEFINITION FINAL.

  PUBLIC SECTION.
    CLASS-METHODS: on_link_click FOR EVENT link_click OF cl_salv_events_table IMPORTING column
                                                                                        row
                                                                                        sender.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_events IMPLEMENTATION.
  METHOD on_link_click.
    MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Zellbutton funktioniert'.
  ENDMETHOD.

ENDCLASS.

TYPES: BEGIN OF gty_outtab.
         INCLUDE STRUCTURE draw.
TYPES:   color      TYPE lvc_t_scol,
         i_celltype TYPE salv_t_int4_column,
       END OF gty_outtab,
       gty_outtab_t TYPE STANDARD TABLE OF gty_outtab WITH EMPTY KEY.

DATA: gt_outtab   TYPE gty_outtab_t,
      go_salv     TYPE REF TO cl_salv_table,
      gt_celltype TYPE salv_t_int4_column.

START-OF-SELECTION.
  SELECT *
  FROM draw
  WHERE dokar LIKE 'ZV%'
  INTO CORRESPONDING FIELDS OF TABLE @gt_outtab.

  LOOP AT gt_outtab ASSIGNING FIELD-SYMBOL(<gs_outtab>).
    CLEAR: gt_celltype.
    IF <gs_outtab>-dokst = 'RL'.
      <gs_outtab>-color = VALUE #( ( fname     = 'DOKVR'
                                     color-col = 5
                                     color-int = 0
                                     color-inv = 0 ) ).
      APPEND VALUE salv_s_int4_column( columnname = 'DOKST'
                                       value      = if_salv_c_cell_type=>button ) TO gt_celltype.
      <gs_outtab>-i_celltype = gt_celltype.
    ELSEIF <gs_outtab>-dokst = 'PY'.
      <gs_outtab>-color = VALUE #( ( color-col = 3
                                     color-int = 0
                                     color-inv = 0 ) ).
    ELSE.
      <gs_outtab>-color = VALUE #( ( color-col = 6
                                     color-int = 0
                                     color-inv = 0
                                     nokeycol  = 'X' ) ).
      APPEND VALUE salv_s_int4_column( columnname = 'DOKST'
                                       value      = if_salv_c_cell_type=>hotspot ) TO gt_celltype.
      <gs_outtab>-i_celltype = gt_celltype.
    ENDIF.
  ENDLOOP.

  TRY.
      cl_salv_table=>factory( EXPORTING r_container  = cl_gui_container=>default_screen
                              IMPORTING r_salv_table = go_salv
                              CHANGING  t_table      = gt_outtab ).

*      DATA(go_column) = CAST cl_salv_column_table( go_salv->get_columns( )->get_column( 'DOKST' ) ).               " Ganze Spalte zu Buttons machen
*      go_column->set_icon( if_salv_c_bool_sap=>true ).
*      go_column->set_cell_type( if_salv_c_cell_type=>button ).
*      SET HANDLER lcl_events=>on_link_click FOR go_salv->get_event( ).

*    SET HANDLER lcl_events=>on_toolbar_click FOR go_salv->get_event( ).                                            "Toolbutton hinzufügen
*    DATA(o_col) = CAST cl_salv_column_table( go_salv->get_columns(  )->get_column( 'link_column' ) ).
*    o_col->set_cell_type( if_salv_c_cell_type=>hotspot ).

      go_salv->get_functions( )->set_all( abap_true ).
*    go_salv->get_functions( )->add_function( name     = |EXPORT|
*                                             icon     = |{ icon_ws_plane }|
*                                             text     = |Export|
*                                             tooltip  = |Daten exportieren|
*                                             position = if_salv_c_function_position=>right_of_salv_functions ).
      go_salv->get_display_settings( )->set_list_header( 'Dokumentinfosätze' ).
      go_salv->get_display_settings( )->set_striped_pattern( abap_true ).
      go_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
      go_salv->get_sorts( )->add_sort( columnname = 'DOKAR' sequence = if_salv_c_sort=>sort_up ).
      go_salv->get_columns( )->set_optimize( abap_true ).
      go_salv->get_columns( )->set_cell_type_column( 'I_CELLTYPE' ).
*    DATA(o_col) = CAST cl_salv_column_table( go_salv->get_columns(  )->get_column( 'DOKST' ) ).                    "Spalte färben < Zeile färben
*    o_col->set_color( VALUE #( col = 5 int = 0 inv = 0 ) ).
      go_salv->get_columns( )->set_color_column( 'COLOR' ).
      LOOP AT go_salv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<c>).
        DATA(o_col2) = <c>-r_column.
        o_col2->set_alignment( if_salv_c_alignment=>centered ).
      ENDLOOP.
      go_salv->display( ).
      WRITE: space.
    CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found cx_salv_wrong_call INTO DATA(cx_error).
      MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH |{ cx_error->get_text( ) }|.
  ENDTRY.