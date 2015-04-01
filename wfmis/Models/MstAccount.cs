using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstAccount
    {
        public Int64 Id { get; set; }
        public string AccountCode { get; set; }
        public string Account { get; set; }
        public Int64 AccountTypeId { get; set; }
        public string AccountType { get; set; }
        public Int64 AccountCashFlowId { get; set; }
        public string AccountCashFlow { get; set; }
        public bool IsLocked { get; set; }
        public Int64 CreatedById { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedById { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
    }
}