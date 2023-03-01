CLASS ltcl_zvzcl_15 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO zvzcl_15.
    METHODS: setup,
      constructor_test FOR TESTING.
ENDCLASS.


CLASS ltcl_zvzcl_15 IMPLEMENTATION.

  METHOD setup.
    cut = NEW #(  ).
  ENDMETHOD.

  METHOD constructor_test.
    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = cut->if_speed ).
  ENDMETHOD.

ENDCLASS.