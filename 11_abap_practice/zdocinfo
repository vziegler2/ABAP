****************************************************************
*
*   Ausstehend:
*
* - Excel-Liste hochladen und auslesen
* - Programm zum Statuswechsel
* - Tabelleninhalte studieren
* - Spaltenbreite in SELECT integrieren
* - Abnahme (Abnahmeformular, Erweiterte Programmprüfung, Programmierrichtlinien)
*
****************************************************************
REPORT zcvvz_docinfo.
****************************************************************
* Tabellen und Typen
****************************************************************
TABLES: draw, drat, cabnt, ausp.

TYPES: BEGIN OF gs_ausgabe,
         dokar    TYPE draw-dokar,
         doknr    TYPE draw-doknr,
         dokvr    TYPE draw-dokvr,
         doktl    TYPE draw-doktl,
         dwnam    TYPE draw-dwnam,
         adatum   TYPE draw-adatum,
         dokst    TYPE draw-dokst,
         doknr_vl TYPE draw-doknr_vl,
         dktxt    TYPE drat-dktxt,
         atbez    TYPE cabnt-atbez,
         atfor    TYPE cabn-atfor,
         atwrt    TYPE ausp-atwrt,
         number   TYPE ausp-dec_value_from,
         curr     TYPE ausp-curr_value_from,
         date     TYPE ausp-date_from,
         time     TYPE ausp-time_from,
         value    TYPE string,
       END OF gs_ausgabe,
       gty_ausgabe TYPE STANDARD TABLE OF gs_ausgabe WITH DEFAULT KEY,
       BEGIN OF ty_params,
         mwrt TYPE RANGE OF ausp-atwrt,
         date TYPE RANGE OF ausp-date_from,
         nbr  TYPE RANGE OF ausp-dec_value_from,
         curr TYPE RANGE OF ausp-curr_value_from,
         time TYPE RANGE OF ausp-time_from,
       END OF ty_params.
****************************************************************
* Selektionsblöcke
****************************************************************
SELECTION-SCREEN BEGIN OF BLOCK bl0 WITH FRAME TITLE TEXT-000.
  SELECT-OPTIONS: so_dokar FOR draw-dokar NO INTERVALS OBLIGATORY,
                  so_doknr FOR draw-doknr,
                  so_dokvr FOR draw-dokvr,
                  so_doktl FOR draw-doktl,
                  so_dokst FOR draw-dokst,
                  so_bsbg FOR drat-dktxt NO INTERVALS MATCHCODE OBJECT zvz_sh_dktxt,
                  so_mmal FOR cabnt-atbez NO INTERVALS MATCHCODE OBJECT zvz_sh_mname.
SELECTION-SCREEN END OF BLOCK bl0.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-016.
  SELECT-OPTIONS: so_mwrt FOR ausp-atwrt NO INTERVALS,
                  so_date FOR ausp-date_from NO INTERVALS NO-EXTENSION,
                  so_nbr FOR ausp-dec_value_from NO INTERVALS NO-EXTENSION,
                  so_curr FOR ausp-curr_value_from NO INTERVALS NO-EXTENSION,
                  so_time FOR ausp-time_from NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK bl1.
****************************************************************
* Initialisierung
****************************************************************
DATA: it_tab          TYPE gty_ausgabe,
      it_tab2         TYPE STANDARD TABLE OF drad,
      it_column_names TYPE zvz_salv_set_column_names,
      ls_params       TYPE ty_params.

ls_params-mwrt[] = so_mwrt[].
ls_params-date[] = so_date[].
ls_params-nbr[]  = so_nbr[].
ls_params-curr[] = so_curr[].
ls_params-time[] = so_time[].

DATA(lt_ranges) = zcl_cvvz_parameters=>return_filled_selopts( REF #( ls_params ) ).
****************************************************************
* Füllt itab
****************************************************************
SELECT DISTINCT a~dokar,
                a~doknr,
                a~dokvr,
                a~doktl,
                a~dwnam,
                a~adatum,
                a~dokst,
                a~doknr_vl,
                b~dktxt,
                e~atbez,
                f~atfor,
                d~atwrt,
                d~dec_value_from,
                d~curr_value_from,
                d~date_from,
                d~time_from
FROM draw AS a
LEFT OUTER JOIN drat AS b ON a~dokar = b~dokar AND a~doknr = b~doknr AND a~dokvr = b~dokvr AND a~doktl = b~doktl
LEFT OUTER JOIN ausp AS d ON d~objek = a~document_info_record_key
LEFT OUTER JOIN cabnt AS e ON d~atinn = e~atinn
LEFT OUTER JOIN cabn AS f ON f~atinn = e~atinn
WHERE a~dokar IN @so_dokar AND a~doknr IN @so_doknr AND a~dokvr IN @so_dokvr AND
      a~doktl IN @so_doktl AND a~dokst IN @so_dokst AND b~dktxt IN @so_bsbg AND
      e~atbez IN @so_mmal
INTO TABLE @it_tab.
****************************************************************
* Füllt itab2
****************************************************************
SELECT *
FROM drad
WHERE dokar IN @so_dokar AND doknr IN @so_doknr AND dokvr IN @so_dokvr AND doktl IN @so_doktl
INTO TABLE @it_tab2.
****************************************************************
* Nach Merkmalwerten filtern
****************************************************************
*Der Nutzer hat mindestens einen Merkmalswert angegeben -> Tabellenzeilen werden gemäß Angabe gefiltert
IF lines( lt_ranges ) GT 0.
  LOOP AT it_tab ASSIGNING FIELD-SYMBOL(<gs_f>) WHERE atfor = 'CHAR' OR atfor = 'DATE' OR atfor = 'NUM' OR atfor = 'TIME' OR atfor = 'CURR'.
    IF <gs_f>-atfor = 'CHAR' AND NOT ( ( so_mwrt IS INITIAL OR <gs_f>-atwrt NOT IN so_mwrt ) ).
      <gs_f>-value = <gs_f>-atwrt.
    ENDIF.
    IF <gs_f>-atfor = 'DATE' AND NOT ( ( so_date IS INITIAL OR <gs_f>-date NOT IN so_date ) ).
      <gs_f>-value = | { <gs_f>-date+6(2) }.{ <gs_f>-date+4(2) }.{ <gs_f>-date+0(4) } |.
    ENDIF.
    IF <gs_f>-atfor = 'NUM' AND NOT ( ( so_nbr IS INITIAL OR <gs_f>-number NOT IN so_nbr ) ).
      <gs_f>-value = <gs_f>-number.
    ENDIF.
    IF <gs_f>-atfor = 'TIME' AND NOT ( ( so_time IS INITIAL OR <gs_f>-time NOT IN so_time ) ).
      <gs_f>-value = | { <gs_f>-time+0(2) }:{ <gs_f>-time+2(2) }:{ <gs_f>-time+4(2) } |.
    ENDIF.
    IF <gs_f>-atfor = 'CURR' AND NOT ( so_curr IS INITIAL OR <gs_f>-curr NOT IN so_curr ).
      <gs_f>-value = <gs_f>-curr.
    ENDIF.
  ENDLOOP.
  LOOP AT it_tab ASSIGNING <gs_f>.
    DELETE it_tab WHERE value IS INITIAL.
  ENDLOOP.
ELSE. "Der Nutzer hat keine Merkmalswerte angegeben -> Keine Filterung der Tabellenzeilen
  LOOP AT it_tab ASSIGNING <gs_f> WHERE atfor = 'CHAR' OR atfor = 'DATE' OR atfor = 'NUM' OR atfor = 'TIME' OR atfor = 'CURR'.
    CASE <gs_f>-atfor.
      WHEN 'CHAR'.
        <gs_f>-value = <gs_f>-atwrt.
      WHEN 'DATE'.
        <gs_f>-value = | { <gs_f>-date+6(2) }.{ <gs_f>-date+4(2) }.{ <gs_f>-date+0(4) } |.
      WHEN 'NUM'.
        <gs_f>-value = <gs_f>-number.
      WHEN 'TIME'.
        <gs_f>-value = | { <gs_f>-time+0(2) }:{ <gs_f>-time+2(2) }:{ <gs_f>-time+4(2) } |.
      WHEN 'CURR'.
        <gs_f>-value = <gs_f>-curr.
    ENDCASE.
  ENDLOOP.
ENDIF.
****************************************************************
* Event-Klasse
****************************************************************
CLASS lcl_events DEFINITION FINAL.

  PUBLIC SECTION.
    CLASS-METHODS: on_double_click
      FOR EVENT if_salv_events_actions_table~double_click
      OF cl_salv_events_table
      IMPORTING row,
      on_link_click
        FOR EVENT if_salv_events_actions_table~link_click
        OF cl_salv_events_table.

ENDCLASS.

CLASS lcl_events IMPLEMENTATION.
  METHOD on_double_click.
    DATA: ls_draw TYPE gs_ausgabe.
    READ TABLE it_tab INTO ls_draw INDEX row. "Speichert die angeklickte Zeile in der Struktur
    SET PARAMETER ID 'CV1' FIELD ls_draw-doknr.
    SET PARAMETER ID 'CV2' FIELD ls_draw-dokar.
    SET PARAMETER ID 'CV3' FIELD ls_draw-dokvr.
    SET PARAMETER ID 'CV4' FIELD ls_draw-doktl.
    CALL TRANSACTION 'CV03N' WITHOUT AUTHORITY-CHECK AND SKIP FIRST SCREEN.
  ENDMETHOD.

  METHOD on_link_click.
    TRY.
        DATA: o_salv TYPE REF TO cl_salv_table.
        CALL METHOD cl_salv_table=>factory(
          IMPORTING
            r_salv_table = o_salv
          CHANGING
            t_table      = it_tab2 ).

        o_salv->get_functions(  )->set_all( abap_true ).
        o_salv->get_display_settings(  )->set_list_header( TEXT-001 ).
        o_salv->get_display_settings(  )->set_striped_pattern( abap_true ).
        o_salv->get_selections(  )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
        o_salv->get_sorts(  )->add_sort( columnname = 'DOKVR' sequence = if_salv_c_sort=>sort_up ).
        o_salv->get_columns(  )->set_optimize( abap_true ).
        zcl_cvvz_salv=>hide_empty_columns( o_salv = o_salv it_tab = it_tab2 ).
        LOOP AT o_salv->get_columns(  )->get(  ) ASSIGNING FIELD-SYMBOL(<c>).
          DATA(o_col2) = <c>-r_column.
          o_col2->set_alignment( if_salv_c_alignment=>centered ).
        ENDLOOP.
        o_salv->display(  ).
      CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found INTO DATA(e_txt).
        MESSAGE e_txt TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
****************************************************************
* Füllt itab2
****************************************************************
  SELECT *
  FROM drad
  WHERE dokar IN @so_dokar AND doknr IN @so_doknr AND dokvr IN @so_dokvr AND doktl IN @so_doktl
  INTO TABLE @it_tab2.
****************************************************************
* ALV
****************************************************************
  TRY.
      DATA: o_salv   TYPE REF TO cl_salv_table,
            o_events TYPE REF TO cl_salv_events_table.
      CALL METHOD cl_salv_table=>factory(
        IMPORTING
          r_salv_table = o_salv
        CHANGING
          t_table      = it_tab ).
****************************************************************
* ALV-Spalten ausblenden
****************************************************************
      zcl_cvvz_salv=>hide_column( o_salv = o_salv lv_colnam = 'ATFOR' ).
      zcl_cvvz_salv=>hide_column( o_salv = o_salv lv_colnam = 'ATWRT' ).
      zcl_cvvz_salv=>hide_column( o_salv = o_salv lv_colnam = 'DATE' ).
      zcl_cvvz_salv=>hide_column( o_salv = o_salv lv_colnam = 'CURR' ).
      zcl_cvvz_salv=>hide_column( o_salv = o_salv lv_colnam = 'NUMBER' ).
      zcl_cvvz_salv=>hide_column( o_salv = o_salv lv_colnam = 'TIME' ).
      zcl_cvvz_salv=>hide_empty_columns( o_salv = o_salv it_tab = it_tab ).
****************************************************************
* ALV-Spaltennamen ändern
****************************************************************
      it_column_names = VALUE #( ( spalte = 'DOKAR' name = TEXT-003 ) ( spalte = 'DOKNR' name = TEXT-004 )
                                   ( spalte = 'DOKVR' name = TEXT-005 ) ( spalte = 'DOKTL' name = TEXT-006 )
                                   ( spalte = 'DOKST' name = TEXT-007 ) ( spalte = 'ADATUM' name = TEXT-008 )
                                   ( spalte = 'DOKNR_VL' name = TEXT-009 ) ( spalte = 'DKTXT' name = TEXT-010 )
                                   ( spalte = 'ATBEZ' name = TEXT-011 ) ( spalte = 'VALUE' name = TEXT-012 ) ).
      zcl_cvvz_salv=>set_column_names( o_salv = o_salv column_names_itab = it_column_names ).
****************************************************************
* ALV-Header
****************************************************************
      DATA(o_grid_header) = NEW cl_salv_form_layout_grid(  ).
      o_grid_header->create_flow( row = 5 column = 1 )->create_text( text = '' ).
      o_grid_header->create_flow( row = 6 column = 1 )->create_text( text = TEXT-013 ).
      o_grid_header->create_flow( row = 6 column = 2 )->create_text( text = TEXT-014 ).
      o_grid_header->create_flow( row = 7 column = 2 )->create_text( text = TEXT-015 ).
      o_salv->set_top_of_list( o_grid_header ).
****************************************************************
* ALV-Events
****************************************************************
      o_events = o_salv->get_event(  ).
      SET HANDLER lcl_events=>on_double_click FOR o_events.
      SET HANDLER lcl_events=>on_link_click FOR o_events.
      DATA(o_col) = CAST cl_salv_column_table( o_salv->get_columns(  )->get_column( 'DOKAR' ) ).
      o_col->set_cell_type( if_salv_c_cell_type=>hotspot ).
****************************************************************
* ALV-Ausgabe
****************************************************************
      o_salv->get_functions(  )->set_all( abap_true ).
      o_salv->get_display_settings(  )->set_list_header( TEXT-002 ).
      o_salv->get_display_settings(  )->set_striped_pattern( abap_true ).
      o_salv->get_selections(  )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
      o_salv->get_sorts(  )->add_sort( columnname = 'DOKNR' sequence = if_salv_c_sort=>sort_up ).
*      o_salv->get_columns(  )->set_optimize( abap_true ).
      LOOP AT o_salv->get_columns(  )->get(  ) ASSIGNING FIELD-SYMBOL(<c>).
        DATA(o_col2) = <c>-r_column.
        o_col2->set_alignment( if_salv_c_alignment=>centered ).
      ENDLOOP.
      o_salv->display(  ).
    CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found INTO DATA(e_txt).
      WRITE: / e_txt->get_text(  ).
  ENDTRY.