using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstTax
    {
        public Int64 Id { get; set; }
        public Int64 UserId { get; set; }
        public string User { get; set; }
        public string TaxCode { get; set; }
        public Int64 TaxTypeId { get; set; }
        public string TaxType { get; set; }
        public decimal TaxRate { get; set; }
        public Int64 AccountId { get; set; }
        public string Account { get; set; }
        public bool IsLocked { get; set; }
        public Int64 CreatedById { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedById { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
    }
}