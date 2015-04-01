using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace wfmis.Models
{
    public class MstUserStaffRole
    {
        public Int64 LineId { get; set; }
        public Int64 LineUserStaffId { get; set; }
        public Int64 LineCompanyId { get; set; }
        public string LineCompany { get; set; }
        public Int64 LinePageId { get; set; }
        public string LinePage { get; set; }
        public bool LineCanAdd { get; set; }
        public bool LineCanSave { get; set; }
        public bool LineCanEdit { get; set; }
        public bool LineCanDelete { get; set; }
        public bool LineCanPrint { get; set; }
        public bool LineCanApprove { get; set; }
        public bool LineCanDisapprove { get; set; }
    }
}