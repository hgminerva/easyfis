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
        public decimal BalanceQuantity { get; set; }
        public Int64 DefaultPriceId { get; set; }
        public string DefaultPriceDescription { get; set; }
        public decimal DefaultPrice { get; set; }
        public decimal DefaultCost { get; set; }
        public Int64 PurchaseTaxId { get; set; }
        public string PurchaseTax { get; set; }
        public decimal PurchaseTaxRate { get; set; }
        public string PurchaseTaxType { get; set; }
        public Int64 SalesTaxId { get; set; }
        public string SalesTax { get; set; }
        public decimal SalesTaxRate { get; set; }
        public string SalesTaxType { get; set; }
        public Int64 PurchaseAccountId { get; set; }
        public string PurchaseAccount { get; set; }
        public Int64 SalesAccountId { get; set; }
        public string SalesAccount { get; set; }
        public Int64 CostAccountId { get; set; }
        public string CostAccount { get; set; }
        public string Remarks { get; set; }
        public Boolean IsAsset { get; set; }
        public string AssetManualNumber { get; set; }
        public Int64 AssetAccountId { get; set; }
        public string AssetAccount { get; set; }
        public string AssetDateAcquired { get; set; }
        public decimal AssetCost { get; set; }
        public decimal AssetLifeInYears { get; set; }
        public decimal AssetSalvageValue { get; set; }
        public Int64 AssetDepreciationAccountId { get; set; }
        public string AssetDepreciationAccount { get; set; }
        public Int64 AssetDepreciationExpenseAccountId { get; set; }
        public string AssetDepreciationExpenseAccount { get; set; }
    }
}