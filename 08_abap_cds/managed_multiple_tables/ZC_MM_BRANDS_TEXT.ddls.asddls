@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child'
@Metadata.ignorePropagatedAnnotations: true
@UI:{ headerInfo: { typeName: 'Data',
                    typeNamePlural: 'Data',
                    title: { type: #STANDARD,
                             value: 'brand_id' }
                  }
    }
define view entity ZC_MM_BRANDS_TEXT
  as projection on ZI_MM_BRANDS_TEXT
{
      @UI.facet: [{ id: 'Texts',
                    purpose: #STANDARD,
                    position: 10,
                    label: 'Texts',
                    type: #IDENTIFICATION_REFERENCE
                  }]
  key brand_id,
      @UI: { lineItem: [ { position: 10, importance: #HIGH, label: 'Language' } ],
             identification:[ { position: 10, label: 'Language' } ],
             selectionField: [ { position: 10 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_SPRAS_VH', element: 'laiso'},
                                           distinctValues: true }]
  key language,
      @UI: { lineItem: [ { position: 20, importance: #HIGH, label: 'Text' } ],
             identification:[ { position: 20, label: 'Text' } ],
             selectionField: [ { position: 20 } ] }
      brand_descr,
      /* Associations */
      ZI_MM_BRANDS_SAP : redirected to parent ZC_MM_BRANDS_SAP
}
