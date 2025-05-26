CLASS event_handler DEFINITION PUBLIC FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_mm_condition_created FOR EVENT created OF cl_purgprcgcndnrecord_events
        IMPORTING conditiontype
                  refconditionrecord
                  sender.
ENDCLASS.

CLASS event_handler IMPLEMENTATION.
  METHOD on_mm_condition_created.
    DATA(lv_conditiontype) = conditiontype.
    DATA(lv_refconditionrecord) = refconditionrecord.
    DATA(lv_sender) = sender.
  ENDMETHOD.
ENDCLASS.