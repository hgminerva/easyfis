using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleSupplier
    {
        public Int64 Id { get; set; }
        public Int64 ArticleId { get; set; }
        public Int64 AccountId { get; set; }
        public string Account { get; set; }
        public string SupplierCode { get; set; }
        public string Supplier { get; set; }
        public string Address { get; set; }
        public string ContactNumbers { get; set; }
        public string ContactPerson { get; set; }
        public string EmailAddress { get; set; }
        public Int64 TermId { get; set; }
        public string Term { get; set; }
        public string TaxNumber { get; set; }
    }
}