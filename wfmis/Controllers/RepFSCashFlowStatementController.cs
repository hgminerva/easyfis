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
    public class RepFSCashFlowStatementController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepFSCashFlowStatement
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab5DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab5DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab5PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["tab5CompanyId"]);

            var IncomeStatement = from d in db.TrnJournals
                                  where d.MstBranch.MstUser.Id == security.GetCurrentSubscriberUser() &&
                                       (d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "INCOME" ||
                                        d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "EXPENSES") &&
                                        d.PeriodId == PeriodId &&
                                        d.MstBranch.MstCompany.Id == CompanyId &&
                                       (d.JournalDate >= DateStart && d.JournalDate <= DateEnd)
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
            
            var MstAccountCashFlows = from d in db.MstAccountCashFlows
                                      where d.UserId == security.GetCurrentSubscriberUser()
                                      select d;

            var NetIncome = from d in IncomeStatement
                            group d by new
                            {
                                PeriodId = d.PeriodId,
                                Period = d.Period,
                                CompanyId = d.CompanyId,
                                Company = d.Company
                            } into g
                            select new Models.RepFSCashFlowStatement
                            {
                                PeriodId = g.Key.PeriodId,
                                Period = g.Key.Period,
                                CompanyId = g.Key.CompanyId,
                                Company = g.Key.Company,
                                AccountCashFlowCode = MstAccountCashFlows.Where(a => a.AccountCashFlowCode == "100").First().AccountCashFlowCode,
                                AccountCashFlow = "100-" + MstAccountCashFlows.Where(a => a.AccountCashFlowCode == "100").First().AccountCashFlow,
                                AccountTypeCode = "0000",
                                AccountType = "Net Income (Loss)",
                                AccountId = Convert.ToInt64(0),
                                AccountCode = "0000",
                                Account = "Net Income (Loss)",
                                Amount = g.Sum(a => a.IEAmount)
                            };

            var CashFlowStatements = from d in db.TrnJournals
                                        where d.MstBranch.MstUser.Id == security.GetCurrentSubscriberUser() &&
                                            (d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "ASSET" ||
                                            d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "LIABILITY" ||
                                            d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "EQUITY" ||
                                            d.MstAccount.MstAccountType.MstAccountCategory.AccountCategory == "EXPENSES") &&
                                            d.PeriodId == PeriodId &&
                                            d.MstBranch.MstCompany.Id == CompanyId &&
                                            d.MstAccount.AccountCashFlowId > 0 &&
                                            (d.JournalDate >= DateStart && d.JournalDate <= DateEnd)
                                        group d by new
                                        {
                                            d.MstPeriod,
                                            d.MstBranch.MstCompany,
                                            d.MstAccount,
                                        } into g
                                        select new Models.RepFSCashFlowStatement
                                        {
                                            PeriodId = g.Key.MstPeriod.Id,
                                            Period = g.Key.MstPeriod.Period,
                                            CompanyId = g.Key.MstCompany.Id,
                                            Company = g.Key.MstCompany.Company,
                                            AccountCashFlowCode = g.Key.MstAccount.MstAccountCashFlow.AccountCashFlowCode,
                                            AccountCashFlow = g.Key.MstAccount.MstAccountCashFlow.AccountCashFlowCode + "-" + g.Key.MstAccount.MstAccountCashFlow.AccountCashFlow,
                                            AccountTypeCode = g.Key.MstAccount.MstAccountType.AccountTypeCode,
                                            AccountType = g.Key.MstAccount.MstAccountType.AccountType,
                                            AccountId = g.Key.MstAccount.Id,
                                            AccountCode = g.Key.MstAccount.AccountCode,
                                            Account = g.Key.MstAccount.Account,
                                            Amount = g.Sum(a => (a.CreditAmount - a.DebitAmount))
                                        };


            var CashFlowStatementsWithNetIncome = (from d in NetIncome select d).Union
                                                  (from d in CashFlowStatements select d);


            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepFSCashFlowStatementData = (from d in CashFlowStatementsWithNetIncome orderby d.AccountCashFlow, d.AccountCode select d).ToList();

            return ReportPaged;
        }

    }
}