@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ageing CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCUSTOMER_AGEING_CDS
  //  provider contract analytical_query

  //define view entity ZCUSTOMER_AGEING_CDS
  with parameters
    @Consumption.defaultValue: '1000'

    COMPANYCODE : bukrs,
    //    @Consumption.defaultValue:#( $session.system_date )
    //    @Semantics.businessDate.at: true
    @Environment.systemField:#USER_DATE
    key_date    : vdm_v_key_date,

    @EndUserText.label: 'Day1'
    @Consumption.defaultValue: '10'
    day1        : int4,

    @EndUserText.label: 'Day2'
    @Consumption.defaultValue: '20'
    day2        : int4,
    @EndUserText.label: 'Day3'
    @Consumption.defaultValue: '30'
    day3        : int4,
    @EndUserText.label: 'Day4'
    @Consumption.defaultValue: '40'
    day4        : int4,
    @EndUserText.label: 'Day5'
    @Consumption.defaultValue: '50'
    day5        : int4,
    @EndUserText.label: 'Day6'
    @Consumption.defaultValue: '60'
    day6        : int4,

    @EndUserText.label: 'Above Day6'
    @Consumption.defaultValue: '70'
    day7        : int4

  as select from    I_OperationalAcctgDocItem as a
    inner join      I_Customer                as b on(
      b.Customer = a.Customer
    )
    inner join      I_JournalEntry            as c on(
      c.AccountingDocument = a.AccountingDocument
      and c.FiscalYear     = a.FiscalYear
      and c.CompanyCode    = a.CompanyCode

    )
    left outer join I_BillingDocumentBasic    as d on(
      d.BillingDocument = a.BillingDocument
    )

    inner join      I_CustomerCompany         as e on(
      e.Customer        = a.Customer
      and e.CompanyCode = a.CompanyCode
    )
    
    
    
//    left outer join I_BillingDocument  as f on ( f.BillingDocument = d.BillingDocument)    
    
    
    

{
        @UI.lineItem      : [{ position: 1 }]
        @Consumption.valueHelpDefinition: [
       { entity:  { name:    'I_Customer_VH',
                    element: 'Customer' }
       }]
        //        @Consumption.valueHelpDefinition: [{ entity :{ element : 'CUSTOMER' , name : 'I_CUSTOMER_VH' }  }]
  key   a.Customer,

        @UI.lineItem      : [{ position: 2 }]
  key   b.CustomerName,
        @UI.lineItem      : [{ position: 3 }]
  key   a.PostingDate,
        @UI.lineItem      : [{ position: 4 }]
  key   a.BillingDocument,
        @UI.lineItem      : [{ position: 5 }]
  key   a.AccountingDocument,
        @UI.lineItem      : [{ position: 6 }]
  key   a.AccountingDocumentType,
        @UI.lineItem      : [{ position: 7 }]
  key   c.DocumentReferenceID,
        @UI.lineItem      : [{ position: 8 }]
        a.Reference2IDByBusinessPartner,
        @UI.lineItem      : [{ position: 9 }]

        a.NetDueDate,
        @UI.lineItem      : [{ position: 10 }]
        //      dats_days_between(  d.BillingDocumentDate ,$parameters.key_date ) as Zdays,
        dats_days_between( a.PostingDate ,$parameters.key_date ) as Zdays,
        @UI.lineItem      : [{ position: 11 }]
        a.CompanyCodeCurrency,
        a.TransactionCurrency,
        @UI.lineItem      : [{ position: 12 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        a.AmountInCompanyCodeCurrency,
        @UI.lineItem      : [{ position: 13 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        //      @EndUserText.label: 'Day1'
        @EndUserText.label: '0-10'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day1
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as zday1,
        @UI.lineItem      : [{ position: 14 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @EndUserText.label: '11-20'
        //      @EndUserText.label: 'Day2'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day1 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day2
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as zday2,
        @UI.lineItem      : [{ position: 15 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @EndUserText.label: '21-30'
        //      @EndUserText.label: 'Day3'

        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day2 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day3
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as zday3,
        @UI.lineItem      : [{ position: 16 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @EndUserText.label: '31-40'
        //      @EndUserText.label: 'Day4'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day3 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day4
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as zday4,
        @UI.lineItem      : [{ position: 17 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @EndUserText.label: '41-50'
        //      @EndUserText.label: 'Day5'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day4 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day5
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as zday5,
        @AnalyticsDetails.query.axis: #ROWS
        @UI.textArrangement: #TEXT_LAST
        @EndUserText.label: '51-60'
        //      @EndUserText.label: 'Day6'
        @UI.lineItem      : [{ position: 18 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Consumption.dynamicLabel: { label : '&1' ,
                                 binding : [ { index : 1 , parameter : 'day1'  } ] }
        //        case when
        //        dats_days_between(  d.BillingDocumentDate ,$parameters.key_date ) > $parameters.day6
        //        then  a.AmountInCompanyCodeCurrency
        //        else null
        //        end                                                       as zday6,

        case when
        dats_days_between(  a.PostingDate ,$parameters.key_date ) > $parameters.day5 and
        dats_days_between(  a.PostingDate ,$parameters.key_date ) <= $parameters.day6
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as zday6,

        @AnalyticsDetails.query.axis: #ROWS
        @UI.textArrangement: #TEXT_LAST
        @EndUserText.label: '61-70'
        @UI.lineItem      : [{ position: 18 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Consumption.dynamicLabel: { label : '&1' ,
                                 binding : [ { index : 1 , parameter : 'day1'  } ] }
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day6 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day7
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as zday7,


        // """""""" adding
        @AnalyticsDetails.query.axis: #ROWS
        @UI.textArrangement: #TEXT_LAST
        @EndUserText.label: 'Above Day 70'
        @UI.lineItem      : [{ position: 19 }]
        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Consumption.dynamicLabel: { label : '&1' ,
                                 binding : [ { index : 2, parameter : 'day1'  } ] }
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day7
        then  a.AmountInCompanyCodeCurrency
        else null
        end                                                      as abovezday7,

        // """""""" adding

        // @Consumption.valueHelpDefinition: [
        //        { entity:  { name:    'I_ChartOfAccountsStdVH',
        //                     element: 'ChartOfAccounts' }
        //                     }]

        //@Consumption.valueHelpDefinition:
        //[{entity: {name: 'ZSEARCH_HELP_RECONACCNT' ,element: 'ReconciliationAccount'}  }]

        e.ReconciliationAccount,
        
        @UI.lineItem      : [{ position: 20 }]
//        @Aggregation.default: #SUM
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        a.AmountInTransactionCurrency,
        
//////////

 @UI.lineItem      : [{ position: 21 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        //      @EndUserText.label: 'Day1'
        @EndUserText.label: '0-10(AmountInTransactionCurrency)'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day1
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as zday1_TransCurr,
        @UI.lineItem      : [{ position: 22 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @EndUserText.label: '11-20(AmountInTransactionCurrency)'
        //      @EndUserText.label: 'Day2'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day1 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day2
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as zday2_TransCurr,
        @UI.lineItem      : [{ position: 23 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @EndUserText.label: '21-30(AmountInTransactionCurrency)'
        //      @EndUserText.label: 'Day3'

        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day2 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day3
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as zday3_TransCurr,
        @UI.lineItem      : [{ position: 24 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @EndUserText.label: '31-40(AmountInTransactionCurrency)'
        //      @EndUserText.label: 'Day4'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day3 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day4
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as zday4_TransCurr,
        @UI.lineItem      : [{ position: 25 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @EndUserText.label: '41-50(AmountInTransactionCurrency)'
        //      @EndUserText.label: 'Day5'
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day4 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day5
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as zday5_TransCurr,
        @AnalyticsDetails.query.axis: #ROWS
        @UI.textArrangement: #TEXT_LAST
        @EndUserText.label: '51-60(AmountInTransactionCurrency)'
        //      @EndUserText.label: 'Day6'
        @UI.lineItem      : [{ position: 26 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @Consumption.dynamicLabel: { label : '&1' ,
                                 binding : [ { index : 1 , parameter : 'day1'  } ] }
        //        case when
        //        dats_days_between(  d.BillingDocumentDate ,$parameters.key_date ) > $parameters.day6
        //        then  a.AmountInCompanyCodeCurrency
        //        else null
        //        end                                                       as zday6,

        case when
        dats_days_between(  a.PostingDate ,$parameters.key_date ) > $parameters.day5 and
        dats_days_between(  a.PostingDate ,$parameters.key_date ) <= $parameters.day6
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as zday6_TransCurr,

        @AnalyticsDetails.query.axis: #ROWS
        @UI.textArrangement: #TEXT_LAST
        @EndUserText.label: '61-70(AmountInTransactionCurrency)'
        @UI.lineItem      : [{ position: 27 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @Consumption.dynamicLabel: { label : '&1' ,
                                 binding : [ { index : 1 , parameter : 'day1'  } ] }
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day6 and
        dats_days_between( a.PostingDate ,$parameters.key_date ) <= $parameters.day7
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as zday7_TransCurr,


        // """""""" adding
        @AnalyticsDetails.query.axis: #ROWS
        @UI.textArrangement: #TEXT_LAST
        @EndUserText.label: 'Above Day 70(AmountInTransactionCurrency)'
        @UI.lineItem      : [{ position: 28 }]
//        @Aggregation.default: #SUM
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
        @Consumption.dynamicLabel: { label : '&1' ,
                                 binding : [ { index : 2, parameter : 'day1'  } ] }
        case when
        dats_days_between( a.PostingDate ,$parameters.key_date ) > $parameters.day7
        then  a.AmountInTransactionCurrency
        else null
        end                                                      as abovezday7_TransCurr,




  
  
  
////////        
        
        @UI.lineItem             : [{ position: 29 }]
      @UI.identification       : [{position: 21}]
      @EndUserText.label       : 'lc_number'
      d.YY1_LCNo_BDH

}
where
       a.FinancialAccountType       =  'D'
  and  c.IsReversal                 =  ''
  and  c.IsReversed                 =  ''
  and  a.SpecialGLCode              <> 'F'
  and(
       a.ClearingAccountingDocument =  ''
    or a.ClearingDate               > $parameters.key_date
  )
  and  a.CompanyCode                = $parameters.COMPANYCODE
  and  a.PostingDate                <= $parameters.key_date
//  and e.ReconciliationAccount      =  e.ReconciliationAccount
