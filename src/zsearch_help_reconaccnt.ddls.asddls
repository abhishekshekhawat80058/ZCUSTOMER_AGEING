@AbapCatalog.sqlViewName: 'ZSEARCHHELP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Recon Account Search Help'
define view ZSEARCH_HELP_RECONACCNT as select from I_OperationalAcctgDocItem
{
    key AccountingDocument,
    CompanyCode
}
