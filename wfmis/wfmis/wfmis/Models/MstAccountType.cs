using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstAccountType
    {
        public Int64 Id { get; set; }
        public string AccountTypeCode { get; set; }
        public string AccountType { get; set; }
        public string AccountCategory { get; set;}
    }
}