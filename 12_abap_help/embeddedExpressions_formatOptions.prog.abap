****************************************************************
* Embedded Expressions - format_options
****************************************************************
REPORT zcvvz_000.
****************************************************************
* [WIDTH = len]
****************************************************************
TYPES result TYPE STANDARD TABLE OF string WITH EMPTY KEY.
*String is extended on the right with blanks
cl_demo_output=>write( VALUE result( FOR j = 1 UNTIL j > strlen( sy-abcde )
                                     ( |{ substring( val = sy-abcde len = j )
                                          WIDTH = j + 4 }<---| ) ) ).
*If len < strlen -> strlen is printed -> No reduction
cl_demo_output=>display( VALUE result( FOR j = 1 UNTIL j > strlen( sy-abcde )
                                       ( |{ substring( val = sy-abcde len = j )
                                            WIDTH = strlen( sy-abcde ) / 2 } <---| ) ) ).
****************************************************************
* [ALIGN = LEFT|RIGHT|CENTER|(dobj)|expr] and [pad = c]
****************************************************************
DATA pad TYPE c LENGTH 1.
cl_demo_input=>request( CHANGING field = pad ).
*PAD uses the first character of the string to fill additional places
cl_demo_output=>new(
  )->write( |{ 'Left'   WIDTH = 20 ALIGN = LEFT   PAD = pad }<---|
  )->write( |{ 'Center' WIDTH = 20 ALIGN = CENTER PAD = pad }<---|
  )->write( |{ 'Right'  WIDTH = 20 ALIGN = RIGHT  PAD = pad }<---|
  )->display( ).
****************************************************************
* [CASE = RAW|UPPER|LOWER|(dobj)|expr]
****************************************************************
DATA: output  TYPE TABLE OF string,
      formats TYPE abap_attrdescr_tab,
      format  LIKE LINE OF formats.

FIELD-SYMBOLS <case> LIKE cl_abap_format=>c_raw.

formats = CAST cl_abap_classdescr(
         cl_abap_classdescr=>describe_by_name( 'CL_ABAP_FORMAT' )
         )->attributes.
DELETE formats WHERE name NP 'C_*' OR is_constant <> 'X'.

LOOP AT formats INTO format.
  ASSIGN cl_abap_format=>(format-name) TO <case>.
*Fill characters are ignored -> No changes
  APPEND |{ format-name WIDTH = 20 }| &
         |{ `UPPER CASE, lower case ` CASE = (<case>) WIDTH = 50 ALIGN = CENTER PAD = 'x' }|
         TO output.
ENDLOOP.
cl_demo_output=>display( output ).