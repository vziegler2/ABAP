CLASS zvzcl_airplane DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zvzif_airplane, zvzif_airplaneconnid.
    DATA: gv_carrier_id TYPE s_carr_id READ-ONLY.
    CONSTANTS: gc_carrid_lufthansa TYPE s_carr_id VALUE 'LH'.
    METHODS: constructor IMPORTING iv_windows TYPE i
                                   iv_seats   TYPE i,
      set_carrier_id,
      set_windows IMPORTING iv_windows TYPE i,
      set_seats IMPORTING iv_seats TYPE i,
      get_windows EXPORTING ev_windows TYPE i,
      get_seats EXPORTING ev_seats TYPE i,
      compute_windows IMPORTING iv_windows_basic TYPE i.
    CLASS-METHODS: compute_data IMPORTING iv_number_1   TYPE i
                                          iv_number_2   TYPE i
                                RETURNING VALUE(rv_sum) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: gv_windows TYPE i,
          gv_seats   TYPE i.
    CLASS-DATA: gv_editor TYPE char20.
    CONSTANTS: gc_carrid_american TYPE s_carr_id VALUE 'AA'.
    METHODS: add_seats IMPORTING iv_number_of_seats TYPE i.
ENDCLASS.



CLASS zvzcl_airplane IMPLEMENTATION.

  METHOD constructor.
    set_carrier_id(  ).
    set_windows( iv_windows ).
    set_seats( iv_seats ).
  ENDMETHOD.

  METHOD set_carrier_id.
    gv_carrier_id = gc_carrid_lufthansa.
  ENDMETHOD.

  METHOD set_windows.
    gv_windows = iv_windows.
  ENDMETHOD.

  METHOD set_seats.
    gv_seats = iv_seats.
    add_seats( 3 ).
  ENDMETHOD.

  METHOD get_windows.
    ev_windows = gv_windows.
  ENDMETHOD.

  METHOD get_seats.
    ev_seats = gv_seats.
  ENDMETHOD.

  METHOD add_seats.
    gv_seats = gv_seats + iv_number_of_seats.
  ENDMETHOD.

  METHOD compute_data.
    rv_sum = iv_number_1 + iv_number_2.
  ENDMETHOD.

  METHOD compute_windows.
    DATA: lv_windows LIKE gv_windows.
    lv_windows = iv_windows_basic + 4.
    set_windows( EXPORTING iv_windows = lv_windows ).
  ENDMETHOD.

  METHOD zvzif_airplane~set_engine_type.
    zvzif_airplane~gv_engine_type = iv_engine_type.
  ENDMETHOD.

  METHOD zvzif_airplaneconnid~determine_conn_id.
    DATA: lv_conn_id LIKE zvzif_airplaneconnid~gv_conn_id.
    SELECT SINGLE connid FROM spfli INTO lv_conn_id WHERE carrid = gc_carrid_lufthansa.
    zvzif_airplaneconnid~set_conn_id( lv_conn_id ).
  ENDMETHOD.

  METHOD zvzif_airplaneconnid~set_conn_id.
    zvzif_airplaneconnid~gv_conn_id = iv_conn_id.
  ENDMETHOD.

ENDCLASS.