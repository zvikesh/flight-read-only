@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Connection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVKS_R_Connection
  as select from /dmo/connection
  -- Value Tables
  association [1..1] to ZVKS_R_Airline as _Airline on $projection.AirlineID = _Airline.AirlineID
{
  key carrier_id          as AirlineID,
  key connection_id       as ConnectionID,
      airport_from_id     as AirportFromID,
      airport_to_id       as AirportToID,
      departure_time      as DepartureTime,
      arrival_time        as ArrivalTime,
      @Semantics.quantity.unitOfMeasure:'DistanceUnit'
      distance            as Distance,
      distance_unit       as DistanceUnit,

      //Demo Fields:Create Composite and move these fields to it
      'sap-icon://flight' as ImageUrl,
      123                 as IntegerValue,
      //cast ( '0000000001' as zvks_de_contact_id ) as ContactID,
      '0000000001'        as ContactID,

      //Value Tables
      _Airline

}
