using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleItemPrice
    {
        public Int64 Line1Id { get; set; }
        public Int64 Line1ArticleId { get; set; }
        public string Line1PriceDescription { get; set; }
        public decimal Line1Price { get; set; }
        public decimal Line1MarkUpPercentage { get; set; }
    }
}