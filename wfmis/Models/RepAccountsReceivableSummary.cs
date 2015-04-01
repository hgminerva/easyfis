using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepAccountsReceivableSummary
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 CompanyId { get; set; }
        public string Company { get; set; }
        public Int64 CustomerId { get; set; }
        public string Customer { get; set; }
        public decimal BalanceAmount { get; set; }
    }
}