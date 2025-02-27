@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Types'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_TYPEVH
  as select from dd07t
{
      @UI.hidden: true
  key domname,
      @UI.hidden: true
  key ddlanguage,
      @UI.hidden: true
  key as4local,
      @UI.hidden: true
  key valpos,
      @UI.hidden: true
  key as4vers,
      domvalue_l,
      ddtext

}
where
      domname    = 'WRF_BRAND_TYPE'
  and ddlanguage = $session.system_language
