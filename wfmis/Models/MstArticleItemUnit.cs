using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleItemUnit
    {
        public Int64 Line2Id { get; set; }
        public Int64 Line2ArticleId { get; set; }
        public Int64 Line2UnitId { get; set; }
        public string Line2Unit { get; set; }
        public decimal Line2Multiplier { get; set; }
    }
}