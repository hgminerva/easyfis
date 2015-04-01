using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnJournalVoucher
    {
        public Int64 Id { get; set; }
        public string Period { get; set; }
        public string Branch { get; set; }
        public string JVNumber { get; set; }
        public string JVManualNumber { get; set; }
        public string JVDate { get; set; }
        public string Particulars { get; set; }
        public Int64 PreparedById { get; set; }
        public Int64 CheckedById { get; set; }
        public Int64 ApprovedById { get; set; }
        public string PreparedBy { get; set; }
        public string CheckedBy { get; set; }
        public string ApprovedBy { get; set; }
        public Boolean IsLocked { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedDateTime { get; set; }
    }
}