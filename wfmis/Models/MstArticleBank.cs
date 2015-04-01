using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleBank
    {
        public Int64 Id { get; set; }
        public Int64 ArticleId { get; set; }
        public Int64 AccountId { get; set; }
        public string Account { get; set; }
        public string BankCode { get; set; }
        public string Bank { get; set; }
        public string BankAccountNumber { get; set; }
        public string Particulars { get; set; }
        public string Address { get; set; }
        public string ContactNumbers { get; set; }
        public string ContactPerson { get; set; }
    }
}