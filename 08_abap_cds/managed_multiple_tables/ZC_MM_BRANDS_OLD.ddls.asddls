@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child'
@Metadata.ignorePropagatedAnnotations: true
@UI:{ headerInfo: { typeName: 'Data',
                    typeNamePlural: 'Data',
                    title: { type: #STANDARD,
                             value: 'zz_c_number' }
                  }
    }
define view entity ZC_MM_BRANDS_OLD
  as projection on ZI_MM_BRANDS_OLD
{
      @UI.facet: [{ id: 'WWS',
                    purpose: #STANDARD,
                    position: 20,
                    label: 'WWS',
                    type: #IDENTIFICATION_REFERENCE
                  }]
      @UI: { lineItem: [ { position: 10, importance: #HIGH, label: 'Number' } ],
             identification:[ { position: 10, label: 'Number' } ] }
  key zz_c_number,
      brand_id,
      @UI: { lineItem: [ { position: 20, importance: #HIGH, label: 'Own Brand' } ],
             identification:[ { position: 20, label: 'Own Brand' } ] }
      zz_c_brand,
      /* Associations */
      ZI_MM_BRANDS_SAP : redirected to parent ZC_MM_BRANDS_SAP
}
