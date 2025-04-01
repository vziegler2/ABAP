REPORT zcvvz_000.

DATA: gs_rfcsi    TYPE rfcsi,
      gv_msg(100).

PARAMETERS: pa_dest TYPE rfcdes-rfcdest DEFAULT 'TS1'. "RFC-Destination finden: Tabelle RFCDES, RFCTYPE = 3.

CALL FUNCTION 'RFC_SYSTEM_INFO' DESTINATION pa_dest
  IMPORTING
    rfcsi_export      = gs_rfcsi.

CALL FUNCTION 'DEMO_RFM_CLASSIC_EXCEPTION_2' DESTINATION pa_dest
  EXCEPTIONS
    classic_exception     = 1
    system_failure        = 2 MESSAGE gv_msg "Die beiden RFC-spezifischen Ausnahmen bieten die Option für weiteren Text
    communication_failure = 3 MESSAGE gv_msg
    OTHERS                = 4.

MESSAGE e001(00) WITH SWITCH #( sy-subrc
                                WHEN 1 THEN |{ sy-subrc }, { sy-msgv1 }|
                                WHEN 2 OR 3 THEN |{ sy-subrc }, { gv_msg }|
                                ELSE |{ sy-subrc }| ).