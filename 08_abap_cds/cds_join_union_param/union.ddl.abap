@AbapCatalog.sqlViewName: 'ZVZCDSUNION'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Beispiel für Union'
define view ZVZCDS_UNION
  as select from but000
{
  partner    as PartnerNumber,
  type       as PartnerType,
  name_last  as ParnterName1,
  name_first as PartnerName2
}
where
  type = '1'
union select from but000
{
  partner    as PartnerNumber,
  type       as PartnerType,
  name_last  as ParnterName1,
  name_first as PartnerName2
}
where
  type = '2'
