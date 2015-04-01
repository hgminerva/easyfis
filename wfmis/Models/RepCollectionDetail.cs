using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepCollectionDetail
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string Collection { get; set; }
        public string ORDate { get; set; }
        public string Account { get; set; }
        public string SINumber { get; set; }
        public string Particulars { get; set; }
        public string PayType { get; set; }
        public string PayTypeDetails { get; set; }
        public decimal Amount { get; set; }
    }
}