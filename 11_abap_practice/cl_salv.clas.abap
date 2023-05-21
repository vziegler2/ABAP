CLASS zvz_cl_salv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS: hide_column IMPORTING o_salv    TYPE REF TO cl_salv_table
                                         lv_colnam TYPE lvc_fname,
      hide_empty_columns IMPORTING o_salv TYPE REF TO cl_salv_table
                                   it_tab TYPE ANY TABLE,
      set_column_names IMPORTING o_salv            TYPE REF TO cl_salv_table
                                 column_names_itab TYPE zvz_salv_set_column_names.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zvz_cl_salv IMPLEMENTATION.

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

ENDCLASS.