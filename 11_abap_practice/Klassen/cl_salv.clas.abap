CLASS zcl_cvvz_salv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_alv_rm_grid_friend.

    METHODS: constructor        IMPORTING io_salv           TYPE REF TO cl_salv_table
                                          iv_list_header    TYPE char70
                                          iv_sort_column    TYPE char30,
             settings,
             change_celltype    IMPORTING iv_columnname     TYPE char30
                                          iv_celltype       TYPE salv_de_celltype,
             color_column       IMPORTING iv_columnname     TYPE char30
                                          iv_col            TYPE int4
                                          iv_int            TYPE int1
                                          iv_inv            TYPE int4,
             add_toolbutton     IMPORTING iv_name           TYPE char70
                                          iv_icon           LIKE icon_ws_plane
                                          iv_text           TYPE string
                                          iv_tooltip        TYPE string,
             hide_column        IMPORTING lv_colnam         TYPE lvc_fname,
             hide_empty_columns IMPORTING it_tab            TYPE ANY TABLE,
             set_column_names   IMPORTING column_names_itab TYPE zvz_salv_set_column_names,
             display.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: o_salv TYPE REF TO cl_salv_table,
          o_outtab TYPE REF TO data,
          mv_list_header TYPE char70,
          mv_sort_column TYPE char30.
ENDCLASS.

CLASS zcl_cvvz_salv IMPLEMENTATION.

  METHOD constructor.
    o_salv = io_salv.
    mv_list_header = iv_list_header.
    mv_sort_column = iv_sort_column.
    me->settings(  ).
  ENDMETHOD.

  METHOD settings.
    TRY.
        o_salv->get_functions( )->set_all( abap_true ).
        o_salv->get_display_settings( )->set_list_header( mv_list_header ).
        o_salv->get_display_settings( )->set_striped_pattern( abap_true ).
        o_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
        o_salv->get_sorts( )->add_sort( columnname = mv_sort_column
                                        sequence   = if_salv_c_sort=>sort_up ).
        o_salv->get_columns( )->set_optimize( abap_true ).

        LOOP AT o_salv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<c>).
          DATA(o_col2) = <c>-r_column.
          o_col2->set_alignment( if_salv_c_alignment=>centered ).
        ENDLOOP.
      CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found cx_salv_wrong_call INTO DATA(cx_error).
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH |{ cx_error->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.

  METHOD change_celltype.
    TRY.
        DATA(o_col) = CAST cl_salv_column_table( o_salv->get_columns( )->get_column( iv_columnname ) ).
        CASE iv_celltype.
          WHEN 5.
            o_col->set_cell_type( if_salv_c_cell_type=>hotspot ).
          WHEN 2.
            o_col->set_cell_type( if_salv_c_cell_type=>button ).
          WHEN 1.
            o_col->set_cell_type( if_salv_c_cell_type=>checkbox ).
          WHEN 3.
            o_col->set_cell_type( if_salv_c_cell_type=>dropdown ).
          WHEN OTHERS.
        ENDCASE.
      CATCH cx_salv_not_found INTO DATA(cx_error).
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH |{ cx_error->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.

  METHOD color_column.
    TRY.
        DATA(o_col) = CAST cl_salv_column_table( o_salv->get_columns( )->get_column( iv_columnname ) ).
        o_col->set_color( VALUE #( col = iv_col int = iv_int inv = iv_inv ) ).
      CATCH cx_salv_not_found INTO DATA(cx_error).
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH |{ cx_error->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.

  METHOD add_toolbutton.
    TRY.
        o_salv->get_functions( )->add_function( name     = iv_name
                                                icon     = |{ iv_icon }|
                                                text     = iv_text
                                                tooltip  = iv_tooltip
                                                position = if_salv_c_function_position=>right_of_salv_functions ).
      CATCH cx_salv_existing cx_salv_wrong_call INTO DATA(cx_error).
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH |{ cx_error->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.

  METHOD hide_column.
    TRY.
        DATA(o_col3) = CAST cl_salv_column_list( o_salv->get_columns( )->get_column( lv_colnam ) ).
        o_col3->set_visible( abap_false ).
      CATCH cx_root INTO DATA(lv_msg).
        MESSAGE lv_msg TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

  METHOD hide_empty_columns.
    LOOP AT o_salv->get_columns(  )->get(  ) ASSIGNING FIELD-SYMBOL(<d>).
      DATA(lv_colnam) = <d>-columnname.
      FIELD-SYMBOLS: <g> TYPE any.
      LOOP AT it_tab ASSIGNING FIELD-SYMBOL(<f>).
        ASSIGN COMPONENT lv_colnam OF STRUCTURE <f> TO <g>.
        IF <g> IS NOT INITIAL.
          DATA(lv_flag) = 1.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_flag NE 1.
        TRY.
            DATA(o_col4) = CAST cl_salv_column_list( o_salv->get_columns( )->get_column( lv_colnam ) ).
            o_col4->set_visible( abap_false ).
          CATCH cx_root INTO DATA(lv_msg2).
            MESSAGE lv_msg2 TYPE 'E'.
        ENDTRY.
      ENDIF.
      lv_flag = 0.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_column_names.
    DATA: iv_iter   TYPE int1 VALUE 1,
          col3      TYPE REF TO cl_salv_column,
          lv_length TYPE lvc_outlen.
    LOOP AT o_salv->get_columns(  )->get(  ) ASSIGNING FIELD-SYMBOL(<d>).
      col3 = <d>-r_column.
      LOOP AT column_names_itab INTO DATA(ls_column_name).
        IF ls_column_name-spalte = <d>-columnname.
          col3->set_long_text( ls_column_name-name ).
          col3->set_medium_text( |{ ls_column_name-name }| ).
          col3->set_short_text( |{ ls_column_name-name }| ).
          lv_length = strlen( ls_column_name-name ).
          col3->set_output_length( lv_length ).
        ENDIF.
      ENDLOOP.
      CLEAR ls_column_name.
    ENDLOOP.
  ENDMETHOD.

  METHOD display.
        o_salv->display( ).
        WRITE: space.
  ENDMETHOD.

ENDCLASS.