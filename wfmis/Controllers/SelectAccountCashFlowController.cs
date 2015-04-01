using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectAccountCashFlowController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectAccountCashFlow
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var AccountCashFlows = from d in data.MstAccountCashFlows
                                   where d.UserId == secure.GetCurrentSubscriberUser() &&
                                         d.AccountCashFlow.Contains(searchTerm == null ? "" : searchTerm)
                                   select new Models.SelectObject
                                   {
                                       id = d.Id,
                                       text = d.AccountCashFlow
                                   };

            Int64 Count = AccountCashFlows.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = AccountCashFlows.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}