@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View with Association'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBTP_I_CDSASSO
  as select from zbtp_dt_cust as Cust
  /* ASSOCITION uses JOIN on DEMAND */
  /* PER CDS We can have Multiple JOINS But only 1 Association 
  and Association should be atlast*/
  
  /* Better to mention Cardinality, If not mentioned Default is 0..1 */
  association [1..*] to zbtp_dt_so as _Head on Cust.cust_id = _Head.buyer
  // composition of target_data_source_name as _association_name
{
  key Cust.cust_id      as CustId,
      Cust.name         as Name,
      Cust.company_name as CompanyName,
      Cust.country      as Country,
      Cust.mobile       as Mobile,

      /* Association fields (Sales Orders of this Customer) */

      // We can also give a whole Table as below:
      _Head             as SalesOrd
      // _Head.soid           as SalesOrderID,
      //_Head.buyer          as Buyer,
      //_Head.sales_person   as SalesPerson,
      // _Head.sales_timestamp as SalesTimestamp
      //_association_name // Make association public
}
