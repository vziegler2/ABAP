@AbapCatalog.sqlViewName: 'ZVZCDSJOIN2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Join zwischen SPFLI und SFLIGHT'
define view ZVZCDS_JOIN2
  as select from    spfli
    left outer join sflight on  spfli.carrid = sflight.carrid
                            and spfli.connid = sflight.connid
{
  spfli.carrid,
  spfli.connid,
  sflight.fldate,
  spfli.cityfrom,
  spfli.cityto,
  spfli.deptime,
  spfli.arrtime,
  sflight.planetype,
  sflight.seatsocc,
  sflight.seatsmax
}
