@AbapCatalog.sqlViewName: 'ZVZCDSASSO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SPFLI mit Assoziationen der Prüftabellen'
define view ZVZCDS_ASSO
  as select from spfli
  association [1..1] to scarr    as _scarr       on  $projection.carrid = _scarr.carrid
  association [1..1] to sgeocity as _cityfrom    on  $projection.CountryFrom = _cityfrom.country
                                                 and $projection.CityFrom    = _cityfrom.city
  association [1..1] to sgeocity as _cityto      on  $projection.CountryTo = _cityto.country
                                                 and $projection.CityTo    = _cityto.city
  association [1..1] to sairport as _airportfrom on  $projection.AirportFrom = _airportfrom.id
  association [1..1] to sairport as _airportto   on  $projection.AirportTo = _airportto.id
{
  key carrid    as carrid,
  key connid    as connid,
      countryfr as CountryFrom,
      cityfrom  as CityFrom,
      countryto as CountryTo,
      cityto    as CityTo,
      airpfrom  as AirportFrom,
      airpto    as AirportTo,
      _scarr,
      _cityfrom,
      _cityto,
      _airportfrom,
      _airportto // Make association public
}