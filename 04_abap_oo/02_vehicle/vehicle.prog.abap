REPORT zcvvz_000.

INCLUDE zcvvz_inc_lif_wheel.
INCLUDE zcvvz_inc_lcl_vehicle.
INCLUDE zcvvz_inc_lcl_truck.
INCLUDE zcvvz_inc_lcl_heavy_truck.
INCLUDE zcvvz_inc_lcl_bus.
INCLUDE zcvvz_inc_lcl_angebotsliste.

START-OF-SELECTION.
  DATA: gr_vehic       TYPE REF TO lcl_vehicle,
        gr_truck       TYPE REF TO lcl_truck,
        gr_heavy_truck TYPE REF TO lcl_heavy_truck,
        gr_bus         TYPE REF TO lcl_bus,
        gr_wheel       TYPE REF TO lif_wheel,
        gr_angebotsliste TYPE REF TO lcl_angebotsliste,
        gv_fuel        TYPE i,
        grt_vehiclist  TYPE STANDARD TABLE OF REF TO lcl_vehicle.

  gr_angebotsliste = NEW #( ).

  gr_vehic = NEW #( iv_make  = 'VW'
                    iv_model = 'Käfer' ).
  APPEND gr_vehic TO grt_vehiclist.

  gr_bus = NEW #( iv_tpass  = 80
                  iv_tmake  = 'Mercedes'
                  iv_tmodel = 'Bus' ).
  APPEND gr_bus TO grt_vehiclist.

  gr_truck = NEW #( iv_tmake   = 'MAN'
                    iv_tmodel  = 'TGA'
                    iv_tweight = 40 ).
  APPEND gr_truck TO grt_vehiclist.

  gr_heavy_truck = NEW #( iv_tmake   = 'MAN'
                          iv_tmodel  = 'TGX'
                          iv_tweight = 80 ).
  APPEND gr_heavy_truck TO grt_vehiclist.

  LOOP AT grt_vehiclist INTO gr_vehic.
    TRY.
        gr_truck ?= gr_vehic.
        gr_truck->meth( ).
      CATCH cx_sy_move_cast_error.
        WRITE: / 'Keine Truckinstanz'.
    ENDTRY.
  ENDLOOP.