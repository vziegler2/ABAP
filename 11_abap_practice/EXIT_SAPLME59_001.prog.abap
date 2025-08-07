" Definitionen für die Steuerungstabellen
TYPES: BEGIN OF lty_control.
         INCLUDE STRUCTURE ebanx.
TYPES:   raube TYPE mara-raube,
       END OF lty_control.

TYPES: BEGIN OF lty_material_data,
         matnr TYPE eban-matnr,
         raube TYPE mara-raube,
       END OF lty_material_data.

DATA: lt_control       TYPE TABLE OF lty_control,
      lt_material_data TYPE TABLE OF lty_material_data,
      ls_control_prev  TYPE lty_control.

ASSIGN ('(RM06BB30)P_GRAUBE') TO FIELD-SYMBOL(<s_checkbox_raube>).

IF <s_checkbox_raube> IS NOT ASSIGNED.
  RETURN.
ENDIF.

IF t_eban[] IS INITIAL OR <s_checkbox_raube> = ''.
  RETURN.
ENDIF.

" Raumbedingung abfragen
SELECT matnr,
       raube
  FROM mara
  INTO TABLE @lt_material_data
   FOR ALL ENTRIES IN @t_eban[]
 WHERE matnr = @t_eban-matnr.

" Eigene Steuerungstabelle aufbauen
LOOP AT t_eban[] ASSIGNING FIELD-SYMBOL(<s_eban>).
  APPEND INITIAL LINE TO lt_control ASSIGNING FIELD-SYMBOL(<s_control>).
  <s_control>-banfn = <s_eban>-banfn.
  <s_control>-bnfpo = <s_eban>-bnfpo.

  TRY.
      DATA(ls_material_data) = lt_material_data[ matnr = <s_eban>-matnr ].
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.

  IF ls_material_data IS NOT INITIAL.
    <s_control>-raube = ls_material_data-raube.
  ENDIF.

  CLEAR ls_material_data.
ENDLOOP.

UNASSIGN: <s_control>, <s_eban>.
SORT lt_control BY raube.

" Bei der ersten Zeile oder wenn sich die Raumbedingung ändert -> neue PO
LOOP AT lt_control ASSIGNING <s_control>.
  IF <s_control>-raube = 'LE'. " LE = Leergut
    <s_control>-raube = ls_control_prev.
  ENDIF.

  IF sy-tabix = 1 OR <s_control>-raube <> ls_control_prev-raube.
    <s_control>-new_po   = 'X'.
    <s_control>-new_item = ''.
  ELSE.
    <s_control>-new_po   = ''.
    <s_control>-new_item = 'X'.
  ENDIF.

  MODIFY lt_control FROM <s_control> INDEX sy-tabix.
  ls_control_prev = <s_control>.
ENDLOOP.

UNASSIGN <s_control>.

" Die Originaltabellen in der neuen Reihenfolge aufbauen
DATA(lt_eban_unsorted) = t_eban[].

CLEAR: t_eban[], t_ebanx[].

LOOP AT lt_control ASSIGNING <s_control>.
  TRY.
      DATA(ls_eban) = lt_eban_unsorted[ banfn = <s_control>-banfn
                                        bnfpo = <s_control>-bnfpo ].
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.

  IF ls_eban IS NOT INITIAL.
    APPEND ls_eban TO t_eban[].
  ENDIF.

  APPEND CORRESPONDING #( <s_control> ) TO t_ebanx[].

  CLEAR ls_eban.
ENDLOOP.
