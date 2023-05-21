CLASS zcl_cvvz_parameters DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_selopt_ref,
             name     TYPE string,
             data_ref TYPE REF TO data,
           END OF ty_selopt_ref,
           tt_selopt_ref TYPE STANDARD TABLE OF ty_selopt_ref WITH DEFAULT KEY,
           BEGIN OF ty_range,
             name   TYPE string,
             sign   TYPE string,
             option TYPE string,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range,
           tt_ranges TYPE STANDARD TABLE OF ty_range WITH DEFAULT KEY.
    CLASS-METHODS: return_filled_selopts IMPORTING ls_selopts       TYPE REF TO data
                                         RETURNING VALUE(lt_ranges) TYPE tt_ranges.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_cvvz_parameters IMPLEMENTATION.
  METHOD return_filled_selopts.
    FIELD-SYMBOLS: <fs_table>     TYPE STANDARD TABLE,
                   <fs_component> TYPE abap_compdescr,
                   <fs_structure> TYPE any.
    DATA: lr_data        TYPE REF TO data,
          lr_structdescr TYPE REF TO cl_abap_structdescr,
          lr_tabledescr  TYPE REF TO cl_abap_tabledescr,
          ls_selopt_ref  TYPE ty_selopt_ref,
          lt_selopt_ref  TYPE tt_selopt_ref.

    ASSIGN ls_selopts->* TO <fs_structure>.

    IF <fs_structure> IS ASSIGNED.
      " Get structure description
      lr_structdescr ?= cl_abap_typedescr=>describe_by_data( <fs_structure> ).
      " Loop through components of the structure
      LOOP AT lr_structdescr->components ASSIGNING <fs_component>.
        " Assign component to field symbol
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_table>.
        IF <fs_table> IS ASSIGNED.
          " Check if table is filled
          IF lines( <fs_table> ) > 0.
            " Create data reference to table
            GET REFERENCE OF <fs_table> INTO ls_selopt_ref-data_ref.
            ls_selopt_ref-name = <fs_component>-name.
            " Append to return table
            APPEND ls_selopt_ref TO lt_selopt_ref.
          ENDIF.
        ENDIF.
        UNASSIGN <fs_table>.
      ENDLOOP.
    ENDIF.
    LOOP AT lt_selopt_ref INTO DATA(ls_selopt_ref2).
      FIELD-SYMBOLS: <fs_table2> TYPE STANDARD TABLE,
                     <fs_line>   TYPE any,
                     <fs_sign>   TYPE any,
                     <fs_option> TYPE any,
                     <fs_low>    TYPE any,
                     <fs_high>   TYPE any.

      " Assign data reference to field symbol
      ASSIGN ls_selopt_ref-data_ref->* TO <fs_table2>.

      IF <fs_table2> IS ASSIGNED.
        LOOP AT <fs_table2> ASSIGNING <fs_line>.
          " Assign components of range line to field symbols
          ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_line> TO <fs_sign>.
          ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_line> TO <fs_option>.
          ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_line> TO <fs_low>.
          ASSIGN COMPONENT 'HIGH' OF STRUCTURE <fs_line> TO <fs_high>.

          IF <fs_sign> IS ASSIGNED AND <fs_option> IS ASSIGNED AND <fs_low> IS ASSIGNED AND <fs_high> IS ASSIGNED.
            " Prepare data for internal table
            DATA(ls_range) = VALUE ty_range( name   = ls_selopt_ref-name
                                             sign   = <fs_sign>
                                             option = <fs_option>
                                             low    = <fs_low>
                                             high   = <fs_high> ).
            " Insert data into internal table
            INSERT ls_range INTO TABLE lt_ranges.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.