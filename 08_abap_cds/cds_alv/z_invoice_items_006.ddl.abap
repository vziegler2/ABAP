@AbapCatalog.sqlViewName: 'Z_ITEMS_006'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Items'
define view Z_INVOICE_ITEMS_006
  as select from sepm_sddl_so_invoice_item
{
  header.buyer.company_name,
  sales_order_invoice_key,
  currency_code,
  gross_amount,
  @EndUserText.quickInfo: 'Paid'
  cast( case header.payment_status when 'P' then 'X'
                                   else ' '
        end as zso_invoice_payment_status ) as payment_status,

  //    Associations
  header
}
where
  currency_code = 'USD'