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
    public class SelectDefaultPeriodController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectDefaultPeriod
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            Int64 BranchId = Convert.ToInt64(nvc["BranchId"] == "" ? "0" : nvc["BranchId"]);

            var Periods = from d in data.MstPeriods
                          where d.MstUser.MstBranches.Count(b => b.Id == BranchId) > 0
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