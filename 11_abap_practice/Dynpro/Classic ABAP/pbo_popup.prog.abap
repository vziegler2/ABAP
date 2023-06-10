*----------------------------------------------------------------------*
***INCLUDE Z00_STATUS_0200O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STDPOPUP'.
  SET TITLEBAR 'CHARGENANZEIGE'.

  IF c_custom_container2 IS NOT BOUND.
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
                                            CHANGING  it_outtab        = tab_display3 ).

  ENDIF.
ENDMODULE.