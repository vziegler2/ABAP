CLASS ltcl_get_amount DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: m_cut TYPE REF TO zvzcl_fizzbuzz.

    METHODS: setup,
      error_cases FOR TESTING RAISING zvzx_000. "Klassische Alternative ohne RAISING zvzx_000
ENDCLASS.


CLASS ltcl_get_amount IMPLEMENTATION.

  METHOD setup.
    m_cut = NEW #(  ).
  ENDMETHOD.

  METHOD error_cases.
    TRY.
        m_cut->lm_fizzbuzz( i_input = 101 ).
*cl_abap_unit_assert=>fail( msg = 'Fail' ).
      CATCH zvzx_000.
    ENDTRY.
*m_cut->lm_fizzbuzz( i_input = 101 EXCEPTIONS <exception_name> = x ).
*cl_abap_unit_assert=>assert_subrc( exp = 4 ).
  ENDMETHOD.

ENDCLASS.