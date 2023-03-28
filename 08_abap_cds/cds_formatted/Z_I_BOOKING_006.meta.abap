@Metadata.layer: #CORE

@UI: {
headerInfo: {
typeName: 'Travel',
typeNamePlural: 'Travels',
          title: {
            type: #STANDARD,
            label: 'Travel',
            value: 'TravelID'
                }
          }
      }
annotate view Z_I_BOOKING_006 with

{
  @UI: { lineItem:       [ { position: 10, importance: #HIGH } ],
         identification: [ { position: 10 } ] }
  BookingID;

  @UI: { lineItem:       [ { position: 20, importance: #HIGH } ],
         identification: [ { position: 20 } ] }
  BookingDate;

  @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
         identification: [ { position: 30 } ] }
  AirlineID;

  @UI: { lineItem:       [ { position: 40, importance: #HIGH } ],
         identification: [ { position: 40 } ] }
  ConnectionID;


  @UI: { lineItem:       [ { position: 50, importance: #HIGH } ],
         identification: [ { position: 50 } ] }
  FlightDate;

  @UI: { lineItem:       [ { position: 60, importance: #MEDIUM } ],
         identification: [ { position: 60 } ] }
  Flight_Price;

}