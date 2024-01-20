@EndUserText.label: 'Flight Read Only App'
-- DCL
@AccessControl.authorizationCheck: #NOT_REQUIRED
-- Metadata
@Metadata:{
 allowExtensions: true,
 ignorePropagatedAnnotations: true
}
-- Data Model
//@VDM.viewType: #CONSUMPTION ***Not released on cloud***
-- Performance
@ObjectModel.usageType:{
    serviceQuality: #C,
    dataClass: #MASTER,
    sizeCategory: #L
}
-- Visual Key
@ObjectModel.semanticKey: ['AirlineID','ConnectionID','FlightDate']
-- Enable Fuzzy Search
@Search.searchable: true
-- Header Info (List and Object Page)
@UI.headerInfo: { typeName: 'Flight',
                  typeNamePlural: 'Flights',
                  title:{ value: 'ConnectionID', type: #STANDARD },
                  description: { value: 'FlightDate', type: #STANDARD }
                  }
-- Chart
@UI.chart: [
  //Radial Micro Chart
  {
    qualifier: 'tqRadialChart',
    title: 'Radial Micro Chart',
    chartType: #DONUT,
    measures: ['RadialChartValue'],
    measureAttributes: [
      {
        measure: 'RadialChartValue',
        role: #AXIS_1,
        asDataPoint: true
      }
    ]
  },
  //Harvey Micro Chart
  {
    qualifier: 'tqHarveyChart',
    title: 'Harvey Micro Chart',
    chartType: #PIE,
    measures: ['HarveyChartValue'],
    measureAttributes: [
      {
        measure: 'HarveyChartValue',
        role: #AXIS_1,
        asDataPoint: true
      }
    ]
  }
]
define view entity ZVKS_C_Flight_R
  as select from ZVKS_R_Flight
  association [1] to ZVKS_R_Airline as _Airline on $projection.AirlineID = _Airline.AirlineID
{

      -- Object Page Annotations --

      @UI.facet: [
      /*
            -- Object Page Header: with Grouped Fields
            {
            id              : 'idTitle',
            purpose         : #HEADER,
            type            : #FIELDGROUP_REFERENCE,
            label           : 'Airport Details',
            targetQualifier : 'tqTitle',
            position        : 10
            },
      */

      -- Header: Data Points
      {
      id              : 'idPrice',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqPrice',
      position        : 10
      },
      {
      id              : 'idProgressIndicator',
      purpose         : #HEADER,
      type            : #DATAPOINT_REFERENCE,
      targetQualifier : 'tqProgressIndicator',
      position        : 20
      },
      {
      id              : 'idRadialChart',
      purpose         : #HEADER,
      type            : #CHART_REFERENCE,
      targetQualifier : 'tqRadialChart',
      position        : 30
      },
      {
      id              : 'idHarveyChart',
      purpose         : #HEADER,
      type            : #CHART_REFERENCE,
      targetQualifier : 'tqHarveyChart',
      position        : 40
      }
      ]

      @UI.lineItem: [ { position: 10 } ]
      @Search:{ defaultSearchElement: true, fuzzinessThreshold: 0.7 }
      @ObjectModel.text.association: '_Airline'
  key AirlineID,

      @UI.lineItem: [ { position: 20 } ]
      @EndUserText:{ label: 'Connection ID', quickInfo: 'Connection ID' }
  key ConnectionID,

      @UI.lineItem: [ { position: 30 } ]
  key FlightDate,

      @UI:{ lineItem: [ { position: 40 }],
            dataPoint:{ qualifier: 'tqPrice', title: 'Price' } }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,

      @UI.hidden: true
      CurrencyCode,

      @UI:{ lineItem: [ { position: 50 }] }
      PlaneTypeID,

      @UI:{ lineItem: [ { position: 60 }] }
      @EndUserText:{ label: 'Maximum Seats', quickInfo: 'Maximum Seats' }
      MaximumSeats,

      @UI:{ lineItem: [ { position: 70 }] }
      @EndUserText:{ label: 'Occupied Seats', quickInfo: 'Occupied Seats' }
      OccupiedSeats,


      /*Move to Composite View*/

      @UI:{ dataPoint:{ title: 'Progress Indicator',
                        qualifier: 'tqProgressIndicator',
                        targetValueElement: 'MaximumSeats',
                        visualization: #PROGRESS, //#BULLET_CHART, //#DONUT, //#PROGRESS,
                        criticality: 'CriticalityCode' } }
      OccupiedSeats as ProgIndValue,

      @UI: {
        dataPoint: { qualifier: 'RadialChartValue',      //value will be displayed as a percentage
                     targetValueElement: 'MaximumSeats',
                     criticality: 'CriticalityCode' }
        /*
        ,
        // Search Term #RadialMicroChartTable
        lineItem: [
          {
            type: #AS_CHART,
            label: 'Radial Chart (#RadialMicroChartTable)',
            valueQualifier: 'radialChart',
            position: 110
          }
        ]
        */
      }
      OccupiedSeats as RadialChartValue,

      @UI: {
        dataPoint: { qualifier: 'HarveyChartValue',
                     maximumValue: 1000.00,                   //Threshold value as DecimalFloat
                     valueFormat.numberOfFractionalDigits: 2,
                     criticality: 'CriticalityCode' }
        /*
        ,
        // Search Term #RadialMicroChartTable
        lineItem: [
          {
            type: #AS_CHART,
            label: 'Radial Chart (#RadialMicroChartTable)',
            valueQualifier: 'radialChart',
            position: 110
          }
        ]
        */
      }
      OccupiedSeats as HarveyChartValue,


      //      cast( 45 as abap.int4 ) as RadialChartValue,
      //      cast( 45 as abap.int4 ) as RadialChartValueTarget,


      //Use Calculated Field to derive Criticality
      3             as CriticalityCode,

      _Airline

}
