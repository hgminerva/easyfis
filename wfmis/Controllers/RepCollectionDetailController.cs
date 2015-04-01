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
    public class RepCollectionDetailController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepCollectionDetail
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab2DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab2DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab2PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab2BranchId"]);

            var Collections = from c in db.TrnCollectionLines
                              where c.TrnCollection.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                    c.TrnCollection.PeriodId == PeriodId &&
                                    c.TrnCollection.BranchId == BranchId &&
                                   (c.TrnCollection.ORDate >= DateStart && c.TrnCollection.ORDate <= DateEnd)
                              select new Models.RepCollectionDetail
                              {
                                  PeriodId = c.TrnCollection.PeriodId,
                                  Period = c.TrnCollection.MstPeriod.Period,
                                  BranchId = c.TrnCollection.BranchId,
                                  Branch = c.TrnCollection.MstBranch.Branch,
                                  Collection = "(TrnCollectionDetail.aspx?Id=" + c.ORId + ")" + c.TrnCollection.ORNumber + " - " + c.TrnCollection.MstArticle.Article,
                                  ORDate = c.TrnCollection.ORDate.ToShortDateString(),
                                  Account = c.MstAccount.Account,
                                  SINumber = c.TrnSalesInvoice.SINumber,
                                  Particulars = c.Particulars,
                                  PayType = c.MstPayType.PayType,
                                  PayTypeDetails = c.MstPayType.PayType == "Cash" ? "" : "Check No.:" + c.CheckNumber + " Check Date:" + Convert.ToString(c.CheckDate.Day) + "/" + Convert.ToString(c.CheckDate.Month) + "/" + Convert.ToString(c.CheckDate.Year),
                                  Amount = c.Amount
                              };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepCollectionDetailData = Collections.ToList();

            return ReportPaged;
        }
    }
}