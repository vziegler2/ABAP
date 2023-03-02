CLASS ltcl_get_amount DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: m_cut TYPE REF TO zvzcl_money_machine.

    METHODS: setup,
      assert_convert
        IMPORTING i_return TYPE i
                  i_input  TYPE i,
      assert_error
        IMPORTING i_input TYPE i,
      verify FOR TESTING RAISING cx_static_check,
      error_cases FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_get_amount IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT m_cut.
  ENDMETHOD.

  METHOD assert_convert.
    cl_abap_unit_assert=>assert_equals( exp = i_return
                                        act = m_cut->get_amount_in_coins( i_input ) ).
  ENDMETHOD.

  METHOD assert_error.
    cl_abap_unit_assert=>assert_equals( exp = -1
                                        act = m_cut->get_amount_in_coins( i_input ) ).
  ENDMETHOD.

  METHOD verify.
    assert_convert( i_return = 1 i_input = 1 ).
    assert_convert( i_return = 2 i_input = 2 ).
    assert_convert( i_return = 4 i_input = 29 ).
  ENDMETHOD.

  METHOD error_cases.
    assert_error( i_input = 0 ).
  ENDMETHOD.

ENDCLASS.