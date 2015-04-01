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
    public class RepDisbursementSummaryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepDisbursementSummary
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab1DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab1DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab1PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab1BranchId"]);

            var Disbursements = from d in db.TrnDisbursements
                                where d.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                      d.PeriodId == PeriodId &&
                                      d.BranchId == BranchId &&
                                     (d.CVDate >= DateStart && d.CVDate <= DateEnd)
                                select new Models.RepDisbursementSummary
                                {
                                  PeriodId = d.PeriodId,
                                  Period = d.MstPeriod.Period,
                                  BranchId = d.BranchId,
                                  Branch = d.MstBranch.Branch,
                                  CVId = d.Id,
                                  CVNumber = "(TrnDisbursementDetail.aspx?Id=" + d.Id + ")" + d.CVNumber,
                                  CVDate = d.CVDate.ToShortDateString(),
                                  CVManualNumber = d.CVManualNumber,
                                  SupplierId = d.SupplierId,
                                  Supplier = d.MstArticle.Article,
                                  Particulars = d.Particulars,
                                  TotalAmount = d.TotalAmount
                                };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepDisbursementSummaryData = Disbursements.ToList();

            return ReportPaged;
        }
    }
}