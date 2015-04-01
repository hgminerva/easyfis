using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectStaffController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectStaff
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Staffs = from d in data.MstUserStaffs
                         where d.UserId  == secure.GetCurrentSubscriberUser() &&
                               d.MstUser1.FullName.Contains(searchTerm == null ? "" : searchTerm)
                         orderby d.MstUser1.FullName
                         select new Models.SelectObject
                         {
                            id = d.UserStaffId,
                            text = d.MstUser1.FullName
                         };

            Int64 Count = Staffs.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Staffs.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }

    }
}