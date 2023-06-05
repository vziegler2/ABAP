*&---------------------------------------------------------------------*
*& Report ZMKRTEST_APPL01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
***********************************************************************
* Jira/Description........: DUAO-xxxx ZILABOP - Run Time
*                           Re-Implementation of Query
*                           ZIX_LAB_OPER Group Z_IX
* Functional concept by...: Shashank Chandra (LHIND)
* Technical concept by....: Marco Kruse (LHIND)
* Realized by.............: Marco Kruse (LHIND)
***********************************************************************
* Change History:
* ---------------------------------------------------------------------
* Description.............:
* Realized by.............:
* Date....................: xxxx-xx-xx
* Where...................: DUAO-xxxx
***********************************************************************

INCLUDE ZMKRTEST_APPL01TOP                      .    " Global Data
INCLUDE zmkrtest_appl01_pbo_0001o01.
* INCLUDE ZMKRTEST_APPL01O01                      .  " PBO-Modules
* INCLUDE ZMKRTEST_APPL01I01                      .  " PAI-Modules
* INCLUDE ZMKRTEST_APPL01F01                      .  " FORM-Routines


INITIALIZATION.
* Objekt erzeugen
  go_view = new zcl_mkrtest_appl01( ).

AT SELECTION-SCREEN.
* Selektionbild Daten in Klasse aktuell halten
  go_view->set_selection_screen_data( it_matnr   = go_view->conv_selopt( so_matnr[] )
                                      it_mtart   = go_view->conv_selopt( so_mtart[] )
                                      it_werks   = go_view->conv_selopt( so_werks[] ) ).

START-OF-SELECTION.
  go_view->get_data1( ).
* Hauptscreen
  CALL SCREEN '0001'.