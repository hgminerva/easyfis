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
    public class RepSalesBookController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepSalesBook
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab3DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab3DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab3PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab3BranchId"]);

            var Sales = from s in db.TrnJournals
                        where s.SIId > 0 &&
                              s.TrnSalesInvoice.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                              s.TrnSalesInvoice.PeriodId == PeriodId &&
                              s.TrnSalesInvoice.BranchId == BranchId &&
                             (s.TrnSalesInvoice.SIDate >= DateStart && s.TrnSalesInvoice.SIDate <= DateEnd)
                        select new Models.RepSalesBook
                        {
                            PeriodId = s.TrnSalesInvoice.PeriodId,
                            Period = s.TrnSalesInvoice.MstPeriod.Period,
                            BranchId = s.TrnSalesInvoice.BranchId,
                            Branch = s.TrnSalesInvoice.MstBranch.Branch,
                            SalesInvoice = "(TrnSalesInvoiceDetail.aspx?Id=" + s.SIId + ")" + s.TrnSalesInvoice.SINumber + " - " + s.TrnSalesInvoice.MstArticle.Article,
                            SIDate = s.TrnSalesInvoice.SIDate.ToShortDateString(),
                            Account = s.MstAccount.Account,
                            Article = s.MstArticle.Article,
                            Particulars = s.Particulars,
                            DebitAmount = s.DebitAmount,
                            CreditAmount = s.CreditAmount
                        };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepSalesBookData = Sales.ToList();

            return ReportPaged;
        }
    }
}