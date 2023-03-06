REPORT zvz_fizzbuzz.

TRY.
    DATA(lo_fizz) = NEW zvzcl_fizzbuzz(  ).
    DATA(lo_exc) = NEW zvzx_000(  ).

    CALL METHOD lo_fizz->lm_fizzbuzz( 0 ).
  CATCH zvzx_000 INTO lo_exc.
    lo_exc->lm_exc( 'Bitte eine Zahl zwischen 1 und 100 wählen' ).
ENDTRY.