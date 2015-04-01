using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnSalesInvoice
    {
        public Int64 Id { get; set; }
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string SINumber { get; set; }
        public string SIManualNumber { get; set; }
        public string SIDate { get; set; }
        public Int64 CustomerId { get; set; }
        public string Customer { get; set; }
        public Int64 TermId { get; set; }
        public string Term { get; set; }
        public string DocumentReference { get; set; }
        public string Particulars { get; set; }
        public Int64 SoldById { get; set; }
        public string SoldBy { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal TotalCollectedAmount { get; set; }
        public decimal TotalDebitAmount { get; set; }
        public decimal TotalCreditAmount { get; set; }
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