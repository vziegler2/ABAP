REPORT zcvvz_000.

DATA: gs_rfcsi TYPE rfcsi.

PARAMETERS: pa_dest TYPE rfcdes-rfcdest DEFAULT 'E04'.

CALL FUNCTION 'RFC_SYSTEM_INFO' DESTINATION pa_dest
  IMPORTING
    rfcsi_export      = gs_rfcsi
*    current_resources =
*    maximal_resources =
*    recommended_delay =
*    s4_hana           =
*    fast_ser_vers     =
.

WRITE: /, gs_rfcsi-rfcdbsys.