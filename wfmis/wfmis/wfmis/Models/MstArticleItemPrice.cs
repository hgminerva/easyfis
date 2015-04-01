using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleItemPrice
    {
        public Int64 Id { get; set; }
        public Int64 ArticleId { get; set; }
        public string PriceDescription { get; set; }
        public decimal Price { get; set; }
    }
}