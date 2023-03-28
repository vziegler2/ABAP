@AbapCatalog.sqlViewName: 'ZVZCDSPARAMETER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Zugriff auf SPFLI mit Parameter'
define view ZVZCDS_PARAMETER
  with parameters
    p_carrid : s_carr_id
  as select from spfli
{
  *
}
where
  carrid = :p_carrid
