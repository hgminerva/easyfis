using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class SysDataTablePager
    {
        public string sEcho { get; set; }
        public int iTotalRecords { get; set; }
        public int iTotalDisplayRecords { get; set; }

        public List<Models.AdminUser> AdminUserData { get; set; }
        public List<Models.MstAccount> MstAccountData { get; set; }
        public List<Models.MstAccountBudgetLine> MstAccountBudgetLineData { get; set; }
        public List<Models.MstAccountCategory> MstAccountCategoryData { get; set; }
        public List<Models.MstAccountType> MstAccountTypeData { get; set; }
        public List<Models.MstAccountCashFlow> MstAccountCashFlowData { get; set; }
        public List<Models.MstArticleBank> MstArticleBankData { get; set; }
        public List<Models.MstArticleCustomer> MstArticleCustomerData { get; set; }
        public List<Models.MstArticleItem> MstArticleItemData { get; set; }
        public List<Models.MstArticleItem> MstArticleItemInventoryData { get; set; }
        public List<Models.MstArticleItemPrice> MstArticleItemPriceData { get; set; }
        public List<Models.MstArticleItemUnit> MstArticleItemUnitData { get; set; }
        public List<Models.MstArticleItemComponent> MstArticleItemComponentData { get; set; }
        public List<Models.MstArticleSupplier> MstArticleSupplierData { get; set; }
        public List<Models.MstCompany> MstCompanyData { get; set; }
        public List<Models.MstDiscount> MstDiscountData { get; set; }
        public List<Models.MstPayType> MstPayTypeData { get; set; }
        public List<Models.MstTax> MstTaxData { get; set; }
        public List<Models.MstTerm> MstTermData { get; set; }
        public List<Models.MstUnit> MstUnitData { get; set; }
        public List<Models.MstUser> MstUserData { get; set; }
        public List<Models.MstUserStaff> MstUserStaffData { get; set; }
        public List<Models.MstUserStaffRole> MstUserStaffRoleData { get; set; }
        public List<Models.RepFSBalanceSheet> RepFSBalanceSheetData { get; set; }
        public List<Models.RepFSIncomeStatement> RepFSIncomeStatementData { get; set; }
        public List<Models.RepFSCashFlowStatement> RepFSCashFlowStatementData { get; set; }
        public List<Models.RepFSTrialBalance> RepFSTrialBalanceData { get; set; }
        public List<Models.RepFSAccountLedger> RepFSAccountLedgerData { get; set; }
        public List<Models.RepAccountsPayable> RepAccountsPayableData { get; set; }
        public List<Models.RepAccountsReceivable> RepAccountsReceivableData { get; set; }
        public List<Models.RepAccountsReceivableSummary> RepAccountsReceivableSummaryData { get; set; }
        public List<Models.RepPurchaseSummary> RepPurchaseSummaryData { get; set; }
        public List<Models.RepPurchaseDetail> RepPurchaseDetailData { get; set; }
        public List<Models.RepPurchaseBook> RepPurchaseBookData { get; set; }
        public List<Models.RepSalesSummary> RepSalesSummaryData { get; set; }
        public List<Models.RepSalesDetail> RepSalesDetailData { get; set; }
        public List<Models.RepSalesBook> RepSalesBookData { get; set; }
        public List<Models.RepCollectionSummary> RepCollectionSummaryData { get; set; }
        public List<Models.RepCollectionDetail> RepCollectionDetailData { get; set; }
        public List<Models.RepCollectionBook> RepCollectionBookData { get; set; }
        public List<Models.RepDisbursementSummary> RepDisbursementSummaryData { get; set; }
        public List<Models.RepDisbursementDetail> RepDisbursementDetailData { get; set; }
        public List<Models.RepDisbursementBook> RepDisbursementBookData { get; set; }
        public List<Models.RepStockIn> RepStockInData { get; set; }
        public List<Models.RepStockOut> RepStockOutData { get; set; }
        public List<Models.RepStockTransfer> RepStockTransferData { get; set; }
        public List<Models.RepStockCard> RepStockCardData { get; set; }
        public List<Models.RepInventory> RepInventoryData { get; set; }
        public List<Models.RepInventoryBook> RepInventoryBookData { get; set; }
        public List<Models.TrnBank> TrnBankData { get; set; }
        public List<Models.TrnBankSummary> TrnBankSummaryData { get; set; }
        public List<Models.TrnCollection> TrnCollectionData { get; set; }
        public List<Models.TrnCollectionLine> TrnCollectionLineData { get; set; }
        public List<Models.TrnDisbursement> TrnDisbursementData { get; set; }
        public List<Models.TrnDisbursementLine> TrnDisbursementLineData { get; set; }
        public List<Models.TrnInventory> TrnInventoryData { get; set; }
        public List<Models.TrnJournal> TrnJournalData { get; set; }
        public List<Models.TrnJournalVoucher> TrnJournalVoucherData { get; set; }
        public List<Models.TrnJournalVoucherLine> TrnJournalVoucherLineData { get; set; }
        public List<Models.TrnPurchaseInvoice> TrnPurchaseInvoiceData { get; set; }
        public List<Models.TrnPurchaseInvoiceLine> TrnPurchaseInvoiceLineData { get; set; }
        public List<Models.TrnPurchaseOrder> TrnPurchaseOrderData { get; set; }
        public List<Models.TrnPurchaseOrderLine> TrnPurchaseOrderLineData { get; set; }
        public List<Models.TrnSalesInvoice> TrnSalesInvoiceData { get; set; }
        public List<Models.TrnSalesInvoiceLine> TrnSalesInvoiceLineData { get; set; }
        public List<Models.TrnSalesOrder> TrnSalesOrderData { get; set; }
        public List<Models.TrnSalesOrderLine> TrnSalesOrderLineData { get; set; }
        public List<Models.TrnStockIn> TrnStockInData { get; set; }
        public List<Models.TrnStockInLine> TrnStockInLineData { get; set; }
        public List<Models.TrnStockOut> TrnStockOutData { get; set; }
        public List<Models.TrnStockOutLine> TrnStockOutLineData { get; set; }
        public List<Models.TrnStockTransfer> TrnStockTransferData { get; set; }
        public List<Models.TrnStockTransferLine> TrnStockTransferLineData { get; set; }
    }
}