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
    public class RepFSIncomeStatementController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepFSIncomeStatement
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab2DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab2DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab2PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["tab2CompanyId"]);

            var JournalEntries = from j in db.TrnJournals
                                 where j.MstBranch.MstUser.Id == security.GetCurrentSubscriberUser() &&
                                       (j.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "INCOME" ||
                                        j.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "EXPENSES") &&
                                        j.PeriodId == PeriodId &&
                                        j.MstBranch.MstCompany.Id == CompanyId &&
                                       (j.JournalDate >= DateStart && j.JournalDate <= DateEnd)
                                 group j by new
                                 {
                                     j.MstPeriod,
                                     j.MstBranch.MstCompany,
                                     j.MstAccount,
                                 } into g
                                 select new Models.RepFSIncomeStatement
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
                                     Amount = g.Sum(a => a.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "INCOME" ? (a.CreditAmount - a.DebitAmount) : (a.DebitAmount - a.CreditAmount)),
                                     IEAmount = g.Sum(a=>(a.CreditAmount - a.DebitAmount))
                                 };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepFSIncomeStatementData = JournalEntries.ToList();

            return ReportPaged;
        }
    }
}