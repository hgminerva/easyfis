using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectAccountController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectAccount
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Accounts = from d in data.MstAccounts
                           where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                 d.Account.Contains(searchTerm == null ? "" : searchTerm)
                           select new Models.SelectObject
                           {
                                id = d.Id,
                                text = d.AccountCode + " - " + d.Account
                           };
            
            Int64 Count = Accounts.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Accounts.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}