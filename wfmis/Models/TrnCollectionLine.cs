using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class TrnCollectionLine
    {
        public Int64 LineId { get; set; }
        public Int64 LineORId { get; set; }
        public Int64 LineAccountId { get; set; }
        public string LineAccount { get; set; }
        public Int64 LineSIId { get; set; }
        public string LineSINumber { get; set; }
        public string LineParticulars { get; set; }
        public decimal LineAmount { get; set; }
        public Int64 LinePayTypeId { get; set; }
        public string LinePayType { get; set; }
        public string LineCheckNumber { get; set; }
        public string LineCheckDate { get; set; }
        public string LineCheckBank { get; set; }
        public Int64 LineBankId { get; set; }
        public string LineBank { get; set; }
    }
}