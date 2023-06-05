FUNCTION z_mkrtest_appl01_scr_0001
  IMPORTING
    io_view TYPE REF TO zcl_mkrtest_appl01.




  go_view = io_view.
  zdp_mx_s_2 = go_view->gs_current_data2.

  CALL SCREEN '0001' STARTING AT 10 10
                     ENDING AT   100 40.



ENDFUNCTION.