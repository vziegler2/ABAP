@AbapCatalog.sqlViewName: 'ZCVVZ_DD_001S'
//@AbapCatalog.compiler.compareFilter: true //Verbesserte Laufzeit im Falle individueller Filterbedingungen:
                                            //Setzt Filterbedingungen in eine einzige JOIN-Bedingung um
//@AbapCatalog.preserveKey: true            //System verwendet eingetragene Schlüssel, sonst automatische Schlüsselvergabe
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '001'
@OData.publish: true //Veröffentlicht den View als OData-Service
                     //Der Service muss dazu in der Transaktion /IWFND/MAINT_SERVICE hinzugefügt werden
                     //Systemalias = "LOCAL"; Technischer Servicename = Externer Servicename = <viewname>_CDS
                     //Ggfs. ICF-Knoten aktivieren
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST] //Es können Felder und Pfadausdrücke erweitert werden (Standard)
                                    //[#GROUP BY] Es können zusätzlich Aggregatsfunktionen erweitert werden
                                    //[#UNION] Es können CDS-Views mit Union-Klauseln erweitert werden
                                    //[#NONE] Keine Erweiterung möglich
@Metadata.allowExtensions: true //Erlaubt Metadatenerweiterungen
define view ZCVVZ_DD_001
  with parameters pa_dokar: dokar,  //Anwendung: SELECT * FROM zcvvz_dd_001( pa_dokar = 'ZRO', ... ) ...
                                    //Anwendung OData: .../<entity>(pa_dokar='ZRO',pa_adatum=datetime'2022-06-01T00:00:00',pa_time=time'PThhHmmMssS')/Set
                                    //Optionale Parameter werden mit der Anweisung "@/@<Environment.systemField:" deklariert
                  pa_adatum: adatum
  as select from draw
  association[0..1] to drat on drat.doknr = $projection.doknr // Statt "$projection" könnte auch draw stehen:
                                                              // "$projection" verweist auf die Feldliste darunter
             /* [0..1] Für einen Eintrag in draw gibt es keinen bis höchstens einen Eintrag in drat
                [0..*] Für einen Eintrag in draw gibt es beliebig viele Einträge in drat
                [1..1] Für einen Eintrag in draw gibt es genau einen Eintrag in drat
                [1..*] Für einen Eintrag in draw gibt es mindestens einen Eintrag in drat */
  // Mehrere Assoziationen mit unterschiedlichen Bedingungen zu einer Tabelle möglich: 
  // Eine Spalte kann zweimal aus unterschiedlichen Zeilen verwendet werden
{
  key dokar,
  key doknr,
  key dokvr,    
  key doktl,
      dokst,
      adatum,
      drat.langu, // Individuelle Filterbedingungen: drat[left outer where dokar = 'ZRO'].langu 
      drat.dktxt
      // sum/max/min/avg/count( <statement> ) as <alias> mit "group by" <Felder> nach der Entitätsdefinition
      // case <variable> when <result> then <option> else <option> end as <alias>
      // cast( <variable> as <type> ) as <alias>
} where dokar = :pa_dokar and adatum > :pa_adatum

/* Numerische Funktionen:
   abs(<variable>)                                                        - Absolutbetrag
   ceil(<variable>)                                                       - Größter ganzzahliger Wert <= <variable>
   floor(<variable>)                                                      - Kleinster ganzzahliger Wert >= <variable>
   div(<variable>, <variable>)                                            - Ganzzahliger Anteil der Division
   division(<variable>, <variable>, <decimals>)                           - Division gerundet auf <decimals> Nachkommastellen
   round(<variable>, <decimals>)                                          - Rundung auf <decimals> Nachkommastellen
   mod(<variable>, <variable>)                                            - Ganzzahliger Rest einer Division
   
   Zeichenkettenfunktionen:
   concat(<variable>, <variable>)                                         - Zeichenketten ohne Leerzeichen zusammenfügen
   concat_with_space(<variable>, <variable>, <spaces>)                    - Zeichenkette getrennt durch <spaces> Leerzeichen zusammenfügen
   instr(<variable>, <character>)                                         - Position erstes Vorkommen von <character>
   left(<variable>, <number>)                                             - Die ersten <number> Zeichen der Variable speichern
   right(<variable>, <number>)                                            - Die letzten <number> Zeichen der Variable speichern
   length(<variable>)                                                     - Die Länge der Variable
   lower(<variable>)                                                      - Umwandlung in Kleinbuchstaben
   upper(<variable>)                                                      - Umwandlung in Großbuchstaben
   lpad(<variable>, <number>, <character>)                                - Variable links mit <number> <character>-Zeichen auffüllen
   rpad(<variable>, <number>, <character>)                                - Variable rechts mit <number> <character>-Zeichen auffüllen
   ltrim(<variable>, <character>)                                         - Variable links um <character>-Zeichen kürzen
   rtrim(<variable>, <character>)                                         - Variable rechts um <character>-Zeichen kürzen
   replace(<variable>, <string>, <string2>)                               - Ersetzt <string> durch <string2>
   substring(<variable>, <start>, <length>)                               - Teilzeichenkette ab Position <start> mit <length> Zeichen
   
   Datums- und Uhrzeitfunktionen:
   dats_is_valid(<date>)                                                  - Datum ist gültig
   tims_is_valid(<time>)                                                  - Uhrzeit ist gültig
   tstmp_is_valid(<tstmp>)                                                - Zeitstempel ist gültig
   dats_days_between(<date>, <date>)                                      - Berechnet die Anzahl der Tage zwischen den beiden Daten
   dats_add_days(<date>, <days>, <on_error>)                              - Addiert <days> Tage zum Datum, <on_error> regelt das Verhalten bei ungültigen Daten:
                                                                            [FAIL]->Ausnahme, [NULL]->SQL-NULL-Wert-Rückgabe, [INITIAL]->00.00.0000-Rückgabe, [UNCHANGED]-><date>-Rückgabe
   dats_add_months(<date>, <months>, <on_error>)                          - Addiert <months> Monate zum Datum, <on_error> siehe oben
   tstmp_current_utctimestamp()                                           - Uhrzeit des Datenbankservers im UTC-Format ohne Millisekunden
   tstmp_seconds_between(<tstmp>, <tstmp>, <on_error>)                    - Berechnet die Sekunden zwischen den Zeitstempeln, <on_error> siehe oben
   tstmp_add_seconds(<tstmp>, <seconds>, <on_error>)                      - Addiert <seconds> Sekunden zum Zeitstempel, <on_error> siehe dats_add_days
   tstmp_to_dats(<tstmp>, <timezone>, <client>, <on_error>)               - Gibt das Datum im Zeitstempel <tstmp> zurück, <on_error> siehe oben
                                                                            Den Mandant erhält man aus der Sitzungsvariablen $SESSION.CLIENT
                                                                            Der Zeitstempel ist ein ganzzahliger Wert mit 15 Stellen (abap.dec(15, 0))
   tstmp_to_tims(<tstmp>, <timezone>, <client>, <on_error>)               - Gibt die Uhrzeit im Zeitstempel <tstmp> zurück, Rest siehe oben
   tstmp_to_dst(<tstmp>, <timezone>, <client>, <on_error>)                - Gibt 'X' zurück, wenn im Zeitpunkt <tstmp> in der Zeitzone <timezone> Sommerzeit herrschte
   dats_tims_to_tstmp(<date>, <time>, <timezone>, <client>, <on_error>)   - Berechnet aus Datum, Uhrzeit, Zeitzone und Mandant den Zeitstempel
   
   Währungs- und Mengenumrechnung:
   currency_conversion(<amount>, <src_cuky>, <dst_cuky>, <exc_rate_date>) - Optionale Parameter: exchange_rate_type, client, decimal_shift, decimal_shift_back, error_handling
                                                                            Formal- und Aktualparameter werden mit "=>" verbunden: client => $SESSION.CLIENT
   unit_conversion(<quan>, <src_unit>, <dst_unit>, <client>, <error>)     - 
*/