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
    public class RepCollectionBookController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepCollectionBook
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab3DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab3DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab3PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab3BranchId"]);

            var Collections = from c in db.TrnJournals
                              where c.ORId > 0 &&
                                    c.TrnCollection.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                    c.TrnCollection.PeriodId == PeriodId &&
                                    c.TrnCollection.BranchId == BranchId &&
                                   (c.TrnCollection.ORDate >= DateStart && c.TrnCollection.ORDate <= DateEnd)
                              select new Models.RepCollectionBook
                              {
                                  PeriodId = c.TrnCollection.PeriodId,
                                  Period = c.TrnCollection.MstPeriod.Period,
                                  BranchId = c.TrnCollection.BranchId,
                                  Branch = c.TrnCollection.MstBranch.Branch,
                                  Collection = "(TrnCollectionDetail.aspx?Id=" + c.ORId + ")" + c.TrnCollection.ORNumber + " - " + c.TrnCollection.MstArticle.Article,
                                  ORDate = c.TrnCollection.ORDate.ToShortDateString(),
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
            ReportPaged.RepCollectionBookData = Collections.ToList();

            return ReportPaged;
        }
    }
}