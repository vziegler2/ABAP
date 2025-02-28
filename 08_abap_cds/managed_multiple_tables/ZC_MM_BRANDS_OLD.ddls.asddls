@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_MM_BRANDS_WWS
  as projection on ZI_MM_BRANDS_WWS
{

  key zz_c_number,
      brand_id,
      zz_c_brand,
      /* Associations */
      ZI_MM_BRANDS_SAP : redirected to parent ZC_MM_BRANDS_SAP
}
