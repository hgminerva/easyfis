using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepDisbursementSummary
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public Int64 CVId { get; set; }
        public string CVDate { get; set; }
        public string CVNumber { get; set; }
        public string CVManualNumber { get; set; }
        public Int64 SupplierId { get; set; }
        public string Supplier { get; set; }
        public string Particulars { get; set; }
        public decimal TotalAmount { get; set; }
    }
}