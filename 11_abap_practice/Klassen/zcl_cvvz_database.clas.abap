CLASS zcl_cvvz_database DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS: check_table_lock IMPORTING iv_gname      TYPE string OPTIONAL
                                              iv_garg       TYPE string OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_cvvz_database IMPLEMENTATION.
  METHOD check_table_lock.
    DATA: lt_enq   TYPE ztt_cvvz_seqg3,
          lv_gname TYPE seqg3-gname,
          lv_garg  TYPE seqg3-garg.

    lv_gname = iv_gname.
    lv_garg = iv_garg.

    CALL FUNCTION 'ENQUEUE_READ'
      EXPORTING  gclient               = sy-mandt
                 gname                 = lv_gname
                 garg                  = lv_garg
                 guname                = sy-uname
                 local                 = space
                 fast                  = space
                 gargnowc              = space
      TABLES     enq                   = lt_enq
      EXCEPTIONS communication_failure = 1
                 system_failure        = 2
                 OTHERS                = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF sy-subrc = 0.
      IF lt_enq[] IS NOT INITIAL.
        MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Objekt ist gesperrt'.
        RETURN.
      ENDIF.
    ELSE.
      MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH 'Fehler bei der Sperrenprüfung'.
      RETURN.
    ENDIF.
  ENDMETHOD.
ENDCLASS.