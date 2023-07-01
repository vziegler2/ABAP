@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '004'
@ClientHandling.type: #CLIENT_DEPENDENT //Schaltet die Mandantenbehandlung an (Standard) oder aus
define table function ZCVVZ_DD_004
with parameters @Environment.systemField: #CLIENT
                pa_mandt : mandt,
                pa_dokar : dokar,
                pa_adatum : adatum
returns {
  mandt : mandt;
  dokar : dokar;
  dokvr : dokvr;
  doktl : doktl_d;
  dokst : dokst;
  adatum : adatum;
//  langu : cvlang;
//  dktxt : dktxt;
  
}
implemented by method zcvvz_cl_001=>read;