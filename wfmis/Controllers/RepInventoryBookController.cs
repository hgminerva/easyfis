using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class RepInventoryBookController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        public string CreateInventoryReference(Data.TrnJournal journal)
        {
            if (journal.INId > 0)
            {
                return "(TrnStockInDetail.aspx?Id=" + journal.INId + ")" + journal.TrnStockIn.INNumber + " - " + journal.TrnStockIn.Particulars;
            }
            else if (journal.OTId > 0)
            {
                return "(TrnStockOutDetail.aspx?Id=" + journal.OTId + ")" + journal.TrnStockOut.OTNumber + " - " + journal.TrnStockOut.Particulars;
            }
            else if (journal.STId > 0)
            {
                return "(TrnStockTransferDetail.aspx?Id=" + journal.STId + ")" + journal.TrnStockTransfer.STNumber + " - " + journal.TrnStockTransfer.Particulars;
            }
            else
            {
                return "";
            }
        }

        // GET api/RepPurchaseBook
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab6DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab6DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab6PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab6BranchId"]);

            var Inventories = from d in db.TrnJournals
                              where (d.INId > 0 || d.OTId > 0 || d.STId > 0 ) &&
                                     d.TrnPurchaseInvoice.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                     d.TrnPurchaseInvoice.PeriodId == PeriodId &&
                                     d.TrnPurchaseInvoice.BranchId == BranchId &&
                                    (d.JournalDate >= DateStart && d.JournalDate <= DateEnd)
                              select new Models.RepInventoryBook
                              {
                                  PeriodId = d.TrnPurchaseInvoice.PeriodId,
                                  Period = d.TrnPurchaseInvoice.MstPeriod.Period,
                                  BranchId = d.TrnPurchaseInvoice.BranchId,
                                  Branch = d.TrnPurchaseInvoice.MstBranch.Branch,
                                  Inventory = CreateInventoryReference(d),
                                  InventoryDate = d.JournalDate.ToShortDateString(),
                                  Account = d.MstAccount.Account,
                                  Article = d.MstArticle.Article,
                                  Particulars = d.Particulars,
                                  DebitAmount = d.DebitAmount,
                                  CreditAmount = d.CreditAmount
                              };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepInventoryBookData = Inventories.ToList();

            return ReportPaged;
        }
    }
}