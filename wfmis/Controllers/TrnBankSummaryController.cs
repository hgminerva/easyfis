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
    public class TrnBankSummaryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/TrnBankSummary
        // ======================

        public Models.TrnBankSummary Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            Int64 BankId = Convert.ToInt64(parameters["tab1BankId"]);
            DateTime DateStart = Convert.ToDateTime(parameters["tab1DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab1DateEnd"]);
            decimal BankBalance = Convert.ToDecimal(parameters["tab1BankBalance"]);

            var BankRecords1 = from d in db.TrnBanks
                               where d.BankId == BankId &&
                                     (d.BankDate >= DateStart && d.BankDate <= DateEnd)
                               group d by new
                               {
                                   BankId = d.BankId
                               } into g
                               select new Models.TrnBankSummary
                               {
                                   BankId = g.Key.BankId,
                                   Document = "Bank Balance",
                                   EndingBankBalance = BankBalance,
                                   TotalDepositInTransit = Convert.ToDecimal(0),
                                   TotalOutstandingWithdrawal = Convert.ToDecimal(0),
                                   AdjustedEndingBankBalance = BankBalance,
                                   EndingBookBalance = Convert.ToDecimal(0),
                                   TotalVoucherDebit = Convert.ToDecimal(0),
                                   TotalVoucherCredit = Convert.ToDecimal(0),
                                   AdjustedEndingBookBalance = Convert.ToDecimal(0)
                               };

            var BankRecords2 = from d in db.TrnBanks
                               where d.BankId == BankId &&
                                     d.IsCleared == false &&
                                     d.ORId > 0 &&
                                     (d.BankDate >= DateStart && d.BankDate <= DateEnd)
                               group d by new
                               {
                                   BankId = d.BankId
                               } into g
                               select new Models.TrnBankSummary
                               {
                                   BankId = g.Key.BankId,
                                   Document = "Total Deposit In Transit",
                                   EndingBankBalance = Convert.ToDecimal(0),
                                   TotalDepositInTransit = g.Sum(s=>(s.DebitAmount - s.CreditAmount)),
                                   TotalOutstandingWithdrawal = Convert.ToDecimal(0),
                                   AdjustedEndingBankBalance = g.Sum(s => (s.DebitAmount - s.CreditAmount)),
                                   EndingBookBalance = Convert.ToDecimal(0),
                                   TotalVoucherDebit = Convert.ToDecimal(0),
                                   TotalVoucherCredit = Convert.ToDecimal(0),
                                   AdjustedEndingBookBalance = Convert.ToDecimal(0)
                               };

            var BankRecords3 = from d in db.TrnBanks
                               where d.BankId == BankId &&
                                     d.IsCleared == false &&
                                     d.CVId > 0 &&
                                     (d.BankDate >= DateStart && d.BankDate <= DateEnd)
                               group d by new
                               {
                                   BankId = d.BankId
                               } into g
                               select new Models.TrnBankSummary
                               {
                                   BankId = g.Key.BankId,
                                   Document = "Total Outstanding Withdrawals",
                                   EndingBankBalance = Convert.ToDecimal(0),
                                   TotalDepositInTransit = Convert.ToDecimal(0),
                                   TotalOutstandingWithdrawal = g.Sum(s => (s.DebitAmount - s.CreditAmount)),
                                   AdjustedEndingBankBalance = g.Sum(s => (s.DebitAmount - s.CreditAmount) * -1),
                                   EndingBookBalance = Convert.ToDecimal(0),
                                   TotalVoucherDebit = Convert.ToDecimal(0),
                                   TotalVoucherCredit = Convert.ToDecimal(0),
                                   AdjustedEndingBookBalance = Convert.ToDecimal(0)
                               };

            var BankRecords4 = from d in db.TrnBanks
                               where d.BankId == BankId &&
                                     d.CVId == null &&
                                     (d.BankDate >= DateStart && d.BankDate <= DateEnd)
                               group d by new
                               {
                                   BankId = d.BankId
                               } into g
                               select new Models.TrnBankSummary
                               {
                                   BankId = g.Key.BankId,
                                   Document = "Book Balance",
                                   EndingBankBalance = Convert.ToDecimal(0),
                                   TotalDepositInTransit = Convert.ToDecimal(0),
                                   TotalOutstandingWithdrawal = Convert.ToDecimal(0),
                                   AdjustedEndingBankBalance = Convert.ToDecimal(0),
                                   EndingBookBalance = g.Sum(s => (s.DebitAmount - s.CreditAmount)),
                                   TotalVoucherDebit = Convert.ToDecimal(0),
                                   TotalVoucherCredit = Convert.ToDecimal(0),
                                   AdjustedEndingBookBalance = g.Sum(s => (s.DebitAmount - s.CreditAmount))
                               };

            var BankRecords5 = from d in db.TrnBanks
                               where d.BankId == BankId &&
                                     d.CVId > 0 &&
                                     (d.BankDate >= DateStart && d.BankDate <= DateEnd)
                               group d by new
                               {
                                   BankId = d.BankId
                               } into g
                               select new Models.TrnBankSummary
                               {
                                   BankId = g.Key.BankId,
                                   Document = "Voucher Adjustments",
                                   EndingBankBalance = Convert.ToDecimal(0),
                                   TotalDepositInTransit = Convert.ToDecimal(0),
                                   TotalOutstandingWithdrawal = Convert.ToDecimal(0),
                                   AdjustedEndingBankBalance = Convert.ToDecimal(0),
                                   EndingBookBalance = Convert.ToDecimal(0),
                                   TotalVoucherDebit = g.Sum(s => s.DebitAmount),
                                   TotalVoucherCredit = g.Sum(s => s.CreditAmount),
                                   AdjustedEndingBookBalance = g.Sum(s => (s.DebitAmount - s.CreditAmount))
                               };

            var BankRecords = (from d in BankRecords1 select d).Union
                              (from d in BankRecords2 select d).Union
                              (from d in BankRecords3 select d).Union
                              (from d in BankRecords4 select d).Union
                              (from d in BankRecords5 select d);


            var BankRecordSummary = from d in BankRecords
                                    group d by new
                                    {
                                        BankId = d.BankId
                                    } into g
                                    select new Models.TrnBankSummary
                                    {
                                        BankId = g.Key.BankId,
                                        Document = "Summary",
                                        EndingBankBalance = g.Sum(s => s.EndingBankBalance),
                                        TotalDepositInTransit = g.Sum(s => s.TotalDepositInTransit),
                                        TotalOutstandingWithdrawal = g.Sum(s => s.TotalOutstandingWithdrawal),
                                        AdjustedEndingBankBalance = g.Sum(s => s.AdjustedEndingBankBalance),
                                        EndingBookBalance = g.Sum(s => s.EndingBookBalance),
                                        TotalVoucherDebit = g.Sum(s => s.TotalVoucherDebit),
                                        TotalVoucherCredit = g.Sum(s => s.TotalVoucherCredit),
                                        AdjustedEndingBookBalance = g.Sum(s => s.AdjustedEndingBookBalance)
                                    };
            if (BankRecordSummary.Any())
            {
                return BankRecordSummary.First();
            }
            else
            {
                return new Models.TrnBankSummary();
            }
        }
    }
}