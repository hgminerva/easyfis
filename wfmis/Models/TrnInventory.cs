using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnInventory
    {
        public Int64 Id { get; set; }
        public Int64 INId { get; set; }
        public Int64 OTId { get; set; }
        public Int64 STId { get; set; }
        public string DocumentNumber { get; set; }
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public string InventoryDate { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public Int64 ItemId { get; set; }
        public string Item { get; set; }
        public Int64 InventoryId { get; set; }
        public string InventoryNumber { get; set; }
        public string Particulars { get; set; }
        public Int64 UnitId { get; set; }
        public string Unit { get; set; }
        public decimal Cost { get; set; }
        public decimal QuantityIn { get; set; }
        public decimal QuantityOut { get; set; }
        public decimal Quantity { get; set; }
        public decimal Amount { get; set; }
    }
}