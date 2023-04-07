REPORT convert_to_substring.

DATA(lv_sysid) = sy-sysid.

DATA(lv_substring) = CONV string( lv_sysid+0(1) ).

WRITE: / lv_sysid, lv_substring.

IF ' ' = ` `.
  "Vergleich eines Charakters mit einem String ist nie wahr.
ENDIF.

IF ' ' = CONV char1( ` ` ).
  "Vergleich zweier char1-Werte ist wahr.
ENDIF.