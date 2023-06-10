REPORT zvzp_templates.
**ifs (IF mit sy-subrc)
*IF sy-subrc <> 0.
*    MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Objekt ist gesperrt'.
*    RETURN.
*ENDIF.${cursor}
**wwri (WRITE)
*WRITE: /, ${cursor}.
**loop (Einfacher Loop in Feldsymbol)
*LOOP AT ${table_name} ASSIGNING FIELD-SYMBOL(<${field_symbol}>).
*  ${cursor}.
*ENDLOOP.
**types (Struktur- und Tabellentyp)
*TYPES: BEGIN OF gty_${struct_name},
*         ${cursor},
*       END OF gty_${struct_name},
*       gty_${struct_name}_t TYPE STANDARD TABLE OF gty_${struct_name} WITH DEFAULT KEY.
**lcl (Local class)
*CLASS lcl_${class_name} DEFINITION.
*  PUBLIC SECTION.
*    METHODS: constructor,
*      set_value IMPORTING par1 TYPE string,
*      get_value RETURNING VALUE(rv_ret) TYPE i.
*  PRIVATE SECTION.
*    DATA: gv_data TYPE i.
*ENDCLASS.
*
*CLASS lcl_${class_name} IMPLEMENTATION.
*  METHOD constructor.
*    ${cursor}
*  ENDMETHOD.
*
*  METHOD set_value.
*    gv_data = par1.
*  ENDMETHOD.
*
*  METHOD get_value.
*    rv_ret = gv_data.
*  ENDMETHOD.
*ENDCLASS.
**salv (SALV-Tabelle mit Grundeinstellungen)
*TRY.
*    DATA: go_salv TYPE REF TO cl_salv_table.
*    cl_salv_table=>factory( EXPORTING r_container  = cl_gui_container=>default_screen
*							IMPORTING r_salv_table = go_salv
*      						CHANGING  t_table      = ${table_name} ).
*
**      DATA(go_column) = CAST cl_salv_column_table( go_salv->get_columns( )->get_column( 'DOKST' ) ).               "Ganze Spalte zu Buttons machen
**      go_column->set_icon( if_salv_c_bool_sap=>true ).
**      go_column->set_cell_type( if_salv_c_cell_type=>button ).
**      SET HANDLER lcl_events=>on_link_click FOR go_salv->get_event( ).
*
**    SET HANDLER lcl_events=>on_toolbar_click FOR go_salv->get_event( ).											"Toolbutton hinzufügen
**    DATA(o_col) = CAST cl_salv_column_table( go_salv->get_columns(  )->get_column( '${link_column}' ) ).
**    o_col->set_cell_type( if_salv_c_cell_type=>hotspot ).
*
*    go_salv->get_functions(  )->set_all( abap_true ).
**    go_salv->get_functions( )->add_function( name     = |EXPORT|
**                                             icon     = |{ icon_ws_plane }|
**                                             text     = |Export|
**                                             tooltip  = |Daten exportieren|
**                                             position = if_salv_c_function_position=>right_of_salv_functions ).
*    go_salv->get_display_settings(  )->set_list_header( '${header}' ).
*    go_salv->get_display_settings(  )->set_striped_pattern( abap_true ).
*    go_salv->get_selections(  )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
*    go_salv->get_sorts(  )->add_sort( columnname = '${sort_column}' sequence = if_salv_c_sort=>sort_up ).
*    go_salv->get_columns(  )->set_optimize( abap_true ).
**    DATA(o_col) = CAST cl_salv_column_table( go_salv->get_columns(  )->get_column( 'DOKST' ) ). 					"Spalte färben
**    o_col->set_color( VALUE #( col = 5 int = 0 inv = 0 ) ).
**    go_salv->get_columns(  )->set_color_column( 'COLOR' ). 														"Zeile färben
*    LOOP AT go_salv->get_columns(  )->get(  ) ASSIGNING FIELD-SYMBOL(<c>).
*      DATA(o_col2) = <c>-r_column.
*      o_col2->set_alignment( if_salv_c_alignment=>centered ).
*    ENDLOOP.
*    go_salv->display(  ).
*	WRITE: space.
*  CATCH cx_salv_msg cx_salv_data_error cx_salv_existing cx_salv_not_found cx_salv_wrong_call INTO DATA(cx_error).
*    MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH |{ cx_error->get_text(  ) }|.
*ENDTRY.
**cld (cl_demo_output in Vollbilddarstellung)
*cl_demo_output=>write_data( ${variable} ).
*
*DATA(lv_html) = cl_demo_output=>get(  ).
*
*cl_abap_browser=>show_html( EXPORTING
*                              title = '${title}'
*                              html_string = lv_html
*                              container = cl_gui_container=>default_screen ).
*
*WRITE: / space.
**sql (SQL-Statement)
*SELECT price,
*       CASE price
*         WHEN '50' THEN '50'
*         ELSE '50'
*       END AS price50,
*       COUNT( DISTINCT fldate ) AS flight_dates,
*       COUNT( * ) AS entries,
*       MIN( price ) AS min,
*       MAX( price ) AS max,
*       AVG( DISTINCT price ) AS avg,
*       SUM( price ) AS sum
*FROM sflight AS a
*INNER JOIN scarr AS b
*ON a~carrid = b~carrid
*WHERE price BETWEEN 500 AND 3000 AND
*      url LIKE '%www%' AND
*      a~carrid IN ('SQ', 'JL', 'LH')
*GROUP BY price
*HAVING COUNT( * ) > 10
*ORDER BY entries DESCENDING, price
*INTO TABLE @DATA(it_tab)
*UP TO 200 ROWS.
**** (Kommentar)
*****************************************************************
** ${cursor}
*****************************************************************
**selopt (Select-Options)
*SELECTION-SCREEN BEGIN OF BLOCK $${bl0} WITH FRAME TITLE $${TEXT-000}.
*  SELECT-OPTIONS: so_$${name} FOR $${table-variable}.$${cursor}
*SELECTION-SCREEN END OF BLOCK $${bl0}.
*
*TYPES: BEGIN OF ty_selopts,
*         ${name} TYPE RANGE OF $${table-variable},
*       END OF ty_selopts.
*
*DATA: ls_selopts TYPE ty_selopts.
*
*ls_selopts-$${name}[] = so_$${name}[].
**form (FORM-Routine)
*PERFORM ${name}.
*"TABLES .
*"USING .
*"CHANGING .
*
*FORM ${name}.
*"TABLES .
*"USING .
*"CHANGING .
*ENDFORM.${cursor}
**header (Header-Informationen)
****************************************************************
* Jira..............: ${jira}
* Description.......: ${description}
* Functional Concept: Vikram Ziegler (Academic Work)
* Technical Concept.: Vikram Ziegler (Academic Work)
* Realized by.......: Vikram Ziegler (Academic Work)
*---------------------------------------------------------------
* Change History:
*---------------------------------------------------------------
* Realized by.......:
* Date..............:
* Where.............:
****************************************************************