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
    public class RepCollectionSummaryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepCollectionSummary
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab1DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab1DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab1PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab1BranchId"]);

            var Collections = from c in db.TrnCollections
                              where c.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                    c.PeriodId == PeriodId &&
                                    c.BranchId == BranchId &&
                                   (c.ORDate >= DateStart && c.ORDate <= DateEnd)
                              select new Models.RepCollectionSummary
                              {
                                PeriodId = c.PeriodId,
                                Period = c.MstPeriod.Period,
                                BranchId = c.BranchId,
                                Branch = c.MstBranch.Branch,
                                ORId = c.Id,
                                ORNumber = "(TrnCollectionDetail.aspx?Id=" + c.Id + ")" + c.ORNumber,
                                ORDate = c.ORDate.ToShortDateString(),
                                ORManualNumber = c.ORManualNumber,
                                CustomerId = c.CustomerId,
                                Customer = c.MstArticle.Article,
                                Particulars = c.Particulars,
                                TotalAmount = c.TotalAmount
                              };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepCollectionSummaryData = Collections.ToList();

            return ReportPaged;
        }
    }
}