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
    public class RepDisbursementBookController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepDisbursementBook
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab3DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab3DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab3PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab3BranchId"]);

            var Disbursements = from c in db.TrnJournals
                                where c.CVId > 0 &&
                                      c.TrnDisbursement.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                      c.TrnDisbursement.PeriodId == PeriodId &&
                                      c.TrnDisbursement.BranchId == BranchId &&
                                     (c.TrnDisbursement.CVDate >= DateStart && c.TrnDisbursement.CVDate <= DateEnd)
                                select new Models.RepDisbursementBook
                                {
                                    PeriodId = c.TrnDisbursement.PeriodId,
                                    Period = c.TrnDisbursement.MstPeriod.Period,
                                    BranchId = c.TrnDisbursement.BranchId,
                                    Branch = c.TrnDisbursement.MstBranch.Branch,
                                    Disbursement = "(TrnDisbursementDetail.aspx?Id=" + c.CVId + ")" + c.TrnDisbursement.CVNumber + " - " + c.TrnDisbursement.MstArticle.Article,
                                    CVDate = c.TrnDisbursement.CVDate.ToShortDateString(),
                                    Account = c.MstAccount.Account,
                                    Article = c.MstArticle.Article,
                                    Particulars = c.Particulars,
                                    DebitAmount = c.DebitAmount,
                                    CreditAmount = c.CreditAmount
                                };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepDisbursementBookData = Disbursements.ToList();

            return ReportPaged;
        }
    }
}