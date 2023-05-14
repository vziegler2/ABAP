REPORT z00.

TYPES: BEGIN OF lty_person,
         name    TYPE string,
         vorname TYPE string,
         alter   TYPE i,
         beruf   TYPE string,
       END OF lty_person,
       tt_person TYPE STANDARD TABLE OF lty_person,
       BEGIN OF lty_komponenten,
         name TYPE string,
       END OF lty_komponenten,
       tt_komponenten TYPE STANDARD TABLE OF lty_komponenten.

DATA: lt_person             TYPE tt_person,
      ls_person             TYPE lty_person,
      lt_komponenten_person TYPE tt_komponenten,
      ls_komponenten        TYPE lty_komponenten,
      lv_path               TYPE string VALUE 'C:\Users\U153937\OneDrive - Lufthansa Group\Desktop\Personen.csv',
      lt_csv_data           TYPE truxs_t_text_data,
      lo_struktur           TYPE REF TO cl_abap_structdescr,
      ls_components         TYPE abap_compdescr,
      ls_csv_data           TYPE LINE OF truxs_t_text_data,
      lv_rest               TYPE string,
      lv_wert               TYPE string,
      lt_komponenten_csv    TYPE TABLE OF lty_komponenten.

FIELD-SYMBOLS: <wert> TYPE any.

CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename = lv_path
*   filetype = 'ASC'
*   has_field_separator     = space
*   header_length           = 0
*   read_by_line            = 'X'
*   dat_mode = space
*   codepage =
*   ignore_cerr             = abap_true
*   replacement             = '#'
*   check_bom               = space
*   virus_scan_profile      =
*   no_auth_check           = space
*  IMPORTING
*   filelength              =
*   header   =
  TABLES
    data_tab = lt_csv_data
*  CHANGING
*   isscanperformed         = space
*  EXCEPTIONS
*   file_open_error         = 1
*   file_read_error         = 2
*   no_batch = 3
*   gui_refuse_filetransfer = 4
*   invalid_type            = 5
*   no_authority            = 6
*   unknown_error           = 7
*   bad_data_format         = 8
*   header_not_allowed      = 9
*   separator_not_allowed   = 10
*   header_too_long         = 11
*   unknown_dp_error        = 12
*   access_denied           = 13
*   dp_out_of_memory        = 14
*   disk_full               = 15
*   dp_timeout              = 16
*   others   = 17
  .
IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

lo_struktur ?= cl_abap_typedescr=>describe_by_name( 'LTY_PERSON' ).

LOOP AT lo_struktur->components INTO ls_components.
  ls_komponenten-name = ls_components-name.
  APPEND ls_komponenten TO lt_komponenten_person.
ENDLOOP.

READ TABLE lt_csv_data INTO ls_csv_data INDEX 1.
lv_rest = ls_csv_data.
DO.
  SPLIT lv_rest AT ';' INTO lv_wert lv_rest.
  CONDENSE lv_wert.
  IF lv_rest IS INITIAL AND lv_wert IS INITIAL.
    EXIT.
  ENDIF.
  ls_komponenten-name = lv_wert.
  APPEND ls_komponenten TO lt_komponenten_csv.
ENDDO.

LOOP AT lt_komponenten_person INTO ls_komponenten.
  READ TABLE lt_komponenten_csv WITH TABLE KEY name = ls_komponenten-name TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
*    MESSAGE e004(zmf_messages) WITH ls_komponenten-name.
    WRITE: / |Komponente { ls_komponenten-name } in der CSV-Datei nicht vorhanden|.
  ENDIF.
ENDLOOP.

LOOP AT lt_csv_data INTO ls_csv_data FROM 2.
  lv_rest = ls_csv_data.
  DO.
    SPLIT lv_rest AT ';' INTO lv_wert lv_rest.
    CONDENSE lv_wert.
    IF lv_rest IS INITIAL AND lv_wert IS INITIAL.
      EXIT.
    ENDIF.
    READ TABLE lt_komponenten_csv INDEX sy-index INTO ls_komponenten.
    ASSIGN COMPONENT ls_komponenten-name OF STRUCTURE ls_person TO <wert>.
    IF <wert> IS ASSIGNED.
      <wert> = lv_wert.
    ENDIF.
    UNASSIGN <wert>.
  ENDDO.
  APPEND ls_Person TO lt_person.
ENDLOOP.

*cl_demo_output=>write_data( lt_person ).
*
*DATA(lv_html) = cl_demo_output=>get(  ).
*
*cl_abap_browser=>show_html( EXPORTING
*                              title = 'Personen'
*                              html_string = lv_html
*                              container = cl_gui_container=>default_screen ).
*
*WRITE: / space.