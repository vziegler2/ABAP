@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_MM_BRANDS_TEXT
  as projection on ZI_MM_BRANDS_TEXT
{
  key brand_id,
  key language,
      brand_descr,
      /* Associations */
      ZI_MM_BRANDS_SAP : redirected to parent ZC_MM_BRANDS_SAP
}
