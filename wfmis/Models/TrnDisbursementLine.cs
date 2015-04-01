using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnDisbursementLine
    {
        public Int64 LineId { get; set; }
        public Int64 LineCVId { get; set; }
        public Int64 LineAccountId { get; set; }
        public string LineAccount { get; set; }
        public Int64 LinePIId { get; set; }
        public string LinePINumber { get; set; }
        public string LineParticulars { get; set; }
        public decimal LineAmount { get; set; }
        public Int64 LineBranchId { get; set; }
        public string LineBranch { get; set; }
    }
}