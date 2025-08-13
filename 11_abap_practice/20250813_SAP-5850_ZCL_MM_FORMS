CLASS zcl_mm_forms DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_delivery_times,
             delivery_start TYPE zmm_e_delivery_start_time,
             break_start    TYPE zmm_e_delvry_pause_start_time,
             break_end      TYPE zmm_e_delvry_pause_end_time,
             delivery_end   TYPE zmm_e_delivery_end_time,
           END OF ts_delivery_times.

    METHODS:
      constructor IMPORTING it_ekpo  TYPE ty_mmpur_print_ekpo
                            is_ekko  TYPE mmpur_print_ekko
                            it_t166p TYPE ty_mmpur_print_t166p
                            is_t166u TYPE t166u
                            iv_mode  TYPE druvo
                            it_t166t TYPE ty_mmpur_print_t166t,

      "!Sichert die Vollständigkeit der angezeigten Artikel bei Änderungsbestellungen
      fill_ekpo,
      "!Warenempfängeradresse wird bestimmt
      "! @parameter rs_adrs_recipient | Adresse des Warenempfängers
      read_bukrs_address RETURNING VALUE(rs_adrs_recipient) TYPE adrs_print,

      main EXPORTING ev_watermark      TYPE xstring
                     ev_logo           TYPE xstring
                     ev_footer         TYPE zbc_forms_config_bezeichner
                     ev_bsart          TYPE char50
                     ev_adrs_rec_short TYPE zbc_forms_config_bezeichner
                     et_adrs_recipient TYPE stringtab
                     et_adrs_sender    TYPE stringtab
                     et_items          TYPE zmm_purchase_ord_t
                     ev_eikto          TYPE eikto
                     es_free_text      TYPE zsd_standard_text
                     ev_inco1          TYPE inco1
                     es_sum_block      TYPE zmm_sum_block_09
                     et_delivery_times TYPE zmm_tt_printform_delivery_time
                     et_fill_tab       TYPE stringtab
                     es_active_fields  TYPE zmm_layout_activ_s
                     ev_iln_werks      TYPE string,

      add_deliver_time IMPORTING is_time          TYPE ts_delivery_times
                                 iv_day_begin     TYPE cacsdayweek
                                 iv_day_end       TYPE cacsdayweek
                       CHANGING  ct_delivery_time TYPE zmm_tt_delivery_times,

      get_message IMPORTING iv_msg_number     TYPE symsgno
                            is_time           TYPE ts_delivery_times
                  RETURNING VALUE(rv_message) TYPE bapi_msg,

      convert_time IMPORTING iv_time                  TYPE tims
                   RETURNING VALUE(rv_converted_time) TYPE symsgv,

      set_logo                 RETURNING VALUE(rv_logo)           TYPE xstring,
      set_footer               RETURNING VALUE(rv_footer)         TYPE char100,
      set_eikto                RETURNING VALUE(rv_eikto)          TYPE eikto,
      set_adrs_recipient       RETURNING VALUE(rt_adrs_recipient) TYPE stringtab,
      set_adrs_recipient_short RETURNING VALUE(rv_adrs_rec_short) TYPE char100,
      "!Senderadresse wird bestimmt
      "! @parameter rt_adrs_sender | Senderadresse
      set_adrs_sender          RETURNING VALUE(rt_adrs_sender)    TYPE stringtab,
      set_free_text            RETURNING VALUE(rs_free_text)      TYPE zsd_standard_text,
      set_delivery_times       RETURNING VALUE(rt_delivery_times) TYPE zmm_tt_printform_delivery_time,

      set_eindt RETURNING VALUE(rv_eindt) TYPE eindt,

      set_menge IMPORTING iv_menge        TYPE bstmg
                RETURNING VALUE(rv_menge) TYPE string,

      set_meins IMPORTING iv_meins        TYPE bstme
                RETURNING VALUE(rv_meins) TYPE string,

      set_mhdrz IMPORTING iv_eindt        TYPE eindt
                RETURNING VALUE(rv_mhdrz) TYPE eindt,

      set_konnr RETURNING VALUE(rv_konnr) TYPE konnr,
      set_iotxt RETURNING VALUE(rv_iotxt) TYPE string,
      set_netpr RETURNING VALUE(rv_netpr) TYPE char10,

      set_vat_data CHANGING cv_vat_rate TYPE char10
                            cv_wmwst    TYPE wmwst,

      add_sum_block IMPORTING iv_vat_rate TYPE char10
                              iv_wmwst    TYPE wmwst,

      finalize_sum_block RETURNING VALUE(rs_sum_block) TYPE zmm_sum_block_09,

      check_incoterms_similarity CHANGING  ct_items        TYPE zmm_purchase_ord_t
                                 RETURNING VALUE(rv_inco1) TYPE inco1,

      calc_fill_tab          RETURNING VALUE(rt_fill_tab)   TYPE stringtab,
      get_active_fields,
      "!Prüft, ob alle Positionen dem gleichen Werk angehören
      "! @parameter rv_is_uniform | Kennzeichen für Gleichheit
      check_werks_similarity RETURNING VALUE(rv_is_uniform) TYPE abap_bool,
      "!ILN des Werks wird bestimmt
      "! @parameter rv_iln | Werks-ILN
      get_iln_werks          RETURNING VALUE(rv_iln)        TYPE string.

  PRIVATE SECTION.
    DATA: mt_ekpo           TYPE ty_mmpur_print_ekpo,
          ms_ekko           TYPE mmpur_print_ekko,
          mt_t166p          TYPE ty_mmpur_print_t166p,
          ms_t166u          TYPE t166u,
          mt_week_days      TYPE ddfixvalues,
          ms_adrs_recipient TYPE adrs_print,
          ms_item           TYPE mmpur_print_ekpo,
          mv_hidden_lines   TYPE i,
          mv_added_lines    TYPE i,
          ms_sum_block      TYPE zmm_sum_block_09,
          ms_active_fields  TYPE zmm_layout_activ_s,
          mt_t166t          TYPE ty_mmpur_print_t166t.
ENDCLASS.

CLASS zcl_mm_forms IMPLEMENTATION.
  METHOD constructor.
    ms_ekko = is_ekko.
    mt_ekpo = it_ekpo.

    IF iv_mode = 2              " Change order
       OR lines( it_ekpo ) = 0. " Occurred in a test case
      fill_ekpo( ).
    ENDIF.

    mt_t166p = it_t166p.
    ms_t166u = is_t166u.
    mt_t166t = it_t166t.

    ms_adrs_recipient = read_bukrs_address( ).
  ENDMETHOD.

  METHOD fill_ekpo.
    REFRESH mt_ekpo.

    SELECT *
      FROM ekpo
     WHERE ebeln = '4500002848'
      INTO CORRESPONDING FIELDS OF TABLE @mt_ekpo.

    LOOP AT mt_ekpo ASSIGNING FIELD-SYMBOL(<s_ekpo>) WHERE loekz = 'L' OR elikz = 'X'.
      <s_ekpo>-menge = '0'.
    ENDLOOP.
  ENDMETHOD.

  METHOD read_bukrs_address.
    SELECT SINGLE adrnr
      FROM t001
     WHERE bukrs = @ms_ekko-bukrs
      INTO @DATA(lv_adrnr).

    CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
      EXPORTING
        address_type                   = '1'
        address_number                 = lv_adrnr
      IMPORTING
        address_printform              = rs_adrs_recipient
      EXCEPTIONS
        address_blocked                = 1
        person_blocked                 = 2
        contact_person_blocked         = 3
        addr_to_be_formated_is_blocked = 4
        OTHERS                         = 5.
    IF sy-subrc <> 0.
      MESSAGE i001(00) WITH |ZCL_MM_FORMS-READ_BUKRS_ADDRESS: { sy-subrc }, { sy-msgv1 }{ sy-msgv2 }{ sy-msgv3 }{ sy-msgv4 }.|.
    ENDIF.

    SELECT SINGLE but000~location_1,
                  but000~location_2,
                  but000~location_3
      FROM but020
      JOIN but000 ON but000~partner = but020~partner
     WHERE addrnumber = @ms_ekko-adrnr
      INTO @DATA(ls_iln).

    DO 10 TIMES.
      ASSIGN COMPONENT sy-index OF STRUCTURE rs_adrs_recipient TO FIELD-SYMBOL(<s_line>).

      IF <s_line> IS NOT ASSIGNED. " All 10 fields filled
        EXIT.
      ELSEIF <s_line> IS INITIAL.  " Free line found
        <s_line> = |ILN: { ls_iln-location_1 }{ ls_iln-location_2 }/{ ls_iln-location_3 }|.
        EXIT.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD main.
    get_active_fields( ).
    es_active_fields  = ms_active_fields.
    ms_active_fields-z_position_preise = ''. " Prices should currently remain generally hidden
*Set header data--------------------------------------------------------
    IF sy-sysid <> 'PS1'.
      DATA(lo_sd_print_form) = NEW zcl_sd_print_form( ).

      ev_watermark = lo_sd_print_form->get_watermark_testbeleg( ).
    ENDIF.

    ev_logo           = set_logo( ).
    ev_footer         = set_footer( ).
    ev_bsart          = ms_t166u-drtyp.
    ev_eikto          = set_eikto( ).
    et_adrs_recipient = set_adrs_recipient( ).
    ev_adrs_rec_short = set_adrs_recipient_short( ).
    et_adrs_sender    = set_adrs_sender( ).
    es_free_text      = set_free_text( ).
    et_delivery_times = set_delivery_times( ).
*Set items data--------------------------------------------------------
    DATA: lv_eindt    TYPE eindt,
          lv_vat_rate TYPE char10,
          lv_wmwst    TYPE wmwst.

    LOOP AT mt_ekpo INTO ms_item.
      CLEAR: lv_eindt, lv_vat_rate, lv_wmwst.

      lv_eindt = set_eindt( ).
      set_vat_data( CHANGING cv_vat_rate = lv_vat_rate
                             cv_wmwst    = lv_wmwst ).

      APPEND VALUE #( chtxt = VALUE #( mt_t166t[ ebelp = ms_item-ebelp ]-chtxt OPTIONAL )
                      idnlf = COND #( WHEN ms_item-idnlf IS INITIAL THEN 'XXXX' ELSE ms_item-idnlf )
                      menge = |{ set_menge( ms_item-menge ) } { set_meins( ms_item-meins ) }|
                      artbz = ms_item-txz01
                      mhd   = set_mhdrz( iv_eindt = lv_eindt )
                      konnr = set_konnr( )
                      iotxt = set_iotxt( )
                      netpr = set_netpr( )
                      bprme = COND #( WHEN ms_item-prsdr IS NOT INITIAL AND ms_active_fields-z_position_preise IS NOT INITIAL THEN |1 { ms_item-bprme }| )
                      kbetr = |{ lv_vat_rate }|
                      inco1 = ms_item-inco1
                      matnr = ms_item-matnr
                      eindt = lv_eindt ) TO et_items.

      add_sum_block( iv_vat_rate = lv_vat_rate
                     iv_wmwst    = lv_wmwst ).
    ENDLOOP.

    es_sum_block = finalize_sum_block( ).
    ev_inco1     = check_incoterms_similarity( CHANGING ct_items = et_items ).

    IF check_werks_similarity( ) = abap_true.
      ev_iln_werks = get_iln_werks( ).
    ENDIF.

    IF ms_active_fields-z_position_preise = 'X'.
      et_fill_tab  = calc_fill_tab( ).
    ENDIF.
  ENDMETHOD.

  METHOD add_deliver_time.
    APPEND INITIAL LINE TO ct_delivery_time ASSIGNING FIELD-SYMBOL(<ls_new>).
*Days------------------------------------------------------------------
    mt_week_days = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_name( 'CACSDAYWEEK' ) )->get_ddic_fixed_values( 'D' ).

    DATA(lv_day_begin) = COND text15( WHEN mt_week_days IS NOT INITIAL
                                      THEN mt_week_days[ low = iv_day_begin ]-ddtext
                                      ELSE iv_day_begin ).

    DATA(lv_day_end)   = COND text15( WHEN mt_week_days IS NOT INITIAL
                                      THEN mt_week_days[ low = iv_day_end ]-ddtext
                                      ELSE iv_day_end ).

    <ls_new>-delivery_days = COND #( WHEN iv_day_begin <> iv_day_end
                                     THEN |{ lv_day_begin } - { lv_day_end }|
                                     ELSE |{ lv_day_begin }| ).
*Time slot-------------------------------------------------------------
    <ls_new>-delivery_time = COND #( WHEN is_time-break_start = ''
                                     THEN get_message( iv_msg_number = 002
                                                       is_time       = is_time )
                                     ELSE get_message( iv_msg_number = 003
                                                       is_time       = is_time ) ).
  ENDMETHOD.

  METHOD get_message.
    CALL FUNCTION 'BAPI_MESSAGE_GETDETAIL'
      EXPORTING
        id         = 'ZMM_FORMS'
        number     = iv_msg_number
        language   = 'D'
        textformat = 'ASC'
        message_v1 = convert_time( is_time-delivery_start )
        message_v2 = convert_time( is_time-break_start )
        message_v3 = convert_time( is_time-break_end )
        message_v4 = convert_time( is_time-delivery_end )
      IMPORTING
        message    = rv_message.
  ENDMETHOD.

  METHOD convert_time.
    SET COUNTRY 'US'.

    cl_abap_timefm=>conv_time_int_to_ext(
      EXPORTING
        time_int            = iv_time            " Type T für internes Zeitformat
        without_seconds     = abap_true          " Flag für Sekunden
        format_according_to = 1
      IMPORTING
        time_ext            = DATA(lv_converted_time) ).

    rv_converted_time = CONV #( lv_converted_time ).
  ENDMETHOD.

  METHOD set_logo.
    DATA: lv_logo_url TYPE char255.

    SELECT bukrs,
           mime_url
      FROM zsd_bukrs_logo
     WHERE bukrs = @ms_ekko-bukrs
        OR bukrs = '*'
      INTO TABLE @DATA(lt_logo).

    TRY.
        lv_logo_url = COND #( WHEN lt_logo[ bukrs = ms_ekko-bukrs ]-mime_url = '*'
                              THEN lt_logo[ bukrs = '*' ]-mime_url
                              ELSE lt_logo[ bukrs = ms_ekko-bukrs ]-mime_url ).
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    DATA(lo_api) = cl_mime_repository_api=>get_api( ).

    lo_api->get( EXPORTING i_url               = lv_logo_url
                           i_check_authority   = abap_false
                 IMPORTING         e_content   = rv_logo
                 EXCEPTIONS parameter_missing  = 1
                            error_occured      = 2
                            not_found          = 3
                            permission_failure = 4
                            OTHERS             = 5 ).
  ENDMETHOD.

  METHOD set_footer.
    SELECT *
      FROM zbc_forms_config
     WHERE    bukrs   = @ms_ekko-bukrs
       AND   datab   <= @sy-datum
       AND ( datbi   >= @sy-datum OR datbi IS INITIAL )
       AND bezeichner = 'FOOTER'
      INTO TABLE @DATA(lt_forms_config).

    rv_footer = VALUE #( lt_forms_config[ 1 ]-url OPTIONAL ).
  ENDMETHOD.

  METHOD set_eikto.
    SELECT SINGLE eikto
      FROM lfm1
     WHERE lifnr = @ms_ekko-lifnr
       AND ekorg = @ms_ekko-ekorg
      INTO @rv_eikto.
  ENDMETHOD.

  METHOD set_adrs_recipient.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE ms_adrs_recipient TO FIELD-SYMBOL(<fs_field>).
      IF sy-subrc <> 0 OR <fs_field> = ''.
        EXIT.
      ELSEIF sy-index <> 1.
        APPEND <fs_field> TO rt_adrs_recipient.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD set_adrs_recipient_short.
    IF ms_ekko-bukrs = '1300'.
      rv_adrs_rec_short = 'CITTI • Immobilienabteilung • Mühlendamm 1 • 24113 Kiel'.
    ELSEIF ms_ekko-bukrs = '1310'.
      rv_adrs_rec_short = 'GK GROSSKAUF • Immobilienabteilung • Mühlendamm 1 • 24113 Kiel'.
    ELSE.
      rv_adrs_rec_short = |{ ms_adrs_recipient-line1 } - { ms_adrs_recipient-line2 } - { ms_adrs_recipient-line3 }|.
    ENDIF.
  ENDMETHOD.

  METHOD set_adrs_sender.
    SELECT SINGLE name1,
                  name2,
                  street,
                  house_num1,
                  post_code1,
                  city1,
                  country
      FROM adrc
     WHERE addrnumber = @ms_ekko-adrnr
      INTO @DATA(ls_adrc).

    APPEND ls_adrc-name1 TO rt_adrs_sender.

    IF ls_adrc-name2 IS NOT INITIAL.
      APPEND ls_adrc-name2 TO rt_adrs_sender.
    ENDIF.

    APPEND |{ ls_adrc-street } { ls_adrc-house_num1 }| TO rt_adrs_sender.

    APPEND |{ ls_adrc-post_code1 } { ls_adrc-city1 CASE = UPPER }| TO rt_adrs_sender.

    IF ls_adrc-country <> 'DE'.
      SELECT SINGLE landx50
        FROM t005t
       WHERE spras = 'E'
         AND land1 = @ls_adrc-country
        INTO @DATA(lv_country).
    ELSE.
      lv_country = 'DEUTSCHLAND'.
    ENDIF.

    APPEND |{ lv_country CASE = UPPER }| TO rt_adrs_sender.

    SELECT SINGLE taxnum
      FROM dfkkbptaxnum
     WHERE partner = @ms_ekko-lifnr
      INTO @DATA(lv_ust_id).

    APPEND |USt-ID: { lv_ust_id }| TO rt_adrs_sender.

    SELECT SINGLE but000~location_1,
                  but000~location_2,
                  but000~location_3
      FROM but020
      JOIN but000 ON but000~partner = but020~partner
     WHERE addrnumber = @ms_ekko-adrnr
      INTO @DATA(ls_iln).

    APPEND |ILN: { ls_iln-location_1 }{ ls_iln-location_2 }/{ ls_iln-location_3 }| TO rt_adrs_sender.
  ENDMETHOD.

  METHOD set_free_text.
    SELECT SINGLE *
      FROM stxh
      INTO CORRESPONDING FIELDS OF @rs_free_text
     WHERE tdname   = @ms_ekko-ebeln
       AND tdspras  = 'D'
       AND tdid     = 'F01'
       AND tdobject = 'EKKO'.

    IF sy-subrc = 0.
      rs_free_text-is_active = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD set_delivery_times.
    DATA: lt_storage_condition TYPE zmm_tt_storage_condition,
          lv_plant             TYPE werks_d,
          ls_times             TYPE ts_delivery_times,
          lv_day_begin         TYPE cacsdayweek,
          lv_day_end           TYPE cacsdayweek.

    SELECT raube
      FROM mara
       FOR ALL ENTRIES IN @mt_ekpo
     WHERE matnr = @mt_ekpo-matnr
      INTO TABLE @lt_storage_condition.

    "Build Range table
    DATA(lt_r_storage_condition) = VALUE zmm_tt_range_storage_condition( FOR <ls_storage_cond>
                                                                          IN lt_storage_condition
                                                                       WHERE ( storage_condition IS NOT INITIAL )
                                                                             sign   = 'I'
                                                                             option = 'EQ'
                                                                             ( low = <ls_storage_cond>-storage_condition ) ).
    " Remove duplicates
    SORT lt_r_storage_condition BY low ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_r_storage_condition COMPARING low.

    " Add default storage condition
    APPEND VALUE zmm_s_range_storage_condition( sign   = 'I'
                                                option = 'EQ'
                                                low    = '*' ) TO lt_r_storage_condition.
    IF lines( mt_ekpo ) <> 0.
      lv_plant = mt_ekpo[ 1 ]-werks.
    ENDIF.

    SELECT *
      FROM zmm_sc_arrivl_tm
      INTO TABLE @DATA(lt_delvry_times)
      WHERE plant              = @lv_plant
        AND storage_condition IN @lt_r_storage_condition
      ORDER BY storage_condition, weekday ASCENDING.

    " Build delivery time table
    LOOP AT lt_r_storage_condition ASSIGNING FIELD-SYMBOL(<ls_storage_condition>).
      DATA(lv_condition) = COND raube( WHEN line_exists( lt_delvry_times[ storage_condition = <ls_storage_condition>-low ] )
                                       THEN <ls_storage_condition>-low
                                       ELSE '*' ).

      " Delivery times for storage condition already added in return table
      IF line_exists( rt_delivery_times[ storage_condition = lv_condition ] ).
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO rt_delivery_times ASSIGNING FIELD-SYMBOL(<ls_return>).
      <ls_return>-storage_condition = lv_condition.

      LOOP AT lt_delvry_times ASSIGNING FIELD-SYMBOL(<ls_times>) WHERE storage_condition = lv_condition.
        IF <ls_times>-delivery_start = '' AND lv_day_begin IS INITIAL.
          CONTINUE.
        ENDIF.

        DATA(ls_tmp_times) = CORRESPONDING ts_delivery_times( <ls_times> ).

        IF ls_times IS INITIAL. " Initialize help variables
          ls_times     = ls_tmp_times.
          lv_day_begin = lv_day_end = <ls_times>-weekday.
        ENDIF.

        " If time slot is the same, only update end day; else add delivery time to table and initialize help variables
        IF ls_times = ls_tmp_times.
          lv_day_end = <ls_times>-weekday.

        ELSE.
          IF ls_times-delivery_start <> ''.
            me->add_deliver_time(
              EXPORTING
                is_time          = ls_times          " Einstelliges Kennzeichen
                iv_day_begin     = lv_day_begin     " Wochentag
                iv_day_end       = lv_day_end       " Wochentag
              CHANGING
                ct_delivery_time = <ls_return>-delivery_times " Anlieferzeiten
            ).
          ENDIF.

          ls_times     = ls_tmp_times.
          lv_day_begin = lv_day_end = <ls_times>-weekday.

        ENDIF.
      ENDLOOP.

      " Add last time slot
      IF ls_times-delivery_start <> '' AND sy-subrc = 0.
        me->add_deliver_time(
          EXPORTING
            is_time          = ls_times          " Einstelliges Kennzeichen
            iv_day_begin     = lv_day_begin     " Wochentag
            iv_day_end       = lv_day_end       " Wochentag
          CHANGING
            ct_delivery_time = <ls_return>-delivery_times " Anlieferzeiten
        ).
      ENDIF.

      CLEAR: lv_day_end, lv_day_begin, ls_times.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_eindt.
    SELECT MAX( eindt )
      FROM eket
     WHERE ebeln = @ms_item-ebeln
       AND ebelp = @ms_item-ebelp
      INTO @rv_eindt.
  ENDMETHOD.

  METHOD set_menge.
    DATA: lv_decimal TYPE string.

    IF iv_menge IS INITIAL.
      rv_menge = '0'.
      RETURN.
    ENDIF.

    DATA(lv_raw) = |{ iv_menge }|.
    REPLACE '.' WITH ',' INTO lv_raw.

    "Entferne überflüssige Nullen
    REPLACE ALL OCCURRENCES OF REGEX ',?0+$' IN lv_raw WITH ''.

    SPLIT lv_raw AT ',' INTO lv_raw lv_decimal. " Trenne Ganzzahl/Dezimalteil

    "Umgekehrte Schleife zur Tausenderpunktsetzung
    DATA(lv_len) = strlen( lv_raw ).
    DO lv_len TIMES.
      DATA(lv_pos) = lv_len - sy-index.
      rv_menge = lv_raw+lv_pos(1) && rv_menge.
      IF ( sy-index MOD 3 = 0 ) AND ( lv_pos > 0 ).
        rv_menge = '.' && rv_menge.
      ENDIF.
    ENDDO.

    IF rv_menge(1) = '.'.
      SHIFT rv_menge LEFT DELETING LEADING '.'.
    ENDIF.

    IF lv_decimal IS NOT INITIAL.
      CONCATENATE rv_menge lv_decimal INTO rv_menge SEPARATED BY ','.
    ENDIF.
  ENDMETHOD.

  METHOD set_meins.
    SELECT SINGLE msehl
      FROM t006a
     WHERE spras = @sy-langu
       AND msehi = @iv_meins
      INTO @rv_meins.
  ENDMETHOD.

  METHOD set_mhdrz.
    IF ms_item-mhdrz IS NOT INITIAL AND iv_eindt IS NOT INITIAL.
      rv_mhdrz = iv_eindt + ms_item-mhdrz.
    ELSE.
      mv_hidden_lines += 1.
    ENDIF.
  ENDMETHOD.

  METHOD set_konnr.
    IF ms_item-konnr IS NOT INITIAL AND ms_item-ktpnr IS NOT INITIAL.
      rv_konnr = ms_item-konnr.
    ELSE.
      mv_hidden_lines += 1.
    ENDIF.
  ENDMETHOD.

  METHOD set_iotxt.
    DATA: lv_tdname TYPE tdobname,
          lv_lines  TYPE f,
          lv_f01    TYPE string,
          lv_f02    TYPE string,
          lt_lines  TYPE TABLE OF tline.

    LOOP AT mt_t166p ASSIGNING FIELD-SYMBOL(<s_t166p>) WHERE tdobject = 'EKPO'
                                                         AND   ( tdid = 'F01' OR tdid = 'F02' )
                                                         AND    ebelp = ms_item-ebelp.
      CLEAR lt_lines.
      lv_tdname = |{ ms_item-ebeln }{ ms_item-ebelp }|.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = <s_t166p>-tdid
          language                = 'D'
          name                    = lv_tdname
          object                  = <s_t166p>-tdobject
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
        MESSAGE i001(00) WITH |ZCL_MM_FORMS-SET_IOTXT: { sy-subrc }, { sy-msgv1 }{ sy-msgv2 }{ sy-msgv3 }{ sy-msgv4 }.|.
      ENDIF.

      IF lines( lt_lines ) <> 0 AND <s_t166p>-tdid = 'F01'.
        LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<s_lines_f01>).
          lv_f01 = |{ lv_f01 }{ <s_lines_f01>-tdline }|.
        ENDLOOP.
      ELSEIF lines( lt_lines ) <> 0 AND <s_t166p>-tdid = 'F02'.
        LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<s_lines_f02>).
          lv_f02 = |{ lv_f02 }{ <s_lines_f02>-tdline }|.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    rv_iotxt = |{ lv_f01 } { lv_f02 }|.

    IF rv_iotxt IS INITIAL.
      mv_hidden_lines += 1.
    ENDIF.

    lv_lines = strlen( rv_iotxt ) / 42. "Vorberechnung in float-Variablen ist notwendig
    mv_added_lines += floor( lv_lines ). "Es passen nur 41 Zeichen in eine Zeile des Infobestelltext
  ENDMETHOD.

  METHOD set_netpr.
    IF ms_item-prsdr IS NOT INITIAL AND ms_active_fields-z_position_preise IS NOT INITIAL.
      SELECT SINGLE kbetr
        FROM prcd_elements
       WHERE kschl = 'PB00'
         AND knumv = @ms_ekko-knumv
         AND kposn = @ms_item-ebelp
        INTO @DATA(lv_kbetr).

      rv_netpr = |{ lv_kbetr DECIMALS = 2 } { ms_ekko-waers }|.
    ELSE.
      mv_hidden_lines += 1.
    ENDIF.
  ENDMETHOD.

  METHOD set_vat_data.
    IF ms_active_fields-z_position_preise IS NOT INITIAL.
      DATA: lt_mwdat TYPE STANDARD TABLE OF rtax1u15.

      CALL FUNCTION 'CALCULATE_TAX_FROM_NET_AMOUNT'
        EXPORTING
          i_bukrs           = ms_ekko-bukrs
          i_mwskz           = ms_item-mwskz
          i_waers           = ms_ekko-waers
          i_wrbtr           = CONV wrbtr( ms_item-netwr )
        TABLES
          t_mwdat           = lt_mwdat
        EXCEPTIONS
          bukrs_not_found   = 1
          country_not_found = 2
          mwskz_not_defined = 3
          mwskz_not_valid   = 4
          ktosl_not_found   = 5
          kalsm_not_found   = 6
          parameter_error   = 7
          knumh_not_found   = 8
          kschl_not_found   = 9
          unknown_error     = 10
          account_not_found = 11
          txjcd_not_valid   = 12
          tdt_error         = 13
          txa_error         = 14
          OTHERS            = 15.
      IF sy-subrc <> 0.
        MESSAGE i001(00) WITH |ZCL_MM_FORMS-SET_VAT_DATA: { sy-subrc }, { sy-msgv1 }{ sy-msgv2 }{ sy-msgv3 }{ sy-msgv4 }.|.
      ENDIF.

      cv_vat_rate = abs( VALUE #( lt_mwdat[ kawrt = ms_item-netwr ]-msatz OPTIONAL ) ). "USt-Prozentsatz
      cv_wmwst = abs( VALUE #( lt_mwdat[ kawrt = ms_item-netwr ]-wmwst OPTIONAL ) ). "USt-Betrag
    ENDIF.
  ENDMETHOD.

  METHOD add_sum_block.
    IF NOT line_exists( ms_sum_block-positions[  vat_rate = iv_vat_rate ] ).
      APPEND INITIAL LINE TO ms_sum_block-positions ASSIGNING FIELD-SYMBOL(<tax_sum>).
      <tax_sum>-vat_rate      = iv_vat_rate.
      <tax_sum>-vat_rate_unit = '%'.
      <tax_sum>-currency = ms_ekko-waers.
    ELSE.
      READ TABLE ms_sum_block-positions ASSIGNING <tax_sum> WITH KEY vat_rate = iv_vat_rate.
    ENDIF.

    <tax_sum>-netval_goods +=  ms_item-netwr.
    <tax_sum>-vat_value    +=  iv_wmwst.
    <tax_sum>-groval_total  = <tax_sum>-netval_goods + <tax_sum>-vat_value.
  ENDMETHOD.

  METHOD finalize_sum_block.
    SORT ms_sum_block-positions BY vat_rate ASCENDING.

    LOOP AT ms_sum_block-positions ASSIGNING FIELD-SYMBOL(<total_sum>).
      <total_sum>-netval_total   = <total_sum>-netval_goods + <total_sum>-netval_ggvs + <total_sum>-val_empties.
      ms_sum_block-sum_netval   += <total_sum>-netval_goods.
      ms_sum_block-sum_vatval   += <total_sum>-vat_value.
      ms_sum_block-sum_grossval += <total_sum>-groval_total.
      ms_sum_block-currency      = ms_ekko-waers.
    ENDLOOP.

    rs_sum_block = ms_sum_block.
  ENDMETHOD.

  METHOD calc_fill_tab.
    DATA: lv_position_lines           TYPE p DECIMALS 2 VALUE '6',
          lv_position_line_height     TYPE p DECIMALS 2 VALUE '0.39',
          lv_tax_line_height          TYPE p DECIMALS 2 VALUE '0.5',
          lv_tax_rest_height          TYPE p DECIMALS 2 VALUE '2',
          lv_fill_line_height         TYPE p DECIMALS 2 VALUE '0.1',
          lv_content_height_first     TYPE p DECIMALS 2 VALUE '10',
          lv_content_height_next      TYPE p DECIMALS 2 VALUE '22.66', "-0,14 wegen Rundungsfehlern
          lv_position_height          TYPE p DECIMALS 2,
          lv_position_count           TYPE p DECIMALS 2,
          lv_tax_line_count           TYPE p DECIMALS 2,
          lv_tax_space                TYPE p DECIMALS 2,
          lv_position_space_first     TYPE p DECIMALS 2,
          lv_position_space_next      TYPE p DECIMALS 2,
          lv_free_space               TYPE p DECIMALS 2,
          lv_max_positions_first_page TYPE p DECIMALS 2,
          lv_max_positions_next_page  TYPE p DECIMALS 2,
          lv_overflow_positions       TYPE p DECIMALS 2,
          lv_next_pages_count         TYPE p DECIMALS 2,
          lv_positions_last_page      TYPE p DECIMALS 2,
          lv_free_space_last_page     TYPE p DECIMALS 2,
          lv_rest_space_first_page    TYPE p DECIMALS 2,
          lv_rest_space_next_page     TYPE p DECIMALS 2,
          lv_hidden_space             TYPE p DECIMALS 2,
          lv_do_count                 TYPE i.

    lv_position_height = lv_position_line_height * lv_position_lines.
    lv_position_count = lines( mt_ekpo ).
    lv_tax_line_count = lines( ms_sum_block-positions ).
    lv_tax_space = ( lv_tax_line_height * lv_tax_line_count ) + lv_tax_rest_height.
    lv_max_positions_first_page = floor( lv_content_height_first / lv_position_height ).
    lv_max_positions_next_page = floor( lv_content_height_next / lv_position_height ).

    IF lv_max_positions_first_page > lv_position_count.
      lv_position_space_first = lv_position_height * lv_position_count.
    ELSE.
      lv_position_space_first = lv_position_height * lv_max_positions_first_page.
    ENDIF.

    lv_position_space_next = lv_position_height * lv_max_positions_next_page.

    lv_rest_space_first_page = lv_content_height_first - lv_position_space_first.
    lv_rest_space_next_page = lv_content_height_next - lv_position_space_next.

    lv_free_space = ( lv_content_height_first - ( lv_position_space_first + lv_tax_space ) ).
    lv_hidden_space = mv_hidden_lines * lv_position_line_height / lv_fill_line_height.

    IF lv_free_space > 0. "Nur eine Seite
      lv_do_count = floor( lv_free_space / lv_fill_line_height ) + lv_hidden_space.
      DO lv_do_count TIMES.
        APPEND INITIAL LINE TO rt_fill_tab.
      ENDDO.
    ELSEIF lv_free_space + lv_tax_space > 0. "Nur Summenbereich auf nächster Seite
      lv_do_count = floor( ( lv_rest_space_first_page + ( lv_content_height_next - lv_tax_space ) ) / lv_fill_line_height ) + lv_hidden_space + mv_added_lines * lv_position_line_height.
      DO lv_do_count TIMES.
        APPEND INITIAL LINE TO rt_fill_tab.
      ENDDO.
    ELSE.
      lv_overflow_positions = lv_position_count - lv_max_positions_first_page.
      lv_next_pages_count = floor( lv_overflow_positions / lv_max_positions_next_page ).
      lv_positions_last_page = lv_overflow_positions - ( lv_max_positions_next_page * lv_next_pages_count ).
      lv_free_space_last_page = ( lv_content_height_next - ( ( lv_positions_last_page * lv_position_height ) + lv_tax_space + lv_tax_rest_height ) ).
      IF lv_free_space_last_page > 0.
        lv_do_count = floor( lv_free_space_last_page / lv_fill_line_height ) + lv_hidden_space + mv_added_lines * lv_position_line_height.
        DO lv_do_count TIMES.
          APPEND INITIAL LINE TO rt_fill_tab.
        ENDDO.
      ELSEIF lv_free_space_last_page + lv_tax_space > 0.
        lv_do_count = floor( ( lv_rest_space_next_page + ( lv_content_height_next - lv_tax_space ) ) / lv_fill_line_height ) + lv_hidden_space + mv_added_lines * lv_position_line_height.
        DO lv_do_count TIMES.
          APPEND INITIAL LINE TO rt_fill_tab.
        ENDDO.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD check_incoterms_similarity.
    IF lines( mt_ekpo ) <> 0.
      DATA(lv_is_uniform) = REDUCE abap_bool(
        INIT result = abap_true
        FOR row IN mt_ekpo
        NEXT result = COND abap_bool(
          WHEN result = abap_true AND ( row-inco1 = mt_ekpo[ 1 ]-inco1 )
          THEN abap_true
          ELSE abap_false ) ).
    ENDIF.

    IF lv_is_uniform = abap_true.
      LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<fs_item>).
        CLEAR <fs_item>-inco1.
      ENDLOOP.

      rv_inco1 = ms_ekko-inco1.
      IF ms_active_fields-z_position_preise IS INITIAL.
        mv_hidden_lines += 1.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_active_fields.
    DATA: lt_layout TYPE zsd_layout_t.

    DATA(lo_sd_print_form) = NEW zcl_sd_print_form( ).

    lo_sd_print_form->get_layout_and_control_fields( EXPORTING is_customer = VALUE #( purch_org = ms_ekko-ekorg
                                                                                      vendor    = ms_ekko-lifnr )
                                                               iv_application   = 'EF'
                                                               iv_output_type   = 'ZBNF'
                                                               iv_company_code  = ms_ekko-bukrs
                                                     IMPORTING es_active_fields = ms_active_fields
                                                     CHANGING  ct_layout        = lt_layout ).
  ENDMETHOD.

  METHOD check_werks_similarity.
    DATA(lv_lines) = lines( mt_ekpo ).

    IF lv_lines = 0.
      rv_is_uniform = abap_false.
    ELSEIF lv_lines = 1.
      rv_is_uniform = abap_true.
    ELSEIF lv_lines > 1.
      rv_is_uniform = REDUCE abap_bool(
        INIT result = abap_true
        FOR row IN mt_ekpo
        NEXT result = COND abap_bool(
          WHEN result = abap_true AND ( row-werks = mt_ekpo[ 1 ]-werks )
          THEN abap_true
          ELSE abap_false ) ).
    ENDIF.
  ENDMETHOD.

  METHOD get_iln_werks.
    TRY.
        DATA(lv_werks) = mt_ekpo[ 1 ]-werks.
      CATCH cx_sy_itab_line_not_found.
      RETURN.
    ENDTRY.

    SELECT SINGLE but000~location_1,
                  but000~location_2,
                  but000~location_3
      FROM but000
      JOIN t001w ON t001w~kunnr = but000~partner
     WHERE t001w~werks = @lv_werks
      INTO @DATA(ls_iln).

    rv_iln = |{ ls_iln-location_1 }{ ls_iln-location_2 }/{ ls_iln-location_3 }|.
  ENDMETHOD.
ENDCLASS.
