class ZCL_MKRTEST_APPL01 definition
  public
  final
  create public .

public section.

  data GS_CURRENT_DATA2 type ZDP_MX_S_2 .

  methods CONSTRUCTOR .
  methods CONV_SELOPT
    importing
      !IT_SELOPT type ANY TABLE
    returning
      value(RT_SELOPT) type RSDSSELOPT_T .
  methods GET_DATA1 .
  methods PAI_0001
    importing
      !IV_OKCODE type SYUCOMM .
  methods PBO_0001 .
  methods POPUP_PAI_0001
    importing
      !IV_OKCODE type SYUCOMM .
  methods POPUP_PBO_0001 .
  methods SET_SELECTION_SCREEN_DATA
    importing
      !IT_MATNR type RSDSSELOPT_T
      !IT_WERKS type RSDSSELOPT_T
      !IT_MTART type RSDSSELOPT_T .
protected section.
private section.

  types:
    GTY_TT_DATA1 TYPE TABLE OF ZDP_MX_S_1 .
  types:
    GTY_TT_DATA2 TYPE TABLE OF ZDP_MX_S_2 .

  constants GC_STRUC1 type TABNAME value 'ZDP_MX_S_1' ##NO_TEXT.
  constants GC_STRUC2 type TABNAME value 'ZDP_MX_S_2' ##NO_TEXT.
  constants GC_STRUC3 type TABNAME value 'MCHB' ##NO_TEXT.
  data GO_CONT type ref to CL_GUI_DOCKING_CONTAINER .
  data GO_SPLIT type ref to CL_GUI_SPLITTER_CONTAINER .
  data GO_CONT_POPUP type ref to CL_GUI_CUSTOM_CONTAINER .
  data GO_GRID1 type ref to CL_GUI_ALV_GRID .
  data GO_GRID2 type ref to CL_GUI_ALV_GRID .
  data GO_GRID3 type ref to CL_GUI_ALV_GRID .
  data GR_MATNR type RSDSSELOPT_T .
  data GR_WERKS type RSDSSELOPT_T .
  data GR_MTART type RSDSSELOPT_T .
  data GT_DATA1 type GTY_TT_DATA1 .
  data GT_DATA2 type GTY_TT_DATA2 .
  data GT_DATA3 type MCHB_TTY .

  methods CREATE_CONTROLS .
  methods GET_DATA2
    importing
      !IV_MATNR type MATNR
      !IV_WERKS type WERKS_D .
  methods GET_FC1
    returning
      value(RT_FC) type LVC_T_FCAT .
  methods GET_FC2
    returning
      value(RT_FC) type LVC_T_FCAT .
  methods GET_FC3
    returning
      value(RT_FC) type LVC_T_FCAT .
  methods HANDLE_DOUBLE_CLICK1
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods HANDLE_HOTSPOT2
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
  methods HANDLE_TOOLBAR1
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods HANDLE_TOOLBAR2
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !E_OBJECT
      !E_INTERACTIVE .
  methods HANDLE_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !E_UCOMM .
  methods SHOW_BATCH_STOCK .
ENDCLASS.



CLASS ZCL_MKRTEST_APPL01 IMPLEMENTATION.


  METHOD constructor.


  ENDMETHOD.


  METHOD conv_selopt.
    LOOP AT it_selopt ASSIGNING FIELD-SYMBOL(<ls_selopt>).
      ASSIGN COMPONENT 'SIGN' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_sign>).
      CHECK sy-subrc EQ 0.
      ASSIGN COMPONENT 'OPTION' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_option>).
      CHECK sy-subrc EQ 0.
      ASSIGN COMPONENT 'LOW' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_low>).
      CHECK sy-subrc EQ 0.
      ASSIGN COMPONENT 'HIGH' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_high>).
      CHECK sy-subrc EQ 0.
      APPEND VALUE #(
        sign   = <lv_sign>
        option = <lv_option>
        low    = <lv_low>
        high   = <lv_high>
      ) TO rt_selopt.
    ENDLOOP.
  ENDMETHOD.


  METHOD create_controls.

     DATA: ls_layout  TYPE lvc_s_layo,
          ls_variant TYPE disvariant.

*   Conainer und Grid erzeugen bzw. Refresh Grid
    IF go_cont IS NOT BOUND.
      CREATE OBJECT go_cont
        EXPORTING
          extension = 9999
        EXCEPTIONS
          OTHERS    = 0.


      CREATE OBJECT go_split          " Split container module - from SAP GUI > PATTERN > ABAP OBJECTS > same splitter OO
        EXPORTING
*         align             = 15
          parent            = go_cont   " parent reference to custom control Dynpro = container
          rows              = 2               " split layout set
          columns           = 1
*         no_autodef_progid_dynnr = no_autodef_progid_dynnr
*         name              = name
        EXCEPTIONS
          OTHERS            = 0.


      CREATE OBJECT go_grid1
        EXPORTING
          i_parent = go_split->get_container( row = 1 column = 1 ).
      ls_layout-grid_title = 'titel ALV 1'.
      ls_layout-zebra      = abap_true.
      ls_layout-sel_mode   = 'B'.
      ls_layout-cwidth_opt = abap_true.
      ls_variant-report    = sy-calld.
      ls_variant-handle   = '0001'.
      DATA(lt_fcat) = get_fc1( ).

      go_grid1->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer   = abap_true
          is_layout            = ls_layout
          is_variant           = ls_variant
          i_save               = 'A'
          i_default            = abap_true
        CHANGING
          it_outtab            = gt_data1
          it_fieldcatalog      = lt_fcat
      ).
      SET HANDLER handle_user_command FOR go_grid1.
      SET HANDLER handle_double_click1 FOR go_grid1.
      SET HANDLER handle_toolbar1 FOR go_grid1.
      go_grid1->set_toolbar_interactive( ).


      CREATE OBJECT go_grid2
        EXPORTING
          i_parent = go_split->get_container( row = 2 column = 1 ).
      ls_layout-grid_title = 'titel ALV 1'.
      ls_layout-zebra      = abap_true.
      ls_layout-sel_mode   = 'B'.
      ls_layout-cwidth_opt = abap_true.
      ls_variant-report    = sy-calld.
      ls_variant-handle   = '0002'.
      DATA(lt_fcat2) = get_fc2( ).

      go_grid2->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer   = abap_true
          is_layout            = ls_layout
          is_variant           = ls_variant
          i_save               = 'A'
          i_default            = abap_true
        CHANGING
          it_outtab            = gt_data2
          it_fieldcatalog      = lt_fcat2
      ).
*      SET HANDLER handle_user_command FOR go_grid.
      SET HANDLER handle_hotspot2 FOR go_grid2.
      SET HANDLER handle_toolbar2 FOR go_grid2.
      go_grid2->set_toolbar_interactive( ).

    ELSE.
      go_grid1->refresh_table_display( is_stable = VALUE #( row = abap_true col = abap_true ) ).
      go_grid2->refresh_table_display( is_stable = VALUE #( row = abap_true col = abap_true ) ).
    ENDIF.


  ENDMETHOD.


  METHOD get_data1.

    SELECT
        mara~matnr,
        marc~werks,  "added from DDIC marc
        mara~pstat,
        mara~mtart,
        mara~mbrsh,
        mara~matkl,
        mara~meins,
        mara~bstme,
        mara~brgew
      FROM mara
        INNER JOIN marc
         ON mara~matnr EQ marc~matnr
          WHERE mara~mtart IN @gr_mtart  "including parameter
            AND mara~matnr IN @gr_matnr   "including select-option
            AND marc~werks IN @gr_werks   "including select-option
      INTO TABLE @gt_data1.


  ENDMETHOD.


  METHOD GET_FC1.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = gc_struc1
      CHANGING
        ct_fieldcat      = rt_fc
      EXCEPTIONS
        OTHERS           = 0.
*    LOOP AT rt_fc ASSIGNING FIELD-SYMBOL(<ls_fc>).
*      CASE <ls_fc>-fieldname.
*        WHEN 'STATUS'.
*          <ls_fc>-icon        = abap_true.
*        WHEN 'SCAN_2ND_RFID' OR 'KTEXTLOS' OR 'LOSMENGE' OR 'MENGENEINH'.
*          <ls_fc>-no_out      = abap_true.
*          <ls_fc>-tech        = abap_true.
*        WHEN 'SAMPLERIDENT'.
*          <ls_fc>-coltext     = text-008.
*          <ls_fc>-scrtext_l   = text-008.
*          <ls_fc>-scrtext_m   = text-008.
*          <ls_fc>-scrtext_s   = text-008.
*        WHEN OTHERS.
*      ENDCASE.
*    ENDLOOP.


  ENDMETHOD.


  METHOD GET_FC2.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = gc_struc2
      CHANGING
        ct_fieldcat      = rt_fc
      EXCEPTIONS
        OTHERS           = 0.
    LOOP AT rt_fc ASSIGNING FIELD-SYMBOL(<ls_fc>).
      CASE <ls_fc>-fieldname.
        WHEN 'XCHPF_ICON'.
          <ls_fc>-icon        = abap_true.
          <ls_fc>-hotspot     = abap_true.
*        WHEN 'SCAN_2ND_RFID' OR 'KTEXTLOS' OR 'LOSMENGE' OR 'MENGENEINH'.
*          <ls_fc>-no_out      = abap_true.
*          <ls_fc>-tech        = abap_true.
*        WHEN 'SAMPLERIDENT'.
*          <ls_fc>-coltext     = text-008.
*          <ls_fc>-scrtext_l   = text-008.
*          <ls_fc>-scrtext_m   = text-008.
*          <ls_fc>-scrtext_s   = text-008.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.


  ENDMETHOD.


  METHOD handle_double_click1.

*   geklickte Zeile einlesen
    READ TABLE gt_data1 INTO DATA(ls_data1) INDEX e_row-index.
    CHECK sy-subrc EQ 0.

*   daten holen
    get_data2( iv_matnr = ls_data1-matnr iv_werks = ls_data1-werks ).

*   ansicht refresh
    go_grid2->refresh_table_display( is_stable = VALUE #( row = abap_true col = abap_true ) ).


  ENDMETHOD.


  METHOD handle_toolbar1.

    DATA: ls_tb       TYPE stb_button.

*   unötige funktionen raus
    DELETE e_object->mt_toolbar WHERE function EQ '&GRAPH'
                                OR    function EQ '&INFO'
                                OR    function EQ '&MB_VIEW'
                                OR    function EQ '&DETAIL'
                                OR    function EQ '&REFRESH'.

   APPEND VALUE stb_button( function = ''
                            butn_type = 3
*                            CHECKED
                            ) TO e_object->mt_toolbar.

   APPEND VALUE stb_button( function = 'MEINEFUNKTION'
                            icon     = icon_red_light
                            quickinfo = '...quickinfo'
                            butn_type = 0
*                   DISABLED
                            text      = 'Meine Funktion'
*                            CHECKED
                            ) TO e_object->mt_toolbar.

  ENDMETHOD.


  METHOD HANDLE_TOOLBAR2.

    DATA: ls_tb       TYPE stb_button.

*   unötige funktionen raus
    DELETE e_object->mt_toolbar WHERE function EQ '&GRAPH'
                                OR    function EQ '&INFO'
                                OR    function EQ '&MB_VIEW'
                                OR    function EQ '&DETAIL'
                                OR    function EQ '&REFRESH'.

  ENDMETHOD.


  method HANDLE_USER_COMMAND.

    CASE e_ucomm.
      WHEN ''.
      WHEN ''.
      WHEN OTHERS.
    ENDCASE.

  endmethod.


  method PAI_0001.
    CASE IV_OKCODE.
      WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
        LEAVE TO SCREEN 0.
      WHEN OTHERS.
    ENDCASE.
  endmethod.


  method PBO_0001.

    SET PF-STATUS '0001' OF PROGRAM 'ZMKRTEST_APPL01'.
    SET TITLEBAR '0001' OF PROGRAM 'ZMKRTEST_APPL01'.

    create_controls( ).

  endmethod.


  METHOD set_selection_screen_data.

    gr_matnr   = it_matnr.
    gr_werks   = it_werks.
    gr_mtart   = it_mtart.

  ENDMETHOD.


  METHOD get_data2.

    CLEAR: gt_data2.

    SELECT
      marc~xchpf,  " added from DDIC marc for Icon
      CASE marc~xchpf
        WHEN 'X' THEN '@XR@'
        ELSE '@XQ@'
      END AS xchpf_icon,
      mard~matnr,
      mard~lgort,
      mard~labst,
      mard~speme,
      mara~meins    " added from DDIC mara

      FROM mard
        INNER JOIN mara
             ON mard~matnr = mara~matnr
        INNER JOIN marc
             ON marc~matnr = mara~matnr
             AND mard~werks = marc~werks
      WHERE mara~matnr = @iv_matnr
      AND   marc~werks = @iv_werks
      INTO CORRESPONDING FIELDS OF TABLE @gt_data2  .

*      LOOP AT gt_grid2 ASSIGNING FIELD-SYMBOL(<fs_2>).        " SALV MEthode: set ICON for XCHAR to be displayed if value = X = Chargen-pflichtig
*        IF <fs_2>-xchpf = 'X'.
*          <fs_2>-xchpf_icon = '@Y1@'.          "condition true then icon / code for 'charge'
*        ENDIF.
*      ENDLOOP.

  ENDMETHOD.


  METHOD GET_FC3.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = gc_struc3
      CHANGING
        ct_fieldcat      = rt_fc
      EXCEPTIONS
        OTHERS           = 0.
    LOOP AT rt_fc ASSIGNING FIELD-SYMBOL(<ls_fc>).
      CASE <ls_fc>-fieldname.
        WHEN 'MATNR' OR 'CHARG' OR 'CLABS' OR 'CSPEM'.
*          <ls_fc>-icon        = abap_true.
*          <ls_fc>-hotspot     = abap_true.
*        WHEN 'SCAN_2ND_RFID' OR 'KTEXTLOS' OR 'LOSMENGE' OR 'MENGENEINH'.
*        WHEN 'SAMPLERIDENT'.
*          <ls_fc>-coltext     = text-008.
*          <ls_fc>-scrtext_l   = text-008.
*          <ls_fc>-scrtext_m   = text-008.
*          <ls_fc>-scrtext_s   = text-008.
        WHEN OTHERS.
          <ls_fc>-no_out      = abap_true.
          <ls_fc>-tech        = abap_true.
      ENDCASE.
    ENDLOOP.


  ENDMETHOD.


  METHOD handle_hotspot2.

*   Zeile einlesen
    READ TABLE gt_data2 INTO gs_current_data2 INDEX e_row_id-index.
    CHECK sy-subrc EQ 0.

    IF gs_current_data2-xchpf EQ abap_true.

      CLEAR: gt_data3.
      SELECT * FROM mchb
        WHERE matnr EQ @GS_CURRENT_DATA2-matnr
        AND   lgort EQ @gs_current_data2-lgort
        INTO TABLE @gt_data3.
      CALL FUNCTION 'Z_MKRTEST_APPL01_SCR_0001'
        EXPORTING
          io_view  = me.
    ENDIF.

  ENDMETHOD.


  method POPUP_PAI_0001.
    CASE IV_OKCODE.
      WHEN 'OKAY' OR 'EXIT'.
        LEAVE TO SCREEN 0.
      WHEN OTHERS.
    ENDCASE.
  endmethod.


  METHOD popup_pbo_0001.

  DATA: ls_layout  TYPE lvc_s_layo,
          ls_variant TYPE disvariant.

   SET PF-STATUS '0001' OF PROGRAM 'SAPLZMKRTEST_APPL01_SCR'.
    SET TITLEBAR '0001' OF PROGRAM 'SAPLZMKRTEST_APPL01_SCR'.



*   Conainer und Grid erzeugen bzw. Refresh Grid
    IF go_cont_popup IS NOT BOUND.
      CREATE OBJECT go_cont_popup
        EXPORTING
          container_name              = 'CUST_CONTAINER'
*          style                       =
*          lifetime                    = lifetime_default
*          repid                       =
*          dynnr                       =
*          no_autodef_progid_dynnr     =
        EXCEPTIONS
          cntl_error                  = 1
          cntl_system_error           = 2
          create_error                = 3
          lifetime_error              = 4
          lifetime_dynpro_dynpro_link = 5
          OTHERS                      = 6
          .
      IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                  WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.



      CREATE OBJECT go_grid3
        EXPORTING
          i_parent = go_cont_popup.
      ls_layout-grid_title = 'titel popup alv'.
      ls_layout-zebra      = abap_true.
      ls_layout-sel_mode   = 'B'.
      ls_layout-cwidth_opt = abap_true.
      ls_variant-report    = sy-calld.
      ls_variant-handle   = '0003'.
      DATA(lt_fcat) = get_fc3( ).

      go_grid3->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer   = abap_true
          is_layout            = ls_layout
          is_variant           = ls_variant
          i_save               = 'A'
          i_default            = abap_true
        CHANGING
          it_outtab            = gt_data3
          it_fieldcatalog      = lt_fcat
      ).

    ELSE.
      go_grid3->refresh_table_display( is_stable = VALUE #( row = abap_true col = abap_true ) ).
    ENDIF.


  ENDMETHOD.


  method SHOW_BATCH_STOCK.
  endmethod.
ENDCLASS.