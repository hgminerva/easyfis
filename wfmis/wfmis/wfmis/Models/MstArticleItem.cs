using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleItem
    {
        public Int64 Id { get; set; }
        public Int64 ArticleId { get; set; }
        public Int64 AccountId { get; set; }
        public string Account { get; set; }
        public string ItemCode { get; set; }
        public string ItemManualCode { get; set; }
        public string BarCode { get; set; }
        public string Item { get; set; }
        public string Category { get; set; }
        public Int64 UnitId { get; set; }
        public string Unit { get; set; }
        public Int64 PurchaseTaxId { get; set; }
        public string PurchaseTax { get; set; }
        public Int64 SalesTaxId { get; set; }
        public string SalesTax { get; set; }
        public Boolean IsAsset { get; set; }
        public string Remarks { get; set; }
    }
}