FUNCTION z_bapi_ob_airline_006
  IMPORTING
    VALUE(id) TYPE zbapi_ob_airline_006-carrid
  EXPORTING
    VALUE(return) TYPE bapiret2
  TABLES
    itemtab LIKE zbapi_ob_airline_006.



  SELECT carrid,
         carrname,
         currcode,
         url FROM scarr INTO TABLE @itemtab WHERE carrid = @id.



ENDFUNCTION.