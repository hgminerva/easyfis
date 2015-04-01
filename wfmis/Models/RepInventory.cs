using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepInventory
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string Item { get; set; }
        public string Unit { get; set; }
        public decimal BeginningQuantity { get; set; }
        public decimal TotalQuantityIn { get; set; }
        public decimal TotalQuantityOut { get; set; }
        public decimal EndingQuantity { get; set; }
    }
}