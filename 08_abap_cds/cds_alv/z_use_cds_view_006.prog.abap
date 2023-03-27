REPORT z_use_cds_view_006.

CLASS lcl_main DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS create
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_main.
    METHODS: run.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD create.

    r_result = NEW #( ).

  ENDMETHOD.

  METHOD run.
    cl_salv_gui_table_ida=>create_for_cds_view( 'Z_INVOICE_ITEMS_006' )->fullscreen(  )->display(  ).
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  lcl_main=>create(  )->run(  ).