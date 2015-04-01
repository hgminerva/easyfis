using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectAccountTypeController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectAccountType
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var AccountTypes = from d in data.MstAccountTypes
                               where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                     d.AccountType.Contains(searchTerm == null ? "" : searchTerm)
                               select new Models.SelectObject
                               {
                                   id = d.Id,
                                   text = d.AccountType
                               };

            Int64 Count = AccountTypes.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = AccountTypes.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}