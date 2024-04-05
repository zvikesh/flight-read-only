@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contact'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVKS_R_Contact
  as select from zvks_a_contact
  -- Value Table
  association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country
{

      @ObjectModel.text.element: ['FullName']
  key contact_id                                                                     as ContactID,

      @Semantics.name.fullName: true
      cast(
      concat_with_space(
        title,
        concat_with_space(first_name,last_name,1),
        1 )
      as abap.char(15)                                                             ) as FullName,

      @Semantics.address.street: true
      street                                                                         as Street,

      @Semantics.address.zipCode: true
      postal_code                                                                    as PostalCode,

      @Semantics.address.city: true
      city                                                                           as City,

      @Semantics.address.country: true
      @EndUserText.label: 'Country'
      country_code                                                                   as CountryCode,

      @Semantics.telephone.type: [ #CELL,#WORK ]
      phone_number                                                                   as PhoneNumber,

      @Semantics.eMail.address: true
      @Semantics.eMail.type: [ #WORK ]
      email_address                                                                  as EmailAddress,

      /*Admin Data*/
      @Semantics.user.createdBy: true
      created_by                                                                     as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at                                                                     as CreatedAt,

      @Semantics.user.lastChangedBy: true
      changed_by                                                                     as ChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true //local ETag field --> OData ETag
      changed_at                                                                     as ChangedAt,

      @Consumption.filter.hidden: true
      @Consumption.valueHelpDefault.display: false
      _Country._Text[1: Language = $session.system_language].CountryName             as CountryName,
      _Country
}
