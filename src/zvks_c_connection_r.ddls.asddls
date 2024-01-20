@EndUserText.label: 'Flight Connections'
-- DCL
@AccessControl.authorizationCheck: #NOT_REQUIRED
-- Metadata
@Metadata:{
 allowExtensions: true,
 ignorePropagatedAnnotations: true
}
-- Data Model
//@VDM.viewType: #CONSUMPTION
-- Performance
@ObjectModel.usageType:{
    serviceQuality: #C,
    dataClass: #MASTER,
    sizeCategory: #L
}
-- Visual Key
@ObjectModel.semanticKey: ['AirlineID', 'ConnectionID']
-- Enable Fuzzy Search
@Search.searchable: true
-- Header Info (List and Object Page)
@UI.headerInfo: { typeName: 'Flight Connection',
                  typeNamePlural: 'Flight Connections',
                  imageUrl: 'ImageUrl',
                  title:{ value: 'AirlineID', type: #STANDARD },
                  description: { value: '_Airline.Name', type: #STANDARD }
                  }
define view entity ZVKS_C_Connection_R
  as select from ZVKS_R_Connection
  //Associations for Navigation
  association [1..*] to ZVKS_C_Flight_R as _FlightDetails  on  $projection.AirlineID    = _FlightDetails.AirlineID
                                                           and $projection.ConnectionID = _FlightDetails.ConnectionID

  //Contact Card - Required to be added to Service Definition for Exposure
  association [0..1] to ZVKS_R_CONTACT  as _AirlineContact on  $projection.ContactID = _AirlineContact.ContactID

  //Text Associations
  association [1..1] to ZVKS_R_Airline  as _Airline        on  $projection.AirlineID = _Airline.AirlineID
  association [1..1] to /DMO/I_Airport  as _AirportFrom    on  $projection.AirportFromID = _AirportFrom.AirportID
  association [1..1] to /DMO/I_Airport  as _AirportTo      on  $projection.AirportFromID = _AirportTo.AirportID
{

      -- Object Page Annotations --

      @UI.facet: [
      -- Header: Grouped Fields
      {
      id              : 'idTitle',
      purpose         : #HEADER,
      type            : #FIELDGROUP_REFERENCE,
      label           : 'Airport Details',
      targetQualifier : 'tqTitle',
      position        : 10
      },

      -- Header: Data Points
      {
      id              : 'idConnection',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqConnection',
      position        : 20
      },
      {
      id              : 'idDepartureTime',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqDepartureTime',
      position        : 30
      },
      {
      id              : 'idArrivalTime',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqArrivalTime',
      position        : 40
      },
      {
      id              : 'idAirlineRating',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'RatingValue',
      position        : 40
      },

      -- Facet: Standard Identification Facet
      {
      id              : 'idIdentification',
      purpose         : #STANDARD,
      type            : #IDENTIFICATION_REFERENCE,
      label           : 'Default Identification Facet',
      position        : 10 } ,

      -- Facet: Header Facet without Sub Groups
      {
      id              : 'idHeaderFacetWithoutSubGroups',
      label           : 'Header Facet without Sub Groups',
      type            : #FIELDGROUP_REFERENCE,
      targetQualifier : 'tqHeaderFacetWithoutSubGroups',
      position        : 20
      },

      -- Facet: Header Facet with Sub Groups
      {
      id              : 'idHeaderFacetWithSubGroups',
      label           : 'Header Facet with  Sub Groups',
      type            : #COLLECTION,
      position        : 30
      },
      {
      parentId        : 'idHeaderFacetWithSubGroups',
      id              : 'idHeaderKey',
      label           : 'Header Key Details',
      type            : #FIELDGROUP_REFERENCE,
      targetQualifier : 'tqHeaderKey'
      },
      {
      parentId        : 'idHeaderFacetWithSubGroups',
      id              : 'idAirportDetails',
      label           : 'Airport Details',
      type            : #FIELDGROUP_REFERENCE,
      targetQualifier : 'tqAirportDetails'
      },
      {
      parentId        : 'idHeaderFacetWithSubGroups',
      id              : 'idTimingDetails',
      label           : 'Timing Details',
      type            : #FIELDGROUP_REFERENCE,
      targetQualifier : 'tqTimingDetails'
      },

      -- Facet: Line Item Facet
      {
      id              : 'idItemFlight',
      purpose         : #STANDARD,
      type            : #LINEITEM_REFERENCE,
      label           : 'Item Table Facet',
      position        : 40,
      targetElement   : '_FlightDetails'
      }]

      @Search: {defaultSearchElement: true, fuzzinessThreshold: 0.7}
      @UI:{ lineItem: [ { position: 10 }],
            identification:[ { position: 10 }],
            fieldGroup: [{ qualifier: 'tqHeaderFacetWithoutSubGroups', position: 10 },
                         { qualifier: 'tqHeaderKey', position: 10 }]}
      @ObjectModel.text.association: '_Airline'
      @Consumption.valueHelpDefinition: [
      { entity: {name: '/DMO/I_Carrier_StdVH', element: 'AirlineID' }, useForValidation: true } ]
  key AirlineID,

      @Search: {defaultSearchElement: true, fuzzinessThreshold: 0.7}
      @UI:{ lineItem: [ { position: 20 }],
            identification:[ { position: 20 }],
            dataPoint: { qualifier: 'tqConnection', title: 'Connection ID' },
            fieldGroup: [{ qualifier: 'tqHeaderFacetWithoutSubGroups', position: 20 },
                         { qualifier: 'tqHeaderKey', position: 20 }]}
      @EndUserText:{ label: 'Connection ID', quickInfo: 'Connection ID' }
  key ConnectionID,

      @Search: {defaultSearchElement: true, fuzzinessThreshold: 0.7}
      @UI:{ lineItem: [ { position: 30, importance: #LOW }],
            selectionField: [{ position: 10 }],
            identification:[ { position: 30 }],
            fieldGroup: [{ qualifier: 'tqTitle', position: 20 },
                         { qualifier: 'tqHeaderFacetWithoutSubGroups', position: 30 },
                         { qualifier: 'tqAirportDetails', position: 10 }]}
      @Consumption.valueHelpDefinition: [
      { entity: {name: '/DMO/I_Airport_StdVH', element: 'AirportID' }, useForValidation: true }]
      @EndUserText:{ label: 'From Airport', quickInfo: 'From Airport' }
      @ObjectModel.text.association: '_AirportFrom'
      AirportFromID,

      @Search: {defaultSearchElement: true, fuzzinessThreshold: 0.7}
      @UI:{ lineItem: [ { position: 40, importance: #LOW }],
            selectionField: [{ position: 20 }],
            identification:[ { position: 40 }],
            fieldGroup: [{ qualifier: 'tqTitle', position: 30 },
                         { qualifier: 'tqHeaderFacetWithoutSubGroups', position: 40 },
                         { qualifier: 'tqAirportDetails', position: 20 }]}
      @Consumption.valueHelpDefinition: [
      { entity: {name: '/DMO/I_Airport_StdVH', element: 'AirportID' }, useForValidation: true }]
      @EndUserText:{ label: 'Airport To', quickInfo: 'Airport To' }
      @ObjectModel.text.association: '_AirportTo'
      AirportToID,

      @UI:{ lineItem: [ { position: 50, criticality: 'Red', criticalityRepresentation: #WITHOUT_ICON }],
            dataPoint: { qualifier: 'tqDepartureTime', title: 'Departure Time', criticality: 'Red' },
            identification:[ { position: 50 }],
            fieldGroup: [{ qualifier: 'tqHeaderFacetWithoutSubGroups', position: 50 },
                         { qualifier: 'tqTimingDetails', position: 10 }]}
      @EndUserText:{ label: 'Departure Time', quickInfo: 'Departure Time' }
      DepartureTime,

      @UI:{ lineItem: [ { position: 60, criticality: 'Green', criticalityRepresentation: #WITHOUT_ICON }],
            dataPoint: { qualifier: 'tqArrivalTime', title: 'Arrival Time', criticality: 'Green' },
            identification:[ { position: 60 }],
            fieldGroup: [{ qualifier: 'tqHeaderFacetWithoutSubGroups', position: 60 },
                         { qualifier: 'tqTimingDetails', position: 20 }]}
      @EndUserText:{ label: 'Arrival Time', quickInfo: 'Arrival Time' }
      ArrivalTime,

      @UI:{ lineItem: [ { position: 70 }],
            identification:[ { position: 70 }],
            fieldGroup: [{ qualifier: 'tqHeaderFacetWithoutSubGroups', position: 70 }]}
      @EndUserText:{ label: 'Distance', quickInfo: 'Distance' }
      //@Semantics.quantity.unitOfMeasure: 'DistanceUnit'           -- Data Element correction required
      Distance,

      @UI:{ lineItem: [ { position: 80 }],
            identification:[ { position: 80 }],
            fieldGroup: [{ qualifier: 'tqHeaderFacetWithoutSubGroups', position: 80 }]}
      @EndUserText:{ label: 'Distance Unit', quickInfo: 'Distance Unit' }
      DistanceUnit,

      /*--- Demo Feilds ---*/
      @UI:{ lineItem: [ { position: 90, type: #AS_CONTACT, value: '_AirlineContact', label: 'Airline Contact' }],
            identification:[ { position: 90, type: #AS_CONTACT, value: '_AirlineContact', label: 'Airline Contact' }] }
      @EndUserText:{ label: 'Airline Contact', quickInfo: 'Airline Contact Card' }
      @Consumption.filter.hidden: true
      ContactID,

      @UI.lineItem: [{
        cssDefault.width: '5em',
        position: 01,
        importance: #HIGH,
        label: 'Flight Image'
      }]
      @Semantics.imageUrl: true
      ImageUrl,

      @UI:{ lineItem: [{ position: 100, type: #AS_DATAPOINT, label: 'Airline Rating' }],
            dataPoint:{ qualifier: 'RatingValue', targetValue: 5, visualization: #RATING, title: 'Airline Rating' } }
      case AirlineID
      when 'AA' then 4.3
      when 'AZ' then 4.5
      when 'LH' then 3.9
      when 'SQ' then 5
      when 'UA' then 4.1
      else 0 end as RatingValue,


      3          as Green,
      1          as Red,

      /*--- Associations for Navigation ---*/
      _FlightDetails,

      /*--- Contact Card ---*/
      _AirlineContact,

      /*--- Text Associations ---*/
      _Airline,
      _AirportFrom,
      _AirportTo

}
