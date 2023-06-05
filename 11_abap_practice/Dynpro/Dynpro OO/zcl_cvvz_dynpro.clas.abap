CLASS zcl_cvvz_dynpro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA: gs_current_data2 TYPE zdp_mx_s_2.

    METHODS: conv_selopt IMPORTING it_selopt        TYPE ANY TABLE
                         RETURNING VALUE(rt_selopt) TYPE rsdsselopt_t,

      set_selection_screen_data IMPORTING it_matnr TYPE rsdsselopt_t
                                          it_mtart TYPE rsdsselopt_t
                                          it_werks TYPE rsdsselopt_t,

      get_data1,
      pbo_0001,
      pai_0001 FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm.

  PRIVATE SECTION.
    TYPES: gty_tt_data1 TYPE TABLE OF zdp_mx_s_1,
           gty_tt_data2 TYPE TABLE OF zdp_mx_s_2.

    CONSTANTS: gc_struc1 TYPE tabname VALUE 'ZDP_MX_S_1',
               gc_struc2 TYPE tabname VALUE 'ZDP_MX_S_2'.

    DATA: gr_matnr TYPE rsdsselopt_t,
          gr_mtart TYPE rsdsselopt_t,
          gr_werks TYPE rsdsselopt_t,
          gt_data1 TYPE gty_tt_data1,
          gt_data2 TYPE gty_tt_data2,
          gt_data3 TYPE mchb_tty,
          go_cont  TYPE REF TO cl_gui_docking_container,
          go_grid2 TYPE REF TO cl_gui_alv_grid.

    METHODS: create_controls,
             get_fc1              RETURNING VALUE(rt_fc) TYPE lvc_t_fcat,
             get_fc2              RETURNING VALUE(rt_fc) TYPE lvc_t_fcat,
             handle_double_click1 FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row,

      get_data2 IMPORTING iv_matnr TYPE matnr
                          iv_werks TYPE werks_d,

      handle_toolbar1 FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object
                                                                     e_interactive,
      handle_toolbar2 FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object
                                                                     e_interactive,
      handle_hotspot2 FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_row_id
                                e_column_id
                                es_row_no.
ENDCLASS.

CLASS zcl_cvvz_dynpro IMPLEMENTATION.
  METHOD conv_selopt.
    LOOP AT it_selopt ASSIGNING FIELD-SYMBOL(<ls_selopt>).
      ASSIGN COMPONENT 'SIGN' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_sign>).
      CHECK sy-subrc = 0.
      ASSIGN COMPONENT 'OPTION' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_option>).
      CHECK sy-subrc = 0.
      ASSIGN COMPONENT 'LOW' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_low>).
      CHECK sy-subrc = 0.
      ASSIGN COMPONENT 'HIGH' OF STRUCTURE <ls_selopt> TO FIELD-SYMBOL(<lv_high>).
      CHECK sy-subrc = 0.
      APPEND VALUE #( sign   = <lv_sign>
                      option = <lv_option>
                      low    = <lv_low>
                      high   = <lv_high> )
             TO rt_selopt.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_selection_screen_data.
    gr_matnr = it_matnr.
    gr_werks = it_werks.
    gr_mtart = it_mtart.
  ENDMETHOD.

  METHOD get_data1.
    SELECT a~matnr,
           b~werks,
           a~pstat,
           a~mtart,
           a~mbrsh,
           a~matkl,
           a~meins,
           a~bstme,
           a~brgew
    FROM mara AS a
    JOIN marc AS b ON a~matnr = b~matnr
    WHERE a~mtart IN @gr_mtart AND
          a~matnr IN @gr_matnr AND
          b~werks IN @gr_werks
    INTO TABLE @gt_data1.
  ENDMETHOD.

  METHOD get_data2.
    CLEAR gt_data2.

    SELECT marc~xchpf,
           CASE marc~xchpf
             WHEN 'X' THEN '@XR@'
             ELSE '@XQ@'
           END AS xchpf_icon,
           mard~matnr,
           mard~lgort,
           mard~labst,
           mard~speme,
           mara~meins
    FROM mard
    JOIN mara ON mard~matnr = mara~matnr
    JOIN marc ON marc~matnr = mara~matnr AND
                 mard~werks = marc~werks
    WHERE mara~matnr = @iv_matnr AND
          marc~werks = @iv_werks
    INTO CORRESPONDING FIELDS OF TABLE @gt_data2.
  ENDMETHOD.

  METHOD pbo_0001.
    SET PF-STATUS 'STANDARD' OF PROGRAM 'ZCVVZ_DYNPRO_OO'.
    SET PF-STATUS 'TITLEBAR' OF PROGRAM 'ZCVVZ_DYNPRO_OO'.

    create_controls( ).
  ENDMETHOD.

  METHOD create_controls.
    DATA: ls_layout  TYPE lvc_s_layo,
          ls_variant TYPE disvariant.

    IF go_cont IS NOT BOUND.
      go_cont = NEW #( extension = 9999 ).
      DATA(go_split) = NEW cl_gui_splitter_container( parent  = go_cont
                                                      rows    = 2
                                                      columns = 1 ).
      DATA(go_grid1) = NEW cl_gui_alv_grid( i_parent = go_split->get_container( row = 1 column = 1 ) ).

      ls_layout-grid_title = 'titel ALV 1'.
      ls_layout-zebra      = abap_true.
      ls_layout-sel_mode   = 'B'.
      ls_layout-cwidth_opt = abap_true.
      ls_variant-report = sy-calld.
      ls_variant-handle = '0001'.
      DATA(lt_fcat) = get_fc1( ).

      go_grid1->set_table_for_first_display( EXPORTING i_bypassing_buffer = abap_true
                                                       is_layout          = ls_layout
                                                       is_variant         = ls_variant
                                                       i_save             = 'A'
                                                       i_default          = abap_true
                                             CHANGING  it_outtab          = gt_data1
                                                       it_fieldcatalog    = lt_fcat ).
      go_grid1->set_toolbar_interactive( ).

      SET HANDLER pai_0001 FOR go_grid1.
      SET HANDLER handle_double_click1 FOR go_grid1.
      SET HANDLER handle_toolbar1 FOR go_grid1.

      go_grid2 = NEW cl_gui_alv_grid( i_parent = go_split->get_container( row = 2 column = 1 ) ).

      ls_layout-grid_title = 'titel ALV 1'.
      ls_layout-zebra      = abap_true.
      ls_layout-sel_mode   = 'B'.
      ls_layout-cwidth_opt = abap_true.
      ls_variant-report = sy-calld.
      ls_variant-handle = '0002'.
      DATA(lt_fcat2) = get_fc2( ).

      go_grid2->set_table_for_first_display( EXPORTING i_bypassing_buffer = abap_true
                                                       is_layout          = ls_layout
                                                       is_variant         = ls_variant
                                                       i_save             = 'A'
                                                       i_default          = abap_true
                                             CHANGING  it_outtab          = gt_data2
                                                       it_fieldcatalog    = lt_fcat2 ).
      go_grid2->set_toolbar_interactive( ).

      SET HANDLER handle_hotspot2 FOR go_grid2.
      SET HANDLER handle_toolbar2 FOR go_grid2.

    ELSE.
      go_grid1->refresh_table_display( is_stable = VALUE #( row = abap_true col = abap_true ) ).
      go_grid2->refresh_table_display( is_stable = VALUE #( row = abap_true col = abap_true ) ).
    ENDIF.
  ENDMETHOD.

  METHOD handle_double_click1.
    READ TABLE gt_data1 INTO DATA(ls_data1) INDEX e_row-index.
    CHECK sy-subrc = 0.

    get_data2( iv_matnr = ls_data1-matnr iv_werks = ls_data1-werks ).

    go_grid2->refresh_table_display( is_stable = VALUE #( row = abap_true col = abap_true ) ).
  ENDMETHOD.

  METHOD handle_hotspot2.
    READ TABLE gt_data2 INTO gs_current_data2 INDEX e_row_id-index.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF gs_current_data2-xchpf = abap_true.

      CLEAR gt_data3.
      SELECT * FROM mchb
        WHERE matnr = @gs_current_data2-matnr
        AND   lgort = @gs_current_data2-lgort
        INTO TABLE @gt_data3.
      CALL FUNCTION 'Z_MKRTEST_APPL01_SCR_0001'
        EXPORTING io_view = me.
    ENDIF.
  ENDMETHOD.

  METHOD handle_toolbar1.
    DELETE e_object->mt_toolbar WHERE    function = '&GRAPH'
                                      OR function = '&INFO'
                                      OR function = '&MB_VIEW'
                                      OR function = '&DETAIL'
                                      OR function = '&REFRESH'.

    APPEND VALUE stb_button( function  = ''
                             butn_type = 3 )
           TO e_object->mt_toolbar.

    APPEND VALUE stb_button( function  = 'MEINEFUNKTION'
                             icon      = icon_red_light
                             quickinfo = '...quickinfo'
                             butn_type = 0
                             text      = 'Eigener Funktionsbutton' )
           TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_toolbar2.
    DELETE e_object->mt_toolbar WHERE    function = '&GRAPH'
                                      OR function = '&INFO'
                                      OR function = '&MB_VIEW'
                                      OR function = '&DETAIL'
                                      OR function = '&REFRESH'.
  ENDMETHOD.

  METHOD get_fc1.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING  i_structure_name       = gc_struc1
      CHANGING   ct_fieldcat            = rt_fc
      EXCEPTIONS inconsistent_interface = 1
                 program_error          = 2
                 OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.

  METHOD get_fc2.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING  i_structure_name       = gc_struc1
      CHANGING   ct_fieldcat            = rt_fc
      EXCEPTIONS inconsistent_interface = 1
                 program_error          = 2
                 OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    LOOP AT rt_fc ASSIGNING FIELD-SYMBOL(<ls_fc>).
      CASE <ls_fc>-fieldname.
        WHEN 'XCHPF_ICON'.
          <ls_fc>-icon    = abap_true.
          <ls_fc>-hotspot = abap_true.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD pai_0001.
    CASE sy-ucomm.
      WHEN '&F15' OR '&F12'.
        LEAVE PROGRAM.
      WHEN '&F03'.
        "CALL SELECTION-SCREEN '1000'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.