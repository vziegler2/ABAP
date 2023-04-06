FUNCTION z_delete_airline_006
  IMPORTING
    VALUE(carrid) TYPE s_carr_id.



  DELETE FROM scarr WHERE carrid = carrid.

ENDFUNCTION.