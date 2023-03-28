@Metadata.layer: #CORE
@UI: { headerInfo: { typeName: 'Travel',
                     typeNamePlural: 'Travels',
                     title: { type: #STANDARD,
                     label: 'Travel',
                     value: 'TravelID' } } }
//@UI.presentationVariant: [{groupBy: [ 'AgencyID', 'CustomerID' ] }]
annotate view Z_I_TRAVEL_R_006 with
{
  @UI.facet: [ { id:              'Travel',
                purpose:         #STANDARD,
                type:            #IDENTIFICATION_REFERENCE,
                label:           'Travel',
                position:        10 } ,
                { id:              'Booking',
                purpose:         #STANDARD,
                type:            #LINEITEM_REFERENCE,
                label:           'Booking',
                position:        20,
                targetElement:   '_Booking'} ]
  @UI: { lineItem: [ { position: 10, importance: #HIGH } ],
         identification:[ { position: 10, label: 'Travel' } ],
         selectionField: [ { position: 10 } ] }
  TravelID;
  @UI: { lineItem: [ { position: 15, importance: #HIGH } ],
         identification:[ { position: 20, label: 'Travel' } ],
         selectionField: [ { position: 15 } ] }
  AgencyID;
  @UI: { lineItem: [ { position: 20, importance: #HIGH } ],
         identification:[ { position: 30, label: 'Travel' } ],
         selectionField: [ { position: 20 } ] }
  CustomerID;
  @UI: { lineItem: [ { position: 30, importance: #HIGH } ],
         identification:[ { position: 40, label: 'Travel' } ],
         selectionField: [ { position: 30 } ] }
  BeginDate;
  @UI: { lineItem: [ { position: 40, importance: #HIGH } ],
         identification:[ { position: 50, label: 'Travel' } ],
         selectionField: [ { position: 40 } ] }
  EndDate;
  @UI: { lineItem: [ { position: 50, importance: #HIGH } ],
         identification:[ { position: 60, label: 'Travel' } ] }
  TotalPrice;
  @UI: { lineItem: [ { position: 50, importance: #HIGH } ] }
  Memo;
  @UI: { lineItem: [ { position: 60, importance: #HIGH } ],
         selectionField: [ { position: 60 } ] }
  Status;
}