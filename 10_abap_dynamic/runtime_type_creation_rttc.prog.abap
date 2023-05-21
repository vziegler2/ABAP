REPORT z00. "Erzeugt eine Tabelle einer Struktur zur Laufzeit (RTTC)

TYPES: BEGIN OF ls_person,
         name  TYPE string,
         alter TYPE i,
       END OF ls_person.

DATA: lo_struktur TYPE REF TO cl_abap_structdescr,
      lo_tabelle  TYPE REF TO cl_abap_tabledescr,
      lr_tabelle  TYPE REF TO data.

FIELD-SYMBOLS: <feldsymbol> TYPE STANDARD TABLE.

"Weist das Beschreibungsobjekt von ls_person dem Datenobjekt lo_struktur zu
lo_struktur ?= cl_abap_typedescr=>describe_by_name( 'LS_PERSON' ).

"Erstellt einen Tabellentypen mit dem Zeilentyp lo_struktur
lo_tabelle = cl_abap_tabledescr=>create( p_line_type = lo_struktur ).

"Erzeugt eine Instanz des neuen Tabellentypen
CREATE DATA lr_tabelle TYPE HANDLE lo_tabelle.
ASSIGN lr_tabelle->* TO <feldsymbol>.