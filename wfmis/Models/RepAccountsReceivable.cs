using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepAccountsReceivable
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 CompanyId { get; set; }
        public string Company { get; set; }
        public Int64 CustomerId { get; set; }
        public string Customer { get; set; }
        public Int64 SIId { get; set; }
        public string SIDate { get; set; }
        public string Term { get; set; }
        public string DueDate { get; set; }
        public int NumberOfDaysFromDueDate { get; set; }
        public string SINumber { get; set; }
        public string DocumentReference { get; set; }
        public decimal BalanceAmount { get; set; }
        public decimal CurrentAmount { get; set; }
        public decimal Age30Amount { get; set; }
        public decimal Age60Amount { get; set; }
        public decimal Age90Amount { get; set; }
        public decimal Age120Amount { get; set; }
    }
}