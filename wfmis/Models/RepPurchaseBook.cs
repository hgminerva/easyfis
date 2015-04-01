using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class RepPurchaseBook
    {
        public Int64 PeriodId { get; set; }
        public string Period { get; set; }
        public Int64 BranchId { get; set; }
        public string Branch { get; set; }
        public string PurchaseInvoice { get; set; }
        public string PIDate { get; set; }
        public string Account { get; set; }
        public string Article { get; set; }
        public string Particulars { get; set; }
        public decimal DebitAmount { get; set; }
        public decimal CreditAmount { get; set; }
    }
}