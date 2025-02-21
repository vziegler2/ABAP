@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table ZMM_CIT_BRAND'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MM_BRANDS_OLD
  as select from zmm_cit_brand
  association to parent ZI_MM_BRANDS_SAP on $projection.brand_id = ZI_MM_BRANDS_SAP.brand_id
{
  key zmm_cit_brand.zz_c_number,
      zmm_cit_brand.brand_id,
      zmm_cit_brand.zz_c_brand,
      ZI_MM_BRANDS_SAP // Make association public
}
