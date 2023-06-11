CLASS zvzcl_15 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zvzif_15.
    ALIASES if_speed FOR zvzif_15~gv_speed.
    METHODS: constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zvzcl_15 IMPLEMENTATION.
  METHOD constructor.
    if_speed = 2.
  ENDMETHOD.

  METHOD zvzif_15~break.
    r_speed = if_speed - i_change.
  ENDMETHOD.

  METHOD zvzif_15~acc.
    r_speed = if_speed + i_change.
  ENDMETHOD.

ENDCLASS.