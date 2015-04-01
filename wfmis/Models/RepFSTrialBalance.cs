using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepFSTrialBalance
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 CompanyId { get; set; }
        public string Company { get; set; }
        public Int64 AccountCategoryId { get; set; }
        public string AccountCategory { get; set; }
        public string AccountTypeCode { get; set; }
        public string AccountType { get; set; }
        public Int64 AccountId { get; set; }
        public string AccountCode { get; set; }
        public string Account { get; set; }
        public decimal DebitAmount { get; set; }
        public decimal CreditAmount { get; set; }
    }
}