REPORT zvzp_itab_aggregation.

TYPES group TYPE c LENGTH 1.
TYPES: BEGIN OF initial_numbers_type,
         group  TYPE group,
         number TYPE i,
       END OF initial_numbers_type,
       tt_initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.

DATA(initial_numbers) = VALUE tt_initial_numbers( ( group = 'a' number = 10 )
                                                  ( group = 'b' number = 5 )
                                                  ( group = 'a' number = 6 )
                                                  ( group = 'c' number = 22 )
                                                  ( group = 'a' number = 13 )
                                                  ( group = 'c' number = 500 ) ).
DATA(lo_ex) = NEW zcl_itab_aggregation(  ).

DATA(return) = lo_ex->perform_aggregation( initial_numbers ).

LOOP AT return INTO DATA(ls_return).
  WRITE: / ls_return-group,
         ls_return-count,
         ls_return-min,
         ls_return-max,
         ls_return-sum,
         ls_return-average.
ENDLOOP.