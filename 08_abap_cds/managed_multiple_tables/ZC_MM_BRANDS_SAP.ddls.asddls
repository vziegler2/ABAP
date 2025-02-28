@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_MM_BRANDS_SAP
  as projection on ZI_MM_BRANDS_SAP
{
  key brand_id,
      brand_type,
      brand_descr,
      language,
      zz_c_number,
      zz_c_brand,
      /* Associations */
      _Text : redirected to composition child ZC_MM_BRANDS_TEXT,
      _WWS  : redirected to composition child ZC_MM_BRANDS_WWS
}
