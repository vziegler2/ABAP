*****************************************************************
** [NUMBER|DATE|TIME|TIMESTAMP = RAW|(SPACE)|(ISO)|USER|ENVIRONMENT|(dobj)|expr]
*****************************************************************
*DATA: num    TYPE p LENGTH 8 DECIMALS 2,
*      date   TYPE d,
*      time   TYPE t,
*      tstamp TYPE timestampl,
*      BEGIN OF country,
*        key  TYPE t005x-land,
*        name TYPE t005t-landx,
*      END OF country,
*      country_tab LIKE TABLE OF country.
*
*DATA: BEGIN OF result,
*        name      TYPE string,
*        key       TYPE string,
*        number    TYPE string,
*        date      TYPE string,
*        time      TYPE string,
*        timestamp TYPE string,
*      END OF result,
*      results LIKE TABLE OF result.
*
*SELECT land AS key
*       FROM t005x
*       ORDER BY PRIMARY KEY
*       INTO CORRESPONDING FIELDS OF TABLE @country_tab
*       ##TOO_MANY_ITAB_FIELDS.
*
*LOOP AT country_tab INTO country.
*  SELECT SINGLE landx AS name
*         FROM t005t
*         WHERE  land1 = @country-key AND
*                spras = @sy-langu
*         INTO CORRESPONDING FIELDS OF @country.
*  MODIFY country_tab FROM country INDEX sy-tabix.
*ENDLOOP.
*
*SORT country_tab BY name AS TEXT.
*country-key  = space.
*country-name = 'User Master Record'.
*INSERT country INTO country_tab INDEX 1.
*
*num  = sy-datum / 100.
*date = sy-datum.
*time = sy-uzeit.
*GET TIME STAMP FIELD tstamp.
** Shows numeric fields in local format
** With USER instead of ENVIRONMENT no SET COUNTRY is needed
*LOOP AT country_tab INTO country.
*  SET COUNTRY country-key.
*  result-name      = country-name.
*  result-key       = country-key.
*  result-number    = |{ num    NUMBER    = ENVIRONMENT }|.
*  result-date      = |{ date   DATE      = ENVIRONMENT }|.
*  result-time      = |{ time   TIME      = ENVIRONMENT }|.
*  result-timestamp = |{ tstamp TIMESTAMP = ENVIRONMENT }|.
*  APPEND result TO results.
*  IF sy-tabix = 1.
*    CLEAR result.
*    APPEND result TO results.
*  ENDIF.
*ENDLOOP.
*
*cl_demo_output=>display( results ).
*****************************************************************
** [ALPHA = IN|OUT|RAW|(dobj)|expr]
*****************************************************************
*PARAMETERS: text   TYPE c LENGTH 20
*                           LOWER CASE
*                           DEFAULT '     0000012345',
*            length TYPE i DEFAULT 20,
*            width  TYPE i DEFAULT 0.
*
*CLASS demo DEFINITION.
*  PUBLIC SECTION.
*    CLASS-METHODS main.
*  PRIVATE SECTION.
*    CLASS-METHODS output IMPORTING title TYPE csequence
*                                   text  TYPE csequence.
*ENDCLASS.
** IN adds Zeros to the left, OUT removes Zeros from the left and adds Blanks to the right
*CLASS demo IMPLEMENTATION.
*  METHOD main.
*    DATA: textstring       TYPE string,
*          resultstringe    TYPE string,
*          resultfield      TYPE REF TO data,
*          resultstring_out TYPE string,
*          resultfield_out  TYPE REF TO data.
*    FIELD-SYMBOLS: <resultfield>     TYPE data,
*                   <resultfield_out> TYPE data.
*    CONCATENATE text `` INTO textstring RESPECTING BLANKS.
*    CREATE DATA resultfield  TYPE c LENGTH length.
*    CREATE DATA resultfield_out TYPE c LENGTH length.
*    ASSIGN resultfield->* TO <resultfield>.
*    ASSIGN resultfield_out->* TO <resultfield_out>.
*    IF width = 0.
*      resultstringe   = |{ textstring ALPHA = IN  }|.
*      output( title = `String, IN` text = resultstringe ).
*      <resultfield>  = |{ textstring ALPHA = IN  }|.
*      output( title = `Field,  IN` text = <resultfield> ).
*      resultstring_out  = |{ textstring ALPHA = OUT }|.
*      output( title = `String, OUT` text = resultstring_out ).
*      <resultfield_out> = |{ textstring ALPHA = OUT }|.
*      output( title = `Field,  OUT` text = <resultfield_out> ).
*    ELSE.
*      resultstringe   = |{ textstring ALPHA = IN  WIDTH = width }|.
*      output( title = `String, IN` text = resultstringe ).
*      <resultfield>  = |{ textstring ALPHA = IN  WIDTH = width }|.
*      output( title = `Field,  IN` text = <resultfield> ).
*      resultstring_out  = |{ textstring ALPHA = OUT WIDTH = width }|.
*      output( title = `String, OUT` text = resultstring_out ).
*      <resultfield_out> = |{ textstring ALPHA = OUT WIDTH = width }|.
*      output( title = `Field,  OUT` text = <resultfield_out> ).
*    ENDIF.
*  ENDMETHOD.
*  METHOD output.
*    DATA fill TYPE c LENGTH 40.
*    WRITE: /(12) title COLOR COL_HEADING NO-GAP,
*            (3)  fill COLOR COL_POSITIVE NO-GAP,
*                 text COLOR COL_NORMAL   NO-GAP,
*                 fill COLOR COL_POSITIVE NO-GAP,
*            40   fill.
*  ENDMETHOD.
*ENDCLASS.
*
*START-OF-SELECTION.
*  demo=>main( ).
*
*AT SELECTION-SCREEN.
*  IF length < 1 OR length > 20.
*    MESSAGE 'Length between 1 and 20 only' TYPE 'E'.
*  ENDIF.
*  IF width < 0 OR width > 20.
*    MESSAGE 'Width between 0 and 20 only' TYPE 'E'.
*  ENDIF.
*****************************************************************
** [TIMEZONE = tz]
*****************************************************************
*TYPES: BEGIN OF timezone,
*         tzone    TYPE ttzz-tzone,
*         descript TYPE ttzzt-descript,
*         datetime TYPE string,
*       END OF timezone.
*
*DATA: timezones TYPE TABLE OF timezone,
*      tstamp    TYPE timestamp.
*
*FIELD-SYMBOLS <timezone> TYPE timezone.
*
*SELECT ttzz~tzone, ttzzt~descript
*       FROM ttzz INNER JOIN ttzzt
*       ON ttzz~tzone = ttzzt~tzone
*       WHERE ttzz~tzone  NOT LIKE '%UTC%' AND
*             ttzzt~langu = 'E'
*       INTO CORRESPONDING FIELDS OF TABLE @timezones
*       ##TOO_MANY_ITAB_FIELDS.
*
*GET TIME STAMP FIELD tstamp.
** Converts a timestamp according to the timezone selected
*LOOP AT timezones ASSIGNING <timezone>.
*  <timezone>-datetime = |{ tstamp TIMEZONE  = <timezone>-tzone
*                                  TIMESTAMP = USER }|.
*ENDLOOP.
*
*SORT timezones BY datetime.
*
*cl_demo_output=>new(
*  )->begin_section( 'Timezones Around the World'
*  )->display( timezones ).
*****************************************************************
** [COUNTRY = cty]
*****************************************************************
*DATA: lv_date    TYPE d     VALUE '20230527',
*      lv_country TYPE land1 VALUE 'US'.
** The land1 type variable can be used instead of ENVIRONMENT
*WRITE / |{ lv_date COUNTRY = lv_country }|.