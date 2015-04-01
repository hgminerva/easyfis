using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnSalesInvoiceLine
    {
        public Int64 LineId { get; set; }
        public Int64 LineSIId { get; set; }
        public Int64 LineSOId { get; set; }
        public string LineSONumber { get; set; }
        public Int64 LineItemId { get; set; }
        public string LineItem { get; set; }
        public Int64 LineItemInventoryId { get; set; }
        public string LineItemInventoryNumber { get; set; }
        public string LineParticulars { get; set; }
        public Int64 LineUnitId { get; set; }
        public string LineUnit { get; set; }
        public Int64 LinePriceId { get; set; }
        public string LinePriceDescription { get; set; }
        public decimal LinePrice { get; set; }
        public Int64 LineDiscountId { get; set; }
        public string LineDiscount { get; set; }
        public decimal LineDiscountRate { get; set; }
        public decimal LineDiscountAmount { get; set; }
        public decimal LineNetPrice { get; set; }
        public decimal LineQuantity { get; set; }
        public decimal LineAmount { get; set; }
        public Int64 LineTaxId { get; set; }
        public string LineTax { get; set; }
        public decimal LineTaxRate { get; set; }
        public decimal LineTaxAmount { get; set; }
        public bool LineTaxAmountInclusive { get; set; }
    }
}