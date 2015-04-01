using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepDisbursementDetail
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string Disbursement { get; set; }
        public string CVDate { get; set; }
        public string Account { get; set; }
        public string PINumber { get; set; }
        public string Particulars { get; set; }
        public decimal Amount { get; set; }
    }
}