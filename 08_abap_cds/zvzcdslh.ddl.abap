@AbapCatalog.sqlViewName: 'ZVZCDSSPFLILH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Daten der Gesellschaft LH'
define view ZVZCDS_SPFLILH
  as select from ZVZCDS_SPFLI
{
  *
}
where
  carrier = 'LH'
