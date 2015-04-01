using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class AdminUser
    {
        public Int64 Id { get; set; }
        public string UserAccountNumber { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public string Address { get; set; }
        public string ContactNumber { get; set; }
        public string EmailAddress { get; set; }
        public Int64 DefaultBranchId { get; set; }
        public string DefaultBranch { get; set; }
        public Int64 DefaultPeriodId { get; set; }
        public string DefaultPeriod { get; set; }
        public bool IsTemplate { get; set; }
        public Int64 TemplateUserId { get; set; }
        public string TemplateUser { get; set; }
        public bool IsLocked { get; set; }
    }
}