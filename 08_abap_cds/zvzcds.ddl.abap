@AbapCatalog.sqlViewName: 'ZVZCDSSPFLI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Einführung'
define view ZVZCDS_SPFLI
  as select from spfli
{
  carrid as carrier,
  connid as connectionnumber,
  cityfrom,
  cityto
}
