INTERFACE zvzif_airplane
  PUBLIC .
  DATA: gv_engine_type TYPE string.
  METHODS: set_engine_type IMPORTING iv_engine_type TYPE string.
ENDINTERFACE.