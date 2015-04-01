using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectPageController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ==================
        // GET api/SelectPage
        // ==================

        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {
            var Items = from d in db.SysPages
                        where secure.GetCurrentSubscriberUser() > 0 &&
                              d.Page.Contains(searchTerm == null ? "" : searchTerm)
                        orderby d.Page
                        select new Models.SelectObject
                        {
                            id = d.Id,
                            text = d.Description
                        };

            Int64 Count = Items.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Items.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}