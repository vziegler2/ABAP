@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root'
@Metadata.ignorePropagatedAnnotations: true
@UI:{ headerInfo: { typeName: 'Brand',
                    typeNamePlural: 'Brands',
                    title: { type: #STANDARD,
                             value: 'brand_id' }
                  },
      presentationVariant: [{sortOrder: [{ by: 'brand_id', direction: #DESC }]}]
    }
define root view entity ZC_MM_BRANDS_SAP
  as projection on ZI_MM_BRANDS_SAP
{
      @UI.facet: [{ id: 'Brand',
                    purpose: #STANDARD,
                    position: 10,
                    label: 'Brands',
                    type: #IDENTIFICATION_REFERENCE
                  },
                  { id: 'Description',
                    purpose: #STANDARD,
                    position: 20,
                    label: 'Descriptions',
                    type: #LINEITEM_REFERENCE,
                    targetElement: '_Text'
                  },
                  { id: 'WWS',
                    purpose: #STANDARD,
                    position: 30,
                    label: 'WWS',
                    type: #LINEITEM_REFERENCE,
                    targetElement: '_WWS'
                  }]
      @UI: { lineItem: [ { position: 10, importance: #HIGH, label: 'SAP ID' } ],
             identification:[ { position: 10, label: 'SAP ID' } ],
             selectionField: [ { position: 10 } ] }
  key brand_id,
      @UI: { lineItem: [ { position: 50, importance: #HIGH, label: 'Type' } ],
             identification:[ { position: 50, label: 'Type' } ] }
      @EndUserText.quickInfo: '2 - Manufacturer Brand, 1 - Own Brand'
      brand_type,
      @UI: { lineItem: [ { position: 30, importance: #HIGH, label: 'Description' } ],
             identification:[ { position: 30, label: 'Description' } ],
             selectionField: [ { position: 30 } ] }
      brand_descr,
      @UI: { lineItem: [ { position: 40, importance: #HIGH, label: 'Language' } ],
             identification:[ { position: 40, label: 'Language' } ] }

      language,
      @UI: { lineItem: [ { position: 20, importance: #HIGH, label: 'WWS Number' } ],
             identification:[ { position: 20, label: 'WWS Number' } ],
             selectionField: [ { position: 20 } ] }
      zz_c_number,
      @UI: { lineItem: [ { position: 60, importance: #HIGH, label: 'Own Brand' } ],
             identification:[ { position: 60, label: 'Own Brand' } ],
             selectionField: [ { position: 60 } ] }
      zz_c_brand,
      /* Associations */
      _Text : redirected to composition child ZC_MM_BRANDS_TEXT,
      _WWS  : redirected to composition child ZC_MM_BRANDS_OLD
}
