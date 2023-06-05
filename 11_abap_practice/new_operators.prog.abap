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
****************************************************************
* Dynamic instantiation (not possible with NEW)
****************************************************************
DATA: any_object TYPE REF TO object.

CREATE OBJECT any_object TYPE ('ZCL_CVVZ_SALV').

TRY.
    CREATE OBJECT any_object TYPE ('NOT_EXISTING_CLASS').
  CATCH cx_sy_create_object_error INTO DATA(cx_error).
    MESSAGE 'Error' TYPE 'E' DISPLAY LIKE 'I'.
ENDTRY.
****************************************************************
* LET (variables for one statement)
****************************************************************
TYPES: BEGIN OF gty_days,
         first_item  TYPE datum,
         second_item TYPE datum,
       END OF gty_days.

DATA(gv_days) = VALUE gty_days( LET yesterday = sy-datum - 1
                                    tomorrow  = sy-datum + 1
                                IN  first_item  = yesterday + 3
                                    second_item = tomorrow + 3 ).
****************************************************************
* Structure and itab CORRESPONDING statt MOVE-CORRESPONDING
****************************************************************
TYPES: BEGIN OF gty_weekdays,
         monday    TYPE datum,
         tuesday   TYPE datum,
         wednesday TYPE datum,
         thursday  TYPE datum,
         friday    TYPE datum,
         saturday  TYPE datum,
         sunday    TYPE datum,
       END OF gty_weekdays,
       gty_weekdays_t TYPE STANDARD TABLE OF gty_weekdays WITH EMPTY KEY,
       BEGIN OF gty_workdays,
         monday    TYPE datum,
         tuesday   TYPE datum,
         wednesday TYPE datum,
         thursday  TYPE datum,
         friday    TYPE datum,
       END OF gty_workdays,
       gty_workdays_t TYPE STANDARD TABLE OF gty_workdays WITH EMPTY KEY.

DATA(gs_weekdays) = VALUE gty_weekdays( monday    = sy-datum
                                        tuesday   = sy-datum + 1
                                        wednesday = sy-datum + 2
                                        thursday  = sy-datum + 3
                                        friday    = sy-datum + 4
                                        saturday  = sy-datum + 5
                                        sunday    = sy-datum + 6 ).

*MOVE-CORRESPONDING weekdays TO workdays.                        "Prüft auf Namensgleichheit
DATA(gs_workdays) = CORRESPONDING gty_workdays( gs_weekdays ).   " Weitere Optionen in Klammer mit Ctrl+Space
" Performanceoptimiert
DATA(gt_weekdays) = VALUE gty_weekdays_t( ( gs_weekdays )
                                          ( monday    = sy-datum
                                            tuesday   = sy-datum + 1
                                            wednesday = sy-datum + 2
                                            thursday  = sy-datum + 3
                                            friday    = sy-datum + 4
                                            saturday  = sy-datum + 5
                                            sunday    = sy-datum + 6 ) ).

DATA(gt_workdays) = CORRESPONDING gty_workdays_t( gt_weekdays ).
****************************************************************
* line_exists and line_index
****************************************************************
TYPES: BEGIN OF gty_workdays2,
         day TYPE string,
       END OF gty_workdays2,
       gty_workdays2_t TYPE STANDARD TABLE OF gty_workdays2 WITH DEFAULT KEY.

DATA(gt_workdays2) = VALUE gty_workdays2_t( ( day = |Monday| )
                                            ( day = |Tuesday| )
                                            ( day = |Wednesday| )
                                            ( day = |Thursday| )
                                            ( day = |Friday| ) ).

*READ TABLE gt_workdays2 INTO DATA(gs_workday1) INDEX 1.
*IF sy-subrc = 0.
*ENDIF.
IF line_exists( gt_workdays2[ 1 ] ).
ENDIF.
*READ TABLE gt_workdays2 WITH KEY day = |Monday| INTO DATA(gs_workday2).
*...
IF line_exists( gt_workdays2[ day = |Monday| ] ).
ENDIF.
*READ TABLE gt_workdays2 TRANSPORTING NO FIELDS WITH KEY day = |Monday|.
*...
DATA(gv_tabix) = line_index( gt_workdays2[ day = |Monday| ] ).
****************************************************************
* itab chaining
****************************************************************
TYPES: BEGIN OF gty_deep_structure_days,
         category TYPE string,
         days     TYPE gty_workdays2,
       END OF gty_deep_structure_days,
       gty_deep_structure_days_t TYPE STANDARD TABLE OF gty_deep_structure_days WITH DEFAULT KEY.

DATA(gs_workdays2) = VALUE gty_workdays2( day = |Monday| ).

DATA(gt_deep_structure_days) = VALUE gty_deep_structure_days_t( category = 'Mai'
                                                                ( days = gs_workdays2 )
                                                                ( days = VALUE gty_workdays2( day = |Tuesday| ) )
                                                                ( days = VALUE gty_workdays2( day = |Wednesday| ) )
                                                                ( days = VALUE gty_workdays2( day = |Thursday| ) ) ).

*READ TABLE gt_deep_structure_days INTO DATA(gs_000) INDEX 1.
*DATA(gv_day1) = gs_000-days-day.
DATA(gv_day1) = gt_deep_structure_days[ 1 ]-days-day.
****************************************************************
* FOR
****************************************************************
TYPES: BEGIN OF gty_happy_workdays,
         day    TYPE string,
         factor TYPE i,
       END OF gty_happy_workdays,
       gty_happy_workdays_t TYPE STANDARD TABLE OF gty_happy_workdays WITH DEFAULT KEY,
       gty_int_tab          TYPE STANDARD TABLE OF i WITH EMPTY KEY.

DATA(gt_happy_workdays) = VALUE gty_happy_workdays_t( ( day = |Monday| factor = 10 )
                                                      ( day = |Tuesday| factor = 20 ) ).
*Hängt alle Werte aus gt_happy_workdays an gt_special_days, deren factor kleiner 20 ist.
*Man könnte auch nur einzelne Werte von gs_happy_workdays anhängen.
DATA(gt_special_days) = VALUE gty_happy_workdays_t( FOR gs_happy_workdays IN gt_happy_workdays WHERE
                                                    ( factor < 20 )
                                                    ( gs_happy_workdays ) ).
*Tabelle mit den Zahlen von 1 bis 10 wird erstellt
DATA(gt_of_i) = VALUE gty_int_tab( FOR i = 1 THEN i + 1 UNTIL i = 10
                                   ( i ) ).
****************************************************************
* REDUCE
****************************************************************
*Ermittelt die Summe der Einträge in gt_of_i
DATA(gv_sum) = REDUCE i( INIT x = 0 FOR ls IN gt_of_i NEXT x += ls ).
DATA(gv_sum2) = REDUCE i( INIT x = 0
                          FOR ls
                          IN VALUE gty_int_tab( FOR i = 1 THEN i + 1 UNTIL i = 10 ( i ) )
                          NEXT x += ls ).
****************************************************************
* FILTER (sorted und hashed tables)
****************************************************************
DATA: gt_of_i_sorted        TYPE SORTED TABLE OF i WITH NON-UNIQUE KEY table_line,
      gt_of_i_from_5_sorted TYPE SORTED TABLE OF i WITH NON-UNIQUE KEY table_line.

gt_of_i_sorted = VALUE #( FOR i = 1 THEN i + 1 UNTIL i = 10
                          ( i ) ).

gt_of_i_from_5_sorted = FILTER #( gt_of_i_sorted WHERE table_line > 5 ).