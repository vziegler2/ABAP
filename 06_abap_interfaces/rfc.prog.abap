REPORT zcvvz_000.

DATA: gs_rfcsi    TYPE rfcsi,
      gv_msg(100),
      exc         TYPE REF TO cx_demo_exception,
      gv_action   LIKE sy-input VALUE 'F',
      gv_err_fnum LIKE arfcrstate-arfcluwcnt VALUE space,
      gs_tcpicdat TYPE abaptext,
      gt_tcpicdat TYPE TABLE OF abaptext.

DATA: gv_dest         TYPE REF TO if_bgrfc_destination_outbound,
      go_unit         TYPE REF TO if_trfc_unit_outbound,
      ge_invalid_dest TYPE REF TO cx_bgrfc_invalid_destination.

PARAMETERS: pa_dest    TYPE rfcdes-rfcdest DEFAULT 'TS1', "RFC-Destination finden: Tabelle RFCDES, RFCTYPE = 3.
            pa_dest2   TYPE bgrfc_dest_name_outbound DEFAULT 'TS1',
            pa_dat(72) DEFAULT 'No comment' LOWER CASE.
*Einfacher RFC-Aufruf
CALL FUNCTION 'RFC_SYSTEM_INFO'
  DESTINATION pa_dest
  IMPORTING
    rfcsi_export = gs_rfcsi.
*Klassische Ausnahme
CALL FUNCTION 'DEMO_RFM_CLASSIC_EXCEPTION'
  DESTINATION pa_dest
  EXCEPTIONS
    classic_exception     = 1
    system_failure        = 2 MESSAGE gv_msg "Die beiden RFC-spezifischen Ausnahmen bieten die Option für weiteren Text
    communication_failure = 3 MESSAGE gv_msg
    OTHERS                = 4.

MESSAGE e001(00) WITH SWITCH #( sy-subrc
                                WHEN 1 THEN |{ sy-subrc }, { sy-msgv1 }|
                                WHEN 2 OR 3 THEN |{ sy-subrc }, { gv_msg }|
                                ELSE |{ sy-subrc }| ).
*Klassenbasierte Ausnahme
TRY. "Für RFC-Aufrufe nicht notwendig, da system_failure die klassenbasierten Ausnahmen abfängt.
    CALL FUNCTION 'DEMO_RFM_CLASS_BASED_EXCEPTION'
      DESTINATION pa_dest
      EXCEPTIONS
        system_failure        = 1 MESSAGE gv_msg
        communication_failure = 2 MESSAGE gv_msg.

    MESSAGE e001(00) WITH |{ sy-subrc }, { gv_msg }|.
  CATCH cx_demo_exception INTO exc. "Klassenbasierte Ausnahme wird trotz RFC behandelt, falls pa_dest = space -> lokaler Aufruf
    MESSAGE e001(00) WITH exc->get_text( ).
ENDTRY.
*Asynchrone Verarbeitung für Datenbankänderungen
CONCATENATE pa_dat '(created:' sy-uzeit ')' INTO gs_tcpicdat SEPARATED BY space.
APPEND gs_tcpicdat TO gt_tcpicdat.

TRY.
    gv_dest = cl_bgrfc_destination_outbound=>create( pa_dest ).
    go_unit = gv_dest->create_trfc_unit( ).

    CALL FUNCTION 'STFC_RETURN_DATA' "Schreibt einen Texteintrag in die Testtabelle TCPIC des Zielsystems
      IN BACKGROUND UNIT go_unit
      EXPORTING
        action   = gv_action
        err_fnum = gv_err_fnum
      TABLES
        tcpicdat = gt_tcpicdat.

    IF sy-subrc NE 0.
      MESSAGE e001(00) WITH |Unexpected error|.
      STOP.
    ENDIF.

  CATCH cx_bgrfc_invalid_destination INTO ge_invalid_dest.
    MESSAGE e001(00) WITH ge_invalid_dest->get_text( ).
    EXIT.
ENDTRY.

COMMIT WORK.
MESSAGE i001(00) WITH |COMMIT WORK done|.