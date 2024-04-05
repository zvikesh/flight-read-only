@EndUserText.label: 'Airline Basic View'
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
    dataClass: #MASTER,
    sizeCategory: #L
}
-- Analytical
@Analytics : {
    dataCategory: #DIMENSION
}
-- Value Help
@ObjectModel.representativeKey: 'AirlineID'
define view entity ZVKS_R_Airline
  as select from /dmo/carrier
{
  key carrier_id            as AirlineID,
      name                  as Name,
      currency_code         as CurrencyCode,
      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt
}
