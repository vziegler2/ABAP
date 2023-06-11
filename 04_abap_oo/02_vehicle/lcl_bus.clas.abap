*&---------------------------------------------------------------------*
*& Include zcvvz_inc_lcl_bus
*&---------------------------------------------------------------------*
CLASS lcl_bus DEFINITION INHERITING FROM lcl_vehicle.

    PUBLIC SECTION.
      METHODS: display_attributes REDEFINITION,
        constructor IMPORTING iv_tpass  TYPE i
                              iv_tmake  TYPE string
                              iv_tmodel TYPE string,
        estimate_fuel REDEFINITION.
    PROTECTED SECTION.
    PRIVATE SECTION.
      DATA: mv_pass TYPE i.
  
  ENDCLASS.
  
  CLASS lcl_bus IMPLEMENTATION.
    METHOD constructor.
      super->constructor( iv_make = iv_tmake
                          iv_model = iv_tmodel ).
      me->mv_pass = iv_tpass.
    ENDMETHOD.
  
    METHOD display_attributes.
      WRITE: /, 'Make:', mv_make.
      WRITE: /, 'Model:', mv_model.
      WRITE: /, 'Passagier:', mv_pass.
    ENDMETHOD.
  
    METHOD estimate_fuel.
      rv_fuel = iv_dist / 100 * 15.
    ENDMETHOD.
  ENDCLASS.