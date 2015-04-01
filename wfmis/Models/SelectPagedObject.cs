using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class SelectPagedObject
    {
        public Int64 Total { get; set; }
        public List<Models.SelectObject> Results { get; set; }
    }
}