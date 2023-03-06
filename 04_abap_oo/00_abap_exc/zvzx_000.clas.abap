CLASS zvzx_000 DEFINITION INHERITING FROM cx_no_check
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS lm_exc.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvzx_000 IMPLEMENTATION.

  METHOD lm_exc.
    MESSAGE ID '00' TYPE 'E' NUMBER '001' WITH 'Bitte eine Zahl zwischen 1 und 100 eingeben!'.
    EXIT.
  ENDMETHOD.

ENDCLASS.