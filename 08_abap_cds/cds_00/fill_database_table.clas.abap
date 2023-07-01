CLASS zcl_cvvz_000 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_cvvz_000 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DELETE FROM zcvvz_dt_000.
    INSERT zcvvz_dt_000 FROM ( SELECT dokar,
                                      doknr,
                                      dokvr,
                                      doktl,
                                      dokst,
                                      adatum
                               FROM draw
                               WHERE dokar = 'ZRO' AND adatum > '20220601' ).
  ENDMETHOD.
ENDCLASS.