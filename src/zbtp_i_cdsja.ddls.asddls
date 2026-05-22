@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View with Association & Joins'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBTP_I_CDSJA
  as select from zbtp_dt_cust as Cust
    inner join zbtp_dt_so as _Head
      on Cust.cust_id = _Head.buyer
    association [0..*] to zbtp_dt_soit as _Item
      on _Head.soid = _Item.soid
      // composition of target_data_source_name as _association_name
{
  key Cust.cust_id      as CustId,
      key _Head.soid    as SalesOrderId,
      Cust.name         as Name,
      Cust.company_name as CompanyName,
      Cust.country      as Country,
      Cust.mobile       as Mobile,

      /* Associations */
      _Item
          // _association_name // Make association public
}
