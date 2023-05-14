REPORT z00. "Liest die Komponenten einer Struktur zur Laufzeit aus (RTTI)

TYPES: BEGIN OF ls_person,
         name  TYPE string,
         alter TYPE i,
       END OF ls_person.

DATA: lo_struktur   TYPE REF TO cl_abap_structdescr,
      ls_components TYPE abap_compdescr.

"Weist das Beschreibungsobjekt von ls_person dem Datenobjekt lo_struktur zu
lo_struktur ?= cl_abap_typedescr=>describe_by_name( 'LS_PERSON' ).

"Die Klasse cl_abap_structdescr enthält als Attribut u.a. die Tabelle components vom Typ abap_compdescr
LOOP AT lo_struktur->components INTO ls_components.
  WRITE: / ls_components-name.
ENDLOOP.