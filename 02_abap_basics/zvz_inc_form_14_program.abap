*&---------------------------------------------------------------------*
*& Include          ZVZ_INC_FORM_14_PROGRAM
*&---------------------------------------------------------------------*

*FORM-Routine mit Kontrollstrukturen definieren
FORM mycalc
*  TABLES my_itab TYPE table
  USING operand1 TYPE i
        operand2 TYPE i
        operator
  CHANGING result TYPE i.
  CASE operator.
    WHEN '+'.
      result = operand1 + operand2.
    WHEN '-'.
      result = operand1 - operand2.
    WHEN '*'.
      result = operand1 * operand2.
    WHEN '/'.
      IF operand2 = 0.
        WRITE: / TEXT-001.
        EXIT.
      ELSE.
        result = operand1 / operand2.
      ENDIF.
    WHEN OTHERS.
      WRITE: / TEXT-002.
      EXIT.
  ENDCASE.
  WRITE: / 'FORM-Routine: ', result.
ENDFORM.

FORM f_check_query.
  IF sy-subrc <> 0.
    MESSAGE TEXT-004 TYPE 'I'.
    WRITE: / 'Fehlercode sy-subrc: ', sy-subrc.
    EXIT.
  ELSE.
    MESSAGE TEXT-005 TYPE 'S'.
    WRITE: / 'Anzahl gelesener Zeilen: ', sy-dbcnt.
  ENDIF.
ENDFORM.