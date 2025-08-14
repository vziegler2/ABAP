  METHOD save_modified.
    TYPES: BEGIN OF szal_lognumber,
             item TYPE balhdr-lognumber,
           END OF szal_lognumber,
           tn_s_appl_log_logno    TYPE szal_lognumber,
           tn_t_appl_log_logno    TYPE STANDARD TABLE OF tn_s_appl_log_logno WITH DEFAULT KEY,
           tn_t_appl_log_messages TYPE STANDARD TABLE OF balm WITH DEFAULT KEY.

    DATA: lt_plantdata           TYPE TABLE OF bapie1marcrt,
          lt_plantdatax          TYPE TABLE OF bapie1marcrtx,
          lt_storagedata         TYPE TABLE OF bapie1mardrt,
          lt_storagedatax        TYPE TABLE OF bapie1mardrtx,
          lt_clientdata          TYPE TABLE OF bapie1marart,
          lt_clientdatax         TYPE TABLE OF bapie1marartx,
          lt_salesdata           TYPE TABLE OF bapie1mvkert,
          lt_salesdatax          TYPE TABLE OF bapie1mvkertx,
          lt_forecastparameters  TYPE TABLE OF bapie1mpoprt,
          lt_forecastparametersx TYPE TABLE OF bapie1mpoprtx,
          lt_massupdate          TYPE TABLE OF zi_massedit,
          ls_headdata            TYPE bapie1mathead,
          lv_return              TYPE bapireturn1,
          lt_lognumber           TYPE tn_t_appl_log_logno,
          ls_lognumber           TYPE tn_s_appl_log_logno,
          lt_messages            TYPE tn_t_appl_log_messages.

    IF update IS INITIAL.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_massedit IN LOCAL MODE
         ENTITY zi_massedit
         ALL FIELDS
         WITH CORRESPONDING #( update-zi_massedit )
         RESULT DATA(lt_massedit).

    lt_massupdate = CORRESPONDING #( update-zi_massedit USING CONTROL ).

    LOOP AT lt_massedit ASSIGNING FIELD-SYMBOL(<ls_massupdate>).

      READ TABLE lt_massupdate INDEX 1 ASSIGNING FIELD-SYMBOL(<massupdate_control>).
      " MARC updates (plant data)
      APPEND INITIAL LINE TO lt_plantdata ASSIGNING FIELD-SYMBOL(<ls_plantdata>).
      APPEND INITIAL LINE TO lt_plantdatax ASSIGNING FIELD-SYMBOL(<ls_plantdatax>).
      <ls_plantdata>-function = '004'.
      <ls_plantdatax>-function = '004'.
      <ls_plantdata>-material = <ls_massupdate>-Matnr.
      <ls_plantdatax>-material = <ls_massupdate>-Matnr.
      <ls_plantdata>-plant = <ls_massupdate>-Werks.
      <ls_plantdatax>-plant = <ls_massupdate>-Werks.

      <ls_plantdata>-pur_status = <ls_massupdate>-Mmsta.
      <ls_plantdatax>-pur_status = 'X'.
      <ls_plantdata>-pvalidfrom = sy-datum.
      <ls_plantdatax>-pvalidfrom = 'X'.
      IF <ls_massupdate>-Mmsta = '20'.
        IF <ls_massupdate>-Mstae = '15'.
          APPEND INITIAL LINE TO lt_clientdata ASSIGNING FIELD-SYMBOL(<ls_clientdata>).
          APPEND INITIAL LINE TO lt_clientdatax ASSIGNING FIELD-SYMBOL(<ls_clientdatax>).
          <ls_clientdata>-function = '004'.
          <ls_clientdatax>-function = '004'.
          <ls_clientdata>-material = <ls_massupdate>-Matnr.
          <ls_clientdatax>-material = <ls_massupdate>-Matnr.
          <ls_clientdata>-pur_status = '20'.
          <ls_clientdatax>-pur_status = 'X'.
          ls_headdata-basic_view = 'X'.
          ls_headdata-list_view  = 'X'.
        ENDIF.
      ENDIF.

      <ls_plantdata>-mrp_ctrler = <ls_massupdate>-Dispo.
      <ls_plantdatax>-mrp_ctrler = 'X'.

      <ls_plantdata>-pur_group = <ls_massupdate>-Ekgrp.
      <ls_plantdatax>-pur_group = 'X'.

      <ls_plantdata>-reorder_pt = <ls_massupdate>-Minbe.
      <ls_plantdatax>-reorder_pt = 'X'.

      <ls_plantdata>-minlotsize = <ls_massupdate>-Bstmi.
      <ls_plantdatax>-minlotsize = 'X'.

      <ls_plantdata>-fixed_lot = <ls_massupdate>-Bstfe.
      <ls_plantdatax>-fixed_lot = 'X'.

      <ls_plantdata>-round_val = <ls_massupdate>-Bstrf.
      <ls_plantdatax>-round_val = 'X'.

      <ls_plantdata>-plnd_delry = <ls_massupdate>-Plifz.
      <ls_plantdatax>-plnd_delry = 'X'.

      <ls_plantdata>-sloc_exprc = <ls_massupdate>-Lgfsb.
      <ls_plantdatax>-sloc_exprc = 'X'.

      <ls_plantdata>-gi_pr_time = <ls_massupdate>-Gi_pr_time.
      <ls_plantdatax>-gi_pr_time = 'X'.

      <ls_plantdata>-plng_cycle = <ls_massupdate>-Lfrhy.
      <ls_plantdatax>-plng_cycle = 'X'.

      <ls_plantdata>-round_prof = <ls_massupdate>-Rdprf.
      <ls_plantdatax>-round_prof = 'X'.

      <ls_plantdata>-gr_pr_time = <ls_massupdate>-Webaz.
      <ls_plantdatax>-gr_pr_time = 'X'.

      " prefill with KEIN when empty?
*        IF <massupdate_control>-Dispr IS INITIAL.
*            <massupdate_control>-Dispr = 'KEIN'.
*            <ls_plantdata>-mrpprofile = 'KEIN'.
*            <ls_plantdatax>-mrpprofile = 'X'.
*        ELSE.
*            <ls_plantdata>-mrpprofile = <ls_massupdate>-Dispr.
*            <ls_plantdatax>-mrpprofile = 'X'.
*        ENDIF.

      <ls_plantdata>-mrpprofile = <ls_massupdate>-Dispr.
      <ls_plantdatax>-mrpprofile = 'X'.

      IF <massupdate_control>-Dispr IS NOT INITIAL.
        " these fields are only supposed to change if a new MRP profile is selected (passive dependency, not actively changeable in the UI)

        " Fetch data from value help CDS view based on the selected MRP profile and update accordingly
        DATA lt_cds_data TYPE TABLE OF zmm_marc_dispr_vh.
        SELECT * FROM zmm_marc_dispr_vh INTO TABLE @lt_cds_data
          WHERE dispr = @<massupdate_control>-Dispr.

        LOOP AT lt_cds_data ASSIGNING FIELD-SYMBOL(<ls_cds_data>).
          <ls_plantdata>-mrp_type = <ls_cds_data>-Dismm.
          <ls_plantdatax>-mrp_type = 'X'.

          <ls_plantdata>-mrp_group = <ls_cds_data>-Disgr.
          <ls_plantdatax>-mrp_group = 'X'.

          <ls_plantdata>-lotsizekey = <ls_cds_data>-Disls.
          <ls_plantdatax>-lotsizekey = 'X'.

          <ls_plantdata>-plan_strgp = <ls_cds_data>-Strgr.
          <ls_plantdatax>-plan_strgp = 'X'.

          <ls_plantdata>-ppc_pl_cal = <ls_cds_data>-Mrppp.
          <ls_plantdatax>-ppc_pl_cal = 'X'.

          <ls_plantdata>-availcheck = <ls_cds_data>-Mtvfp.
          <ls_plantdatax>-availcheck = 'X'.
        ENDLOOP.
      ENDIF.

      "(only update storage bin(Lgpbe) when storage location(lgfsb) is not empty
      IF <ls_massupdate>-lgfsb IS NOT INITIAL.
        " MARD updates (storage data)
        APPEND INITIAL LINE TO lt_storagedata ASSIGNING FIELD-SYMBOL(<ls_storagedata>).
        APPEND INITIAL LINE TO lt_storagedatax ASSIGNING FIELD-SYMBOL(<ls_storagedatax>).

        <ls_storagedata>-function = '004'.
        <ls_storagedatax>-function = '004'.
        <ls_storagedata>-material = <ls_massupdate>-Matnr.
        <ls_storagedatax>-material = <ls_massupdate>-Matnr.
        <ls_storagedata>-plant = <ls_massupdate>-Werks.
        <ls_storagedatax>-plant = <ls_massupdate>-Werks.
        <ls_storagedata>-stge_loc = <ls_massupdate>-Lgfsb.
        <ls_storagedatax>-stge_loc = <ls_massupdate>-Lgfsb.

        <ls_storagedata>-stge_bin = <ls_massupdate>-Lgpbe.
        <ls_storagedatax>-stge_bin = 'X'.
      ENDIF.

      " PROP updates (forecast data)
      APPEND INITIAL LINE TO lt_forecastparameters ASSIGNING FIELD-SYMBOL(<ls_forecastparameters>).
      APPEND INITIAL LINE TO lt_forecastparametersx ASSIGNING FIELD-SYMBOL(<ls_forecastparametersx>).

      <ls_forecastparameters>-function = '004'.
      <ls_forecastparametersx>-function = '004'.
      <ls_forecastparameters>-material = <ls_massupdate>-Matnr.
      <ls_forecastparametersx>-material = <ls_massupdate>-Matnr.
      <ls_forecastparameters>-plant = <ls_massupdate>-Werks.
      <ls_forecastparametersx>-plant = <ls_massupdate>-Werks.
      <ls_forecastparameters>-fore_prof = <ls_massupdate>-Propr.
      <ls_forecastparametersx>-fore_prof = 'X'.

      ls_headdata-function   = '004'.
      ls_headdata-material   = <ls_massupdate>-matnr.
      ls_headdata-logst_view = 'X'.

      IF <massupdate_control>-mmsta = '20'. " New changed plant-specific status value
        ls_headdata = VALUE #( BASE ls_headdata
                               basic_view = 'X'
                               sales_view = 'X'
                               logdc_view = 'X' ).

        <ls_plantdata> = VALUE #( BASE <ls_plantdata>
                                  plng_cycle = 'T05' ).

        <ls_plantdatax> = VALUE #( BASE <ls_plantdatax>
                                   plng_cycle = 'X' ).

        APPEND VALUE #( material   = <ls_massupdate>-matnr
                        sal_status = '17'
                        svalidfrom = sy-datum ) TO lt_clientdata.

        APPEND VALUE #( material   = <ls_massupdate>-matnr
                        sal_status = 'X'
                        svalidfrom = 'X' ) TO lt_clientdatax.

        APPEND VALUE #( material   = <ls_massupdate>-matnr
                        sales_org  = '3100'
                        distr_chan = '01'
                        sal_status = '17'
                        valid_from = sy-datum ) TO lt_salesdata.

        APPEND VALUE #( material   = <ls_massupdate>-matnr
                        sales_org  = '3100'
                        distr_chan = '01'
                        sal_status = 'X'
                        valid_from = 'X' ) TO lt_salesdatax.
      ENDIF.

      CALL FUNCTION 'Z_MM_MATDATA_MASSEDIT'
        EXPORTING iv_headdata            = ls_headdata
        IMPORTING ev_return              = lv_return
        TABLES    it_plantdata           = lt_plantdata
                  it_plantdatax          = lt_plantdatax
                  it_storagedata         = lt_storagedata
                  it_storagedatax        = lt_storagedatax
                  it_clientdata          = lt_clientdata
                  it_clientdatax         = lt_clientdatax
                  it_salesdata           = lt_salesdata
                  it_salesdatax          = lt_salesdatax
                  it_forecastparameters  = lt_forecastparameters
                  it_forecastparametersx = lt_forecastparametersx.

      IF lv_return-type = 'E'.
        ls_lognumber-item = lv_return-log_no.

        IF NOT line_exists( lt_lognumber[ item = ls_lognumber-item ] ).
          INSERT ls_lognumber INTO TABLE lt_lognumber.
        ENDIF.

        CALL FUNCTION 'APPL_LOG_READ_DB_WITH_LOGNO'
          TABLES lognumbers = lt_lognumber
                 messages   = lt_messages.

        LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_messages>).
          IF <ls_messages>-msgty <> 'E'.
            CONTINUE.
          ENDIF.

          DATA(lo_message_reported) = new_message( id       = <ls_messages>-msgid
                                                   number   = <ls_messages>-msgno
                                                   severity = if_abap_behv_message=>severity-error
                                                   v1       = <ls_messages>-msgv1
                                                   v2       = <ls_messages>-msgv2
                                                   v3       = <ls_messages>-msgv3
                                                   v4       = <ls_messages>-msgv4 ).

          APPEND VALUE #( %msg        = lo_message_reported
                          %key-Matnr  = <ls_massupdate>-Matnr
                          %key-Werks  = <ls_massupdate>-Werks
                          %update     = 'X'
                          %op-%update = if_abap_behv=>mk-on
                          Matnr       = <ls_massupdate>-Matnr
                          Werks       = <ls_massupdate>-Werks ) TO reported-zi_massedit.

          APPEND VALUE #( %tky        = <ls_massupdate>-%tky
                          %op-%update = if_abap_behv=>mk-on ) TO failed-zi_massedit.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
