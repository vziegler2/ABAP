REPORT zcvvz_001.

CLASS lcl_report DEFINITION.
*
  PUBLIC SECTION.
*
*   Final output table
    TYPES: BEGIN OF ty_vbak,
           vbeln TYPE vbak-vbeln,
           erdat TYPE erdat,
           auart TYPE auart,
           kunnr TYPE kunnr,
           i_celltype TYPE salv_t_int4_column,
           END   OF ty_vbak.
    DATA: t_vbak TYPE STANDARD TABLE OF ty_vbak.

*   ALV reference
    DATA: o_alv TYPE REF TO cl_salv_table.

    METHODS:
      get_data,           "  data selection
      generate_output.    "  Generating output
*
  PRIVATE SECTION.
    METHODS:
      set_columns.        "  Set columns
ENDCLASS.                    "lcl_report DEFINITION
*
*
START-OF-SELECTION.
  DATA: lo_report TYPE REF TO lcl_report.
*
  CREATE OBJECT lo_report.
  lo_report->get_data( ).
  lo_report->generate_output( ).


*
CLASS lcl_report IMPLEMENTATION.
*
  METHOD get_data.
*   data selection

    SELECT vbeln erdat auart kunnr
           INTO  CORRESPONDING FIELDS OF TABLE t_vbak
           FROM  vbak
           UP TO 20 ROWS.

    FIELD-SYMBOLS: <lfs_vbak> LIKE LINE OF t_vbak.
    DATA: lt_celltype TYPE salv_t_int4_column.
    DATA: ls_celltype LIKE LINE OF lt_celltype.
    LOOP AT t_vbak ASSIGNING <lfs_vbak>.
      CLEAR: lt_celltype.
* Only VBELN for 2nd record
      IF sy-tabix = 2.
        ls_celltype-columnname = 'VBELN'.
        ls_celltype-VALUE      = if_salv_c_cell_type=>HOTSPOT.
        APPEND ls_celltype TO lt_celltype.
* Only ERDAT for 3rd record
      ELSEIF sy-tabix = 3.
        ls_celltype-columnname = 'ERDAT'.
        ls_celltype-VALUE      = if_salv_c_cell_type=>button.
        APPEND ls_celltype TO lt_celltype.
* Entire 5th record
      ELSEIF sy-tabix = 5.
        ls_celltype-columnname = ".
        ls_celltype-VALUE      = if_salv_c_cell_type=>HOTSPOT.
        APPEND ls_celltype TO lt_celltype.
      ENDIF.
      <lfs_vbak>-i_celltype = lt_celltype.
    ENDLOOP.

  ENDMETHOD.                    "get_data
*
  METHOD generate_output.
* New ALV instance
    DATA: lx_msg TYPE REF TO cx_salv_msg.
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = o_alv
          CHANGING
            t_table      = t_vbak ).
      CATCH cx_salv_msg INTO lx_msg.
    ENDTRY.
*
* Setting up the Columns
    me->set_columns( ).

* Displaying the ALV
    o_alv->display( ).

  ENDMETHOD.                    "generate_output
*
  METHOD set_columns.
*
*...Get all the Columns
    DATA: lo_cols TYPE REF TO cl_salv_columns_table.
    lo_cols = o_alv->get_columns( ).
*
*   set the Column optimization
    lo_cols->set_optimize( 'X' ).

*   Set the Cell Type
    TRY.
        lo_cols->set_cell_type_column( 'I_CELLTYPE' ).
      CATCH cx_salv_data_error.                         "#EC NO_HANDLER
    ENDTRY.

  ENDMETHOD.                    "SET_COLUMNS

*
*
ENDCLASS.