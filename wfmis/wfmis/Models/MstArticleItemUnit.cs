using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstArticleItemUnit
    {
        public Int64 Id { get; set; }
        public Int64 ArticleId { get; set; }
        public Int64 UnitId { get; set; }
        public string Unit { get; set; }
        public decimal Multiplier { get; set; }
    }
}