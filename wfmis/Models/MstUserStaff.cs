using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstUserStaff
    {
        public Int64 Id { get; set; }
        public Int64 UserId { get; set; }
        public string User { get; set; }
        public Int64 UserStaffId { get; set; }
        public string UserStaff { get; set; }
        public Int64 RoleId { get; set; }
        public string Role { get; set; }
    }
}