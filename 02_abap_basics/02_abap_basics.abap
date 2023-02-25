*&---------------------------------------------------------------------*
*& Report 02_ABAP_BASICS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT 02_abap_basics.

*Parameter und Typdeklaration
PARAMETERS: p_name(12),
            p_birth    TYPE d DEFAULT sy-datum,
            p_carid    TYPE sflight-carrid,
            p_op1      TYPE i,
            p_op2      TYPE i,
            p_oper.

TYPES: BEGIN OF ltys_address,
         city(40),
         zipcode(5)  TYPE n,
         country(40),
         street(50),
         number(5)   TYPE n,
       END OF ltys_address.

*Variablendeklaration und -initialisierung
DATA: l_msg(20)     VALUE 'l_msg',
      l_num         TYPE i,
      l_num2        TYPE string,
      r_calculator  TYPE REF TO zcl_mini_calc,
      x_myexception TYPE REF TO cx_sy_zerodivide,
      ls_address    TYPE ltys_address,
      lt_address    TYPE TABLE OF ltys_address,
      lt_address2   TYPE TABLE OF ltys_address,
      lt_flights    TYPE TABLE OF sflight,
      ls_flight     TYPE sflight.

lt_address = VALUE #( ( city = 'Würzburg' zipcode = '97070' country = 'Germany' street = 'Zwinger' number = '9' )
                      ( city = 'Würzburg' zipcode = '97070' country = 'Germany' street = 'Zwinger' number = '11' ) ).

MOVE-CORRESPONDING lt_address TO lt_address2.

*Input-Prüfung
IF p_name = 'NAME' OR p_carid = ''.
  WRITE / 'Bitte Namen und Fluggesellschaft eingeben'.
  EXIT.
ENDIF.

*Output
WRITE: / p_name,
       / p_birth,
       / p_carid,
       / l_msg.

*Tabellenbearbeitung
LOOP AT lt_address2 INTO ls_address WHERE number = '11'.
  WRITE: / ls_address-city,
         ls_address-zipcode,
         ls_address-country,
         ls_address-street,
         ls_address-number.
ENDLOOP.

DESCRIBE TABLE lt_address2 LINES l_num.
WRITE: / 'Anzahl der Tabellenzeilen: ', l_num.
*READ lt_address2 INTO ls_address ...
*MODIFY TABLE lt_address2 FROM ls_address ...
*INSERT ls_address INTO TABLE lt_address2 ...
*APPEND lt_address2 TO ls_address.
*DELETE lt_address2 ...

*Funktionsbaustein aufrufen
CALL FUNCTION 'MINI_CALC'
  EXPORTING
    operand1         = p_op1
    operand2         = p_op2
    operator         = p_oper
  IMPORTING
    result           = l_num
  EXCEPTIONS
    division_by_zero = 1
    operator_wrong   = 2
    OTHERS           = 3.
CASE sy-subrc.
  WHEN 0.
    WRITE: / 'Funktionsbaustein: ', p_op1, ' ', p_oper, ' ', p_op2, '=', l_num.
  WHEN 1.
    WRITE: / TEXT-001.
    EXIT.
  WHEN 2.
    WRITE: / TEXT-002.
    EXIT.
  WHEN 3.
    WRITE: / TEXT-003.
    EXIT.
ENDCASE.

*Klassen-Methode aufrufen
TRY.
    CREATE OBJECT r_calculator.

    CALL METHOD r_calculator->calculate
      EXPORTING
        im_op1    = p_op1
        im_oper   = p_oper
        im_op2    = p_op2
      IMPORTING
        ex_result = l_num2.
    WRITE: / 'Klassen-Methode: ', l_num2, '(String)'.

  CATCH cx_sy_zerodivide INTO x_myexception.
    l_num2 = x_myexception->get_text( ).
    WRITE: / l_num2.
ENDTRY.

*FORM-Routine aufrufen
PERFORM mycalc
USING p_op1 p_op2 p_oper
CHANGING l_num.

*Datenbankzugriffe
*SELECT SINGLE: WHERE-Bedingung liefert einen Eintrag, da alle Keys verwendet werden.
SELECT SINGLE * FROM sflight INTO ls_flight
  WHERE carrid = 'LH' AND connid = '0400' AND fldate = '20131224'.
PERFORM f_check_query.
*Effizienter als der folgende Schleifenzugriff
SELECT * FROM sflight INTO TABLE lt_flights
  WHERE carrid = 'LH' AND connid = '0400'.
PERFORM f_check_query.
*SELECT als Schleife zum direkten Arbeiten mit mehreren Tabelleneinträgen. (ineffizient)
SELECT * FROM sflight INTO ls_flight
  WHERE carrid = 'LH' AND connid = '0400'.
  WRITE: / ls_flight-fldate.
ENDSELECT.
PERFORM f_check_query.
*CLIENT SPECIFIC: Ein anderer als der aktuelle Mandant ist wählbar.

*FORM-Routine mit Kontrollstrukturen definieren & in "INCLUDE zvz_inc_form_14_program." auslagern
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
    WRITE: / 'Fehlerhafter Datenbankzugriff!', / 'Fehlercode sy-subrc: ', sy-subrc.
    EXIT.
  ELSE.
    WRITE: / 'Anzahl gelesener Zeilen: ', sy-dbcnt.
  ENDIF.
ENDFORM.

*Methoden-Implementation der Klasse zcl_mini_calc
*METHOD calculate.
*  CASE im_oper.
*    WHEN '+'.
*      ex_result = im_op1 + im_op2.
*    WHEN '-'.
*      ex_result = im_op1 - im_op2.
*    WHEN '*'.
*      ex_result = im_op1 * im_op2.
*    WHEN '/'.
*      IF im_op2 = 0.
*        RAISE EXCEPTION TYPE cx_sy_zerodivide.
*      ELSE.
*        ex_result = im_op1 / im_op2.
*      ENDIF.
*    WHEN OTHERS.
*      ex_result = 'Falscher Operator'.
*  ENDCASE.
*ENDMETHOD.