using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnJournal
    {
        public Int64 Id { get; set; }
        public Int64 PIId { get; set; }
        public string PINumber { get; set; }
        public Int64 CVId { get; set; }
        public string CVNumber { get; set; }
        public Int64 SIId { get; set; }
        public string SINumber { get; set; }
        public Int64 ORId { get; set; }
        public string ORNumber { get; set; }
        public Int64 INId { get; set; }
        public string INNumber { get; set; }
        public Int64 OTId { get; set; }
        public string OTNumber { get; set; }
        public Int64 JVId { get; set; }
        public string JVNumber { get; set; }
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public string JournalDate { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public Int64 AccountId { get; set; }
        public string Account { get; set; }
        public Int64 ArticleId { get; set; }
        public string Article { get; set; }
        public string Particulars { get; set; }
        public decimal DebitAmount { get; set; }
        public decimal CreditAmount { get; set; }
    }
}