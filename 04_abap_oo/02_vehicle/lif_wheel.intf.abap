*&---------------------------------------------------------------------*
*& Include zcvvz_inc_lif_wheel
*&---------------------------------------------------------------------*
INTERFACE lif_wheel.
  METHODS: check_wheel.
  CLASS-DATA: kv_no_of_wheels TYPE i READ-ONLY.
  CLASS-METHODS: get_no_of_wheels RETURNING VALUE(rv_no_of_wheels) TYPE i.
ENDINTERFACE.