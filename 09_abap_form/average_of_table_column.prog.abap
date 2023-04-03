*Sie wollen die durchschnittlichen Sitzplätze der Economy, Business und First Class wissen.
*Gruppieren Sie die Ergebnisse nach carrid und connid.
*Tabelle: SFLIGHT

DATA: lv_avrg TYPE p DECIMALS 2.

SELECT carrid AS carrid,
       connid AS connid,
       seatsocc AS economy,
       seatsocc_b AS business,
       seatsocc_f AS first FROM sflight
INTO TABLE @DATA(lit_avrge).

PERFORM f_average_table_field
TABLES lit_avrge
USING 'ECONOMY'
CHANGING lv_avrg.

WRITE: / lv_avrg.

PERFORM f_average_table_field
TABLES lit_avrge
USING 'BUSINESS'
CHANGING lv_avrg.

WRITE: / lv_avrg.

PERFORM f_average_table_field
TABLES lit_avrge
USING 'FIRST'
CHANGING lv_avrg.

WRITE: / lv_avrg.
cl_demo_output=>display( lit_avrge ).

FORM f_average_table_field
  TABLES i_table TYPE table
  USING i_field TYPE string
  CHANGING r_result TYPE p.

  DATA: lv_sum   TYPE f.

  DATA(lv_lines) = lines( i_table ).

  LOOP AT i_table ASSIGNING FIELD-SYMBOL(<l>).
    ASSIGN COMPONENT i_field OF STRUCTURE <l> TO FIELD-SYMBOL(<fs>).
    IF sy-subrc = 0.
      lv_sum += <fs>.
    ENDIF.
  ENDLOOP.

  r_result = lv_sum / lv_lines.

ENDFORM.

*Spaltensumme eines Feldes einer internen Tabelle mit REDUCE berechnen
*
*SELECT * FROM spfli INTO TABLE @DATA(it_spfli).
*
*DATA(lv_fltime_sum) = REDUCE spfli-fltime( INIT s = 0
*                                           FOR <l> IN it_spfli
*                                           NEXT s = s + <l>-fltime ).