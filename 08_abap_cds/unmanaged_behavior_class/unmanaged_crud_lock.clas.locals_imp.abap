CLASS lhc_zr_mm_brands DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_mm_brands RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zr_mm_brands.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zr_mm_brands.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zr_mm_brands.

    METHODS read FOR READ
      IMPORTING keys FOR READ zr_mm_brands RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zr_mm_brands.

    METHODS rba_texts FOR READ
      IMPORTING keys_rba FOR READ zr_mm_brands\_texts FULL result_requested RESULT result LINK association_links.

    METHODS rba_wws FOR READ
      IMPORTING keys_rba FOR READ zr_mm_brands\_wws FULL result_requested RESULT result LINK association_links.

    METHODS cba_texts FOR MODIFY
      IMPORTING entities_cba FOR CREATE zr_mm_brands\_texts.

    METHODS cba_wws FOR MODIFY
      IMPORTING entities_cba FOR CREATE zr_mm_brands\_wws.

ENDCLASS.

CLASS lhc_zr_mm_brands IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD create.
    DATA: ls_brand TYPE wrf_brands,
          ls_brand_t TYPE wrf_brands_t,
          ls_brand_w TYPE zmm_cit_brand,
          lt_msg TYPE TABLE OF vrm_value,
          lv_language TYPE c LENGTH 6 VALUE 'EDKVLN'.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<s_entity>).
      ls_brand = CORRESPONDING #( <s_entity> ).
      ls_brand_t = CORRESPONDING #( <s_entity> ).
      ls_brand_w = CORRESPONDING #( <s_entity> ).
*Test ID format--------------------------------------------------------
      FIND REGEX '^[A-Z][0-9]{3}$' IN <s_entity>-brand_id.
      IF sy-subrc <> 0.
        APPEND VALUE #( text = 'Wrong ID format' ) TO lt_msg.
      ENDIF.
*Test existing ID------------------------------------------------------
      SELECT SINGLE * FROM wrf_brands
        INTO @DATA(ls_existing)
        WHERE brand_id = @<s_entity>-brand_id.
      IF sy-subrc = 0.
        APPEND VALUE #( text = 'Entry already exists.' ) TO lt_msg.
      ENDIF.

      IF lt_msg IS INITIAL.
*Update database-------------------------------------------------------
        INSERT wrf_brands FROM ls_brand.

        DO strlen( lv_language ) TIMES.
          DATA(lv_index) = sy-index - 1.
          ls_brand_t-language = lv_language+lv_index(1).
          INSERT wrf_brands_t FROM ls_brand_t.
        ENDDO.

        ls_brand_w-zz_c_number = '999996'.
        INSERT zmm_cit_brand FROM ls_brand_w.
      ELSE.
*Error message---------------------------------------------------------
        LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<s_msg>).
          APPEND VALUE #(  %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                         text = lt_msg[ sy-index ]-text ) ) TO reported-zr_mm_brands.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<s_entity>).
      UPDATE wrf_brands
        SET brand_type = <s_entity>-brand_type
        WHERE brand_id = <s_entity>-brand_id.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<s_key>).
      DELETE FROM wrf_brands WHERE brand_id = <s_key>-brand_id.
      DELETE FROM wrf_brands_t WHERE brand_id = <s_key>-brand_id.
      DELETE FROM zmm_cit_brand WHERE brand_id = <s_key>-brand_id.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
    DATA: lv_tabname_brands TYPE tabname VALUE 'WRF_BRANDS',
          lv_tabname_texts  TYPE tabname VALUE 'WRF_BRANDS_T',
          lv_tabname_wws    TYPE tabname VALUE 'ZMM_CIT_BRAND'.

    TRY.
        "Instantiate lock object
        DATA(lock_brands) = cl_abap_lock_object_factory=>get_instance( iv_name = 'E_TABLE' ).
        DATA(lock_texts) = cl_abap_lock_object_factory=>get_instance( iv_name = 'E_TABLE' ).
        DATA(lock_wws) = cl_abap_lock_object_factory=>get_instance( iv_name = 'E_TABLE' ).
      CATCH cx_abap_lock_failure INTO DATA(exception).
        RAISE SHORTDUMP exception.
    ENDTRY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      TRY.
          "enqueue travel instance
          lock_brands->enqueue(
              it_parameter  = VALUE #( (  name = 'TABNAME' value = REF #( lv_tabname_brands ) ) )
              it_table_mode = VALUE #( ( table_name = lv_tabname_brands mode = if_abap_lock_object=>cs_mode-write_lock ) ) ).

          lock_texts->enqueue(
              it_parameter  = VALUE #( (  name = 'TABNAME' value = REF #( lv_tabname_texts ) ) )
              it_table_mode = VALUE #( ( table_name = lv_tabname_texts mode = if_abap_lock_object=>cs_mode-write_lock ) ) ).

          lock_wws->enqueue(
              it_parameter  = VALUE #( (  name = 'TABNAME' value = REF #( lv_tabname_wws ) ) )
              it_table_mode = VALUE #( ( table_name = lv_tabname_wws mode = if_abap_lock_object=>cs_mode-write_lock ) ) ).
          "if foreign lock exists
        CATCH cx_abap_foreign_lock INTO DATA(foreign_lock).
          APPEND VALUE #( brand_id = <key>-brand_id  ) TO failed-zr_mm_brands.
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text = foreign_lock->get_longtext( ) ) ) TO reported-zr_mm_brands.
        CATCH cx_abap_lock_failure INTO exception.
          RAISE SHORTDUMP exception.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_texts.
  ENDMETHOD.

  METHOD rba_wws.
  ENDMETHOD.

  METHOD cba_texts.
  ENDMETHOD.

  METHOD cba_wws.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_mm_brands DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_mm_brands IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.