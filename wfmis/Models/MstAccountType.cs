﻿using System;
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
        public Int64 AccountCategoryId { get; set; }
        public string AccountCategory { get; set;}
        public bool IsLocked { get; set; }
        public Int64 CreatedById { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDateTime { get; set; }
        public Int64 UpdatedById { get; set; }
        public string UpdatedBy { get; set; }
        public string UpdatedDateTime { get; set; }
    }
}