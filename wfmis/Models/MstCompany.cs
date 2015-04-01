using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstCompany
    {
        public Int64 Id { get; set; }
        public string CompanyCode { get; set; }
        public string Company { get; set; }
        public string Address { get; set; }
        public string ContactNumber { get; set; }
        public bool IsLocked { get; set; }
        public Int64 CreatedById { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedById { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
    }
}