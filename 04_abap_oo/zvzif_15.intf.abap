INTERFACE zvzif_15
  PUBLIC .
  DATA: gv_speed TYPE int1.
  METHODS: break
    IMPORTING i_change       TYPE int1
    RETURNING VALUE(r_speed) TYPE int1,
    acc
      IMPORTING i_change       TYPE int1
      RETURNING VALUE(r_speed) TYPE int1.
ENDINTERFACE.