using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleItemComponent
    {
        public Int64 Line3Id { get; set; }
        public Int64 Line3ArticleId { get; set; }
        public Int64 Line3ComponentArticleId { get; set; }
        public string Line3ComponentArticle { get; set; }
        public decimal Line3Quantity { get; set; }
        public Int64 Line3UnitId { get; set; }
        public string Line3Unit { get; set; }
    }
}