*&---------------------------------------------------------------------*
*& Wieviele Zeilen eines Spaltenwertes sind vorhanden?
*& Was ist die Summe bestimmter Zeilen einer Spalte?
*& Was sind die MIN- und MAX-Werte einer Spalte?
*&---------------------------------------------------------------------*
REPORT zvzp_reduce.

SELECT * FROM spfli INTO TABLE @DATA(it_spfli).
LOOP AT it_spfli ASSIGNING FIELD-SYMBOL(<f>).
  WRITE: / <f>-carrid, <f>-connid, <f>-distance.
ENDLOOP.
*Wieviele Zeilen eines Spaltenwertes sind vorhanden?
DATA(lv_count) = REDUCE i( INIT x = 0
                           FOR <l> IN it_spfli WHERE ( carrid = 'LH' )
                           NEXT x += 1 ).
WRITE: / 'Result:', lv_count.
*Was ist die Summe bestimmter Zeilen einer Spalte?
DATA(lv_distance_sum) = REDUCE spfli-distance( INIT t = 0
                                               FOR <l> IN it_spfli WHERE ( carrid = 'LH' )
                                               NEXT t += <l>-distance ).
WRITE: / 'Result: ', lv_distance_sum.
*Was sind die MIN- und MAX-Werte einer Spalte?
DATA(lv_min) = REDUCE spfli-distance( INIT m = 100000
                                      FOR <l> IN it_spfli
                                      NEXT m = COND #( WHEN <l>-distance < m THEN <l>-distance ELSE m ) ).
WRITE: / 'Min: ', lv_min.
DATA(lv_max) = REDUCE spfli-distance( INIT m = 0
                                      FOR <l> IN it_spfli
                                      NEXT m = COND #( WHEN <l>-distance > m THEN <l>-distance ELSE m ) ).
WRITE: / 'Max: ', lv_max.