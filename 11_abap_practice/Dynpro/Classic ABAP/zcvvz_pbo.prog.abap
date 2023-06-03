*----------------------------------------------------------------------*
***INCLUDE Z00_STATUS_0100O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STANDARD'.
  SET TITLEBAR 'TITLEBAR_0100'.

  IF c_custom_container IS INITIAL.
****************************************************************
* Container, Splitter und ALVs erzeugen
****************************************************************
    c_custom_container = NEW #( container_name = 'CCONTROL1' ).

    o_splitter_container = NEW #( parent = c_custom_container
                                  rows = 2
                                  columns = 1 ).

    alv_grid = NEW #( i_parent = o_splitter_container->get_container( row = 1 column = 1 ) ).

    alv_grid2 = NEW #( i_parent = o_splitter_container->get_container( row = 2 column = 1 ) ).
****************************************************************
* SELECT ALV1
****************************************************************
    SELECT a~matnr,
           b~werks,
           a~mtart,
           b~maabc,
           b~xchpf
    FROM mara AS a
    JOIN marc AS b ON a~matnr = b~matnr
    WHERE a~matnr IN @so_matnr AND b~werks IN @so_werks "AND a~mtart = @pa_mtart
    INTO TABLE @tab_display.
****************************************************************
* Display ALV1
****************************************************************
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZCVVZ_ST_00'
      CHANGING
        ct_fieldcat      = lt_fieldcat.

    READ TABLE lt_fieldcat WITH KEY fieldname = 'XCHPF' INTO ls_fieldcat.
    IF sy-subrc = 0.
      ls_fieldcat-no_out = 'X'.
      MODIFY lt_fieldcat FROM ls_fieldcat INDEX sy-tabix.
    ENDIF.

    alv_grid->set_table_for_first_display( EXPORTING i_structure_name = 'ZCVVZ_ST_00'
                                           CHANGING it_outtab = tab_display
                                                    it_fieldcatalog = lt_fieldcat ).

    SET HANDLER lcl_event_handle=>handle_double_click FOR alv_grid.

  ENDIF.
ENDMODULE.