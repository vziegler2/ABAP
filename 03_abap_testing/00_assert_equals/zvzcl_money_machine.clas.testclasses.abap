CLASS ltcl_get_amount DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: m_cut TYPE REF TO zvzcl_money_machine.

    METHODS: setup,
      assert_convert_coins
        IMPORTING r_return TYPE i
                  i_input  TYPE i,
      assert_convert_notes
        IMPORTING r_return TYPE i
                  i_input  TYPE i,
      assert_invalid_input
        IMPORTING r_return TYPE i
                  i_input  TYPE i,
      assert_converts_both
        IMPORTING i_input  TYPE i
                  r_return TYPE zvzcl_money_machine=>tt_change,
      assert_error
        IMPORTING i_input TYPE i,
      verify FOR TESTING RAISING cx_static_check.
*      error_cases FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_get_amount IMPLEMENTATION.

  METHOD setup.
    m_cut = NEW #(  ).
  ENDMETHOD.

  METHOD assert_convert_coins.
    cl_abap_unit_assert=>assert_equals( exp = r_return
                                        act = m_cut->get_amount_in_coins( i_input ) ).
  ENDMETHOD.

  METHOD assert_convert_notes.
    cl_abap_unit_assert=>assert_equals( exp = r_return
                                        act = m_cut->get_amount_in_notes( i_input ) ).
  ENDMETHOD.

  METHOD assert_invalid_input.
    cl_abap_unit_assert=>assert_initial( m_cut->get_change( i_input ) ).
  ENDMETHOD.

  METHOD assert_converts_both.
    cl_abap_unit_assert=>assert_equals( exp = r_return
                                        act = m_cut->get_change( i_input ) ).
  ENDMETHOD.

  METHOD assert_error.
    cl_abap_unit_assert=>assert_equals( exp = -1
                                        act = m_cut->get_amount_in_coins( i_input ) ).
  ENDMETHOD.

  METHOD verify.
    assert_convert_coins( r_return = 1 i_input = 1 ).
    assert_convert_coins( r_return = 2 i_input = 2 ).
    assert_convert_coins( r_return = 4 i_input = 29 ).
    assert_convert_notes( r_return = 0 i_input = 4 ).
    assert_convert_notes( r_return = 25 i_input = 29 ).
    assert_invalid_input( r_return = 0 i_input = -11 ).
    assert_invalid_input( r_return = 0 i_input = 0 ).
    assert_converts_both( r_return = VALUE #( ( amount = 1 type = 'coin' ) ) i_input = 1 ).
    assert_converts_both( r_return = VALUE #( ( amount = 2 type = 'coin' ) ) i_input = 2 ).
    assert_converts_both( r_return = VALUE #( ( amount = 2 type = 'coin' )
                                              ( amount = 1 type = 'coin' ) ) i_input = 3 ).
    assert_converts_both( r_return = VALUE #( ( amount = 2 type = 'coin' )
                                              ( amount = 2 type = 'coin' ) ) i_input = 4 ).
    assert_converts_both( r_return = VALUE #( ( amount = 5 type = 'note' ) ) i_input = 5 ).
    assert_converts_both( r_return = VALUE #( ( amount = 5 type = 'note' )
                                              ( amount = 2 type = 'coin' )
                                              ( amount = 1 type = 'coin' ) ) i_input = 8 ).
    assert_converts_both( r_return = VALUE #( ( amount = 10 type = 'note' ) ) i_input = 10 ).
    assert_converts_both( r_return = VALUE #( ( amount = 10 type = 'note' )
                                              ( amount = 5 type = 'note' ) ) i_input = 15 ).
    assert_converts_both( r_return = VALUE #( ( amount = 20 type = 'note' ) ) i_input = 20 ).
    assert_converts_both( r_return = VALUE #( ( amount = 50 type = 'note' ) ) i_input = 50 ).
    assert_converts_both( r_return = VALUE #( ( amount = 50 type = 'note' )
                                              ( amount = 20 type = 'note' )
                                              ( amount = 10 type = 'note' )
                                              ( amount = 5 type = 'note' ) ) i_input = 85 ).
    assert_converts_both( r_return = VALUE #( ( amount = 100 type = 'note' ) ) i_input = 100 ).
    assert_converts_both( r_return = VALUE #( ( amount = 200 type = 'note' ) ) i_input = 200 ).
    assert_converts_both( r_return = VALUE #( ( amount = 500 type = 'note' ) ) i_input = 500 ).
    assert_converts_both( r_return = VALUE #( ( amount = 200 type = 'note' )
                                              ( amount = 100 type = 'note' )
                                              ( amount = 50 type = 'note' )
                                              ( amount = 20 type = 'note' )
                                              ( amount = 10 type = 'note' )
                                              ( amount = 5 type = 'note' )
                                              ( amount = 2 type = 'coin' )
                                              ( amount = 1 type = 'coin' ) ) i_input = 388 ).
    assert_converts_both( r_return = VALUE #( ( amount = 500 type = 'note' )
                                              ( amount = 100 type = 'note' )
                                              ( amount = 50 type = 'note' )
                                              ( amount = 20 type = 'note' )
                                              ( amount = 10 type = 'note' )
                                              ( amount = 5 type = 'note' )
                                              ( amount = 2 type = 'coin' )
                                              ( amount = 1 type = 'coin' ) ) i_input = 688 ).
  ENDMETHOD.

*    METHOD error_cases.
*      assert_error( i_input = 0 ).
*    ENDMETHOD.

ENDCLASS.