REPORT zvzp_ids.

DATA: lt_carrids TYPE TABLE OF zob_st_006.

CALL FUNCTION 'Z_GET_AIRLINE_IDS_006'
  DESTINATION 'obd_OBD_00'
  TABLES
    carrids = lt_carrids.

cl_demo_output=>display( lt_carrids ).

*------------------------------------------------

PARAMETERS: p_carr TYPE s_carrname OBLIGATORY,
            p_curr TYPE s_currcode OBLIGATORY,
            p_url  TYPE s_carrurl OBLIGATORY.

DATA: lt_scarr_cpy TYPE TABLE OF scarr.

CALL FUNCTION 'Z_ADD_AIRLINE_006'
  DESTINATION 'obd_OBD_00'
  EXPORTING
    carrname = p_carr
    currcode = p_curr
    url      = p_url.

*------------------------------------------------

PARAMETERS: p_carrid TYPE s_carr_id.

CALL FUNCTION 'Z_DELETE_AIRLINE_006'
  DESTINATION 'obd_OBD_00'
  EXPORTING
    carrid = p_carrid.