using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Models
{
    public class MstArticleItemInventory : ApiController
    {
        public Int64 Id { get; set; }
        public Int64 ItemId { get; set; }
        public string Item { get; set; }
        public Int64 INId { get; set; }
        public Int64 STId { get; set; }
        public string InventoryNumber { get; set; }
        public decimal Cost { get; set; }
        public Int64 UnitId { get; set; }
        public string Unit { get; set; }
        public decimal TotalQuantityIn { get; set; }
        public decimal TotalQuantityOut { get; set; }
        public decimal BalanceQuantity { get; set; }
        public decimal Amount { get; set; }
    }
}