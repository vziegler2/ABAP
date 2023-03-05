CLASS zvzcl_money_machine DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_amount_in_coins
      IMPORTING i_amount              TYPE i
      RETURNING VALUE(r_result_coins) TYPE i.
    METHODS get_amount_in_notes
      IMPORTING i_amount              TYPE i
      RETURNING VALUE(r_result_notes) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvzcl_money_machine IMPLEMENTATION.

  METHOD get_amount_in_coins.
    r_result_coins = COND #( WHEN i_amount <= 0 THEN -1 ELSE i_amount MOD 5 ).
  ENDMETHOD.


  METHOD get_amount_in_notes.
    r_result_notes = i_amount - get_amount_in_coins( i_amount = i_amount ).
  ENDMETHOD.

ENDCLASS.