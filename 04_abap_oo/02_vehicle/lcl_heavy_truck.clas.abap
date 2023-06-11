*&---------------------------------------------------------------------*
*& Include zcvvz_inc_lcl_heavy_truck
*&---------------------------------------------------------------------*
CLASS lcl_heavy_truck DEFINITION INHERITING FROM lcl_truck.

    PUBLIC SECTION.
      METHODS: heavy_test,
               lif_wheel~check_wheel REDEFINITION.
    PROTECTED SECTION.
    PRIVATE SECTION.
  
  ENDCLASS.
  
  CLASS lcl_heavy_truck IMPLEMENTATION.
    METHOD heavy_test.
    ENDMETHOD.
  
    METHOD lif_wheel~check_wheel.
      WRITE: /, 'Dies ist der Interface-Methodenaufruf aus lcl_heavy_truck'.
    ENDMETHOD.
  
  ENDCLASS.