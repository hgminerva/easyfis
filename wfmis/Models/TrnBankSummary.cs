using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnBankSummary
    {
        public Int64 BankId { get; set; }
        public string Document { get; set; }
        public decimal EndingBankBalance { get; set; }
        public decimal TotalDepositInTransit { get; set; }
        public decimal TotalOutstandingWithdrawal { get; set; }
        public decimal AdjustedEndingBankBalance { get; set; }
        public decimal EndingBookBalance { get; set; }
        public decimal TotalVoucherDebit { get; set; }
        public decimal TotalVoucherCredit { get; set; }
        public decimal AdjustedEndingBookBalance { get; set; }
    }
}