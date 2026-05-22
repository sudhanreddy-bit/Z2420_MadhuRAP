@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product (Interface) CDS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BTP_Prod
  as select from zbtp_dt_prod //composition of target_data_source_name as _association_name
{
  
  key prod_id as ProdId,
      desct   as Description,
  @Semantics.amount.currencyCode: 'Currency'
      price   as Price,
      currency as Currency
      // _association_name // Make association public
}
