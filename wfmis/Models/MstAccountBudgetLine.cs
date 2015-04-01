using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstAccountBudgetLine
    {
        public Int64 LineId { get; set; }
        public Int64 LineAccountId { get; set; }
        public string LineAccount { get; set; }
        public Int64 LinePeriodId { get; set; }
        public string LinePeriod { get; set; }
        public Int64 LineCompanyId { get; set; }
        public string LineCompany { get; set; }
        public string LineParticulars { get; set; }
        public decimal LineAmount { get; set; }
    }
}