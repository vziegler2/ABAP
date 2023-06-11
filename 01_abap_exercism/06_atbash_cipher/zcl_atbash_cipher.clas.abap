CLASS zcl_atbash_cipher DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS decode
      IMPORTING
        cipher_text       TYPE string
      RETURNING
        VALUE(plain_text) TYPE string .
    METHODS encode
      IMPORTING
        plain_text         TYPE string
      RETURNING
        VALUE(cipher_text) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: gty_char_t TYPE STANDARD TABLE OF c WITH DEFAULT KEY,
           gty_int_t  TYPE STANDARD TABLE OF i WITH DEFAULT KEY.

    DATA: gt_plain_text  TYPE gty_char_t,
          gt_cipher_text TYPE gty_char_t,
          gv_i           TYPE i VALUE 0.
ENDCLASS.



CLASS zcl_atbash_cipher IMPLEMENTATION.

  METHOD decode.
    DATA(gt_chars) = VALUE gty_char_t( FOR i = 0 THEN i + 1 UNTIL i = 26
                                       ( to_lower( sy-abcde+i(1) ) ) ).
    DATA(gt_cipher) = VALUE gty_char_t( FOR i = 0 THEN i + 1 UNTIL i = strlen( cipher_text )
                                        ( CONV char1( cipher_text+i(1) ) ) ).

    LOOP AT gt_cipher ASSIGNING FIELD-SYMBOL(<gv_char_cipher>).
      IF line_exists( gt_chars[ table_line = <gv_char_cipher> ] ).
        DATA(gv_tabix) = line_index( gt_chars[ table_line = <gv_char_cipher> ] ).
        IF gv_tabix < 14.
          APPEND gt_chars[ gv_tabix + ( ( 13 - gv_tabix ) * 2 ) + 1 ] TO gt_plain_text.
        ELSE.
          APPEND gt_chars[ gv_tabix - ( ( gv_tabix - 14 ) * 2 ) - 1 ] TO gt_plain_text.
        ENDIF.
      ELSE.
        APPEND <gv_char_cipher> TO gt_plain_text.
      ENDIF.
    ENDLOOP.

    CONCATENATE LINES OF gt_plain_text INTO plain_text.
  ENDMETHOD.

  METHOD encode.
    DATA(gt_chars) = VALUE gty_char_t( FOR i = 0 THEN i + 1 UNTIL i = 26
                                       ( to_lower( sy-abcde+i(1) ) ) ).
    DATA(gt_i) = VALUE gty_int_t( FOR i = 1 THEN i + 1 UNTIL i = 10
                                  ( i ) ).
    DATA(gt_plain) = VALUE gty_char_t( FOR i = 0 THEN i + 1 UNTIL i = strlen( plain_text )
                                       ( CONV char1( to_lower( plain_text+i(1) ) ) ) ).

    LOOP AT gt_plain ASSIGNING FIELD-SYMBOL(<gv_char_plain>).
      IF line_exists( gt_chars[ table_line = <gv_char_plain> ] ).
        DATA(gv_tabix) = line_index( gt_chars[ table_line = <gv_char_plain> ] ).
        IF gv_i MOD 5 = 0 AND gv_i <> 0.
          APPEND '|' TO gt_cipher_text.
          gv_i = 0.
        ENDIF.
        IF gv_tabix < 14.
          APPEND gt_chars[ gv_tabix + ( ( 13 - gv_tabix ) * 2 ) + 1 ] TO gt_cipher_text.
          gv_i += 1.
        ELSE.
          APPEND gt_chars[ gv_tabix - ( ( gv_tabix - 14 ) * 2 ) - 1 ] TO gt_cipher_text.
          gv_i += 1.
        ENDIF.
      ELSEIF <gv_char_plain> = ',' OR <gv_char_plain> = '.'.
        CONTINUE.
      ELSEIF line_exists( gt_i[ table_line = <gv_char_plain> ] ).
        APPEND <gv_char_plain> TO gt_cipher_text.
        gv_i += 1.
      ENDIF.
    ENDLOOP.

    CONCATENATE LINES OF gt_cipher_text INTO cipher_text.
    REPLACE ALL OCCURRENCES OF '|' IN cipher_text WITH ` `.
  ENDMETHOD.
ENDCLASS.