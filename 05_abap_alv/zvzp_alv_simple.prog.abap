REPORT zvz_ob_000_exercise01.
* Beispiele in https://techazmaan.com/sap-alv-report-list/

*** Aufgabe
* Zeige 100 Verkaufsbelege (VBAP) in einem ALV-Grid an

DATA: o_alv TYPE REF TO cl_salv_table.

SELECT * FROM vbap INTO TABLE @DATA(it_vbap) UP TO 100 ROWS.

TRY.
    cl_salv_table=>factory( IMPORTING r_salv_table = o_alv
                            CHANGING t_table = it_vbap ).
    o_alv->display(  ).
  CATCH cx_salv_msg INTO DATA(lo_exc).
    cl_demo_output=>display( lo_exc ).
ENDTRY.