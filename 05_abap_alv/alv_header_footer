****************************************************************
* ALV-Header
****************************************************************
      DATA(o_grid_header) = NEW cl_salv_form_layout_grid(  ).
      o_grid_header->create_header_information( row = 1 column = 1 text = 'Headline' ).
      o_grid_header->create_action_information( row = 2 column = 1 text = 'Action Text' ).
      o_grid_header->create_flow( row = 3 column = 1 )->create_text( text = 'Headerflow:' ).
      o_grid_header->create_flow( row = 3 column = 3 )->create_text( text = 'Floating Text' ).
      o_salv->set_top_of_list( o_grid_header ).
      DATA(o_grp_head) = NEW cl_salv_form_groupbox( header = 'Groupbox' ).
      DATA(o_grp_head_grid) = o_grp_head->create_grid(  ).
      DATA(o_label_1) = o_grp_head_grid->create_label( row = 1 column = 1 text = |Label 1| ).
      DATA(o_text_1) = o_grp_head_grid->create_text( row = 1 column = 2 text = |Text 1| ).
      DATA(o_label_2) = o_grp_head_grid->create_label( row = 1 column = 3 text = |Label 2| ).
      DATA(o_text_2) = o_grp_head_grid->create_text( row = 1 column = 4 text = |Text 2| ).
      o_grid_header->set_element( row = 4 column = 1 r_element = o_grp_head ).
      o_grp_head_grid->set_grid_lines( if_salv_form_c_grid_lines=>no_lines ).
****************************************************************
* ALV-Footer
****************************************************************
      DATA(o_grid_footer) = NEW cl_salv_form_layout_grid(  ).
      o_salv->set_end_of_list( o_grid_footer ).
      o_grid_footer->create_action_information( row = 2 column = 1 text = 'Action Text' ).
      o_grid_footer->create_flow( row = 3 column = 1 )->create_text( text = 'Footerflow:' ).
      o_grid_footer->create_flow( row = 3 column = 3 )->create_text( text = 'Floating Text' ).
      DATA(o_grp_foot) = NEW cl_salv_form_groupbox( header = 'Groupbox' ).
      DATA(o_grp_foot_grid) = o_grp_foot->create_grid(  ).
      DATA(o_label_3) = o_grid_footer->create_label( row = 4 column = 4 text = |Label 3| ).
      DATA(o_text_3) = o_grid_footer->create_text( row = 4 column = 5 text = |Text 3| ).
      o_grid_footer->set_element( row = 4 column = 1 r_element = o_grp_foot ).
      o_grp_foot_grid->set_grid_lines( if_salv_form_c_grid_lines=>no_lines ).
      o_label_3->set_label_for( o_text_3 ).