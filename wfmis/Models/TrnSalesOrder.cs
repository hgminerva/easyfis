using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnSalesOrder
    {
        public Int64 Id { get; set; }
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string SONumber { get; set; }
        public string SOManualNumber { get; set; }
        public string SODate { get; set; }
        public Int64 CustomerId { get; set; }
        public string Customer { get; set; }
        public Int64 TermId { get; set; }
        public string Term { get; set; }
        public string OrderNumber { get; set; }
        public string DateNeeded { get; set; }
        public string Particulars { get; set; }
        public Int64 OrderedById { get; set; }
        public string OrderedBy { get; set; }
        public bool IsClosed { get; set; }
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