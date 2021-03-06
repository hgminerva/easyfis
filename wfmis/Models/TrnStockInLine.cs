﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnStockInLine
    {
        public Int64 LineId { get; set; }
        public Int64 LineINId { get; set; }
        public Int64 LineItemId { get; set; }
        public string LineItem { get; set; }
        public Int64 LineItemInventoryId { get; set; }
        public string LineItemInventoryNumber { get; set; }
        public string LineParticulars { get; set; }
        public Int64 LineUnitId { get; set; }
        public string LineUnit { get; set; }
        public decimal LineCost { get; set; }
        public decimal LineQuantity { get; set; }
        public decimal LineAmount { get; set; }
        public Int64 LineBaseUnitId { get; set; }
        public string LineBaseUnit { get; set; }
        public decimal LineBaseQuantity { get; set; }
        public decimal LineBaseCost { get; set; }
    }
}