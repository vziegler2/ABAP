REPORT z_ob_re_006_badi.

DATA: handle  TYPE REF TO z_badi_calc_vat_006,
      sum     TYPE p,
      vat     TYPE p,
      percent TYPE p.

PARAMETERS: country TYPE char2.

sum = 50.

GET BADI handle FILTERS country = country.

CALL BADI handle->get_vat
  EXPORTING
    iv_amount      = sum
  IMPORTING
    ev_amount_vat  = vat
    ev_percent_vat = percent.

WRITE: 'Prozent:', percent, 'Umsatzsteuer:', vat.