REPORT zvzp_airplane.

DATA(lo_airplane) = NEW zvzcl_airplane( iv_windows = 50
                                        iv_seats = 100 ).

IF lo_airplane IS BOUND.
  MESSAGE ID '00' TYPE 'S' NUMBER 001
  WITH 'Objektreferenzvariable ist mit Instanz gefüllt.'.
ENDIF.