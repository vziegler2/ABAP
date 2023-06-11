CLASS zcl_cvvz_000 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES: zif_cvvz_000.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_cvvz_000 IMPLEMENTATION.
  METHOD zif_cvvz_000~average_temperature_forecast.
    DATA(random) = cl_abap_random=>create( seed = cl_abap_random=>seed( ) ).
    average_temp = random->intinrange( low = -20 high = 40 ).
  ENDMETHOD.
ENDCLASS.