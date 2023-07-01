CLASS zcvvz_cl_001 DEFINITION PUBLIC.
  PUBLIC SECTION.
  INTERFACES: if_amdp_marker_hdb.

  CLASS-METHODS: read FOR TABLE FUNCTION zcvvz_dd_004.
ENDCLASS.



CLASS zcvvz_cl_001 IMPLEMENTATION.
  METHOD read BY DATABASE FUNCTION FOR HDB
                 LANGUAGE SQLSCRIPT
                 OPTIONS READ-ONLY
                 USING draw.

    RETURN SELECT mandt,
                  dokar,
                  dokvr,
                  doktl,
                  dokst,
                  adatum
    FROM draw
    WHERE mandt = :pa_mandt AND
          dokar = :pa_dokar AND
          adatum > :pa_adatum;

  ENDMETHOD.

ENDCLASS.