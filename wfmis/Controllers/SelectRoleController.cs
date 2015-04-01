using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectRoleController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectRole
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {
            var Items = from d in data.SysRoles
                        where secure.GetCurrentSubscriberUser() > 0 &&
                              d.Role.Contains(searchTerm == null ? "" : searchTerm)
                        orderby d.Role
                        select new Models.SelectObject
                        {
                            id = d.Id,
                            text = d.Role
                        };

            Int64 Count = Items.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Items.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}