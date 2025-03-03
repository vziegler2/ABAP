CLASS lhc_zi_mm_brands_sap DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_mm_brands_sap RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE zi_mm_brands_sap.

ENDCLASS.

CLASS lhc_zi_mm_brands_sap IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD precheck_delete.
    SELECT DISTINCT brand_id
    FROM mara
    WHERE brand_id <> '' AND lvorm = '' AND mstae <> '99'
    INTO TABLE @DATA(lt_brand_id).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<s_keys>).
      IF line_exists( lt_brand_id[ brand_id = <s_keys>-brand_id ] ).
        APPEND VALUE #(  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text = |Brand { <s_keys>-brand_id } is used| ) ) TO reported-zi_mm_brands_sap.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_mm_brands_sap DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_mm_brands_sap IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_zi_mm_brands_sap TYPE STANDARD TABLE OF zi_mm_brands_sap,
          lt_brand_id         TYPE STANDARD TABLE OF wrf_brand_id,
          ls_brand            TYPE wrf_brands,
          ls_brand_t          TYPE wrf_brands_t,
          ls_brand_w          TYPE zmm_cit_brand,
          lt_msg              TYPE TABLE OF vrm_value,
          lv_language         TYPE c LENGTH 6 VALUE 'EDKVLN',
          lv_index            TYPE i,
          lr_brand_id         TYPE RANGE OF wrf_brands-brand_id.
*CREATE----------------------------------------------------------------
    IF create-zi_mm_brands_sap IS NOT INITIAL.
      lt_zi_mm_brands_sap = CORRESPONDING #( create-zi_mm_brands_sap ).
      ls_brand = CORRESPONDING #( lt_zi_mm_brands_sap[ 1 ] ).
      ls_brand_t = CORRESPONDING #( lt_zi_mm_brands_sap[ 1 ] ).
      ls_brand_w = CORRESPONDING #( lt_zi_mm_brands_sap[ 1 ] ).

*Test SAP ID format----------------------------------------------------
      FIND REGEX '^[A-Z][0-9]{3}$' IN ls_brand-brand_id.
      IF sy-subrc <> 0.
        APPEND VALUE #( key = 'w' text = 'Unusual SAP ID format' ) TO lt_msg.
      ENDIF.

*Check private label---------------------------------------------------
      IF ls_brand-brand_type = '1' AND ls_brand_w-zz_c_brand = ''.
        APPEND VALUE #( text = 'Missing private label' ) TO lt_msg.
      ELSEIF ls_brand-brand_type = '2' AND ls_brand_w-zz_c_brand <> ''.
        APPEND VALUE #( text = 'Conflicting label type' ) TO lt_msg.
      ENDIF.

      IF lt_msg IS INITIAL OR lt_msg[ 1 ]-key = 'w'.
*Warning message-------------------------------------------------------
        LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<s_msg_w>).
          APPEND VALUE #(  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                         text = lt_msg[ sy-index ]-text ) ) TO reported-zi_mm_brands_sap.
        ENDLOOP.
*Update database-------------------------------------------------------
        INSERT wrf_brands FROM ls_brand.

        DO strlen( lv_language ) TIMES.
          lv_index = sy-index - 1.
          ls_brand_t-language = lv_language+lv_index(1).
          INSERT wrf_brands_t FROM ls_brand_t.
        ENDDO.

        INSERT zmm_cit_brand FROM ls_brand_w.
      ELSE.
*Error message---------------------------------------------------------
        LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<s_msg>).
          APPEND VALUE #(  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text = lt_msg[ sy-index ]-text ) ) TO reported-zi_mm_brands_sap.
        ENDLOOP.
      ENDIF.
    ENDIF.
*UPDATE----------------------------------------------------------------
    lt_zi_mm_brands_sap = CORRESPONDING #( update-zi_mm_brands_sap ).

    IF lt_zi_mm_brands_sap IS NOT INITIAL.
      SELECT * FROM zi_mm_brands_sap FOR ALL ENTRIES IN @lt_zi_mm_brands_sap
               WHERE brand_id = @lt_zi_mm_brands_sap-brand_id
               INTO TABLE @lt_zi_mm_brands_sap.

      LOOP AT update-zi_mm_brands_sap ASSIGNING FIELD-SYMBOL(<s_new_data>).
        ASSIGN lt_zi_mm_brands_sap[ brand_id = <s_new_data>-brand_id ] TO FIELD-SYMBOL(<s_old_data>).

        IF <s_new_data>-%control-brand_descr = if_abap_behv=>mk-on.
          <s_old_data>-brand_descr = <s_new_data>-brand_descr.
        ENDIF.

        IF <s_new_data>-%control-brand_type = if_abap_behv=>mk-on.
          <s_old_data>-brand_type = <s_new_data>-brand_type.
        ENDIF.

        IF <s_new_data>-%control-zz_c_brand = if_abap_behv=>mk-on.
          <s_old_data>-zz_c_brand = <s_new_data>-zz_c_brand.
        ENDIF.
      ENDLOOP.

      ls_brand = CORRESPONDING #( lt_zi_mm_brands_sap[ 1 ] ).
      ls_brand_t = CORRESPONDING #( lt_zi_mm_brands_sap[ 1 ] ).
      ls_brand_w = CORRESPONDING #( lt_zi_mm_brands_sap[ 1 ] ).

*Check private label---------------------------------------------------
      IF ls_brand-brand_type = '1' AND ls_brand_w-zz_c_brand = ''.
        APPEND VALUE #( text = 'Missing private label' ) TO lt_msg.
      ELSEIF ls_brand-brand_type = '2' AND ls_brand_w-zz_c_brand <> ''.
        APPEND VALUE #( text = 'Conflicting label type' ) TO lt_msg.
      ENDIF.

      IF lt_msg IS INITIAL.
        UPDATE wrf_brands
          SET brand_type = ls_brand-brand_type
          WHERE brand_id = ls_brand-brand_id.

        DO strlen( lv_language ) TIMES.
          lv_index = sy-index - 1.
          ls_brand_t-language = lv_language+lv_index(1).
          UPDATE wrf_brands_t
            SET brand_descr = ls_brand_t-brand_descr
            WHERE brand_id = ls_brand-brand_id AND
                  language = ls_brand_t-language.
        ENDDO.

        UPDATE zmm_cit_brand
          SET zz_c_brand = ls_brand_w-zz_c_brand
          WHERE brand_id = ls_brand-brand_id.
      ELSE.
*Error message---------------------------------------------------------
        LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<s_msg_u>).
          APPEND VALUE #(  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text = lt_msg[ sy-index ]-text ) ) TO reported-zi_mm_brands_sap.
        ENDLOOP.
      ENDIF.
    ENDIF.
*DELETE----------------------------------------------------------------
    IF delete-zi_mm_brands_sap IS NOT INITIAL.
      lr_brand_id = VALUE #( FOR ls_brand_id IN delete-zi_mm_brands_sap
                           ( sign = 'I' option ='EQ' low = ls_brand_id-brand_id ) ).

      DELETE FROM wrf_brands WHERE brand_id IN @lr_brand_id.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.