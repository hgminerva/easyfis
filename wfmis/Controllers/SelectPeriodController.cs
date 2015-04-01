using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectPeriodController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectPeriod
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Periods = from d in db.MstPeriods
                          where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                  d.Period.Contains(searchTerm == null ? "" : searchTerm)
                          select new Models.SelectObject
                          {
                                id = d.Id,
                                text = d.Period
                          };

            Int64 Count = Periods.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Periods.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}