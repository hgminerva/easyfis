using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnJournalVoucherLine
    {
        public Int64 LineId { get; set; }
        public Int64 LineJVId { get; set; }
        public Int64 LineBranchId { get; set; }
        public string LineBranch { get; set; }
        public Int64 LineAccountId { get; set; }
        public string LineAccount { get; set; }
        public Int64 LineArticleId { get; set; }
        public string LineArticle { get; set; }
        public decimal LineDebitAmount { get; set; }
        public decimal LineCreditAmount { get; set; }
        public string LineParticulars { get; set; }
        public Int64 LinePIId { get; set; }
        public string LinePINumber { get; set; }
        public Int64 LineSIId { get; set; }
        public string LineSINumber { get; set; }  
    }
}