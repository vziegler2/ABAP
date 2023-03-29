@AbapCatalog.sqlViewName: 'ZVZCDSASSO2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Assoziation SFLIGHT mit Prüftabellen'
define view ZVZCDS_ASSO2
  as select from sflight
  association [1..1] to saplane     as _saplane on  $projection.planetype = _saplane.planetype
  association [1..1] to ZVZCDS_ASSO as _spfli   on  $projection.carrid = _spfli.carrid
                                                and $projection.connid = _spfli.connid
{
  key carrid,
  key connid,
  key fldate,
      planetype,
      _saplane,
      _spfli // Make association public
}