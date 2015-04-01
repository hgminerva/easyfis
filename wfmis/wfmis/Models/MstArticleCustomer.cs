using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleCustomer
    {
        public Int64 Id { get; set; }
        public Int64 ArticleId { get; set; }
        public Int64 AccountId { get; set; }
        public string Account { get; set; }
        public string CustomerCode { get; set; }
        public string Customer { get; set; }
        public string Address { get; set; }
        public string ContactNumbers { get; set; }
        public string ContactPerson { get; set; }
        public string EmailAddress { get; set; }
    }
}