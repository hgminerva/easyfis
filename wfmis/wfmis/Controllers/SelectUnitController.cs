using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectUnitController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectStaff
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Units = from d in data.MstUnits
                        where d.MstUser.Id == secure.GetCurrentUser() &&
                              d.Unit.Contains(searchTerm == null ? "" : searchTerm)
                        select new Models.SelectObject
                        {
                            id = d.Id,
                            text = d.Unit
                        };

            Int64 Count = Units.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Units.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}