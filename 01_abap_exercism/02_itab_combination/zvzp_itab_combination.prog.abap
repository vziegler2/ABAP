REPORT zvzp_exercism.

TYPES: BEGIN OF alphatab_type,
         cola TYPE string,
         colb TYPE string,
         colc TYPE string,
       END OF alphatab_type.
TYPES alphas TYPE STANDARD TABLE OF alphatab_type WITH EMPTY KEY.

TYPES: BEGIN OF numtab_type,
         col1 TYPE string,
         col2 TYPE string,
         col3 TYPE string,
       END OF numtab_type.
TYPES nums TYPE STANDARD TABLE OF numtab_type WITH EMPTY KEY.

TYPES: BEGIN OF combined_data_type,
         colx TYPE string,
         coly TYPE string,
         colz TYPE string,
       END OF combined_data_type.
TYPES combined_data TYPE STANDARD TABLE OF combined_data_type WITH EMPTY KEY.

DATA(alphas) = VALUE alphas( ( cola = 'A' colb = 'B' colc = 'C' )
                             ( cola = 'D' colb = 'E' colc = 'F' )
                             ( cola = 'G' colb = 'H' colc = 'I' ) ).

DATA(nums) = VALUE nums( ( col1 = '1' col2 = '2' col3 = '3' )
                         ( col1 = '4' col2 = '5' col3 = '6' )
                         ( col1 = '7' col2 = '8' col3 = '9' ) ).

DATA(lo_ex) = NEW zvzcl_exercism(  ).

DATA(return) = lo_ex->perform_combination( alphas = alphas nums = nums ).

cl_demo_output=>display( return ).