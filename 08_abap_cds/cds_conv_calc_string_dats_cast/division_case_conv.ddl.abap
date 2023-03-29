@AbapCatalog.sqlViewName: 'ZVZCDSCALC2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multiplikation und Division'
define view ZVZCDS_CALC2
  as select from ZVZCDS_CALC
{
  carrid,
  connid,
  seatsmax_sum,
  seatsocc_sum,
  seatsfree,
  case seatsmax_sum
  when 0 then 0
  else division( seatsocc_sum * 100, seatsmax_sum , 1)
  end                                       as utilization,
  fltp_to_dec( seatsfree as abap.dec(7,1) ) as seatsfreedec
}