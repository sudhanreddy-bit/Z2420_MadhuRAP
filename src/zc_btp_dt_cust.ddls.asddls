@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZBTP_DT_CUST'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_BTP_DT_CUST
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_BTP_DT_CUST
  association [1..1] to ZR_BTP_DT_CUST as _BaseEntity on $projection.CUSTID = _BaseEntity.CUSTID
{
  key CustID,
  Name,
  CompanyName,
  Country,
  City,
  Mobile,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChanged,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChanged,
  @Semantics: {
    User.Createdby: true
  }
  LocalChangedBy,
  @Semantics: {
    User.Lastchangedby: true
  }
  LastChangedBy,
  _BaseEntity
}
