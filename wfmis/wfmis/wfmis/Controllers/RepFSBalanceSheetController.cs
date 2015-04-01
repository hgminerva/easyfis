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
    public class RepFSBalanceSheetController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepFSBalanceSheet
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime AsOfDate = Convert.ToDateTime(parameters["AsOfDate"]);
            Int64 PeriodId = Convert.ToInt64(parameters["PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["CompanyId"]);

            var JournalEntries = from j in db.TrnJournals
                                 where j.MstBranch.MstCompany.MstUser.Id == security.GetCurrentUser() &&
                                       (j.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "Asset" ||
                                        j.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "Liability" ||
                                        j.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "Equity") &&
                                        j.PeriodId == PeriodId &&
                                        j.MstBranch.MstCompany.Id == CompanyId &&
                                        j.JournalDate <= AsOfDate
                                 group j by new
                                 {
                                     j.MstPeriod,
                                     j.MstBranch.MstCompany,
                                     j.MstAccount,
                                 } into g
                                 select new Models.RepFSBalanceSheet
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
                                    Account = g.Key.MstAccount.AccountCode + " - " + g.Key.MstAccount.Account,
                                    Amount = g.Sum(a=>a.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "Asset" ? (a.DebitAmount - a.CreditAmount) : (a.CreditAmount - a.DebitAmount)),
                                    LEAmount = g.Sum(a=>a.MstAccount.MstAccountType.MstAccountCategory.AccountCategory != "Asset" ? (a.CreditAmount - a.DebitAmount) : 0)
                                 };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepFSBalanceSheetData = JournalEntries.ToList();

            return ReportPaged;
        }

    }
}