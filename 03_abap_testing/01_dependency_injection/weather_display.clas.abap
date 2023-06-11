CLASS zcl_cvvz_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: constructor IMPORTING weather_service TYPE REF TO zif_cvvz_000 OPTIONAL,
      forecast RETURNING VALUE(forecast) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: weather_service TYPE REF TO zif_cvvz_000.
ENDCLASS.



CLASS zcl_cvvz_001 IMPLEMENTATION.
  METHOD constructor.
    IF weather_service IS BOUND.
      me->weather_service = weather_service.
    ELSE.
      me->weather_service = NEW zcl_cvvz_000( ).
    ENDIF.
  ENDMETHOD.

  METHOD forecast.
    forecast = COND #( LET average_temp = weather_service->average_temperature_forecast( ) IN
                       WHEN average_temp < 0  THEN |It is very cold today.|
                       WHEN average_temp < 15 THEN |It is cold today.|
                       WHEN average_temp < 20 THEN |It is nice today.|
                       WHEN average_temp < 25 THEN |It is warm today.|
                       ELSE                        |It is hot today.| ).
  ENDMETHOD.
ENDCLASS.