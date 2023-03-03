*&---------------------------------------------------------------------*
*& Report zvzp_alv_edit
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvzp_alv_edit.
*Im GUI-Status STANDARD muss noch unter Funktionstasten -> Symbolleisten das zweite Feld mit &DATA_SAVE befüllt werden.
*Danach muss die Oberfläche durch Rechtsklick auf STANDARD aktiviert werden.
*Felder können durch einfügen von "ls_fieldcat-edit = 'X'." verändert werden.
DATA: ls_spfli    TYPE spfli,
      it_spflicp  TYPE TABLE OF spfli,
      it_changes  TYPE TABLE OF spfli,
      ls_fieldcat TYPE slis_fieldcat_alv,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      ls_layout   TYPE slis_layout_alv,
      lv_index    TYPE int1 VALUE 0.
SELECT * FROM spfli INTO TABLE @DATA(it_spfli).

ls_fieldcat-fieldname = 'CARRID'.
ls_fieldcat-seltext_m = 'CarrId'.
ls_fieldcat-col_pos = lv_index + 1.
ls_fieldcat-outputlen = 10.
ls_fieldcat-key = 'X'.
ls_fieldcat-just = 'L'.
APPEND ls_fieldcat TO it_fieldcat.
CLEAR ls_fieldcat.

ls_fieldcat-fieldname = 'CONNID'.
ls_fieldcat-seltext_m = 'ConnId'.
ls_fieldcat-col_pos = lv_index + 1.
ls_fieldcat-outputlen = 10.
ls_fieldcat-key = 'X'.
ls_fieldcat-just = 'L'.
APPEND ls_fieldcat TO it_fieldcat.
CLEAR ls_fieldcat.

ls_fieldcat-fieldname = 'CITYFROM'.
ls_fieldcat-seltext_m = 'City From'.
ls_fieldcat-col_pos = lv_index + 1.
ls_fieldcat-outputlen = 30.
ls_fieldcat-just = 'L'.
ls_fieldcat-edit = 'X'.
APPEND ls_fieldcat TO it_fieldcat.
CLEAR ls_fieldcat.

ls_fieldcat-fieldname = 'CITYTO'.
ls_fieldcat-seltext_m = 'City To'.
ls_fieldcat-col_pos = lv_index + 1.
ls_fieldcat-outputlen = 30.
ls_fieldcat-just = 'L'.
APPEND ls_fieldcat TO it_fieldcat.
CLEAR ls_fieldcat.

it_spflicp[] = it_spfli[].
ls_layout-zebra = 'X'.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program       = sy-repid
    i_callback_pf_status_set = 'PF_STATUS_SET'
    i_callback_user_command  = 'USER_COMMAND'
    is_layout                = ls_layout
    it_fieldcat              = it_fieldcat
  TABLES
    t_outtab                 = it_spfli.

FORM pf_status_set USING extab TYPE slis_t_extab.
  SET PF-STATUS 'STANDARD'.
ENDFORM.

FORM f_save_data.
  DATA: ls_spflicp   TYPE spfli,
        ls_spfli_tmp TYPE spfli.

  CLEAR it_changes[].
  LOOP AT it_spfli INTO ls_spfli.
    READ TABLE it_spflicp INTO ls_spflicp INDEX sy-tabix.
    IF ls_spflicp <> ls_spfli.
      APPEND ls_spfli TO it_changes.
      MOVE-CORRESPONDING ls_spfli TO ls_spfli_tmp.
      MODIFY spfli FROM ls_spfli_tmp.
    ENDIF.
    CLEAR ls_spflicp.
  ENDLOOP.
ENDFORM.

FORM user_command USING p_ucomm TYPE sy-ucomm
                        p_selfield TYPE slis_selfield.
  CASE p_ucomm.
    WHEN '&DATA_SAVE'.
      PERFORM f_save_data.
  ENDCASE.
ENDFORM.