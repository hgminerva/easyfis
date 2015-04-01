using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepPurchaseSummary
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public Int64 PIId { get; set; }
        public string PIDate { get; set; }
        public string PINumber { get; set; }
        public string PIManualNumber { get; set; }
        public Int64 SupplierId { get; set; }
        public string Supplier { get; set; }
        public string Particulars { get; set; }
        public string DocumentReference { get; set; }
        public string Term { get; set; }
        public string DueDate { get; set; }
        public decimal TotalAmount { get; set; }
    }
}