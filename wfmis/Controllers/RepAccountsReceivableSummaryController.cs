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
    public class RepAccountsReceivableSummaryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepAccountsReceivableSummary
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime AsOfDate = Convert.ToDateTime(parameters["tab2AsOfDate"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab2PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["tab2CompanyId"]);

            var AccountsReceivableSummary = from d in db.TrnSalesInvoices
                                            where d.MstBranch.MstUser.Id == security.GetCurrentSubscriberUser() &&
                                                  d.PeriodId == PeriodId &&
                                                  d.MstBranch.MstCompany.Id == CompanyId &&
                                                  d.SIDate <= AsOfDate &&
                                                  (d.TotalAmount - d.TotalCollectedAmount + d.TotalDebitAmount - d.TotalCreditAmount) != 0
                                             group d by new 
                                             {
                                                 d.MstPeriod,
                                                 d.MstBranch.MstCompany,
                                                 d.MstArticle
                                             } into g
                                             select new Models.RepAccountsReceivableSummary
                                             {
                                                 PeriodId = g.Key.MstPeriod.Id,
                                                 Period = g.Key.MstPeriod.Period,
                                                 CompanyId = g.Key.MstCompany.Id,
                                                 Company = g.Key.MstCompany.Company,
                                                 CustomerId = g.Key.MstArticle.Id,
                                                 Customer = g.Key.MstArticle.Article,
                                                 BalanceAmount = g.Sum(a=>a.TotalAmount - a.TotalCollectedAmount + a.TotalDebitAmount - a.TotalCreditAmount)
                                             };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepAccountsReceivableSummaryData = AccountsReceivableSummary.ToList();

            return ReportPaged;
        }
    }
}