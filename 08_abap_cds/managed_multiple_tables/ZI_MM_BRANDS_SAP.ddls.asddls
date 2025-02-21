@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table WRF_BRANDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MM_BRANDS_SAP
  as select from wrf_brands
  association to wrf_brands_t on wrf_brands.brand_id = wrf_brands_t.brand_id
                    and wrf_brands_t.language = 'E'
  association to zmm_cit_brand on wrf_brands.brand_id = zmm_cit_brand.brand_id
  composition [0..*] of ZI_MM_BRANDS_TEXT as _Text
  composition [0..*] of ZI_MM_BRANDS_OLD  as _WWS
{
  key wrf_brands.brand_id,
      wrf_brands.brand_type,
      wrf_brands_t.brand_descr,
      wrf_brands_t.language,
      zmm_cit_brand.zz_c_number,
      zmm_cit_brand.zz_c_brand,
      // Make association public
      _Text,
      _WWS
}
