CLASS zvzcl_exercism DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS hamming_distance
      IMPORTING
        first_strand  TYPE string
        second_strand TYPE string
      RETURNING
        VALUE(result) TYPE i
      RAISING
        cx_parameter_invalid.
ENDCLASS.

CLASS zvzcl_exercism IMPLEMENTATION.

  METHOD hamming_distance.
    IF strlen( first_strand ) = strlen( second_strand ).
      result = REDUCE #( INIT r = 0
                         FOR i = 0 WHILE i < strlen( first_strand )
                         NEXT r += COND #( WHEN first_strand+i(1) <> second_strand+i(1) THEN 1 ELSE 0 ) ).
    ELSE.
      RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.