CLASS zvzcl_money_machine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_amount_in_coins
        IMPORTING i_amount TYPE i
        RETURNING VALUE(r_value) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvzcl_money_machine IMPLEMENTATION.

  METHOD get_amount_in_coins.
    r_value = COND #( WHEN i_amount <= 0 THEN -1 ELSE i_amount MOD 5 ).
  ENDMETHOD.

ENDCLASS.