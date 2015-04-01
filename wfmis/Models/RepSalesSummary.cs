using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepSalesSummary
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public Int64 SIId { get; set; }
        public string SIDate { get; set; }
        public string SINumber { get; set; }
        public string SIManualNumber { get; set; }
        public Int64 CustomerId { get; set; }
        public string Customer { get; set; }
        public string Particulars { get; set; }
        public string Sales { get; set; }
        public string Term { get; set; }
        public string DueDate { get; set; }
        public decimal TotalAmount { get; set; }
    }
}