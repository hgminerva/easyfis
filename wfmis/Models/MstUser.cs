using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstUser
    {
        public Int64 Id { get; set; }
        public string UserAccountNumber { get; set; }
        public string FullName { get; set; }
        public string Address { get; set; }
        public string ContactNumber { get; set; }
        public string EmailAddress { get; set; }
        public Int64 DefaultBranchId { get; set; }
        public string DefaultBranch { get; set; }
        public Int64 DefaultPeriodId { get; set; }
        public string DefaultPeriod { get; set; }
        public bool IsTemplate { get; set; }
        public string Particulars { get; set; }
        public Int64 FSIncomeStatementAccountId { get; set; }
        public string FSIncomeStatementAccount { get; set; }
        public Int64 SupplierAccountId { get; set; }
        public string SupplierAccount { get; set; }
        public Int64 CustomerAccountId { get; set; }
        public string CustomerAccount { get; set; }
        public Int64 ItemPurchaseAccountId { get; set; }
        public string ItemPurchaseAccount { get; set; }
        public Int64 ItemSalesAccountId { get; set; }
        public string ItemSalesAccount { get; set; }
        public Int64 ItemCostAccountId { get; set; }
        public string ItemCostAccount { get; set; }
        public Int64 ItemAssetAccountId { get; set; }
        public string ItemAssetAccount { get; set; }
        public bool IsAutoInventory { get; set; }
        public Int64 TemplateUserId { get; set; }
        public string TemplateUser { get; set; }
        public string InventoryValuationMethod { get; set; }
        public bool IsLocked { get; set; }
    }
}