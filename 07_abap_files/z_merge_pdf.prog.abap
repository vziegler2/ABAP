REPORT z_merge_pdf.

TRY.
    DATA: lv_rc    TYPE i,
          it_files TYPE filetable.
*Öffnet einen Dialog, um mehrere (Anzahl = lv_rc) PDF-Dateien zu öffnen, die in it_files gespeichert werden
    cl_gui_frontend_services=>file_open_dialog( EXPORTING file_filter = |pdf (*.pdf)\|*.pdf\|{ cl_gui_frontend_services=>filetype_all }|
                                                          multiselection = abap_true
                                                CHANGING  file_table = it_files
                                                          rc = lv_rc ).
    IF lv_rc > 0.
      DATA(o_pdf_merger) = NEW cl_rspo_pdf_merge(  ).
      LOOP AT it_files ASSIGNING FIELD-SYMBOL(<f>).
        DATA: lv_filesize TYPE w3param-cont_len,
              it_bin_data TYPE w3mimetabtype.
*Lädt die aktuelle Datei hoch, wandelt sie ins SOLIX-Binärformat um und speichert sie in it_bin_data
        cl_gui_frontend_services=>gui_upload( EXPORTING filename = |{ it_files[ sy-tabix ]-filename }|
                                                        filetype = 'BIN'
                                              IMPORTING filelength = lv_filesize
                                              CHANGING data_tab = it_bin_data ).
*Wandelt das SOLIX-Daten in XSTRING-Daten um und speichert sie in lv_bin_data
        DATA(lv_bin_data) = cl_bcs_convert=>solix_to_xstring( it_solix = it_bin_data ).
*Speichert die XSTRING-Daten in der Klasse cl_rspo_pdf_merge()
        o_pdf_merger->add_document( lv_bin_data ).
        WRITE: / |{ it_files[ sy-tabix ]-filename } --> added.|.
      ENDLOOP.
*Fügt die Dokumente in lv_merged_pdf zusammen
      o_pdf_merger->merge_documents( IMPORTING merged_document = DATA(lv_merged_pdf)
                                               rc = lv_rc ).
*Die Rückkonvertierung zu SOLIX-Daten wird in it_bin_data_merged gespeichert
      DATA(it_bin_data_merged) = cl_bcs_convert=>xstring_to_solix( lv_merged_pdf ).
*Lädt die Datei herunter
      cl_gui_frontend_services=>gui_download( EXPORTING filename = 'merged.pdf'
                                                        filetype = 'BIN'
                                                        bin_filesize = xstrlen( lv_merged_pdf )
                                              CHANGING data_tab = it_bin_data_merged ).
      WRITE: / |Merged PDF ---> downloaded!|.
    ENDIF.
  CATCH cx_root INTO DATA(e_txt).
    WRITE: / e_txt->get_text(  ).
ENDTRY.