@EndUserText.label: 'Flight Basic View'
-- DCL
@AccessControl.authorizationCheck: #NOT_REQUIRED
-- Metadata
@Metadata:{
 allowExtensions: true,
 ignorePropagatedAnnotations: true
}
-- Data Model
//@VDM.viewType: #BASIC
-- Performance
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #MASTER
}
--- Analytical
@Analytics : {
    dataCategory: #DIMENSION
}
define view entity ZVKS_R_Flight
  as select from /dmo/flight
{
  key carrier_id     as AirlineID,
  key connection_id  as ConnectionID,
  key flight_date    as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price          as Price,
      currency_code  as CurrencyCode,
      plane_type_id  as PlaneTypeID,
      seats_max      as MaximumSeats,
      seats_occupied as OccupiedSeats
}
