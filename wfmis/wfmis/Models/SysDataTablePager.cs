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
        public List<Models.MstArticleCustomer> MstArticleCustomerData { get; set; }
        public List<Models.MstArticleItem> MstArticleItemData { get; set; }
        public List<Models.MstArticleItemPrice> MstArticleItemPriceData { get; set; }
        public List<Models.MstArticleItemUnit> MstArticleItemUnitData { get; set; }
        public List<Models.MstArticleSupplier> MstArticleSupplierData { get; set; }
        public List<Models.RepFSBalanceSheet> RepFSBalanceSheetData { get; set; }
        public List<Models.TrnJournalVoucher> TrnJournalVoucherData { get; set; }
        public List<Models.TrnJournalVoucherLine> TrnJournalVoucherLineData { get; set; }
        public List<Models.TrnPurchaseInvoice> TrnPurchaseInvoiceData { get; set; }
        public List<Models.TrnPurchaseInvoiceLine> TrnPurchaseInvoiceLineData { get; set; }
        public List<Models.TrnDisbursement> TrnDisbursementData { get; set; }
    }
}