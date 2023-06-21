CLASS zcl_cvvz_excel_download DEFINITION PUBLIC FINAL CREATE PUBLIC .
    PUBLIC SECTION.
      METHODS: constructor       IMPORTING io_data            TYPE REF TO data,
               itab_to_xstring   IMPORTING io_data            TYPE REF TO data
                                 RETURNING VALUE(rv_bin_data) TYPE xstring,
               xstring_to_solix  RETURNING VALUE(rt_raw_data) TYPE solix_tab,
               excel_save_dialog RETURNING VALUE(rv_fullpath) TYPE string,
               gui_download.
    PRIVATE SECTION.
      DATA: mv_filename TYPE string,
            mv_path     TYPE string,
            mv_bin_data TYPE xstring,
            mt_raw_data TYPE solix_tab,
            mv_fullpath TYPE string.
  ENDCLASS.
  
  
  
  CLASS zcl_cvvz_excel_download IMPLEMENTATION.
    METHOD constructor.
      DATA(lo_data) = io_data.
  
      me->itab_to_xstring( lo_data ).
      me->xstring_to_solix( ).
      me->excel_save_dialog( ).
      me->gui_download( ).
    ENDMETHOD.
  
    METHOD itab_to_xstring.
      TRY.
          mv_bin_data = cl_fdt_xl_spreadsheet=>if_fdt_doc_spreadsheet~create_document( itab         = io_data
                                                                                       iv_call_type = if_fdt_doc_spreadsheet=>gc_call_dec_table ).
          rv_bin_data = mv_bin_data.
        CATCH cx_fdt_excel_core INTO DATA(e_text).
          MESSAGE e_text->get_text( ) TYPE 'I'.
      ENDTRY.
    ENDMETHOD.
  
    METHOD xstring_to_solix.
      mt_raw_data = cl_bcs_convert=>xstring_to_solix( mv_bin_data ).
  
      rt_raw_data = mt_raw_data.
    ENDMETHOD.
  
    METHOD excel_save_dialog.
      cl_gui_frontend_services=>file_save_dialog( EXPORTING  default_file_name         = 'GUI_Export'
                                                             default_extension         = 'xlsx'
                                                  CHANGING   filename                  = mv_filename
                                                             path                      = mv_path
                                                             fullpath                  = rv_fullpath
                                                  EXCEPTIONS cntl_error                = 1
                                                             error_no_gui              = 2
                                                             not_supported_by_gui      = 3
                                                             invalid_default_file_name = 4
                                                             OTHERS                    = 5 ).
  
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
  
      mv_fullpath = rv_fullpath.
    ENDMETHOD.
  
    METHOD gui_download.
      cl_gui_frontend_services=>gui_download( EXPORTING  bin_filesize            = xstrlen( mv_bin_data )
                                                         filename                = mv_fullpath
                                                         filetype                = 'BIN'
                                              CHANGING   data_tab                = mt_raw_data
                                              EXCEPTIONS file_write_error        = 1
                                                         no_batch                = 2
                                                         gui_refuse_filetransfer = 3
                                                         invalid_type            = 4
                                                         no_authority            = 5
                                                         unknown_error           = 6
                                                         header_not_allowed      = 7
                                                         separator_not_allowed   = 8
                                                         filesize_not_allowed    = 9
                                                         header_too_long         = 10
                                                         dp_error_create         = 11
                                                         dp_error_send           = 12
                                                         dp_error_write          = 13
                                                         unknown_dp_error        = 14
                                                         access_denied           = 15
                                                         dp_out_of_memory        = 16
                                                         disk_full               = 17
                                                         dp_timeout              = 18
                                                         file_not_found          = 19
                                                         dataprovider_exception  = 20
                                                         control_flush_error     = 21
                                                         not_supported_by_gui    = 22
                                                         error_no_gui            = 23
                                                         OTHERS                  = 24 ).
  
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDMETHOD.
  
  ENDCLASS.