*&---------------------------------------------------------------------*
*& Report zvzp_abap_basics
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvzp_abap_basics.

INITIALIZATION.
*Parameterdeklaration in separaten SELECTION-SCREEN-Blöcken------------------------------------------------------------------------
  SELECTION-SCREEN BEGIN OF BLOCK 0 WITH FRAME TITLE TEXT-006.
    SELECTION-SCREEN SKIP.
    PARAMETERS: p_name(12),
                p_birth    TYPE d DEFAULT sy-datum,
                p_carid    TYPE sflight-carrid,
                p_op1      TYPE i,
                p_op2      TYPE i,
                p_oper.
  SELECTION-SCREEN END OF BLOCK 0.
  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK 1 WITH FRAME TITLE TEXT-007.
    SELECTION-SCREEN SKIP.
    PARAMETERS: p_sel  RADIOBUTTON GROUP r1 DEFAULT 'X',
                p_fm   RADIOBUTTON GROUP r1,
                p_test AS CHECKBOX DEFAULT space.
*    SELECT-OPTIONS: so_vkont FOR fkkvkp-vkont OBLIGATORY,
*                so_gpart FOR fkkvkp-gpart.
  SELECTION-SCREEN END OF BLOCK 1.

*Typdeklaration--------------------------------------------------------------------------------------------------------------------
  TYPES: BEGIN OF ltys_address,
           city(40),
           zipcode(5)  TYPE n,
           country(40),
           street(50),
           number(5)   TYPE n,
         END OF ltys_address.

*Variablendeklaration und -initialisierung-----------------------------------------------------------------------------------------
  DATA: l_msg(20)      VALUE 'l_msg',
        l_num          TYPE i,
        l_num2         TYPE string,
        r_datum        TYPE date,
        i_datum        TYPE char10 VALUE '2023-02-23',
        r_calculator   TYPE REF TO zcl_mini_calc,
        x_myexception  TYPE REF TO cx_sy_zerodivide,
        ls_address     TYPE ltys_address,
        lt_address     TYPE TABLE OF ltys_address,
        lt_address2    TYPE TABLE OF ltys_address,
        lt_flights     TYPE TABLE OF sflight,
        ls_flight      TYPE sflight,
        lt_bapisfldats TYPE TABLE OF bapisfldat,
        ls_bapisfldat  TYPE bapisfldat,
        lt_rets        TYPE TABLE OF bapiret2,
        ls_ret         TYPE bapiret2,
        lv_time        TYPE timestamp.

  FIELD-SYMBOLS: <field_symbol>,
                 <field_symbol2> TYPE ltys_address.

  lt_address = VALUE #( ( city = 'Würzburg' zipcode = '97070' country = 'Germany' street = 'Zwinger' number = '9' )
                        ( city = 'Würzburg' zipcode = '97070' country = 'Germany' street = 'Zwinger' number = '11' ) ).
  INSERT VALUE ltys_address( city = 'Würzburg' zipcode = '97070' country = 'Germany' street = 'Zwinger' number = '13' ) INTO TABLE lt_address.
  DATA(lt_address3) = VALUE ltys_address( city = 'Würzburg' zipcode = '97070' country = 'Germany' street = 'Zwinger' number = '15' ).
  APPEND lt_address3 TO lt_address.
  MOVE-CORRESPONDING lt_address TO lt_address2.
  l_num = COND #( WHEN p_birth = sy-datum THEN 1 ELSE p_op1 ).
  r_datum = |{ i_datum+0(4) }{ i_datum+5(2) }{ i_datum+8(2) }|.
  REPLACE ALL OCCURRENCES OF '-' IN i_datum WITH ''.
  ASSIGN l_num TO <field_symbol>.
  SELECT * FROM spfli INTO TABLE @DATA(it_spfli).
  GET TIME STAMP FIELD lv_time. "Alternativ TIMESTAMPL als TYPE möglich (L für long)
*Konvertierung mit CONVERT TIME STAMP gv_time_stamp TIME ZONE gv_timezone -> F1-Hilfe

*Falls das Field-Symbol schon deklariert ist, ist nur ASSIGNING nötig.
*IF-Statement ist nötig, weil bei fehlerhaftem ASSIGN das Programm abstürzt.
  LOOP AT lt_address2 ASSIGNING FIELD-SYMBOL(<field_symbol3>).
    IF sy-subrc = 0.
      <field_symbol3>-city = 'Hamburg'.
    ENDIF.
  ENDLOOP.
*Input-Prüfung---------------------------------------------------------------------------------------------------------------------
*TYPE: A = Abbruch, E = Fehler, I = Info, S = Status, W = Warn, (X = Exit -> Dump, sollte nicht verwendet werden)
*Message-Werte sind in SY-MSGID, SY-MSGTY, SY-MSGNO, SY-MSGV1, SY-MSGV2, SY-MSGV3, SY-MSGV4 gespeichert
AT SELECTION-SCREEN.
  IF p_name IS INITIAL OR p_carid IS INITIAL.
    MESSAGE ID '00' TYPE 'E' NUMBER '001' WITH 'Bitte Namen und Fluggesellschaft angeben!'.
    EXIT.
  ENDIF.

*Nachrichten (SE91->Nachrichtenklasse 00)------------------------------------------------------------------------------------------
*I = Fenster, S/E = links unten, W/A/X = Dynpro
*RAISING kann angehängt werden, um Methoden/Funktionsbausteine aufzurufen
  MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Ihr Benutzer: ' sy-uname.
  MESSAGE 'Programm gestartet.' TYPE 'I'.

*Formatierter Output---------------------------------------------------------------------------------------------------------------
START-OF-SELECTION.
  SKIP TO LINE 5.
  WRITE: / 'Das ist dein Name in Zeile 5: ', p_name,
         / 'Das ist dein Geburtsdatum: ', p_birth HOTSPOT,
         / p_carid, ' ', icon_list AS ICON HOTSPOT,
         / l_msg COLOR COL_NEGATIVE,
         / r_datum,
         / i_datum,
         / lv_time,
         / <field_symbol>.

*Tabellenbearbeitung---------------------------------------------------------------------------------------------------------------
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

*Funktionsbaustein aufrufen--------------------------------------------------------------------------------------------------------
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

*Klassen-Methode aufrufen----------------------------------------------------------------------------------------------------------
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

*FORM-Routine aufrufen-------------------------------------------------------------------------------------------------------------
  PERFORM mycalc
  USING p_op1 p_op2 p_oper
  CHANGING l_num.

*Datenbankzugriffe-----------------------------------------------------------------------------------------------------------------
*SELECT SINGLE: WHERE-Bedingung liefert einen Eintrag, da alle Keys verwendet werden.
  SELECT SINGLE * FROM sflight INTO ls_flight
  WHERE carrid = 'LH' AND connid = '0400' AND fldate = '20131224'.
  PERFORM f_check_query.
*Datenbankzugriff per SELECT und Funktionsbaustein (effizienter)
  IF p_sel = 'X'.
    SELECT * FROM sflight INTO TABLE lt_flights
    WHERE carrid = p_carid.
    PERFORM f_check_query.
    l_num = sy-dbcnt.
  ELSE.
    CALL FUNCTION 'BAPI_FLIGHT_GETLIST'
      EXPORTING
        airline     = p_carid
      TABLES
        flight_list = lt_bapisfldats
        return      = lt_rets.
    .
    DESCRIBE TABLE lt_bapisfldats LINES l_num.
    IF l_num = 0.
      WRITE: / 'Kein passender Inhalt in der Tabelle' COLOR COL_NEGATIVE.
      LOOP AT lt_rets INTO ls_ret.
        WRITE ls_ret-message.
      ENDLOOP.
    ENDIF.
  ENDIF.
*SELECT als Schleife zum direkten Arbeiten mit mehreren Tabelleneinträgen. (ineffizient)
  SELECT * FROM sflight INTO ls_flight
    WHERE carrid = 'LH' AND connid = '0400'.
    WRITE: / ls_flight-fldate.
  ENDSELECT.
  PERFORM f_check_query.
*CLIENT SPECIFIC: Ein anderer als der aktuelle Mandant ist wählbar.

*AT LINE-SELECTION: Mehrere Listen per Doppelklick aufrufen------------------------------------------------------------------------
*ALV (ABAP List Viewer)
  IF l_num = 0.
    EXIT.
  ELSE.
    SKIP TO LINE 29.
    WRITE: / 'Tabelle mit ', l_num, 'Zeilen.', / '->', 'einfache Anzeige' COLOR COL_NORMAL.
    SKIP TO LINE 31.
    WRITE: / '->', 'ALV-Anzeige' COLOR COL_NORMAL HOTSPOT, icon_list AS ICON HOTSPOT.
  ENDIF.

AT LINE-SELECTION.
  WRITE: / 'Listenstufe: ', sy-lsind, / 'Angeklickte Zeile: ', sy-lilli, / 'Index der Ereignisauslösung: ', sy-listi.
  IF sy-lsind = 3.
    sy-lsind = 0.
  ENDIF.
  CASE sy-lilli.
    WHEN 30.
      IF p_sel = 'X'.
        LOOP AT lt_flights INTO ls_flight.
          WRITE: / ls_flight-carrid, ls_flight-connid, ls_flight-fldate.
        ENDLOOP.
      ELSE.
        LOOP AT lt_bapisfldats INTO ls_bapisfldat.
          WRITE: / ls_bapisfldat-airlineid, ls_bapisfldat-connectid, ls_bapisfldat-flightdate.
        ENDLOOP.
      ENDIF.
    WHEN 31.
      IF p_sel = 'X'.
        CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
          EXPORTING
            i_structure_name = 'sflight'
          TABLES
            t_outtab         = lt_flights.
        IF sy-subrc <> 0.
          WRITE: / 'ALV-Error.'.
        ENDIF.
      ELSE.
        CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
          EXPORTING
            i_structure_name = 'bapisfldat'
          TABLES
            t_outtab         = lt_bapisfldats.
        IF sy-subrc <> 0.
          WRITE: / 'ALV-Error.'.
        ENDIF.
      ENDIF.
  ENDCASE.


*SELECT mit JOIN über drei Tabellen------------------------------------------------------------------------------------------------
*  SELECT a~partner a~type
*         b~vkont b~vkbez b~loevm
*         c~vertrag c~bukrs c~sparte
*         c~einzdat c~auszdat c~billfinit c~loevm
*    FROM ( ( but000  AS a
*         JOIN fkkvkp AS b ON a~partner = b~gpart )
*         JOIN ever   AS c ON b~vkont   = c~vkonto )
*    INTO TABLE gt_input
*    WHERE a~partner IN so_gpart
*    AND   b~vkont   IN so_vkont
*    AND   c~vertrag IN so_vertr
*    AND   b~loevm <> 'X'
*    AND   c~loevm <> 'X'.

  INCLUDE zvz_inc_form_14_program.