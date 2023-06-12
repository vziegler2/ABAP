* vorher sortieren und subtotal setzen
o_alv->get_sorts( )->add_sort( columnname = 'CARRID' sequence = if_salv_c_sort=>sort_up subtotal = abap_true ).
 
* Aggregation
o_alv->get_aggregations( )->add_aggregation( columnname  = 'PAYMENTSUM'                    " für Spalte 'PAYMENTSUM'
                                             aggregation = if_salv_c_aggregation=>total ). " Summe bilden

*    go_agg->set_aggregation_before_items( ).