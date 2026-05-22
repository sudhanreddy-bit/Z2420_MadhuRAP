@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View with Join Condition'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBTP_I_CDSJOIN
  as select from     zbtp_dt_so   as Head
    right outer join zbtp_dt_cust as Cust on Head.buyer = Cust.cust_id
  // composition of target_data_source_name as _association_name
{
  key Head.soid               as Soid,
      Head.buyer              as Buyer,
      Head.sales_person       as SalesPerson,
      Head.sales_timestamp    as SalesTimestamp,
      Head.approval_timestamp as ApprovalTimestamp,
      Head.created_on         as CreatedOn,
      
      Cust.cust_id            as CustomerID,
      Cust.name               as CustomerName,
      Cust.country            as CustomerCountry,
      Cust.company_name       as CustomerOrg
      //   _association_name // Make association public
}
where
  Cust.country = 'US'
