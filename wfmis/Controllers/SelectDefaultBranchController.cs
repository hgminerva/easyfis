using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectDefaultBranchController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectDefaultBranch
   
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int UserStaffId = Convert.ToInt32(nvc["UserStaffId"]);

            var Branches = from d in data.MstBranches
                           where d.MstCompany.MstUserStaffRoles.Count(s => s.MstUserStaff.UserStaffId == UserStaffId) > 0 
                           select new Models.SelectObject
                           {
                               id = d.Id,
                               text = d.MstCompany.Company + " - " + d.Branch
                           };                                

            Int64 Count = Branches.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Branches.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }        
    }
}