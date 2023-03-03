*&---------------------------------------------------------------------*
*& Report zvzp_formatted
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvzp_alv_formatted.

SELECT * FROM spfli INTO TABLE @DATA(it_spfli).
TRY.
    DATA: o_salv TYPE REF TO cl_salv_table.
    CALL METHOD cl_salv_table=>factory(
      IMPORTING
        r_salv_table = o_salv
      CHANGING
        t_table      = it_spfli ).

    o_salv->get_functions(  )->set_all( abap_true ).
    o_salv->get_display_settings(  )->set_list_header( 'Flightconnections' ).
    o_salv->get_display_settings(  )->set_striped_pattern( abap_true ).
    o_salv->get_selections(  )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
    o_salv->get_sorts(  )->add_sort( columnname = 'CONNID' sequence = if_salv_c_sort=>sort_up ).
    o_salv->get_columns(  )->set_optimize( abap_true ).
    LOOP AT o_salv->get_columns(  )->get(  ) ASSIGNING FIELD-SYMBOL(<c>).
      DATA(o_col) = <c>-r_column.
      o_col->set_alignment( if_salv_c_alignment=>centered ).
    ENDLOOP.
    o_salv->display(  ).
  CATCH cx_salv_msg.
ENDTRY.