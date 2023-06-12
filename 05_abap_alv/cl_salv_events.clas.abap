CLASS lcl_events DEFINITION.

  PUBLIC SECTION.
    INTERFACES: if_alv_rm_grid_friend.    

    CLASS-METHODS: on_double_click
      FOR EVENT if_salv_events_actions_table~double_click
      OF cl_salv_events_table
      IMPORTING row
                column,
      on_link_click
        FOR EVENT if_salv_events_actions_table~link_click
        OF cl_salv_events_table
        IMPORTING row
                  column.

ENDCLASS.

CLASS lcl_events IMPLEMENTATION.
  METHOD on_double_click.
    DATA: ls_click TYPE ${table}.
    READ TABLE ${itab} INTO ls_click INDEX row. "Speichert die angeklickte Zeile in der Struktur
    SET PARAMETER ID '${parameter_id}' FIELD ls_click-${column}.
    SET PARAMETER ID '${parameter_id2}' FIELD ls_click-${column2}.
    SET PARAMETER ID '${parameter_id3}' FIELD ls_click-${column3}.
    SET PARAMETER ID '${parameter_id4}' FIELD ls_click-${column4}.
    CALL TRANSACTION '${transaction_code}' WITHOUT AUTHORITY-CHECK.
  ENDMETHOD.

  METHOD on_link_click.
    DATA: ls_click TYPE ${table}.
    READ TABLE ${itab} INTO ls_click INDEX row. "Speichert die angeklickte Zeile in der Struktur
    MESSAGE |{ row }, { column }, { ls_click-${column5} }| TYPE 'I'.
  ENDMETHOD.

ENDCLASS.