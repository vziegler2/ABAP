****************************************************************
* Description.......: Checks regularly in a time period whether
*                     a document info record is locked
* Realized by.......: Vikram Ziegler (Academic Work)
*---------------------------------------------------------------
* Change History....: Finished v1.0.0 (14.06.2023)
****************************************************************
REPORT zcvvz_check_lock_in_time_range.
****************************************************************
* Variables
****************************************************************
CONSTANTS: gv_timelimit TYPE i      VALUE 120 ##NEEDED,
           gv_tablename TYPE char30 VALUE 'DRAW' ##NEEDED,
           gv_intervall TYPE i      VALUE 1 ##NEEDED.

DATA: draw               TYPE draw ##NEEDED,
      gv_tablekey        TYPE eqegraarg ##NEEDED,
      gv_start_time      TYPE timestampl ##NEEDED,
      gv_end_time        TYPE timestampl ##NEEDED,
      gv_seconds_elapsed TYPE i ##NEEDED,
      gv_check_counter   TYPE i VALUE 0 ##NEEDED,
      gt_enq             TYPE STANDARD TABLE OF seqg3 WITH HEADER LINE ##NEEDED. " Header line needed

gv_tablekey = |{ sy-mandt }{ draw-dokar WIDTH = 3 }{ draw-doknr }{ draw-dokvr }{ draw-doktl }|.
GET TIME STAMP FIELD gv_start_time.
****************************************************************
* During [gv_timelimit] seconds: One lock check every [gv_intervall] seconds
****************************************************************
DO.
  WAIT UP TO gv_intervall SECONDS.
* One lock check per second.
  CALL FUNCTION 'ENQUEUE_READ'
    EXPORTING  gname                 = gv_tablename
               garg                  = gv_tablekey
    TABLES     enq                   = gt_enq
    EXCEPTIONS communication_failure = 1
               system_failure        = 2
               OTHERS                = 3.
* Program ends, if document info record is free.
  IF sy-subrc = 0.
    IF gt_enq IS INITIAL.
      EXIT.
    ENDIF.
  ELSE.
    MESSAGE i435(00) WITH TEXT-002.
    EXIT.
  ENDIF.

  gv_check_counter += 1.
  CLEAR gt_enq.
* Get current time and calculate elapsed time.
  GET TIME STAMP FIELD gv_end_time.

  TRY.
      gv_seconds_elapsed = cl_abap_tstmp=>subtract( tstmp1 = gv_end_time
                                                    tstmp2 = gv_start_time ).
    CATCH cx_parameter_invalid_range cx_parameter_invalid_type INTO DATA(cx_error) ##NEEDED.
      MESSAGE i435(00) WITH |{ cx_error->get_text( ) }|.
      EXIT.
  ENDTRY.
* Program ends, if more then [gv_timelimit] seconds elapsed.
  IF gv_seconds_elapsed >= gv_timelimit.
    MESSAGE i435(00) WITH |{ TEXT-003 } { gv_seconds_elapsed } { TEXT-004 } { gv_check_counter } { TEXT-005 }|.
    EXIT.
  ENDIF.
ENDDO.