@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root'
@Metadata.ignorePropagatedAnnotations: true
@UI:{ headerInfo: { typeName: 'Brand',
                    typeNamePlural: 'Brands',
                    title: { type: #STANDARD,
                             value: 'brand_id' }
                  }
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
      @UI: { lineItem: [ { position: 20, importance: #HIGH, label: 'Type: 1=Own Brand, 2=Manufacturer Brand' } ],
             identification:[ { position: 20, label: 'Type' } ],
             selectionField: [ { position: 20 } ] }
      @EndUserText.quickInfo: '2 - Manufacturer Brand, 1 - Own Brand'
      brand_type,
      /* Associations */
      _Text : redirected to composition child ZC_MM_BRANDS_TEXT,
      _WWS  : redirected to composition child ZC_MM_BRANDS_OLD
}
