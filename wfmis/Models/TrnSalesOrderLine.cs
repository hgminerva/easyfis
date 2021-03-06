﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnSalesOrderLine
    {
        public Int64 LineId { get; set; }
        public Int64 LineSOId { get; set; }
        public Int64 LineItemId { get; set; }
        public string LineItem { get; set; }
        public string LineParticulars { get; set; }
        public Int64 LineUnitId { get; set; }
        public string LineUnit { get; set; }
        public decimal LinePrice { get; set; }
        public decimal LineQuantity { get; set; }
        public decimal LineAmount { get; set; }
    }
}