****************************************************************
* Jira..............: None
* Description.......: Reprogramming of mkruses MM report
* Functional Concept: Vikram Ziegler (Academic Work)
* Technical Concept.: Vikram Ziegler (Academic Work)
* Realized by.......: Vikram Ziegler (Academic Work)
*---------------------------------------------------------------
* Change History:
*---------------------------------------------------------------
* Realized by.......: Klasse Z. 120-121 (Titel)
* Date..............:
* Where.............:
****************************************************************
REPORT zcvvz_dynpro_oo.

TABLES: marc, mara.

DATA(go_view) = NEW zcl_mkrtest_appl01( ).

SELECT-OPTIONS: so_matnr FOR marc-matnr,
                so_mtart FOR mara-mtart,
                so_werks FOR marc-werks.

go_view->set_selection_screen_data( it_matnr = go_view->conv_selopt( so_matnr[] )
                                    it_mtart = go_view->conv_selopt( so_mtart[] )
                                    it_werks = go_view->conv_selopt( so_werks[] ) ).

go_view->get_data1( ).

CALL SCREEN '100'.

INCLUDE zcvvz_dynpro_oo_status_0100o01.

INCLUDE zcvvz_dynpro_oo_user_commani01.