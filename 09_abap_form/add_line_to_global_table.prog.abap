FUNCTION z_add_airline_006
  IMPORTING
    VALUE(carrname) TYPE s_carrname
    VALUE(currcode) TYPE s_currcode
    VALUE(url) TYPE s_carrurl.



  TYPES: BEGIN OF ls_alpha,
           alpha TYPE c,
         END OF ls_alpha,
         tt_alpha TYPE STANDARD TABLE OF ls_alpha WITH EMPTY KEY.

  DATA: lt_alpha  TYPE tt_alpha,
        ls_scarr  TYPE scarr,
        lv_char   TYPE c,
        lv_char2  TYPE c,
        lv_index  TYPE i VALUE 0,
        lv_index2 TYPE i,
        lv_carrid TYPE s_carr_id.

  lt_alpha = VALUE #( ( alpha = 'A' ) ( alpha = 'B' ) ( alpha = 'C' ) ( alpha = 'D' )
                      ( alpha = 'E' ) ( alpha = 'F' ) ( alpha = 'G' ) ( alpha = 'H' )
                      ( alpha = 'I' ) ( alpha = 'J' ) ( alpha = 'K' ) ( alpha = 'L' )
                      ( alpha = 'M' ) ( alpha = 'N' ) ( alpha = 'O' ) ( alpha = 'P' )
                      ( alpha = 'Q' ) ( alpha = 'R' ) ( alpha = 'S' ) ( alpha = 'T' )
                      ( alpha = 'U' ) ( alpha = 'V' ) ( alpha = 'W' ) ( alpha = 'X' )
                      ( alpha = 'Y' ) ( alpha = 'Z' ) ).

  DATA(lv_length) = strlen( carrname ).

  WHILE lv_index < lv_length.
    lv_char = carrname+lv_index(1).
    lv_index2 = lv_index + 1.
    WHILE lv_index2 < lv_length.
      lv_char2 = carrname+lv_index2(1).
      lv_carrid = |{ lv_char }{ lv_char2 }|.
      SELECT * FROM scarr WHERE carrid = @lv_carrid INTO @ls_scarr.
      ENDSELECT.
      IF ls_scarr IS INITIAL.
        ls_scarr-mandt = sy-mandt.
        ls_scarr-carrid = lv_carrid.
        ls_scarr-carrname = carrname.
        ls_scarr-currcode = currcode.
        ls_scarr-url = url.
        INSERT scarr FROM ls_scarr.
        MESSAGE |ID { lv_carrid } hinzugefügt| TYPE 'I'.
        RETURN.
      ENDIF.
      CLEAR ls_scarr.
      lv_index2 += 1.
    ENDWHILE.
    lv_index += 1.
  ENDWHILE.

  DATA(lv_lines) = lines( lt_alpha ).
  lv_index = 1.

  WHILE lv_index <= lv_lines.
    lv_char = lt_alpha[ lv_index ].
    lv_index2 = lv_index.
    WHILE lv_index2 <= lv_lines.
      lv_char2 = lt_alpha[ lv_index2 ].
      lv_carrid = |{ lv_char }{ lv_char2 }|.
      SELECT carrid FROM scarr WHERE carrid = @lv_carrid INTO @ls_scarr.
      ENDSELECT.
      IF ls_scarr IS INITIAL.
        ls_scarr-mandt = sy-mandt.
        ls_scarr-carrid = lv_carrid.
        ls_scarr-carrname = carrname.
        ls_scarr-currcode = currcode.
        ls_scarr-url = url.
        INSERT scarr FROM ls_scarr.
        MESSAGE |ID { lv_carrid } hinzugefügt| TYPE 'I'.
        RETURN.
      ENDIF.
      CLEAR ls_scarr.
      lv_index2 += 1.
    ENDWHILE.
    lv_index += 1.
  ENDWHILE.

ENDFUNCTION.