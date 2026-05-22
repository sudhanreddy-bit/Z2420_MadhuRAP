
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer (Interface)'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BTP_Cust
  as select from zbtp_dt_cust //composition of target_data_source_name as _association_name
{
  key cust_id       as CustId,
      name          as Name,
      company_name  as CompanyName,
      country       as Country,
      mobile        as Mobile
// _association_name // Make association public      
}
