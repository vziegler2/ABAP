@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table WRF_BRANDS_T'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MM_BRANDS_TEXT
  as select from wrf_brands_t
  association to parent ZI_MM_BRANDS_SAP on $projection.brand_id = ZI_MM_BRANDS_SAP.brand_id
{
  key wrf_brands_t.brand_id,
  key wrf_brands_t.language,
      wrf_brands_t.brand_descr,
      ZI_MM_BRANDS_SAP // Make association public
}
