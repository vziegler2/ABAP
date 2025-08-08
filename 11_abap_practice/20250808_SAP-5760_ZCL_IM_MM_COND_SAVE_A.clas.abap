CLASS zcl_im_mm_cond_save_a DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_ex_sd_cond_save_a.

    TYPES zmm_cond_save_a_t TYPE STANDARD TABLE OF zmm_cond_save_a WITH DEFAULT KEY.

    METHODS: initialization IMPORTING it_time       TYPE cond_time_vake_db_t
                                      it_konpdb_new TYPE cond_konpdb_t
                                      it_konpdb_old TYPE cond_konpdb_t,

      split_key_fields IMPORTING iv_fieldname   TYPE fieldname
                                 iv_vakey       TYPE char255
                       CHANGING  cs_cond_save_a TYPE zmm_cond_save_a
                                 cv_offset      TYPE char255,

      check_additional_materials,

      job_conditions_create_zve1_4 IMPORTING iv_kschl         TYPE kschl
                                             iv_lifnr         TYPE lifnr
                                             iv_matnr         TYPE matnr
                                             iv_ekorg         TYPE ekorg
                                   RETURNING VALUE(rt_result) TYPE zmm_cond_save_a_t,

      get_main_supplier_changes,
      calculate_new_prices CHANGING is_cond_save_a TYPE zmm_cond_save_a,
      create_sd_conditions CHANGING is_cond_save_a TYPE zmm_cond_save_a,

      create_where_string IMPORTING iv_kschl                  TYPE kschl
                                    iv_lifnr                  TYPE lifnr
                                    iv_matnr                  TYPE matnr
                                    iv_ekorg                  TYPE ekorg
                          RETURNING VALUE(rv_where_condition) TYPE string.

  PRIVATE SECTION.
    TYPES: BEGIN OF mty_add_materials,
             matnr TYPE matnr,
             werks TYPE werks_d,
           END OF mty_add_materials.

    DATA: mv_stop          TYPE abap_bool,
          ms_time          TYPE cond_time_vake_db,
          ms_new           TYPE konpdb,
          ms_old           TYPE konpdb,
          ms_cond_save_a   TYPE zmm_cond_save_a,
          mt_add_materials TYPE TABLE OF mty_add_materials,
          mt_cond_save_a   TYPE TABLE OF zmm_cond_save_a,
          mt_kalsm         TYPE TABLE OF kalsm,
          mt_condtypes     TYPE TABLE OF kscha.
ENDCLASS.


CLASS zcl_im_mm_cond_save_a IMPLEMENTATION.
  METHOD if_ex_sd_cond_save_a~condition_save_exit.
    IF /cmt/cl_ca_cef_processor=>is_active( iv_extensionkey = 'ZMM_CONDITION_CHANGE_CALC_NEW_PRICES' ) = abap_false.
      RETURN.
    ENDIF.

    initialization( it_time       = ct_time
                    it_konpdb_new = ct_konpdb_new
                    it_konpdb_old = ct_konpdb_old ).

    IF mv_stop = abap_true.
      RETURN.
    ENDIF.

    check_additional_materials( ).

    DELETE FROM zmm_cond_save_a WHERE edited = 'S'.
  ENDMETHOD.

  METHOD initialization.
    DATA: lr_struc  TYPE REF TO cl_abap_structdescr,
          lt_fields TYPE ddfields,
          lv_offset TYPE char255.

    ms_time = VALUE #( it_time[ 1 ] OPTIONAL ).
    ms_new  = VALUE #( it_konpdb_new[ 1 ] OPTIONAL ).
    ms_old  = VALUE #( it_konpdb_old[ 1 ] OPTIONAL ).
    DATA(lv_dbtab) = |{ ms_time-kvewe }{ ms_time-kotabnr }|.
    "The imported percentages are one decimal place too large.
    IF ms_new-konwa = '%'.
      ms_old-kbetr /= 10.
      ms_new-kbetr /= 10.
    ENDIF.

    ms_cond_save_a = VALUE zmm_cond_save_a( start_date = ms_time-datab
                                            end_date   = ms_time-datbi
                                            knumh      = ms_time-knumh
                                            kschl      = ms_time-kschl
                                            dbtab      = lv_dbtab
                                            updkz      = ms_time-xxdbaction
                                            kappl      = ms_time-kappl
                                            krech      = ms_new-krech
                                            obetr      = ms_old-kbetr
                                            nbetr      = ms_new-kbetr
                                            konwa      = ms_new-konwa
                                            tcode      = sy-tcode
                                            uname      = sy-uname
                                            udate      = sy-datum
                                            utime      = sy-uzeit ).

    IF ms_time-kappl <> 'M'. " Only for MM conditions
      mv_stop = abap_true.
    ENDIF.

    lr_struc ?= cl_abap_elemdescr=>describe_by_name( lv_dbtab ). " Get structure description for the database table
    lt_fields = lr_struc->get_ddic_field_list( ).

    DELETE lt_fields WHERE keyflag = abap_false.

    LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<s_field>) FROM 4 TO 6. " Fields 1-3: MANDT, KAPPL, KSCHL
      split_key_fields( EXPORTING iv_fieldname   = <s_field>-fieldname " vakey is split into EKORG, LIFNR, MATNR, MATKL
                                  iv_vakey       = ms_time-vakey
                        CHANGING  cs_cond_save_a = ms_cond_save_a
                                  cv_offset      = lv_offset ).
    ENDLOOP.

    IF    ms_cond_save_a-lifnr  = '0000911500' " Data for this LIFNR is sent from WWS
       OR ms_cond_save_a-ekorg <> '3000'. " Only EKORG for AT
      mv_stop = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD split_key_fields.
    CASE iv_fieldname.
      WHEN 'EKORG'.
        cs_cond_save_a-ekorg = |{ iv_vakey+cv_offset(4) }|.
        cv_offset += 4.
      WHEN 'LIFNR'.
        cs_cond_save_a-lifnr = |{ iv_vakey+cv_offset(10) }|.
        cv_offset += 10.
      WHEN 'MATNR'.
        cs_cond_save_a-matnr = |{ iv_vakey+cv_offset(40) }|.
        cv_offset += 40.
      WHEN 'MATKL'.
        cs_cond_save_a-matkl = |{ iv_vakey+cv_offset(9) }|.
        cv_offset += 9.
    ENDCASE.
  ENDMETHOD.

  METHOD check_additional_materials.
    SELECT DISTINCT eina~matnr,
                    coalesce( eord~werks, '####' ) AS werks
      FROM eina
      JOIN eine ON eine~infnr = eina~infnr
      LEFT JOIN mara ON mara~matnr = eina~matnr
      LEFT JOIN eord ON eord~matnr = eina~matnr
     WHERE eina~lifnr = @ms_cond_save_a-lifnr
       AND eine~ekorg = @ms_cond_save_a-ekorg
       AND (
             ( @ms_cond_save_a-matnr IS NOT INITIAL AND eina~matnr = @ms_cond_save_a-matnr ) " Material condition change
             OR ( @ms_cond_save_a-matnr IS INITIAL AND @ms_cond_save_a-matkl IS INITIAL     ) " Supplier condition change
             OR ( @ms_cond_save_a-matnr IS INITIAL AND @ms_cond_save_a-matkl IS NOT INITIAL AND mara~matkl = @ms_cond_save_a-matkl ) ) " Material group condition change
      INTO TABLE @mt_add_materials.

    IF mt_add_materials IS NOT INITIAL.
      LOOP AT mt_add_materials ASSIGNING FIELD-SYMBOL(<s_add_materials>) WHERE matnr IS NOT INITIAL AND werks IS NOT INITIAL.
        APPEND VALUE #( matnr = <s_add_materials>-matnr
                        werks = <s_add_materials>-werks ) TO mt_cond_save_a.
      ENDLOOP.

      IF mt_cond_save_a IS NOT INITIAL.
        MODIFY zmm_cond_save_a FROM TABLE mt_cond_save_a.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD job_conditions_create_zve1_4.
    mt_condtypes = VALUE #( ( 'ZVE1' )
                            ( 'ZVE2' )
                            ( 'ZVE3' )
                            ( 'ZVE4' ) ).

    mt_kalsm = VALUE #( ( kalsm = 'ZM0000' )
                        ( kalsm = 'ZM0001' ) ).

    get_main_supplier_changes( ).

    DATA(lv_where_string) = create_where_string( iv_kschl = iv_kschl
                                                 iv_lifnr = iv_lifnr
                                                 iv_matnr = iv_matnr
                                                 iv_ekorg = iv_ekorg ).

    SELECT *
      FROM zmm_cond_save_a
     WHERE (lv_where_string)
      INTO TABLE @mt_cond_save_a.

    LOOP AT mt_cond_save_a ASSIGNING FIELD-SYMBOL(<s_cond_save_a>).
      calculate_new_prices( CHANGING is_cond_save_a = <s_cond_save_a> ).

      create_sd_conditions( CHANGING is_cond_save_a = <s_cond_save_a> ).
    ENDLOOP.

    MODIFY zmm_cond_save_a FROM TABLE mt_cond_save_a.
    rt_result = mt_cond_save_a.
  ENDMETHOD.

  METHOD get_main_supplier_changes.
    DATA lt_add_lifnr_chng TYPE TABLE OF zmm_cond_save_a.

    SELECT MAX( udate )
      FROM zmm_cond_save_a
     WHERE uname = ''
      INTO @DATA(lv_max_udate).

    IF lv_max_udate = '00000000'.
      RETURN.
    ENDIF.

    SELECT DISTINCT cdpos~objectid, " Read changes to the standard supplier from change documents
                    cdhdr~tcode,
                    cdpos~tabkey
      FROM cdpos
      JOIN cdhdr ON cdpos~changenr = cdhdr~changenr
     WHERE tabname  = 'EORD'
*   AND fname      = 'FLIFN' "Not possible because in the article cockpit all entries are deleted
*   AND value_new  = 'X'     "and recreated when order book changes occur
       AND udate   >= @lv_max_udate
      INTO TABLE @DATA(lt_objectid).

    LOOP AT lt_objectid ASSIGNING FIELD-SYMBOL(<s_objectid>).
      APPEND VALUE #( matnr = <s_objectid>-objectid(40)
                      werks = <s_objectid>-tabkey+40(4)
                      tcode = <s_objectid>-tcode
                      uname = sy-uname
                      udate = sy-datum
                      utime = sy-uzeit ) TO lt_add_lifnr_chng.
    ENDLOOP.

    MODIFY zmm_cond_save_a FROM TABLE lt_add_lifnr_chng.
  ENDMETHOD.

  METHOD calculate_new_prices.
    DATA: ls_komk   TYPE komk,
          ls_komp   TYPE komp,
          lt_komv   TYPE TABLE OF komv,
          ls_lfa1   TYPE lfa1,
          ls_lfm1   TYPE lfm1,
          ls_mt06e  TYPE mt06e,
          lv_effpr  TYPE f,
          lv_nntpr  TYPE f,
          lv_estpr  TYPE f,
          lv_bonba  TYPE f,
          lv_factor TYPE f.

    SELECT SINGLE *
      FROM eina
     WHERE lifnr = @is_cond_save_a-lifnr
       AND matnr = @is_cond_save_a-matnr
      INTO @DATA(ls_eina).

    SELECT SINGLE *
      FROM eine
     WHERE infnr = @ls_eina-infnr
       AND ekorg = @is_cond_save_a-ekorg
      INTO @DATA(ls_eine).

    SELECT SINGLE matkl
      FROM mara
     WHERE matnr = @is_cond_save_a-matnr
      INTO @ls_eina-matkl.

    CALL FUNCTION 'MM_CURRENT_PRICE_INFORECORD'
      EXPORTING i_eina = ls_eina
      CHANGING  c_eine = ls_eine.

    CALL FUNCTION 'VENDOR_MASTER_DATA_SELECT_00'
      EXPORTING  i_lfa1_lifnr     = is_cond_save_a-lifnr
                 i_lfm1_ekorg     = is_cond_save_a-ekorg
      IMPORTING  a_lfa1           = ls_lfa1
                 a_lfm1           = ls_lfm1
      EXCEPTIONS vendor_not_found = 1
                 internal_error   = 2
                 lifnr_blocked    = 3
                 OTHERS           = 4.

    DATA(ls_t001) = VALUE t001( waers    = 'EUR'
                                waabw    = '00'
                                fmhrdate = '00000000'
                                offsacct = '0' ).

    DATA(ls_t001w) = VALUE t001w( let01 = '0'
                                  let02 = '0'
                                  let03 = '0'
                                  betol = '000' ).

    LOOP AT mt_kalsm ASSIGNING FIELD-SYMBOL(<s_kalsm>).
      CALL FUNCTION 'ME_FILL_KOMK_IN'
        EXPORTING i_eina  = ls_eina
                  i_eine  = ls_eine
                  i_lfa1  = ls_lfa1
                  i_t001  = ls_t001
                  i_lfm1  = ls_lfm1
                  i_kalsm = <s_kalsm>-kalsm
                  i_kappl = 'M'
                  i_egimp = ''
                  i_prsdt = is_cond_save_a-start_date
                  i_t001w = ls_t001w
        IMPORTING e_komk  = ls_komk.

      IF is_cond_save_a-werks <> '####'.
        ls_komk = VALUE #( BASE ls_komk
                           werks = is_cond_save_a-werks ).
      ENDIF.

      SELECT SINGLE *
        FROM mara
       WHERE matnr = @is_cond_save_a-matnr
        INTO CORRESPONDING FIELDS OF @ls_mt06e.

      ls_mt06e = VALUE #( BASE ls_mt06e
                          webaz        = '0'
                          untto        = ''
                          uebto        = ''
                          mahn1        = ''
                          mahn2        = ''
                          mahn3        = '0'
                          verpr        = '0.00'
                          stprs        = '0.00'
                          peinh        = '0'
                          bsext        = '2'
                          bsint        = '0'
                          plifz        = '0'
                          cuobj        = '000000000000000000'
                          cuobf        = '000000000000000000'
                          mmstd        = '00000000'
                          mstde        = '00000000'
                          bstrf        = '0.000'
                          bstma        = '0.000'
                          bstmi        = '0.000'
                          gi_pr_time   = '0'
                          min_troc     = '000'
                          max_troc     = '000'
                          target_stock = '0.000' ).

      CALL FUNCTION 'ME_FILL_KOMP_IN'
        EXPORTING i_eina  = ls_eina
                  i_eine  = ls_eine
                  i_t001w = ls_t001w
                  i_komk  = ls_komk
                  i_mt06e = ls_mt06e
                  i_matnr = is_cond_save_a-matnr
                  i_charg = ''
        IMPORTING e_komp  = ls_komp.

      IF is_cond_save_a-werks <> '####'.
        ls_komp = VALUE #( BASE ls_komp
                           werks = is_cond_save_a-werks ).
      ENDIF.

      CALL FUNCTION 'PRICING'
        EXPORTING calculation_type = 'B'
                  comm_head_i      = ls_komk
                  comm_item_i      = ls_komp
        IMPORTING comm_head_e      = ls_komk
                  comm_item_e      = ls_komp
        TABLES    tkomv            = lt_komv.

      is_cond_save_a-waers = ls_komk-waerk.
      " Divide price by quantity
      lv_factor = 1 / ls_komp-mglme / ls_komp-lgumz * ls_komp-lgumn.

      lv_effpr = ls_komp-effwr * lv_factor.
      lv_nntpr = ls_komp-kzwi1 * lv_factor.
      lv_estpr = ls_komp-kzwi2 * lv_factor.
      lv_bonba = ls_komp-bonba * lv_factor.

      IF lv_effpr IS NOT INITIAL.
        is_cond_save_a-meins = ls_komp-meins.

        IF <s_kalsm> = 'ZM0000'.
          is_cond_save_a-effpr = lv_effpr.
          is_cond_save_a-nntpr = lv_nntpr.
          is_cond_save_a-estpr = lv_estpr.
          is_cond_save_a-bonba = lv_bonba.
        ELSEIF <s_kalsm> = 'ZM0001'.
          is_cond_save_a-effpr_rase = lv_effpr.
          is_cond_save_a-nntpr_rase = lv_nntpr.
          is_cond_save_a-estpr_rase = lv_estpr.
          is_cond_save_a-bonba_rase = lv_bonba.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_sd_conditions.
    DATA lt_copy_records TYPE TABLE OF komv.

    " Create future condition
    " Attention: Future conditions will be overwritten by changes to previous conditions
    " Future conditions must be changed on their start date
    DATA(ls_komg) = VALUE komg( vkbur = '4800'
                                matnr = is_cond_save_a-matnr ). " Must have exactly 18 digits for Fuba

    LOOP AT mt_condtypes ASSIGNING FIELD-SYMBOL(<s_condtype>).
      CLEAR lt_copy_records.

      lt_copy_records = VALUE #( ( kappl = 'V'
                                   kschl = <s_condtype>
                                   kbetr = ''
                                   waers = 'EUR'
                                   kpein = '1'
                                   kmein = 'ST' ) ).

      lt_copy_records[ 1 ]-kbetr = SWITCH #( <s_condtype>
                                             WHEN 'ZVE1' THEN is_cond_save_a-effpr
                                             WHEN 'ZVE2' THEN is_cond_save_a-effpr_rase
                                             WHEN 'ZVE3' THEN is_cond_save_a-nntpr
                                             WHEN 'ZVE4' THEN is_cond_save_a-nntpr_rase
                                             ELSE             '' ).

      DATA: lv_datab TYPE vake-datab,
            lv_datbi TYPE vake-datbi,
            lv_prdat TYPE vake-datbi.

      CALL FUNCTION 'RV_CONDITION_COPY'
        EXPORTING  application                 = 'V'
                   condition_table             = '940'
                   condition_type              = <s_condtype>
                   date_from                   = is_cond_save_a-start_date
                   date_to                     = is_cond_save_a-end_date
                   enqueue                     = abap_true
                   key_fields                  = ls_komg
                   maintain_mode               = 'A' " Mode (A - Create, B - Change, C - Display, D - Create with template)
                   no_authority_check          = abap_true
                   overlap_confirmed           = abap_true
        IMPORTING  e_datab                     = lv_datab
                   e_datbi                     = lv_datbi
                   e_prdat                     = lv_prdat
        TABLES     copy_records                = lt_copy_records
        EXCEPTIONS enqueue_on_record           = 1
                   invalid_application         = 2
                   invalid_condition_number    = 3
                   invalid_condition_type      = 4
                   no_authority_ekorg          = 5
                   no_authority_kschl          = 6
                   no_authority_vkorg          = 7
                   no_selection                = 8
                   table_not_valid             = 9
                   no_material_for_settlement  = 10
                   no_unit_for_period_cond     = 11
                   no_unit_reference_magnitude = 12
                   invalid_condition_table     = 13
                   OTHERS                      = 14.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ELSE.
        CALL FUNCTION 'RV_CONDITION_SAVE'.
        CALL FUNCTION 'RV_CONDITION_RESET'.
        COMMIT WORK.
        is_cond_save_a-edited = 'S'.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_where_string.
    DATA lt_conditions TYPE TABLE OF string.

    IF iv_kschl IS NOT INITIAL.
      APPEND |KSCHL = '{ iv_kschl }'| TO lt_conditions.
    ENDIF.

    IF iv_lifnr IS NOT INITIAL.
      APPEND |LIFNR = '{ iv_lifnr }'| TO lt_conditions.
    ENDIF.

    IF iv_matnr IS NOT INITIAL.
      APPEND |MATNR = '{ iv_matnr }'| TO lt_conditions.
    ENDIF.

    IF iv_ekorg IS NOT INITIAL.
      APPEND |EKORG = '{ iv_ekorg }'| TO lt_conditions.
    ENDIF.

    IF lt_conditions IS NOT INITIAL.
      CONCATENATE LINES OF lt_conditions INTO rv_where_condition SEPARATED BY ' AND '.
    ELSE.
      rv_where_condition = '1 = 1'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
