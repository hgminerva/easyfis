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
    public class RepSalesSummaryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepSalesSummary
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab1DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab1DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab1PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab1BranchId"]);

            var Sales = from s in db.TrnSalesInvoices
                        where s.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                              s.PeriodId == PeriodId &&
                              s.BranchId == BranchId &&
                             (s.SIDate >= DateStart && s.SIDate <= DateEnd)
                        select new Models.RepSalesSummary
                        {
                            PeriodId = s.PeriodId,
                            Period = s.MstPeriod.Period,
                            BranchId = s.BranchId,
                            Branch = s.MstBranch.Branch,
                            SIId = s.Id,
                            SINumber = "(TrnSalesInvoiceDetail.aspx?Id=" + s.Id + ")" + s.SINumber,
                            SIDate = s.SIDate.ToShortDateString(),
                            SIManualNumber = s.SIManualNumber,
                            CustomerId = s.CustomerId,
                            Customer = s.MstArticle.Article,
                            Particulars = s.Particulars,
                            Sales = s.MstUser.FullName,
                            Term = s.MstTerm.Term,
                            DueDate = s.SIDate.AddDays(Convert.ToInt16(s.MstTerm.NumberOfDays)).ToShortDateString(),
                            TotalAmount = s.TotalAmount
                        };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepSalesSummaryData = Sales.ToList();

            return ReportPaged;
        }
    }
}