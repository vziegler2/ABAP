@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table WRF_BRANDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MM_BRANDS_SAP
  as select from wrf_brands
  composition [0..*] of ZI_MM_BRANDS_TEXT as _Text
  composition [0..*] of ZI_MM_BRANDS_OLD as _WWS
{
  key wrf_brands.brand_id,
      wrf_brands.brand_type,
      // Make association public
      _Text,
      _WWS
}
