using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepStockCard
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string Item { get; set; }
        public string Unit { get; set; }
        public string InventoryDocument { get; set; }
        public string InventoryDate { get; set; }
        public string InventoryNumber { get; set; }
        public decimal BeginningQuantity { get; set; }
        public decimal QuantityIn { get; set; }
        public decimal QuantityOut { get; set; }
        public decimal Quantity { get; set; }
    }
}