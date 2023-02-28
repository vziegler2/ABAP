CLASS ltcl_get_amount_in_coins DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO zvzcl_money_machine.

    METHODS: setup,
      amount_1_coin_1 FOR TESTING,
      amount_2_coin_2 FOR TESTING.
ENDCLASS.


CLASS ltcl_get_amount_in_coins IMPLEMENTATION.

  METHOD setup.
    cut = NEW zvzcl_money_machine(  ).
  ENDMETHOD.

  METHOD amount_1_coin_1.
    DATA(coin_amount) = cut->get_amount_in_coins( 1 ).
    cl_abap_unit_assert=>assert_equals( exp = 1
                                        act = coin_amount ).
  ENDMETHOD.

  METHOD amount_2_coin_2.
    DATA(coin_amount) = cut->get_amount_in_coins( 2 ).
    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = coin_amount ).
  ENDMETHOD.

ENDCLASS.