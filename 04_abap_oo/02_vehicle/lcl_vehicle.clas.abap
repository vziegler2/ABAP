*&---------------------------------------------------------------------*
*& Include zcvvz_inc_lcl_vehicle
*&---------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION.

    PUBLIC SECTION.
      DATA: mv_make TYPE string READ-ONLY.
  
      METHODS: display_attributes,
        set_model   IMPORTING REFERENCE(iv_model) TYPE string,
        get_model   EXPORTING REFERENCE(ev_model) TYPE string,
        set_make    IMPORTING iv_make             TYPE string,
        get_make    EXPORTING ev_make             TYPE string,
        constructor IMPORTING iv_make TYPE string
                              iv_model TYPE string,
        estimate_fuel IMPORTING iv_dist TYPE i
                      RETURNING VALUE(rv_fuel) TYPE i.
  
        CLASS-METHODS: get_counter RETURNING VALUE(rv_counter) TYPE i,
                       class_constructor.
  
    PROTECTED SECTION.
      DATA: mv_model TYPE string.
    PRIVATE SECTION.
      CLASS-DATA: kv_counter TYPE i.
      METHODS: hello_world.
  ENDCLASS.
  
  CLASS lcl_vehicle IMPLEMENTATION.
    METHOD class_constructor.
      kv_counter = 10.
    ENDMETHOD.
  
    METHOD constructor.
      me->mv_make = iv_make.
      me->mv_model = iv_model.
      kv_counter += 1.
    ENDMETHOD.
  
    METHOD hello_world.
      WRITE: / 'Hello World'.
    ENDMETHOD.
  
    METHOD display_attributes.
      WRITE: / 'Make : ', me->mv_make, /, 'Model : ', me->mv_model.
    ENDMETHOD.
  
    METHOD set_model.
      me->mv_model = iv_model.
    ENDMETHOD.
  
    METHOD get_model.
      ev_model = me->mv_model.
    ENDMETHOD.
  
    METHOD set_make.
      me->mv_make = iv_make.
    ENDMETHOD.
  
    METHOD get_make.
      ev_make = me->mv_make.
    ENDMETHOD.
  
    METHOD get_counter.
      rv_counter = kv_counter.
    ENDMETHOD.
  
    METHOD estimate_fuel.
    ENDMETHOD.
  
  ENDCLASS.