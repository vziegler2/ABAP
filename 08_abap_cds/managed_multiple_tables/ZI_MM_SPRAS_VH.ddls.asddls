@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Languages'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_SPRAS_VH
  as select from t002
  association to t002t on  t002t.spras = '2'
                       and t002t.sprsl = t002.spras
{
      @UI.hidden: true
  key t002.spras,
      t002.laiso,
      t002t.sptxt
}
