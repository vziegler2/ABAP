****************************************************************
* ALV-Spaltenfarbe
****************************************************************
      TRY.
          DATA(lv_color) = VALUE lvc_s_colo( col = col_positive
                                             int = 0
                                             inv = 0 ).

          DATA(o_col3) = CAST cl_salv_column_table( o_salv->get_columns( )->get_column( 'DOKST' ) ).
          o_col3->set_color( lv_color ).

        CATCH cx_salv_not_found.
      ENDTRY.