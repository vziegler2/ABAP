CLASS lcl_weather_service_stub DEFINITION.
  PUBLIC SECTION.
    INTERFACES: zif_cvvz_000.

    METHODS: constructor IMPORTING average_temp TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: average_temp TYPE i.
ENDCLASS.

CLASS lcl_weather_service_stub IMPLEMENTATION.
  METHOD zif_cvvz_000~average_temperature_forecast.
    average_temp = me->average_temp.
  ENDMETHOD.

  METHOD constructor.
    me->average_temp = average_temp.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_weather_display DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_very_cold FOR TESTING RAISING cx_static_check,
      test_hot FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_weather_display IMPLEMENTATION.
  METHOD test_very_cold.
    DATA(weather_service) = NEW lcl_weather_service_stub( -10 ).
    DATA(weather_display) = NEW zcl_cvvz_001( weather_service ).
    cl_abap_unit_assert=>assert_equals( exp = |It is very cold today.|
                                        act = weather_display->forecast( ) ).
  ENDMETHOD.

  METHOD test_hot.
    DATA(weather_service) = NEW lcl_weather_service_stub( 30 ).
    DATA(weather_display) = NEW zcl_cvvz_001( weather_service ).
    cl_abap_unit_assert=>assert_equals( exp = |It is hot today.|
                                        act = weather_display->forecast( ) ).
  ENDMETHOD.
ENDCLASS.