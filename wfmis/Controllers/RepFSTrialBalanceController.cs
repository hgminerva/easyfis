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
    public class RepFSTrialBalanceController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepFSTrialBalance
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab3DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab3DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab3PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["tab3CompanyId"]);

            var JournalEntries = from j in db.TrnJournals
                                 where j.MstBranch.MstUser.Id == security.GetCurrentSubscriberUser() &&
                                       j.PeriodId == PeriodId &&
                                       j.MstBranch.MstCompany.Id == CompanyId &&
                                      (j.JournalDate >= DateStart && j.JournalDate <= DateEnd)
                                 group j by new
                                 {
                                     j.MstPeriod,
                                     j.MstBranch.MstCompany,
                                     j.MstAccount,
                                 } into g
                                 select new Models.RepFSTrialBalance
                                 {
                                     PeriodId = g.Key.MstPeriod.Id,
                                     Period = g.Key.MstPeriod.Period,
                                     CompanyId = g.Key.MstCompany.Id,
                                     Company = g.Key.MstCompany.Company,
                                     AccountCategoryId = g.Key.MstAccount.MstAccountType.MstAccountCategory.Id,
                                     AccountCategory = g.Key.MstAccount.MstAccountType.MstAccountCategory.AccountCategoryCode + " - " + g.Key.MstAccount.MstAccountType.MstAccountCategory.AccountCategory,
                                     AccountTypeCode = g.Key.MstAccount.MstAccountType.AccountTypeCode,
                                     AccountType = g.Key.MstAccount.MstAccountType.AccountType,
                                     AccountId = g.Key.MstAccount.Id,
                                     AccountCode = g.Key.MstAccount.AccountCode,
                                     Account = Convert.ToString(g.Key.MstAccount.Id) + " - " + g.Key.MstAccount.AccountCode + " - " + g.Key.MstAccount.Account,
                                     DebitAmount = g.Sum(a => a.DebitAmount),
                                     CreditAmount = g.Sum(a => a.CreditAmount)
                                 };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepFSTrialBalanceData = JournalEntries.ToList();

            return ReportPaged;
        }
    }
}