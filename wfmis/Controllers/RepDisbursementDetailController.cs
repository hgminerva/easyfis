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
    public class RepDisbursementDetailController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepDisbursementDetail
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab2DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab2DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab2PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab2BranchId"]);

            var Disbursements = from c in db.TrnDisbursementLines
                                where c.TrnDisbursement.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                      c.TrnDisbursement.PeriodId == PeriodId &&
                                      c.TrnDisbursement.BranchId == BranchId &&
                                     (c.TrnDisbursement.CVDate >= DateStart && c.TrnDisbursement.CVDate <= DateEnd)
                                select new Models.RepDisbursementDetail
                                {
                                    PeriodId = c.TrnDisbursement.PeriodId,
                                    Period = c.TrnDisbursement.MstPeriod.Period,
                                    BranchId = c.TrnDisbursement.BranchId,
                                    Branch = c.TrnDisbursement.MstBranch.Branch,
                                    Disbursement = "(TrnDisbursementDetail.aspx?Id=" + c.CVId + ")" + c.TrnDisbursement.CVNumber + " - " + c.TrnDisbursement.MstArticle.Article,
                                    CVDate = c.TrnDisbursement.CVDate.ToShortDateString(),
                                    Account = c.MstAccount.Account,
                                    PINumber = c.TrnPurchaseInvoice.PINumber,
                                    Particulars = c.Particulars,
                                    Amount = c.Amount
                                };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepDisbursementDetailData = Disbursements.ToList();

            return ReportPaged;
        }
    }
}