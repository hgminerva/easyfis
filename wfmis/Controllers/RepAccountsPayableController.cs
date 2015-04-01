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
    public class RepAccountsPayableController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        private decimal ComputeAge(int Age, int Elapsed, decimal Amount)
        {
            decimal returnValue = 0;

            switch (Age)
            {
                case 0:
                    returnValue = Elapsed < 30 ? Amount : 0;
                    break;
                case 1:
                    returnValue = Elapsed >= 30 && Elapsed < 60 ? Amount : 0;
                    break;
                case 2:
                    returnValue = Elapsed >= 60 && Elapsed < 90 ? Amount : 0;
                    break;
                case 3:
                    returnValue = Elapsed >= 90 && Elapsed < 120 ? Amount : 0;
                    break;
                case 4:
                    returnValue = Elapsed >= 120 ? Amount : 0;
                    break;
            }
            return returnValue;
        }

        // GET api/RepAccountsPayable
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime AsOfDate = Convert.ToDateTime(parameters["tab1AsOfDate"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab1PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["tab1CompanyId"]);

            var AccountsPayables = from d in db.TrnPurchaseInvoices
                                   where d.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                         d.PeriodId == PeriodId &&
                                         d.MstBranch.MstCompany.Id == CompanyId &&
                                         d.PIDate <= AsOfDate &&
                                         d.IsLocked == true
                                   select new
                                   {
                                       PeriodId = d.PeriodId,
                                       Period = d.MstPeriod.Period,
                                       CompanyId = d.MstBranch.CompanyId,
                                       Company = d.MstBranch.MstCompany.Company,
                                       SupplierId = d.SupplierId,
                                       Supplier = d.MstArticle.Article,
                                       PIId = d.Id,
                                       PIDate = d.PIDate.ToShortDateString(),
                                       Term = d.MstTerm.Term,
                                       DueDate = d.PIDate.AddDays(Convert.ToInt16(d.MstTerm.NumberOfDays)).ToShortDateString(),
                                       NumberOfDaysFromDueDate = AsOfDate.Subtract(d.PIDate.AddDays(Convert.ToInt16(d.MstTerm.NumberOfDays))).Days,
                                       PINumber = Convert.ToString(d.Id) + " - " + d.PINumber,
                                       DocumentReference = d.DocumentReference,
                                       BalanceAmount = d.TotalAmount -
                                                       (d.TrnDisbursementLines.Where(c => c.PIId == d.Id && c.TrnDisbursement.IsLocked == true && c.TrnDisbursement.CVDate <= AsOfDate).Count() == 0 ? 0 : d.TrnDisbursementLines.Where(c => c.PIId == d.Id && c.TrnDisbursement.IsLocked == true && c.TrnDisbursement.CVDate <= AsOfDate).Sum(c => c.Amount)) +
                                                       (d.TrnJournalVoucherLines.Where(c => c.PIId == d.Id && c.TrnJournalVoucher.IsLocked == true && c.TrnJournalVoucher.JVDate <= AsOfDate).Count() == 0 ? 0 : d.TrnJournalVoucherLines.Where(c => c.PIId == d.Id && c.TrnJournalVoucher.IsLocked == true && c.TrnJournalVoucher.JVDate <= AsOfDate).Sum(c => c.DebitAmount - c.CreditAmount))
                                   };

            var AgedAccountsPayables = from d in AccountsPayables
                                       where d.BalanceAmount != 0
                                       select new Models.RepAccountsPayable
                                       {
                                            PeriodId = d.PeriodId,
                                            Period = d.Period,
                                            CompanyId = d.CompanyId,
                                            Company = d.Company,
                                            SupplierId = d.SupplierId,
                                            Supplier = d.Supplier,
                                            PIId = d.PIId,
                                            PIDate = d.PIDate,
                                            Term = d.Term,
                                            DueDate = d.DueDate,
                                            NumberOfDaysFromDueDate = d.NumberOfDaysFromDueDate,
                                            PINumber = d.PINumber,
                                            DocumentReference = d.DocumentReference,
                                            BalanceAmount = d.BalanceAmount,
                                            CurrentAmount = ComputeAge(0, d.NumberOfDaysFromDueDate, d.BalanceAmount),
                                            Age30Amount = ComputeAge(1, d.NumberOfDaysFromDueDate, d.BalanceAmount),
                                            Age60Amount = ComputeAge(2, d.NumberOfDaysFromDueDate, d.BalanceAmount),
                                            Age90Amount = ComputeAge(3, d.NumberOfDaysFromDueDate, d.BalanceAmount),
                                            Age120Amount = ComputeAge(4, d.NumberOfDaysFromDueDate, d.BalanceAmount)
                                       };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepAccountsPayableData = AgedAccountsPayables.ToList();

            return ReportPaged;
        }
    }
}