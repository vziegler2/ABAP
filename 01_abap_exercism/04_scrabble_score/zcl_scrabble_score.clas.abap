CLASS zcl_scrabble_score DEFINITION PUBLIC .

  PUBLIC SECTION.
    METHODS score
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_scrabble_score IMPLEMENTATION.
  METHOD score.
    DATA(buffer) = input.
    TRANSLATE buffer TO UPPER CASE.
    result = count( val = buffer regex = '[AEIOULNRST]')
             + 2 * count( val = buffer regex = '[DG]')
             + 3 * count( val = buffer regex = '[BCMP]')
             + 4 * count( val = buffer regex = '[FHVWY]')
             + 5 * count( val = buffer regex = '[K]')
             + 8 * count( val = buffer regex = '[JX]')
             + 10 * count( val = buffer regex = '[QZ]').
  ENDMETHOD.
ENDCLASS.