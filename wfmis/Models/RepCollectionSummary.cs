using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepCollectionSummary
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public Int64 ORId { get; set; }
        public string ORDate { get; set; }
        public string ORNumber { get; set; }
        public string ORManualNumber { get; set; }
        public Int64 CustomerId { get; set; }
        public string Customer { get; set; }
        public string Particulars { get; set; }
        public decimal TotalAmount { get; set; }
    }
}