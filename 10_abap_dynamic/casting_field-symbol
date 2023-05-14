REPORT z00. "Gibt die aktuelle Uhrzeit aus

TYPES: BEGIN OF ls_uhrzeit,
         stunde(2)  TYPE n,
         minute(2)  TYPE n,
         sekunde(2) TYPE n,
       END OF ls_uhrzeit.

FIELD-SYMBOLS: <feldsymbol>  TYPE ls_uhrzeit,
               <feldsymbol2> TYPE any, "Generisches Feldsymbol
               <wert>        TYPE n.

ASSIGN sy-uzeit TO <feldsymbol> CASTING.
ASSIGN sy-uzeit TO <feldsymbol2> CASTING TYPE ls_uhrzeit. "Generisches Feldsymbol -> Typangabe nötig

WRITE: <feldsymbol>-stunde, <feldsymbol>-minute, <feldsymbol>-sekunde.

DO. "Generisches Feldsymbol -> Strukturelemente sind erst zur Laufzeit bekannt
  ASSIGN COMPONENT sy-index OF STRUCTURE <feldsymbol2> TO <wert>.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  WRITE: / <wert>.
ENDDO.