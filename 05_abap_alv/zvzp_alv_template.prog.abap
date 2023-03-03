*&---------------------------------------------------------------------*
*& Report zvzp_alv_template
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvzp_alv_template.
*cl_gui_alv_grid -> Erstellung Grid
*cl_alv_table_create -> Erstellung Tabelle
*if_salv_* -> Anpassung Grid
*SALV_TABLE-Objekt -> Beliebtestes vordefiniertes ALV-Grid
*SALV_HIERSEQ_TABLE-Objekt -> Vordefiniertes ALV-Grid für komplexere Datenstrukturen
DATA: ls_spfli TYPE spfli,
      it_spflicp TYPE TABLE OF spfli,
      it_changes TYPE TABLE OF spfli,
      ls_fieldcat TYPE slis_fieldcat_alv,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      ls_layout TYPE slis_layout_alv.
SELECT * FROM spfli INTO TABLE @DATA(it_spfli).
*@ vor dem Parameter Data gibt an, dass it_spfli eine strukturierte Variable wird.
*Daten aus einer Datenbanktabelle werden in einer internen Tabelle gespeichert.
TRY.
DATA(o_alv) = NEW cl_gui_alv_grid( i_parent = cl_gui_container=>default_screen
                                   i_appl_events = abap_true ).
*i_parent gibt an, wo das ALV-Grid angezeigt wird.
*i_appl_events gibt an, ob Benutzeraktionen Applikationsereignisse auslösen.
DATA: o_salv TYPE REF TO cl_salv_table.
cl_salv_table=>factory( IMPORTING r_salv_table = o_salv
                        CHANGING t_table = it_spfli ).
*Generiert eine ALV-Tabelle und speichert sie in r_salv_table.
*Übergibt die itab an t_table zur Darstellung.
DATA(it_fcat) = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = o_salv->get_columns(  )
                                                                   r_aggregations = o_salv->get_aggregations(  ) ).
*Erstellt einen Feldkatalog, über den die Tabelle konfiguriert werden kann.
*r_columns enthält die Spalteninformationen der Tabelle.
*r_aggregations enthält die Aggregationsinformationen der Tabelle.
DATA(lv_layout) = VALUE lvc_s_layo( zebra = abap_true
                                    grid_title = 'Flightconnections' ).
*Erstellt ein Layout-Objekt für die ALV-Tabelle.
*zebra speichert eine alternative Hintergrundfarbe.
*grid_title speichert den Titel der Tabelle.
o_alv->set_table_for_first_display( EXPORTING is_layout = lv_layout
                                    CHANGING it_fieldcatalog = it_fcat
                                             it_outtab = it_spfli ).
*Zeigt die ALV-Tabelle auf Basis der zuvor erstellten Objekte an.
cl_abap_list_layout=>suppress_toolbar(  ).
*Lässt die Leerzeile am oberen Bildschirmrand in älteren SAP-Anzeigeversionen verschwinden.
WRITE: space.
*Wird benötigt, damit das ALV-Grid angezeigt werden kann.
CATCH cx_salv_msg.
ENDTRY.