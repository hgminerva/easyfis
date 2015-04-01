using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepStockOut
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string StockOut { get; set; }
        public string OTDate { get; set; }
        public decimal Quantity { get; set; }
        public string Unit { get; set; }
        public string Item { get; set; }
        public string Particulars { get; set; }
        public decimal Cost { get; set; }
        public decimal Amount { get; set; }
    }
}