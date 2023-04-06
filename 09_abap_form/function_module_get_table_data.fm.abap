FUNCTION z_get_airline_ids_006
  TABLES
    carrids LIKE zob_st_006.



  " You can use the template 'functionModuleParameter' to add here the signature!

  SELECT carrid FROM scarr INTO TABLE carrids.

  cl_demo_output=>display( carrids ).

ENDFUNCTION.