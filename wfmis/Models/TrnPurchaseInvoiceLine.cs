using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnPurchaseInvoiceLine
    {
        public Int64 LineId { get; set; }
        public Int64 LinePIId { get; set; }
        public Int64 LinePOId { get; set; }
        public string LinePONumber { get; set; }
        public Int64 LineItemId { get; set; }
        public string LineItem { get; set; }
        public string LineParticulars { get; set; }
        public Int64 LineUnitId { get; set; }
        public string LineUnit { get; set; }
        public decimal LineCost { get; set; }
        public decimal LineQuantity { get; set; }
        public decimal LineAmount { get; set; }
        public Int64 LineTaxId { get; set; }
        public string LineTax { get; set; }
        public decimal LineTaxRate { get; set; }
        public decimal LineTaxAmount { get; set; }
    }
}