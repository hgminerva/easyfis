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

            DateTime AsOfDate = Convert.ToDateTime(parameters["tab1AsOfDate"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab1PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["tab1CompanyId"]);

            // Balance Sheet Entries
            var JournalEntries = from j in db.TrnJournals
                                 where j.MstBranch.MstCompany.MstUser.Id == security.GetCurrentSubscriberUser() &&
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
                                     Account = Convert.ToString(g.Key.MstAccount.Id) + " - " + g.Key.MstAccount.AccountCode + " - " + g.Key.MstAccount.Account,
                                     Amount = g.Sum(a => a.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "Asset" ? (a.DebitAmount - a.CreditAmount) : (a.CreditAmount - a.DebitAmount)),
                                     LEAmount = g.Sum(a => a.MstAccount.MstAccountType.MstAccountCategory.AccountCategory != "Asset" ? (a.CreditAmount - a.DebitAmount) : 0)
                                 };

            var BalanceSheet = JournalEntries; 

            // Retained Earnings
            var RetainedEarningsAccount = from d in db.MstUsers
                                          where d.Id == security.GetCurrentSubscriberUser()
                                          select d;
            if (RetainedEarningsAccount.First().FSIncomeStatementAccountId != null) {
                var IncomeStatement = from d in db.TrnJournals
                                      where d.MstBranch.MstUser.Id == security.GetCurrentSubscriberUser() &&
                                           (d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "INCOME" ||
                                            d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "EXPENSES") &&
                                            d.PeriodId == PeriodId &&
                                            d.MstBranch.MstCompany.Id == CompanyId &&
                                            d.JournalDate <= AsOfDate
                                      group d by new
                                      {
                                          d.MstPeriod,
                                          d.MstBranch.MstCompany,
                                          d.MstAccount,
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
                                          Account = g.Key.MstAccount.AccountCode + " - " + g.Key.MstAccount.Account,
                                          Amount = g.Sum(a => a.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "INCOME" ? (a.CreditAmount - a.DebitAmount) : (a.DebitAmount - a.CreditAmount)),
                                          IEAmount = g.Sum(a => (a.CreditAmount - a.DebitAmount))
                                      };

                if (IncomeStatement.Any())
                {
                    var RetainedEarnings = from d in IncomeStatement
                                           group d by new
                                           {
                                               PeriodId = d.PeriodId,
                                               Period = d.Period,
                                               CompanyId = d.CompanyId,
                                               Company = d.Company
                                           } into g
                                           select new Models.RepFSBalanceSheet
                                           {
                                               PeriodId = g.Key.PeriodId,
                                               Period = g.Key.Period,
                                               CompanyId = g.Key.CompanyId,
                                               Company = g.Key.Company,
                                               AccountCategoryId = RetainedEarningsAccount.First().MstAccount.MstAccountType.MstAccountCategory.Id,
                                               AccountCategory = RetainedEarningsAccount.First().MstAccount.MstAccountType.MstAccountCategory.AccountCategoryCode + " - " + RetainedEarningsAccount.First().MstAccount.MstAccountType.MstAccountCategory.AccountCategory,
                                               AccountTypeCode = RetainedEarningsAccount.First().MstAccount.MstAccountType.AccountTypeCode,
                                               AccountType = RetainedEarningsAccount.First().MstAccount.MstAccountType.AccountType,
                                               AccountId = RetainedEarningsAccount.First().FSIncomeStatementAccountId.Value,
                                               AccountCode = RetainedEarningsAccount.First().MstAccount.AccountCode,
                                               Account = RetainedEarningsAccount.First().MstAccount.AccountCode + " - " + RetainedEarningsAccount.First().MstAccount.Account,
                                               Amount = g.Sum(a => a.IEAmount),
                                               LEAmount = g.Sum(a => a.IEAmount)
                                           };

                    BalanceSheet = (from d in JournalEntries select d).Union
                                   (from d in RetainedEarnings select d);
                }
            }

            // Return Paged Balance Sheet
            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepFSBalanceSheetData = (from d in BalanceSheet select d).ToList();

            return ReportPaged;
        }

    }
}