REPORT zvz_15_program.

SELECTION-SCREEN BEGIN OF BLOCK start_screen WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_input TYPE i DEFAULT 0.

SELECTION-SCREEN END OF BLOCK start_screen.

TYPES: input TYPE c LENGTH 10,
       BEGIN OF ls_value,
         zahl     TYPE i,
         ergebnis TYPE input,
       END OF ls_value,
       tt_value TYPE STANDARD TABLE OF ls_value WITH EMPTY KEY.

DATA: lt_ergebnis     TYPE tt_value,
      lo_zvz_15_class TYPE REF TO zvz_15_class,
      lo_salv_table   TYPE REF TO cl_salv_table,
      interfacerefvariable TYPE REF TO zvzif_15.

AT SELECTION-SCREEN.
  IF p_input < 1 OR p_input > 15.
    MESSAGE ID '00' TYPE 'E' NUMBER '001' WITH 'Bitte Ganzzahl zwischen 1 und 15 eingeben!'.
    EXIT.
  ENDIF.

  interfacerefvariable = NEW zvzcl_15(  ).
  
  CREATE OBJECT lo_zvz_15_class.

  lt_ergebnis = lo_zvz_15_class->fizzbuzz( p_input ).

  TRY.
      cl_salv_table=>factory(  IMPORTING r_salv_table = lo_salv_table
                               CHANGING  t_table      = lt_ergebnis ).

      lo_salv_table->display( ).

    CATCH cx_salv_not_found cx_salv_msg.
  ENDTRY.