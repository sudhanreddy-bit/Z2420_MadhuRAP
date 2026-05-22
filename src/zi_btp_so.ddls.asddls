@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order (Interface) CDS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BTP_SO
  as select from zbtp_dt_so
  association [1..1] to ZI_BTP_Cust as _Customer
    on $projection.Buyer  = _Customer.CustId
    // composition of target_data_source_name as _association_name
{
  key soid               as SoId,
      buyer              as Buyer,
      sales_person       as SalesPerson,
      sales_timestamp    as SalesTimestamp,
      sales_manager      as SalesManager,
      approval_timestamp as ApprovalTimestamp,
      created_by         as CreatedBy,
      created_on         as CreatedOn,
      changed_by         as ChangedBy,
      changed_on         as ChangedOn,
      url                as Url,
//     _association_name // Make association public
  /* Associations */
  _Customer
}
