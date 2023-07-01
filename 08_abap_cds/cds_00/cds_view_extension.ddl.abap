@AbapCatalog.sqlViewAppendName: 'ZCVVZ_EXT_002S'
@EndUserText.label: '002e'
extend view ZCVVZ_DD_001 with ZCVVZ_EXT_002
  association[0..1] to drap on drap.doknr = $projection.doknr
{
  drap.stzae //Auswirkungen auf bestehende Abfragen hätte "drap[inner].stzae",
             //falls "stzae" für einzelne Ergebnisse initial wäre
}