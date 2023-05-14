REPORT z00. "Inhalt einer beliebigen Tabelle auslesen

PARAMETERS: pa_table TYPE char30. "Der Tabellenname als Parameter

DATA: lt_table TYPE REF TO data, "Ein Zeiger auf einen beliebigen Datentyp
      lv_zahl  TYPE i VALUE 10. "Testvariable zur Zuweisungsdemonstration
****************************************************************
* GET REFERENCE OF <Speicheradresse> INTO <Referenzvariable>.
****************************************************************
GET REFERENCE OF lv_zahl INTO lt_table. "Zuweisungsdemonstration

FIELD-SYMBOLS: <table> TYPE ANY TABLE. "Ein Feldsymbol auf eine beliebige Tabelle

****************************************************************
* CREATE DATA <Referenzvariable> (TYPE <Typname> (falls generische Referenz))
* Erzeugt ein Datenobjekt zur Laufzeit
****************************************************************
"CREATE DATA initialisiert die Referenzvariable lt_table mit einer internen Instanz der Tabelle pa_table
CREATE DATA lt_table TYPE STANDARD TABLE OF (pa_table).

"Generische Referenzvariablen müssen vor der Weiterverarbeitung Feldsymbolen zugewiesen werden
ASSIGN lt_table->* TO <table>.

SELECT * FROM (pa_table) INTO TABLE <table>. "Daten werden in interne Tabelle eingelesen

*cl_demo_output=>write_data( <table> ).
*
*DATA(lv_html) = cl_demo_output=>get(  ).
*
*cl_abap_browser=>show_html( EXPORTING
*                              title = 'Tabelle'
*                              html_string = lv_html
*                              container = cl_gui_container=>default_screen ).
*
*WRITE: / space.