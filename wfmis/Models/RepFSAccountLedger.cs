using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepFSAccountLedger
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 CompanyId { get; set; }
        public string Company { get; set; }
        public Int64 AccountId { get; set; }
        public string AccountCode { get; set; }
        public string Account { get; set; }
        public Int64 ArticleId { get; set; }
        public string Article { get; set; }
        public string Document { get; set; }
        public Int64 DocumentId { get; set; }
        public string DocumentDate { get; set; }
        public string DocumentNumber { get; set; }
        public string Particulars { get; set; }
        public decimal DebitAmount { get; set; }
        public decimal CreditAmount { get; set; }
    }
}