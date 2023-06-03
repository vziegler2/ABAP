REPORT zcvvz_excelupload.

TRY.
    DATA: lv_rc       TYPE i,
          it_files    TYPE filetable,
          lv_action   TYPE i,
          lv_filesize TYPE w3param-cont_len,
          lv_filetype TYPE w3param-cont_type,
          it_bin_data TYPE w3mimetabtype.

    cl_gui_frontend_services=>file_open_dialog(
      EXPORTING file_filter = |xlsx (*.xlsx)\|*.xlsx\|{ cl_gui_frontend_services=>filetype_all }|
      CHANGING  file_table  = it_files
                rc          = lv_rc
                user_action = lv_action ).

    IF lv_action = cl_gui_frontend_services=>action_ok.
      IF lines( it_files ) > 0.

        cl_gui_frontend_services=>gui_upload( EXPORTING filename   = |{ it_files[ 1 ]-filename }|
                                                        filetype   = 'BIN'
                                              IMPORTING filelength = lv_filesize
                                              CHANGING  data_tab   = it_bin_data ).

        DATA(lv_bin_data) = cl_bcs_convert=>solix_to_xstring( it_solix = it_bin_data ).
        DATA(o_excel) = NEW cl_fdt_xl_spreadsheet( document_name = CONV #( it_files[ 1 ]-filename )
                                                   xdocument     = lv_bin_data ).
        DATA it_worksheet_names TYPE if_fdt_doc_spreadsheet=>t_worksheet_names.
        o_excel->if_fdt_doc_spreadsheet~get_worksheet_names( IMPORTING worksheet_names = it_worksheet_names ).

        IF lines( it_worksheet_names ) > 0.
          DATA(o_worksheet_itab) = o_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( it_worksheet_names[ 1 ] ).
          ASSIGN o_worksheet_itab->* TO FIELD-SYMBOL(<worksheet>).

          ASSIGN o_worksheet_itab->* TO <worksheet>.
        ENDIF.
      ENDIF.
    ENDIF.

  CATCH cx_root INTO DATA(e_text).
    MESSAGE e_text->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
ENDTRY.

****************************************************************
* <worksheet> in Datenbanktabelle speichern
****************************************************************
*" zmy_table ist eine Struktur, die der Excel-Datei gleicht
*DATA: lt_zmy_table TYPE TABLE OF zmy_table.
*
*" Loop through worksheet and append data to internal table
*LOOP AT <worksheet> ASSIGNING FIELD-SYMBOL(<fs_line>).
*  APPEND <fs_line> TO lt_zmy_table.
*ENDLOOP.
*
*" Insert data into the database table
*INSERT zmy_table FROM TABLE lt_zmy_table.
*
*IF sy-subrc <> 0.
*  " Issue a message if there's a problem
*  MESSAGE 'Problem beim Hochladen der Daten' TYPE 'E'.
*ENDIF.
****************************************************************
* Auf einzelne Tabellenelemente zugreifen
****************************************************************
*DATA: lv_fieldname TYPE fieldname.
*
*" Loop through worksheet
*LOOP AT <worksheet> ASSIGNING FIELD-SYMBOL(<fs_line>).
*
*  " Get the structure description of the line structure
*  DATA(lo_struct_descr) = cl_abap_typedescr=>describe_by_data( <fs_line> ).
*
*  " Get the components of the structure
*  DATA(lt_components) = CAST cl_abap_structdescr( lo_struct_descr )->get_components( ).
*
*  " Loop through the components
*  LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
*
*    " Get the fieldname of the component
*    lv_fieldname = <fs_component>-name.
*
*    " Get the value of the field
*    ASSIGN COMPONENT lv_fieldname OF STRUCTURE <fs_line> TO FIELD-SYMBOL(<fs_field>).
*
*    IF <fs_field> IS ASSIGNED.
*      " Access the field value here
*      WRITE: / 'Field:', lv_fieldname, 'Value:', <fs_field>.
*    ENDIF.
*
*  ENDLOOP.
*
*ENDLOOP.