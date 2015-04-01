using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstAccount
    {
        public Int64 Id { get; set; }
        public string AccountCode { get; set; }
        public string Account { get; set; }
        public string AccountType { get; set; }
    }
}