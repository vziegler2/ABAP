REPORT zvzp_json.

TYPES: BEGIN OF ls_json,
         key   TYPE string,
         value TYPE string,
       END OF ls_json.

TYPES:
  BEGIN OF ts_animal_characteristics,
    type  TYPE string,
    name  TYPE string,
    age   TYPE string,
    loves TYPE string,
    breed TYPE string,
  END OF ts_animal_characteristics,
  tt_animals TYPE STANDARD TABLE OF ts_animal_characteristics WITH EMPTY KEY.

DATA:  ls_jsondata TYPE ls_json.
DATA: BEGIN OF ls_animals,
        animals TYPE tt_animals,
      END OF ls_animals.

DATA(lv_jsondata) = '{ "key": "1", "value": "One" }'.
DATA(ls_jsondata2) = '{ "animals" :[{ "type": "cat", "name": "Tishka", "age": 5, "loves": "sausage", "breed": "red cat" }, { "type": "dog", "name": "Tuzik", "age": 5, "breed": "Ovcharka", "hobby": "throw a ball" } ]}'.

/ui2/cl_json=>deserialize(
  EXPORTING json = CONV #( lv_jsondata )
  CHANGING data = ls_jsondata
).

/ui2/cl_json=>deserialize(
  EXPORTING json = CONV #( ls_jsondata2 )
  CHANGING data = ls_animals
).

cl_demo_output=>display( ls_jsondata  ).
cl_demo_output=>display( ls_animals-animals  ).