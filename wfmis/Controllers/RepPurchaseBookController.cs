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
    public class RepPurchaseBookController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepPurchaseBook
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab3DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab3DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab3PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab3BranchId"]);

            var Purchases = from p in db.TrnJournals
                            where p.PIId > 0 &&
                                  p.TrnPurchaseInvoice.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                  p.TrnPurchaseInvoice.PeriodId == PeriodId &&
                                  p.TrnPurchaseInvoice.BranchId == BranchId &&
                                 (p.TrnPurchaseInvoice.PIDate >= DateStart && p.TrnPurchaseInvoice.PIDate <= DateEnd)
                            select new Models.RepPurchaseBook
                            {
                                PeriodId = p.TrnPurchaseInvoice.PeriodId,
                                Period = p.TrnPurchaseInvoice.MstPeriod.Period,
                                BranchId = p.TrnPurchaseInvoice.BranchId,
                                Branch = p.TrnPurchaseInvoice.MstBranch.Branch,
                                PurchaseInvoice = "(TrnPurchaseInvoiceDetail.aspx?Id=" + p.PIId + ")" + p.TrnPurchaseInvoice.PINumber + " - " + p.TrnPurchaseInvoice.MstArticle.Article,
                                PIDate = p.TrnPurchaseInvoice.PIDate.ToShortDateString(),
                                Account = p.MstAccount.Account,
                                Article = p.MstArticle.Article,
                                Particulars = p.Particulars,
                                DebitAmount = p.DebitAmount,
                                CreditAmount = p.CreditAmount
                            };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepPurchaseBookData = Purchases.ToList();

            return ReportPaged;
        }
    }
}