*&---------------------------------------------------------------------*
*& Include zcvvz_inc_lcl_truck
*&---------------------------------------------------------------------*
CLASS lcl_truck DEFINITION INHERITING FROM lcl_vehicle.

    PUBLIC SECTION.
      INTERFACES: lif_wheel.
  
      ALIASES: meth FOR lif_wheel~check_wheel.
  
      METHODS: set_weight IMPORTING iv_weight TYPE i,
        display_attributes REDEFINITION,
        constructor IMPORTING iv_tweight TYPE i
                              iv_tmake   TYPE string
                              iv_tmodel  TYPE string,
        estimate_fuel REDEFINITION.
  
        EVENTS: truck_available EXPORTING VALUE(ev_string) TYPE string OPTIONAL.
        CLASS-EVENTS: truck_ready EXPORTING VALUE(ev_string) TYPE string OPTIONAL.
  
    PROTECTED SECTION.
      CLASS-DATA: kv_no_trucks TYPE i.
    PRIVATE SECTION.
      DATA: mv_weight TYPE i.
  
  ENDCLASS.
  
  CLASS lcl_truck IMPLEMENTATION.
  
    METHOD constructor.
      super->constructor( iv_make = iv_tmake
                          iv_model = iv_tmodel ).
      me->mv_weight = iv_tweight.
      RAISE EVENT truck_available EXPORTING ev_string = |Das ist ein Übergabeparameter|.
      RAISE EVENT truck_ready EXPORTING ev_string = |Das ist ein Übergabeparameter aus der statischen Methode|.
    ENDMETHOD.
  
    METHOD set_weight.
      mv_weight = iv_weight.
    ENDMETHOD.
  
    METHOD display_attributes.
      WRITE: /, 'Make:', mv_make.
      WRITE: /, 'Model:', mv_model.
      WRITE: /, 'Gewicht:', mv_weight.
    ENDMETHOD.
  
    METHOD estimate_fuel.
      rv_fuel = iv_dist / 100 * 10.
    ENDMETHOD.
  
    METHOD lif_wheel~check_wheel.
      WRITE: /, 'Dies ist der Interface-Methodenaufruf'.
    ENDMETHOD.
  
    METHOD lif_wheel~get_no_of_wheels.
      rv_no_of_wheels = lif_wheel~kv_no_of_wheels.
    ENDMETHOD.
  
  ENDCLASS.