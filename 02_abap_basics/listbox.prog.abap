REPORT listbox.

DATA: it_cbval TYPE STANDARD TABLE OF vrm_value WITH DEFAULT KEY.

PARAMETERS: p_l_lang TYPE char3 AS LISTBOX VISIBLE LENGTH 20 USER-COMMAND lb_cmd.

INITIALIZATION.

  it_cbval = VALUE #( ( key = 'A_1' text = 'Punkt eins' )
                      ( key = 'A_2' text = 'Punkt zwei' ) ).

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_L_LANG'
      values          = it_cbval
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

  IF sy-subrc = 0.
    IF lines( it_cbval ) > 0.
      p_l_lang = 'A_1'.
    ENDIF.
  ENDIF.

START-OF-SELECTION.
  TRY.
      DATA(s) = it_cbval[ key = p_l_lang ].
    CATCH cx_root.
  ENDTRY.
