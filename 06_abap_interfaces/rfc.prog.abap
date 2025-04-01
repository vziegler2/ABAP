REPORT zcvvz_000.

DATA: gs_rfcsi TYPE rfcsi,
      gv_msg(100),
      gv_msg2(100).

PARAMETERS: pa_dest TYPE rfcdes-rfcdest DEFAULT 'E04'. "RFC-Destination finden: Tabelle RFCDES, RFCTYPE = 3.

CALL FUNCTION 'RFC_SYSTEM_INFO' DESTINATION pa_dest
  IMPORTING
    rfcsi_export      = gs_rfcsi.

CALL FUNCTION 'DEMO_RFM_CLASSIC_EXCEPTION'
  EXCEPTIONS
    classic_exception = 1
    system_failure    = 2 gv_msg
    communication_failure = 3 gv_msg2
    others = 4.

MESSAGE i001(00) WITH SWITCH #( sy-subrc
                                WHEN 1 THEN |{ sy-subrc }, { sy-msgv1 }| 
                                WHEN 2 THEN |{ sy-subrc }, { gv_msg }|
                                WHEN 3 THEN |{ sy-subrc }, { gv_msg2 }|
                                ELSE |{ sy-subrc }| ).