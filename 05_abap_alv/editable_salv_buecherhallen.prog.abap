REPORT zcvvz_001.

CLASS lcl_events DEFINITION.

  PUBLIC SECTION.
    METHODS: on_added_function FOR EVENT added_function OF cl_salv_events_table IMPORTING e_salv_function
                                                                                          sender.
  PROTECTED SECTION.
ENDCLASS.

START-OF-SELECTION.
  DATA: go_salv      TYPE REF TO cl_salv_table,
        gv_edit_flag TYPE flag VALUE abap_false.

  DATA(go_events) = NEW lcl_events( ).
  DATA(column_names_itab) = VALUE zvz_salv_set_column_names( ( spalte = 'MANDT' name = 'Mandant' )
                                                             ( spalte = 'ID' name = 'ID' )
                                                             ( spalte = 'LOCATION' name = 'Location' )
                                                             ( spalte = 'OPEN_HOURS' name = 'Opening hours' ) ).

  SELECT mandt,
         id,
         location,
         open_hours
  FROM zcvvz_bib
  INTO TABLE @DATA(gt_outtab).

  TRY.
      cl_salv_table=>factory( EXPORTING r_container  = cl_gui_container=>default_screen
                              IMPORTING r_salv_table = go_salv
                              CHANGING  t_table      = gt_outtab ).

      DATA(go_fts) = NEW zcl_cvvz_salv( io_salv        = go_salv
                                        io_outtab      = REF #( gt_outtab )
                                        iv_tabletype   = 'ZCVVZ_BIB'
                                        iv_list_header = |Bücherhallen Hamburg| ).
      go_fts->set_column_names( column_names_itab = column_names_itab ).
      go_fts->hide_column( lv_colnam = 'MANDT' ).
      DATA(gt_keyfields) = go_fts->get_key_fields_of_ddic_table( 'ZCVVZ_BIB' ).

      go_salv->get_functions( )->add_function( name     = 'EDIT'
                                               icon     = |{ icon_ws_plane }|
                                               text     = 'Edit'
                                               tooltip  = 'Bearbeiten'
                                               position = if_salv_c_function_position=>right_of_salv_functions ).

      go_salv->get_functions( )->add_function( name     = 'SAVE'
                                               icon     = |{ icon_ws_ship }|
                                               text     = 'Save'
                                               tooltip  = 'Speichern'
                                               position = if_salv_c_function_position=>right_of_salv_functions ).

      go_salv->get_functions( )->add_function( name     = 'INSERT'
                                               icon     = |{ icon_ws_rail }|
                                               text     = 'Insert'
                                               tooltip  = 'Einfügen'
                                               position = if_salv_c_function_position=>right_of_salv_functions ).

      go_salv->get_functions( )->add_function( name     = 'DELETE'
                                               icon     = |{ icon_ws_post }|
                                               text     = 'Delete'
                                               tooltip  = 'Löschen'
                                               position = if_salv_c_function_position=>right_of_salv_functions ).

      SET HANDLER go_events->on_added_function FOR go_salv->get_event( ).

      go_salv->display( ).
      WRITE: space.
    CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found cx_salv_wrong_call INTO DATA(cx_error).
      MESSAGE i435(00) WITH |{ cx_error->get_text( ) }|.
  ENDTRY.

CLASS lcl_events IMPLEMENTATION.
  METHOD on_added_function.
    CASE e_salv_function.
      WHEN 'EDIT'.
        go_fts->edit_button_click( it_keyfields = gt_keyfields ).
      WHEN 'SAVE'.
        go_fts->save_button_click(  ).
      WHEN 'INSERT'.
        DATA(lv_id) = lines( gt_outtab ).
        IF gt_outtab[ lines( gt_outtab ) ]-id <= lines( gt_outtab ).
          DATA(lv_count) = 0.
          LOOP AT gt_outtab ASSIGNING FIELD-SYMBOL(<ls_outtab>).
            CHECK lv_count = <ls_outtab>-id.
            lv_count += 1.
          ENDLOOP.
          lv_id = lv_count.
        ELSEIF line_exists( gt_outtab[ lv_id + 1 ] ).
          lv_id += 1.
        ENDIF.

        APPEND VALUE zcvvz_bib( id = lv_id location = '' ) TO gt_outtab.
        SORT gt_outtab BY id.

        IF go_fts->mv_edit_flag = abap_false.
          go_fts->edit_button_click( it_keyfields = gt_keyfields ).
        ELSE.
          go_salv->refresh( ).
        ENDIF.
      WHEN 'DELETE'.
        DATA(lt_sel_rows) = go_salv->get_selections( )->get_selected_rows( ).
        DATA lt_del_rows TYPE TABLE OF zcvvz_bib.

        SORT lt_sel_rows DESCENDING.

        LOOP AT lt_sel_rows ASSIGNING FIELD-SYMBOL(<ls_sel_row>).
          APPEND gt_outtab[ <ls_sel_row> ] TO lt_del_rows.
          DELETE gt_outtab INDEX <ls_sel_row>.
        ENDLOOP.

        DELETE zcvvz_bib FROM TABLE lt_del_rows.
        go_salv->refresh( ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.