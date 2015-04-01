using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnBank
    {
        public Int64 Id { get; set; }
        public Int64 CVId { get; set; }
        public Int64 ORId { get; set; }
        public Int64 JVId { get; set; }
        public string DocumentNumber { get; set; }
        public string BankDate { get; set; }
        public Int64 BankId { get; set; }
        public string Bank { get; set;}
        public decimal DebitAmount { get; set; }
        public decimal CreditAmount { get; set; }
        public string CheckNumber { get; set; }
        public string CheckDate { get; set; }
        public string CheckBank { get; set; }
        public bool IsCleared { get; set; }
        public string DateCleared { get; set; }
        public string Particulars { get; set; }
        public Int64 CreatedById { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedById { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
    }
}