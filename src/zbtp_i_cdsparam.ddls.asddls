@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View with Parameters'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBTP_I_CDSPARAM
  with parameters
  /* To make Paramaeters Optional use Environment.ssytem etc,
  Only Certain Fields can be made Optional, */
  /* Select-Options is not Possible*/
  
    @Environment.systemField: #USER
    p_Country : abap.char(30)
  as select from zbtp_dt_cust as Cust
    association [1..*] to zbtp_dt_so as _Head
      on Cust.cust_id = _Head.buyer
{
  key Cust.cust_id      as CustId,
      Cust.name         as CustName,
      Cust.company_name as CompanyName,
      Cust.country      as Country,
      Cust.mobile       as Mobile,

      $parameters.p_Country as Parameter_Country,

      _Head.soid         as SalesOrderId,
      _Head.buyer        as Buyer,
      _Head.sales_person as SalesPerson
}
where
  Cust.country = $parameters.p_Country
