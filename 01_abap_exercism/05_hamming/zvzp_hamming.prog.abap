REPORT zvzp_exercism.

DATA: first_strand  TYPE string VALUE 'GAGCCTACTAACGGGAT',
      second_strand TYPE string VALUE 'CATCGTAATGACGGCCT'.

DATA(lo_ex) = NEW zvzcl_exercism(  ).
DATA(return) = lo_ex->hamming_distance( first_strand = first_strand second_strand = second_strand ).

cl_demo_output=>display( return ).