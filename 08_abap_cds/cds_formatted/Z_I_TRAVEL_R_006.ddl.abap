@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Model View Entity - Read Only'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_TRAVEL_R_006
  as select from /DMO/I_Travel_U as Travel

  association [1..1] to /DMO/I_Agency   as _Agency       on $projection.AgencyID = _Agency.AgencyID
  association [1..1] to /DMO/I_Customer as _Customer     on $projection.CustomerID = _Customer.CustomerID
  association [0..*] to I_CurrencyText  as _CurrencyText on $projection.CurrencyCode = _CurrencyText.Currency
  composition [0..*] of Z_I_BOOKING_006 as _Booking

{

  key TravelID,
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Agency', element: 'AgencyID'} }]
      @ObjectModel.text.association: '_Agency'
      AgencyID,
      @Consumption.valueHelpDefinition: [{ entity: {name: '/DMO/I_Customer', element: 'CustomerID'} }]
      @ObjectModel.text.association: '_Customer'
      CustomerID,
      concat_with_space(_Customer.Title, _Customer.LastName, 1) as Addressee,
      BeginDate,

      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      @DefaultAggregation: #SUM
      TotalPrice,
      @Semantics.amount.currencyCode: 'CurrencyUSD'
      currency_conversion ( amount => TotalPrice,
                            source_currency => CurrencyCode,
                            round => 'X',
                            target_currency => cast('USD' as abap.cuky(5)),
                            exchange_rate_date => cast('20200429' as abap.dats),
                            error_handling => 'SET_TO_NULL' )   as PriceInUSD,
      cast('USD' as abap.cuky( 5 ))                             as CurrencyUSD,
      @ObjectModel.text.association: '_CurrencyText'
      CurrencyCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Memo,
      Status,
      LastChangedAt,
      /* Associations */
      _Agency,
      _Booking,
      _Currency,
      _Customer,
      _CurrencyText
}