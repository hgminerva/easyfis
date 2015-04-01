using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnDisbursement
    {
        public Int64 Id { get; set; }
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string CVNumber { get; set; }
        public string CVManualNumber { get; set; }
        public string CVDate { get; set; }
        public string Particulars { get; set; }
        public Int64 SupplierId { get; set; }
        public string Supplier { get; set; }
        public Int64 BankId { get; set; }
        public string Bank { get; set; }
        public Int64 PayTypeId { get; set; }
        public string PayType { get; set; }
        public string CheckNumber { get; set; }
        public string CheckDate { get; set; }
        public string CheckPayee { get; set; }
        public decimal TotalAmount { get; set; }
        public bool IsCleared { get; set; }
        public string DateCleared { get; set; }
        public bool IsPrinted { get; set; }
        public Int64 PreparedById { get; set; }
        public string PreparedBy { get; set; }
        public Int64 CheckedById { get; set; }
        public string CheckedBy { get; set; }
        public Int64 ApprovedById { get; set; }
        public string ApprovedBy { get; set; }
        public bool IsLocked { get; set; }
        public Int64 CreatedById { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedById { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
    }
}