using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstDiscount
    {
        public Int64 Id { get; set; }
        public Int64 UserId { get; set; }
        public string Discount { get; set; }
        public decimal DiscountRate { get; set; }
        public bool IsTaxLess { get; set; }
        public bool IsLocked { get; set; }
        public Int64 CreatedById { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedById { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
    }
}