REPORT zvzp_exercism.

DATA(lo_ex) = NEW zvzcl_exercism(  ).

DATA(return) = lo_ex->score( 'Hello' ).

WRITE: / return.