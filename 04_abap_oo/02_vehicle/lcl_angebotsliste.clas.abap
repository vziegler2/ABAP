*&---------------------------------------------------------------------*
*& Include zcvvz_inc_lcl_angebotsliste
*&---------------------------------------------------------------------*
CLASS lcl_angebotsliste DEFINITION.

    PUBLIC SECTION.
      METHODS: on_truck_available FOR EVENT truck_available
                                  OF lcl_truck
                                  IMPORTING ev_string
                                            sender,
               constructor.
      CLASS-METHODS: on_truck_ready FOR EVENT truck_ready
                                              OF lcl_truck
                                              IMPORTING ev_string.
    PROTECTED SECTION.
    PRIVATE SECTION.
  
  ENDCLASS.
  
  CLASS lcl_angebotsliste IMPLEMENTATION.
    METHOD on_truck_available.
      DATA: lr_truck TYPE REF TO lcl_truck.
  
      WRITE: /, |Truck ist verfügbar.|.
      WRITE: /, ev_string.
  
      lr_truck = sender.
      lr_truck->display_attributes(  ).
    ENDMETHOD.
  
    METHOD on_truck_ready.
      WRITE: /, |Truck ist verfügbar.|.
      WRITE: /, ev_string.
    ENDMETHOD.
  
    METHOD constructor.
      SET HANDLER on_truck_available FOR ALL INSTANCES. "Deaktivierbar mit ACTIVATION ''
      SET HANDLER on_truck_ready.
    ENDMETHOD.
  
  ENDCLASS.