INTERFACE zvzif_airplaneconnid
  PUBLIC .
  DATA: gv_conn_id TYPE s_conn_id.
  METHODS: determine_conn_id,
    set_conn_id IMPORTING iv_conn_id TYPE s_conn_id.
ENDINTERFACE.