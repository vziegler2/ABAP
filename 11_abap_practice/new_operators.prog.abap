REPORT zcvvz_000.
****************************************************************
* CAST statt ?=
****************************************************************
*DATA structdescr TYPE REF TO cl_abap_structdescr.
*structdescr ?= cl_abap_typedescr=>describe_by_name( 'STRING_T' ).
*DATA(components_old) = structdescr->components.

*DATA(components) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( 'STRING_T' ) )->components.
****************************************************************
* VALUE zur Struktur-/Tabellenfüllung
****************************************************************
DATA(sflight_wa) = VALUE sflight( fldate = sy-datum price = 500 seatsmax = 20 ).
****************************************************************
* COND statt IF
****************************************************************
*DATA: ret_var TYPE string.
*
*IF 1 = 1.
*  ret_var = 'TRUE'.
*ELSEIF 2 = 2.
*  ret_var = 'FALSE'.
*ELSE.
*  ret_var = 'UnKnown'.
*ENDIF.

DATA(ret_var) = COND #( WHEN 1 = 1 THEN 'TRUE'
                        WHEN 2 = 2 THEN 'FALSE'
                        ELSE            'UnKnown' ).
****************************************************************
* SWITCH statt CASE
****************************************************************
DATA(days) = 5.
*
*CASE days.
*  WHEN 1.
*    ret_var = 'MO'.
*  WHEN 2.
*    ret_var = 'DI'.
*  WHEN OTHERS.
*    ret_var = 'HMH'.
*ENDCASE.

ret_var = SWITCH #( days
                    WHEN 1 THEN 'MO'
                    WHEN 2 THEN 'DI'
                    ELSE        'HMH' ).
****************************************************************
* CONV zur Typkonvertierung
****************************************************************
IF ' ' = ` `.
  WRITE / |Erste Bedingung|.
ELSEIF ' ' = CONV char1( ` ` ).
  WRITE / |Zweite Bedingung|.
ENDIF.
****************************************************************
* EXACT für Numchars
****************************************************************
*DATA seatsmax TYPE n LENGTH 255.

*seatsmax = '3 Business + 2 Economy'.

TYPES numtext TYPE n LENGTH 255.

TRY.
    DATA(number) = EXACT numtext( '4 Apples + 2 Oranges' ).
  CATCH cx_sy_conversion_error INTO DATA(cxerror).
    MESSAGE cxerror TYPE 'E' DISPLAY LIKE 'I'.
ENDTRY.