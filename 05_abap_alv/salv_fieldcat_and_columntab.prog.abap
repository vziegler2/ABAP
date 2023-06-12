DATA: go_salv  TYPE REF TO cl_salv_table,
go_fcat  TYPE REF TO data,
lvc_fcat TYPE lvc_t_fcat.

cl_salv_table=>factory( " EXPORTING r_container  = cl_gui_container=>default_screen
                  IMPORTING r_salv_table = go_salv
                  CHANGING  t_table      = gt_outtab ).

CREATE DATA go_fcat LIKE gt_outtab.
*    ASSIGN go_fcat->* TO FIELD-SYMBOL(<gs_fcat>).
*    lvc_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns      = go_salv->get_columns( )
*                                                                  r_aggregations = go_salv->get_aggregations( ) ).

DATA(go_column) = NEW cl_salv_column_table( columnname        = 'DOKAR'
                                      r_columns         = go_salv->get_columns( )
                                      r_table_structure = go_fcat ).