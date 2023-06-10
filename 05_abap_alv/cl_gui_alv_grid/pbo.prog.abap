*----------------------------------------------------------------------*
***INCLUDE ZCVVZ_002_STATUS_0100O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STANDARD'.
  SET TITLEBAR 'TITLEBAR'.

  IF go_cc IS INITIAL.
    go_cc = NEW #( container_name = 'CCCONTAINER' ).
    go_alv = NEW #( i_parent = go_cc ).
    DATA(go_events) = NEW lcl_event_receiver( ).

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZCVVZ_ST_03'
      CHANGING
        ct_fieldcat      = gt_fieldcat.

    gt_fieldcat[ fieldname = 'DOKST' ]-web_field = 'HL_FNAME'.

    gs_hype-handle = 1.
    gs_hype-href   = 'https://www.sap.com/germany/index.html?url_id=auto_hp_redirect_germany'.
    APPEND gs_hype TO gt_hypetab.
    gs_hype-handle = 2.
    gs_hype-href   = 'https://open.sap.com/'. " Kann auch Funktionscode beinhalten, der dann in Event user_command verarbeitet wird
    APPEND gs_hype TO gt_hypetab.

    LOOP AT gt_fieldcat ASSIGNING FIELD-SYMBOL(<gs_fieldcat>).
      IF sy-tabix < 10.
        <gs_fieldcat>-sp_group = 1.
      ELSEIF <gs_fieldcat>-fieldname = 'DOKNR'.
        <gs_fieldcat>-edit_mask = 'CONVERSION_EXIT_ALPHA_INPUT'.
      ELSE.
        <gs_fieldcat>-sp_group  = 2.
      ENDIF.
    ENDLOOP.

    SELECT * FROM draw WHERE dokar LIKE 'ZV%' INTO CORRESPONDING FIELDS OF TABLE @gt_outtab.
    LOOP AT gt_outtab ASSIGNING FIELD-SYMBOL(<gs_outtab>).
      IF <gs_outtab>-dokst = 'RL'.
        <gs_outtab>-light     = '3'.
        <gs_outtab>-linecolor = |C500|.
        <gs_outtab>-hl_fname  = gt_hypetab[ 1 ]-handle.
*        <gs_outtab>-ct = VALUE #( ( fname = 'DOKVR'
*                                    color-col = 5
*                                    color-int = 0
*                                    color-inv = 0 ) ).
      ELSEIF <gs_outtab>-dokst = 'PY'.
        <gs_outtab>-light     = '2'.
        <gs_outtab>-linecolor = |C300|.
*        <gs_outtab>-ct = VALUE #( ( fname = 'DOKVR'
*                                    color-col = 3
*                                    color-int = 0
*                                    color-inv = 0 ) ).
      ELSE.
        <gs_outtab>-light     = '1'.
        <gs_outtab>-linecolor = |C600|.
        <gs_outtab>-hl_fname  = gt_hypetab[ 2 ]-handle.
*        <gs_outtab>-ct = VALUE #( ( fname = 'DOKVR'
*                                    color-col = 6
*                                    color-int = 0
*                                    color-inv = 0 ) ).
      ENDIF.
    ENDLOOP.

    go_alv->set_table_for_first_display( EXPORTING " i_structure_name = 'GTY_DRAW'
                                                   is_variant        = gs_disvariant
                                                   i_save            = 'A'
                                                   i_default         = 'X'
                                                   is_layout         = gs_layout
                                                   it_hyperlink      = gt_hypetab
                                                   it_special_groups = gt_fgtexts
                                         CHANGING  it_outtab         = gt_outtab
                                                   it_fieldcatalog   = gt_fieldcat ).

    SET HANDLER go_events->handle_toolbar
                go_events->handle_user_command
                go_events->handle_context_menu
                go_events->handle_menu_button FOR go_alv.
    go_alv->set_toolbar_interactive( ).
  ENDIF.
ENDMODULE.