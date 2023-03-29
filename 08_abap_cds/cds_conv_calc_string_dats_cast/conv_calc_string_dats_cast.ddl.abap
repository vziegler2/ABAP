@AbapCatalog.sqlViewName: 'ZVZCDSCALC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Berechnungen'
define view ZVZCDS_CALC
  as select from sflight
    join         spfli on  spfli.carrid = spfli.carrid
                       and spfli.connid = spfli.connid
{
  sflight.carrid                                                    as carrid,
  sflight.connid                                                    as connid,
  cityfrom                                                          as cityfrom,
  cityto                                                            as cityto,
  distance                                                          as distance,
  distid                                                            as distid,
  price                                                             as price,
  currency                                                          as currency,
  unit_conversion( quantity => distance,
                   source_unit => distid,
                   target_unit => cast( 'KM' as abap.unit(3) ),
                   error_handling => 'SET_TO_NULL' )                as distance_km,
  unit_conversion( quantity => distance,
                   source_unit => distid,
                   target_unit => cast( 'MI' as abap.unit(3) ),
                   error_handling => 'KEEP_UNCONVERTED' )           as distance_mi,
  currency_conversion( amount => price,
                       source_currency => currency,
                       target_currency => cast( 'EUR' as abap.cuky( 5 )),
                       exchange_rate_type => 'M',
                       exchange_rate_date => cast($session.system_date as dats preserving type ),
                       error_handling => 'SET_TO_NULL')             as price_eur,
  seatsmax + seatsmax_b + seatsmax_f                                as seatsmax_sum,
  seatsocc + seatsocc_b + seatsocc_f                                as seatsocc_sum,
  cast ( seatsmax + seatsmax_b + seatsmax_f -
  seatsocc - seatsocc_b - seatsocc_f as abap.fltp )                 as seatsfree,
  concat_with_space( sflight.carrid, sflight.connid, 1)             as flight,
  fldate                                                            as flightdate,
  substring( fldate, 1, 4)                                          as flyear,
  substring( fldate, 1, 6)                                          as flyearmonth,
  substring( fldate, 5, 2)                                          as flmonth,
  dats_days_between(
    cast ( $session.system_date as dats preserving type ), fldate ) as datediff
}