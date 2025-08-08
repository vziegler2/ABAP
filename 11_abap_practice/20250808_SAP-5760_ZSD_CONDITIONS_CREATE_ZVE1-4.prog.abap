REPORT zsd_conditions_create_zve1_4.

IF /cmt/cl_ca_cef_processor=>is_active( iv_extensionkey = 'ZMM_CONDITION_CHANGE_CALC_NEW_PRICES' ) = abap_false.
  RETURN.
ENDIF.

SELECTION-SCREEN BEGIN OF BLOCK bl0 WITH FRAME TITLE TEXT-000.
  PARAMETERS: p_kschl TYPE kschl,
              p_lifnr TYPE lifnr,
              p_matnr TYPE matnr,
              p_ekorg TYPE ekorg.
SELECTION-SCREEN END OF BLOCK bl0.

DATA(lo_class) = NEW zcl_im_mm_cond_save_a( ).

DATA(lt_alv) = lo_class->job_conditions_create_zve1_4( iv_kschl = p_kschl
                                                       iv_lifnr = p_lifnr
                                                       iv_matnr = p_matnr
                                                       iv_ekorg = p_ekorg ).

IF sy-batch IS NOT INITIAL.
  RETURN.
ENDIF.

TYPES zmm_cond_save_a_t TYPE STANDARD TABLE OF zmm_cond_save_a WITH DEFAULT KEY.

TYPES: BEGIN OF ty_alv_with_color.
         INCLUDE TYPE zmm_cond_save_a.
TYPES:   line_color TYPE lvc_t_scol,
       END OF ty_alv_with_color.

DATA lt_alv_display TYPE TABLE OF ty_alv_with_color.

LOOP AT lt_alv ASSIGNING FIELD-SYMBOL(<ls_alv>).
  APPEND INITIAL LINE TO lt_alv_display ASSIGNING FIELD-SYMBOL(<ls_display>).
  MOVE-CORRESPONDING <ls_alv> TO <ls_display>.

  IF <ls_alv>-edited = 'S'.
    " Set color to green (code 5)
    APPEND VALUE #( color = VALUE #( col = 5
                                     int = 0
                                     inv = 0 ) ) TO <ls_display>-line_color.
  ELSE.
    " Set color to red (code 6)
    APPEND VALUE #( color = VALUE #( col = 6
                                     int = 0
                                     inv = 0 ) ) TO <ls_display>-line_color.
  ENDIF.
ENDLOOP.

TRY.
    DATA go_salv TYPE REF TO cl_salv_table.
    cl_salv_table=>factory( IMPORTING r_salv_table = go_salv
                            CHANGING  t_table      = lt_alv_display ).

    go_salv->get_functions( )->set_all( abap_true ).
    go_salv->get_display_settings( )->set_list_header( |Ergebnis ({ lines( lt_alv_display ) })| ).
    go_salv->get_display_settings( )->set_striped_pattern( abap_true ).
    go_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
    go_salv->get_columns( )->set_optimize( abap_true ).
    go_salv->get_columns( )->set_color_column( 'LINE_COLOR' ).

    LOOP AT go_salv->get_columns( )->get( ) ASSIGNING FIELD-SYMBOL(<c>).
      DATA(o_col2) = <c>-r_column.
      o_col2->set_alignment( if_salv_c_alignment=>centered ).

      DATA(lv_short_text) = SWITCH char10( <c>-columnname
                                           WHEN 'EFFPR'      THEN 'Eff. Pr.'
                                           WHEN 'EFFPR_RASE' THEN 'Eff. Pr. R'
                                           WHEN 'NNTPR'      THEN 'Net Net'
                                           WHEN 'NNTPR_RASE' THEN 'Net Net R'
                                           WHEN 'ESTPR'      THEN 'Cost Pr.'
                                           WHEN 'ESTPR_RASE' THEN 'Cost Pr. R'
                                           WHEN 'BONBA'      THEN 'Final Pr.'
                                           WHEN 'BONBA_RASE' THEN 'Final Pr. R'
                                           WHEN 'START_DATE' THEN 'Start Date'
                                           WHEN 'END_DATE'   THEN 'End Date'
                                           WHEN 'DBTAB'      THEN 'DB Table'
                                           WHEN 'UPDKZ'      THEN 'Update Fl.'
                                           WHEN 'EDITED'     THEN 'Status' ).

      DATA(lv_medium_text) = SWITCH char20( <c>-columnname
                                            WHEN 'EFFPR'      THEN 'Effective Price'
                                            WHEN 'EFFPR_RASE' THEN 'Effective Price RASE'
                                            WHEN 'NNTPR'      THEN 'Net Net Price'
                                            WHEN 'NNTPR_RASE' THEN 'Net Net Price RASE'
                                            WHEN 'ESTPR'      THEN 'Cost Price'
                                            WHEN 'ESTPR_RASE' THEN 'Cost Price RASE'
                                            WHEN 'BONBA'      THEN 'Final Invoice Price'
                                            WHEN 'BONBA_RASE' THEN 'Final Invoice Pr. R'
                                            WHEN 'START_DATE' THEN 'Start Date Validity'
                                            WHEN 'END_DATE'   THEN 'End Date of Validity'
                                            WHEN 'DBTAB'      THEN 'Database Table'
                                            WHEN 'UPDKZ'      THEN 'Update Flag'
                                            WHEN 'EDITED'     THEN 'Processing status' ).

      DATA(lv_long_text) = SWITCH char40( <c>-columnname
                                          WHEN 'EFFPR'      THEN 'Effective Price'
                                          WHEN 'EFFPR_RASE' THEN 'Effective Price w/o temporary conditions'
                                          WHEN 'NNTPR'      THEN 'Net Net Price'
                                          WHEN 'NNTPR_RASE' THEN 'Net Net Price w/o temporary conditions'
                                          WHEN 'ESTPR'      THEN 'Cost Price'
                                          WHEN 'ESTPR_RASE' THEN 'Cost Price w/o temporary conditions'
                                          WHEN 'BONBA'      THEN 'Final Invoice Price'
                                          WHEN 'BONBA_RASE' THEN 'Final Invoice Pr. w/o temp. conditions'
                                          WHEN 'START_DATE' THEN 'Start Date of Validity'
                                          WHEN 'END_DATE'   THEN 'End Date of Validity'
                                          WHEN 'DBTAB'      THEN 'Database Table'
                                          WHEN 'UPDKZ'      THEN 'Update Flag'
                                          WHEN 'EDITED'     THEN 'Processing status' ).

      IF lv_short_text IS INITIAL.
        CONTINUE.
      ENDIF.

      o_col2->set_short_text( lv_short_text ).
      o_col2->set_medium_text( lv_medium_text ).
      o_col2->set_long_text( lv_long_text ).
    ENDLOOP.

    go_salv->display( ).
    WRITE space.

  CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found cx_salv_wrong_call INTO DATA(cx_error).
    MESSAGE i435(00) WITH |{ cx_error->get_text( ) }|.
ENDTRY.
