CLASS zvzcl_fizzbuzz DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS lm_fizzbuzz
      IMPORTING i_input TYPE i
      RAISING   zvzx_000.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: gc_fizz TYPE string VALUE 'Fizz',
               gc_buzz TYPE string VALUE 'Buzz',
               gc_fibu TYPE string VALUE 'FizzBuzz'.
ENDCLASS.



CLASS zvzcl_fizzbuzz IMPLEMENTATION.
  METHOD lm_fizzbuzz.

    DATA: lv_output TYPE string,
          i_iter    TYPE i.

    i_iter = i_input.

    WHILE i_iter <= 100.
      lv_output = i_iter.
      IF i_iter MOD 5 = 0 AND i_iter MOD 3 = 0.
        WRITE: gc_fibu, /.
      ELSEIF i_iter MOD 3 = 0.
        WRITE: gc_fizz, /.
      ELSEIF i_iter MOD 5 = 0.
        WRITE: gc_buzz, /.
      ELSE.
        WRITE: lv_output, /.
      ENDIF.
      i_iter += 1.
    ENDWHILE.

    IF i_input > 100 OR i_input < 1.
      RAISE EXCEPTION TYPE zvzx_000.
    ENDIF.
  ENDMETHOD.
ENDCLASS.