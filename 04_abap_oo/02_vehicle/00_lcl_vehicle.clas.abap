REPORT z00.

CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION.
*    TYPES: BEGIN OF ls_mytyp,
*             feld1 TYPE i,
*             feld2 TYPE string,
*           END OF ls_mytyp,
*           tt_mytyp TYPE STANDARD TABLE OF ls_mytyp WITH DEFAULT KEY.
*
*    CONSTANTS: pi TYPE p DECIMALS 4 LENGTH 3 VALUE '3.1415'.

    DATA: mv_make  TYPE string.
*          mv_model TYPE string.
*          ms_lokal TYPE ls_mytyp.

    METHODS: display_attributes,
      set_model IMPORTING REFERENCE(iv_model) TYPE string OPTIONAL "Importing-Parameter sind standardmäßig ein Call-by-Reference und nicht änderbar
                          VALUE(iv_text)      TYPE string OPTIONAL
                          iv_text2            TYPE string OPTIONAL
                            PREFERRED PARAMETER iv_model, "Kann bei ausschließlich optionalen Parametern verwendet werden, um die automatische Befüllung bei einzelner Parameterangabe festzulegen
      set_model2 IMPORTING iv_model TYPE string,
      get_model EXPORTING REFERENCE(ev_model) TYPE string "Exportparameter sind standardmäßig optional und übernehmen bei Call-by-Reference den Wert der Übergabevariable
                          VALUE(ev_text)      TYPE string,
      change_value "IMPORTING iv_name TYPE string
        "EXPORTING ev_name TYPE string
        CHANGING cv_name   TYPE string OPTIONAL "Pseudoüberladung durch optionale Parameter
                 cv_name_i TYPE i OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_model TYPE string.
    METHODS: hello_world.

ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.

  METHOD hello_world.
    WRITE: / 'Hello World'.
  ENDMETHOD.

  METHOD display_attributes.
    hello_world(  ).
    WRITE: / 'Make : ', mv_make, /, 'Model : ', mv_model.
  ENDMETHOD.

  METHOD set_model.
    mv_model = iv_model.
*    iv_model = 'eins'.
*    iv_text = 'zwei'.
  ENDMETHOD.

  METHOD set_model2.
    mv_model = iv_model.
  ENDMETHOD.

  METHOD get_model.
    ev_model = mv_model.
  ENDMETHOD.

  METHOD change_value.
    IF cv_name IS NOT INITIAL. "Prüfung der optionalen Parameter
      cv_name = cv_name && cv_name.
    ENDIF.
    IF cv_name_i IS NOT INITIAL.
      cv_name_i = 42.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION. "Notwendig, weil sonst das Coding nach der Klasse nicht erreichbar ist (da in keinem Eventblock wie einer Klasse)

  DATA: gr_vehic  TYPE REF TO lcl_vehicle,
*      gr_vehic2 TYPE REF TO lcl_vehicle,
*      gr_vehic3 TYPE REF TO lcl_vehicle,
        gv_model  TYPE string,
        gv_text   TYPE string VALUE 'Text',
        gv_name   TYPE string VALUE 'Hugo',
        grt_vehic TYPE STANDARD TABLE OF REF TO lcl_vehicle. "Tabelle die Referenzvariablen auf Instanzen zusammenfasst (für viele Instanzen)
*      gs_struktur TYPE lcl_vehicle=>ls_mytyp.

*CREATE OBJECT: gr_vehic.
*               gr_vehic2.

*gr_vehic3 = gr_vehic2.
  CREATE OBJECT: gr_vehic.
  gr_vehic->mv_make = 'VW'.
*gr_vehic->mv_model = 'Käfer'.
  APPEND gr_vehic TO grt_vehic.
  CREATE OBJECT: gr_vehic.
  gr_vehic->mv_make = 'Mercedes'.
*gr_vehic->mv_model = '200D'.
  APPEND gr_vehic TO grt_vehic.
  CREATE OBJECT: gr_vehic.
  gr_vehic->mv_make = 'Ford'.
*gr_vehic->mv_model = 'Taunus'.
  APPEND gr_vehic TO grt_vehic.
*gr_vehic2->mv_make = 'Mercedes'.
*gr_vehic2->mv_model = '200D'.
*gr_vehic3->mv_model = '300D'.

*APPEND gr_vehic TO grt_vehic.
*APPEND gr_vehic2 TO grt_vehic.
*APPEND gr_vehic3 TO grt_vehic.

  "table_line ist der Spaltenname, über den auf die einzelnen Attribute zugegriffen werden kann
*READ TABLE grt_vehic INTO gr_vehic WITH KEY table_line->mv_make = 'VW'.
*  LOOP AT grt_vehic INTO gr_vehic.
*    WRITE: / gr_vehic->mv_make.
*  ENDLOOP.

*  gr_vehic->hello_world(  ).
*  gr_vehic->display_attributes(  ).
  gr_vehic->set_model(
    EXPORTING
      iv_model = 'Taunus'
      iv_text  = 'Hello World'
  ).

  gr_vehic->set_model( 'Taunus' ). "Bei mehreren optionalen Parametern wird der preferred parameter automatisch befüllt (bei einer Parameterangabe)
  gr_vehic->set_model2( 'Taunus' ).

  gr_vehic->get_model(
    IMPORTING
      ev_model = gv_model
      ev_text = gv_text
  ).

*  CALL METHOD gr_vehic->get_model
*    IMPORTING
*      ev_model = gv_model.

  WRITE: / gv_model.

  gr_vehic->change_value(
*    EXPORTING
*      iv_name = gv_name
*    IMPORTING
*      ev_name = gv_name
     CHANGING
       cv_name = gv_name "Changing funktioniert wie ein gemeinsames Importing und Exporting
  ).

  WRITE: / gv_name.