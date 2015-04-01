using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectBranchController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectBranch
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Branches = from d in data.MstBranches
                           where d.MstUser.Id == secure.GetCurrentUser() &&
                                 d.Branch.Contains(searchTerm == null ? "" : searchTerm)
                           select new Models.SelectObject
                           {
                               id = d.Id,
                               text = d.Branch
                           };

            Int64 Count = Branches.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Branches.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}