@AbapCatalog.sqlViewName: 'ZVZCDSODATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OData-Publish'
@OData.publish: true
define view ZVZCDS_ODATA
  as select from spfli
{
  key carrid   as Carrier,
  key connid   as FlightNumber,
      cityfrom as CityFrom,
      cityto   as CityTo
}