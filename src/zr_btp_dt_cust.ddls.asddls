@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBTP_DT_CUST'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_BTP_DT_CUST
  as select from ZBTP_DT_CUST
{
  key cust_id as CustID,
  name as Name,
  company_name as CompanyName,
  country as Country,
  city as City,
  mobile as Mobile,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged,
  @Semantics.user.createdBy: true
  local_changed_by as LocalChangedBy,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy
}
