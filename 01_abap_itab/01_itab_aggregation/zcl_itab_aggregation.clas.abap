CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.
    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.
    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_itab_aggregation IMPLEMENTATION.
  METHOD perform_aggregation.
    LOOP AT initial_numbers INTO DATA(initial) GROUP BY ( key = initial-group count = GROUP SIZE ) ASCENDING INTO DATA(group).
      APPEND INITIAL LINE TO aggregated_data ASSIGNING FIELD-SYMBOL(<aggregated>).
      <aggregated>-group = group-key.
      <aggregated>-count = group-count.
      <aggregated>-min = 2147483647.
      LOOP AT GROUP group INTO DATA(item).
        <aggregated>-sum += item-number.
        <aggregated>-min = nmin( val1 = <aggregated>-min val2 = item-number ).
        <aggregated>-max = nmax( val1 = <aggregated>-max val2 = item-number ).
      ENDLOOP.
      <aggregated>-average = <aggregated>-sum / <aggregated>-count.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.