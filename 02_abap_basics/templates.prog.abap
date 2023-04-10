REPORT zvzp_templates.
**ifs (IF mit sy-subrc)
*IF sy-subrc = 0.
*  ${cursor}
*ENDIF.
**wwri (WRITE)
*WRITE: / ${cursor}.
**loop (Einfacher Loop in Feldsymbol)
*LOOP AT ${table_name} ASSIGNING FIELD-SYMBOL(<${field_symbol}>).
*  ${cursor}.
*ENDLOOP.
**types (Struktur- und Tabellentyp)
*TYPES: BEGIN OF ls_${struct_name},
*         ${cursor},
*       END OF ls_${struct_name},
*       tt_${struct_name} TYPE STANDARD TABLE OF ls_${struct_name} WITH DEFAULT KEY.
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
*    DATA: o_salv TYPE REF TO cl_salv_table.
*    CALL METHOD cl_salv_table=>factory(
*      IMPORTING
*        r_salv_table = o_salv
*      CHANGING
*        t_table      = ${table_name} ).
*
*    o_salv->get_functions(  )->set_all( abap_true ).
*    o_salv->get_display_settings(  )->set_list_header( '${header}' ).
*    o_salv->get_display_settings(  )->set_striped_pattern( abap_true ).
*    o_salv->get_selections(  )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
*    o_salv->get_sorts(  )->add_sort( columnname = '${sort_column}' sequence = if_salv_c_sort=>sort_up ).
*    o_salv->get_columns(  )->set_optimize( abap_true ).
*    LOOP AT o_salv->get_columns(  )->get(  ) ASSIGNING FIELD-SYMBOL(<c>).
*      DATA(o_col) = <c>-r_column.
*      o_col->set_alignment( if_salv_c_alignment=>centered ).
*    ENDLOOP.
*    o_salv->display(  ).
*  CATCH cx_root INTO DATA(e_txt).
*    WRITE: / e_txt->get_text(  ).
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