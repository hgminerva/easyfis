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
    public class RepPurchaseSummaryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepPurchaseSummary
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab1DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab1DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab1PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab1BranchId"]);

            var Purchases = from p in db.TrnPurchaseInvoices
                            where p.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                  p.PeriodId == PeriodId &&
                                  p.BranchId == BranchId &&
                                 (p.PIDate >= DateStart && p.PIDate <= DateEnd)
                                 select new Models.RepPurchaseSummary
                                 {
                                     PeriodId = p.PeriodId,
                                     Period = p.MstPeriod.Period,
                                     BranchId = p.BranchId,
                                     Branch = p.MstBranch.Branch,
                                     PIId = p.Id,
                                     PINumber = "(TrnPurchaseInvoiceDetail.aspx?Id=" + p.Id + ")" + p.PINumber,
                                     PIDate = p.PIDate.ToShortDateString(),
                                     PIManualNumber = p.PIManualNumber,
                                     SupplierId = p.SupplierId,
                                     Supplier = p.MstArticle.Article,
                                     Particulars = p.Particulars,
                                     DocumentReference = p.DocumentReference,
                                     Term = p.MstTerm.Term,
                                     DueDate = p.PIDate.AddDays(Convert.ToInt16(p.MstTerm.NumberOfDays)).ToShortDateString(),
                                     TotalAmount = p.TotalAmount
                                 };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepPurchaseSummaryData = Purchases.ToList();

            return ReportPaged;
        }
    }
}