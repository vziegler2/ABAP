REPORT zcvvz_docstatus.
****************************************************************
* 1. Datenbanktabelle ändern -> Bei allen DOKAR mit DOKST PY -> STATEXIT/STATFORM eintragen
****************************************************************
*SELECT * FROM tdws WHERE dokst = 'RL' INTO TABLE @DATA(lt_table).
*
*LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<f>).
*  <f>-statexit = 'ZCVVZ_DOCSTATUS'.
*  <f>-statform = 'SET_PY_TO_RL'.
*ENDLOOP.
*
*MODIFY tdws FROM TABLE lt_table.
****************************************************************
* 2. Datenbankeinträge zählen -> Doppelte RL-Einträge vorhanden?
****************************************************************
*SELECT doknr,
*       COUNT( * ) AS anzahl
*FROM draw
*WHERE dokst = 'RL'
*GROUP BY doknr
*ORDER BY anzahl DESCENDING
*INTO TABLE @DATA(lt_table2).
*
*LOOP AT lt_table2 ASSIGNING FIELD-SYMBOL(<g>).
*  IF <g>-anzahl > 1.
*    MESSAGE ID '00' TYPE 'I' NUMBER 001 WITH |Dokument { <g>-doknr } Status prüfen.|.
*  ENDIF.
*ENDLOOP.
****************************************************************
* 3. FORM-Routine -> Status und Protokollierung ändern
****************************************************************
PERFORM set_py_to_rl.

FORM set_py_to_rl.
  DATA: gs_drap TYPE drap,
        draw    TYPE draw.

  CALL FUNCTION 'ENQUEUE_EZCVVZ_DRAW'
    EXPORTING  mode_draw      = 'E'
               mandt          = sy-mandt
               dokar          = draw-dokar
               doknr          = draw-doknr
               doktl          = draw-doktl
               x_dokar        = space
               x_doknr        = space
               x_doktl        = space
               _scope         = '2'
               _wait          = space
               _collect       = ' '
    EXCEPTIONS foreign_lock   = 1
               system_failure = 2
               OTHERS         = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION 'ENQUEUE_EZCVVZ_DRAP'
    EXPORTING  mode_draw      = 'E'
               mandt          = sy-mandt
               dokar          = draw-dokar
               doknr          = draw-doknr
               doktl          = draw-doktl
               x_dokar        = space
               x_doknr        = space
               x_doktl        = space
               _scope         = '2'
               _wait          = space
               _collect       = ' '
    EXCEPTIONS foreign_lock   = 1
               system_failure = 2
               OTHERS         = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  SELECT *
  FROM draw
  WHERE dokar = @draw-dokar AND doknr = @draw-doknr AND dokvr <> @draw-dokvr AND doktl = @draw-doktl AND dokst = 'RL'
  INTO @DATA(gs_draw).
  ENDSELECT.

  IF gs_draw IS NOT INITIAL.
    gs_draw-dokst = 'SU'.

    MODIFY draw FROM gs_draw.

    SELECT *
    FROM drap
    WHERE dokar = @draw-dokar AND doknr = @draw-doknr AND dokvr <> @draw-dokvr AND doktl = @draw-doktl
    INTO TABLE @DATA(lt_table4).

    gs_drap-mandt  = sy-mandt.
    gs_drap-dokar  = draw-dokar.
    gs_drap-doknr  = draw-doknr.
    gs_drap-dokvr  = lt_table4[ 1 ]-dokvr.
    gs_drap-doktl  = draw-doktl.
    gs_drap-dokst  = 'SU'.
    gs_drap-stzae  = lines( lt_table4 ) + 1.
    gs_drap-datum  = sy-datum.
    gs_drap-pzeit  = sy-timlo.
    gs_drap-prnam  = sy-uname.
    gs_drap-protf  = 'Automatische Systemänderung'.
    gs_drap-audit1 = ''.
    gs_drap-audit2 = ''.

    INSERT drap FROM gs_drap.
  ENDIF.

  CALL FUNCTION 'DEQUEUE_EZCVVZ_DRAW'
    EXPORTING mode_draw = 'E'
              mandt     = sy-mandt
              dokar     = draw-dokar
              doknr     = draw-doknr
              doktl     = draw-doktl
              x_dokar   = space
              x_doknr   = space
              x_doktl   = space
              _scope    = '3'
              _synchron = space
              _collect  = ' '.

  CALL FUNCTION 'DEQUEUE_EZCVVZ_DRAP'
    EXPORTING mode_draw = 'E'
              mandt     = sy-mandt
              dokar     = draw-dokar
              doknr     = draw-doknr
              doktl     = draw-doktl
              x_dokar   = space
              x_doknr   = space
              x_doktl   = space
              _scope    = '3'
              _synchron = space
              _collect  = ' '.
ENDFORM.