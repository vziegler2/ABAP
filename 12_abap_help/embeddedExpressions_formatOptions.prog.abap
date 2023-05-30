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
****************************************************************
* [SIGN = LEFT|LEFTPLUS|LEFTSPACE|RIGHT|RIGHTPLUS|RIGHTSPACE|(dobj)|expr]
****************************************************************
DATA: num1    TYPE i VALUE -10,
      num2    TYPE i VALUE +10,
      results TYPE TABLE OF string,
      formats TYPE abap_attrdescr_tab,
      format  LIKE LINE OF formats.

FIELD-SYMBOLS <sign> LIKE cl_abap_format=>s_left.

formats =
  CAST cl_abap_classdescr(
         cl_abap_classdescr=>describe_by_name( 'CL_ABAP_FORMAT' )
         )->attributes.
DELETE formats WHERE name NP 'S_*' OR is_constant <> 'X'.
* LEFT = Nur - wird links angezeigt, + nicht (default)
* LEFTPLUS = - oder + werden links angezeigt
* LEFTSPACE = - oder Space werden links angezeigt
* Alle RIGHT*-Werte analog auf der rechten Seite
LOOP AT formats INTO format.
  ASSIGN cl_abap_format=>(format-name) TO <sign>.
  APPEND |{ format-name WIDTH = 16 }  | &
         |"{ num1 SIGN = (<sign>) }"  | &
         |"{ num2 SIGN = (<sign>) }"  | TO results.
ENDLOOP.
cl_demo_output=>display( results ).
****************************************************************
* [EXPONENT  = exp]
****************************************************************
DATA: lv_number   TYPE f VALUE '12345.0'.
* For very small and big numbers
WRITE: / |{ lv_number EXPONENT = 4 }|.
****************************************************************
* [DECIMALS  = dec]
****************************************************************
DATA: lv_float TYPE f VALUE '3.14159'.
* Shows only the specified decimal places
WRITE: / |{ lv_float DECIMALS = 2 }|.
****************************************************************
* [ZERO = YES|NO|(dobj)|expr]
****************************************************************
DATA: lv_num TYPE i VALUE 0,
      lv_num2 TYPE i VALUE 0.
* YES outputs the number (default), NO outputs an empty string
WRITE: / |{ lv_num ZERO = YES }|,  / |{ lv_num2 ZERO = NO }|.
****************************************************************
* [XSD = YES|NO|(dobj)|expr]
****************************************************************
DATA result TYPE TABLE OF string.

DATA: i          TYPE i            VALUE -123,
      int8       TYPE int8         VALUE -123,
      p          TYPE p DECIMALS 2 VALUE `-1.23`,
      decfloat16 TYPE decfloat16   VALUE `123E+1`,
      decfloat34 TYPE decfloat34   VALUE `-3.140000E+02`,
      f          TYPE f            VALUE `-3.140000E+02`,
      c          TYPE c LENGTH 3   VALUE ` Hi`,
      string     TYPE string       VALUE ` Hello `,
      n          TYPE n LENGTH 6   VALUE `001234`,
      d          TYPE d            VALUE `20020204`,
      t          TYPE t            VALUE `201501`,
      x          TYPE x LENGTH 3   VALUE `ABCDEF`,
      xstring    TYPE xstring      VALUE `456789AB`.

DEFINE write_template.
  APPEND |{ &1 WIDTH = 14  }| &&
         |{ &2 WIDTH = 30  }| &&
         |{ &2 XSD   = YES }| TO result.
END-OF-DEFINITION.
* Formats the data types to their asXML representation (especially date and time)
FORMAT FRAMES OFF.
write_template `i`          i.
write_template `int8`       int8.
write_template `p`          p.
write_template `decfloat16` decfloat16.
write_template `decfloat34` decfloat34.
write_template `f`          f.
APPEND `` TO result.
write_template `c`          c.
write_template `string`     string.
write_template `n`          n.
write_template `d`          d.
write_template `t`          t.
APPEND `` TO result.
write_template `x`          x.
write_template `xstring`    xstring.
cl_demo_output=>display( result ).
****************************************************************
* [STYLE =  SIMPLE|SIGN_AS_POSTFIX|SCALE_PRESERVING
*           |SCIENTIFIC|SCIENTIFIC_WITH_LEADING_ZERO
*           |SCALE_PRESERVING_SCIENTIFIC|ENGINEERING
*           |(dobj)|expr]
****************************************************************
CLASS cl_abap_format DEFINITION LOAD.
* Defines the style of decimal floating point numbers
CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
  PRIVATE SECTION.
    CLASS-DATA: BEGIN OF format,
                  value LIKE cl_abap_format=>e_xml_text,
                  name  TYPE abap_attrdescr-name,
                END OF format,
                formats LIKE SORTED TABLE OF format
                        WITH UNIQUE KEY value.
    CLASS-METHODS get_formats.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA: number TYPE decfloat34 VALUE '-12345.67890',
          BEGIN OF result,
            style         TYPE string,
            write_to      TYPE c LENGTH 20,
            template_raw  TYPE c LENGTH 20,
            template_user TYPE c LENGTH 20,
          END OF result,
          results LIKE TABLE OF result,
          off     TYPE i,
          exc     TYPE REF TO cx_sy_unknown_currency.
    get_formats( ).
    LOOP AT demo=>formats INTO demo=>format.
      result-style = demo=>format-name+2.
      WRITE number TO result-write_to
        STYLE demo=>format-value LEFT-JUSTIFIED.
      result-template_raw =
        |{ number STYLE  = (demo=>format-value) }|.
      result-template_user =
        |{ number STYLE  = (demo=>format-value)
                  NUMBER = USER }|.
      APPEND result TO results.
    ENDLOOP.
    cl_demo_output=>display( results ).
  ENDMETHOD.
  METHOD get_formats.
    DATA: formats TYPE abap_attrdescr_tab,
          format  LIKE LINE OF formats.
    FIELD-SYMBOLS <format> LIKE cl_abap_format=>o_scientific.
    formats =
      CAST cl_abap_classdescr(
             cl_abap_classdescr=>describe_by_name( 'CL_ABAP_FORMAT' )
             )->attributes.
    DELETE formats WHERE name NP 'O_*' OR is_constant <> 'X'.
    LOOP AT formats INTO format.
      ASSIGN cl_abap_format=>(format-name) TO <format>.
      demo=>format-value = <format>.
      demo=>format-name = format-name.
      INSERT demo=>format INTO TABLE demo=>formats.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).
****************************************************************
* [CURRENCY = cur]
****************************************************************
DATA: lv_amount TYPE p DECIMALS 2 VALUE '123.459'.
* Outputs the number according to the specified currency rules
WRITE: / |{ lv_amount CURRENCY = 'EUR' }|.