****************************************************************
*
*   Ausstehend:
*
* - Popup für Dynpro 200 einstellen
*
****************************************************************
REPORT zcvvz_material.
****************************************************************
* Daten
****************************************************************
TABLES: mara, marc, mard.

DATA: c_custom_container   TYPE REF TO cl_gui_custom_container,
      c_custom_container2  TYPE REF TO cl_gui_custom_container,
      o_splitter_container TYPE REF TO cl_gui_splitter_container,
      alv_grid             TYPE REF TO cl_gui_alv_grid,
      alv_grid2            TYPE REF TO cl_gui_alv_grid,
      alv_grid3            TYPE REF TO cl_gui_alv_grid,
      lt_fieldcat          TYPE lvc_t_fcat,
      ls_fieldcat          TYPE lvc_s_fcat,
      lt_fieldcat2         TYPE lvc_t_fcat,
      ls_fieldcat2         TYPE lvc_s_fcat,
      tab_display          TYPE TABLE OF zcvvz_st_00,
      tab_display2         TYPE TABLE OF zcvvz_st_01,
      tab_display3         TYPE TABLE OF zcvvz_st_02,
      ok_code              LIKE sy-ucomm,
      lv_werks             TYPE marc-werks,
      lv_lgort             TYPE mard-lgort.

SELECTION-SCREEN BEGIN OF BLOCK bl0 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: so_matnr FOR mara-matnr DEFAULT '201058610:K0654',
                  so_werks FOR marc-werks.
  PARAMETERS: pa_mtart TYPE mara-mtart.
SELECTION-SCREEN END OF BLOCK bl0.
****************************************************************
* Event-Handler-Klasse
****************************************************************
CLASS lcl_event_handle DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS: handle_double_click FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row
                                                                                           e_column,
      handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_row_id
                                                                                e_column_id.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_event_handle IMPLEMENTATION.

  METHOD handle_double_click.
    DATA: ls_draw TYPE zcvvz_st_00.
    READ TABLE tab_display INTO ls_draw INDEX e_row.
    lv_werks = ls_draw-werks.

    SELECT b~matnr,
           a~lgort,
           a~labst,
           a~speme,
           b~meins
    FROM mard AS a
    JOIN marc AS c ON a~matnr = c~matnr AND a~werks = c~werks
    JOIN mara AS b ON a~matnr = b~matnr
    WHERE a~matnr = @ls_draw-matnr
    INTO TABLE @tab_display2.

    IF ls_draw-xchpf = 'X'.
      LOOP AT tab_display2 ASSIGNING FIELD-SYMBOL(<f>).
        <f>-status = icon_information.
      ENDLOOP.
    ENDIF.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZCVVZ_ST_01'
      CHANGING
        ct_fieldcat      = lt_fieldcat2.

    READ TABLE lt_fieldcat2 WITH KEY fieldname = 'MATNR' INTO ls_fieldcat2.
    IF sy-subrc = 0.
      ls_fieldcat2-no_out = 'X'.
      MODIFY lt_fieldcat2 FROM ls_fieldcat2 INDEX sy-tabix.
    ENDIF.

    READ TABLE lt_fieldcat2 WITH KEY fieldname = 'STATUS' INTO ls_fieldcat2.
    IF sy-subrc = 0.
      ls_fieldcat2-hotspot = 'X'.
      MODIFY lt_fieldcat2 FROM ls_fieldcat2 INDEX sy-tabix.
    ENDIF.

    alv_grid2->set_table_for_first_display( EXPORTING i_structure_name = 'ZCVVZ_ST_01'
                                            CHANGING it_outtab = tab_display2
                                                     it_fieldcatalog = lt_fieldcat2 ).

    SET HANDLER lcl_event_handle=>handle_hotspot_click FOR alv_grid2.
  ENDMETHOD.

  METHOD handle_hotspot_click.
    DATA: ls_draw TYPE zcvvz_st_01.
    READ TABLE tab_display2 INTO ls_draw INDEX e_row_id.
    lv_lgort = ls_draw-lgort.

    IF c_custom_container2 IS INITIAL.
      c_custom_container2 = NEW #( container_name = 'CCONTROL2' ).

      alv_grid3 = NEW #( i_parent = c_custom_container2 ).

      SELECT b~matnr,
         a~charg,
         a~laeda,
         a~clabs,
         a~cspem,
         b~meins
        FROM mchb AS a
        JOIN mard AS c ON a~matnr = c~matnr AND a~werks = c~werks AND a~lgort = c~lgort
        JOIN mara AS b ON a~matnr = b~matnr
        WHERE b~matnr = @ls_draw-matnr
        INTO TABLE @tab_display3.

      alv_grid3->set_table_for_first_display( EXPORTING i_structure_name = 'ZCVVZ_ST_02'
                                              CHANGING it_outtab = tab_display3 ).

    ENDIF.

    CALL SCREEN 200.
  ENDMETHOD.

ENDCLASS.
****************************************************************
* Screen und Imports
****************************************************************
START-OF-SELECTION.

  CALL SCREEN 100.

  INCLUDE z00_status_0100o01.

  INCLUDE z00_user_command_0100i01.

  INCLUDE z00_user_command_0200i01.

  INCLUDE z00_status_0200o01.