using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectAccountCategoryController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectAccountCategory
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var AccountCategories = from d in data.MstAccountCategories
                                    where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                          d.AccountCategory.Contains(searchTerm == null ? "" : searchTerm)
                                    select new Models.SelectObject
                                    {
                                       id = d.Id,
                                       text = d.AccountCategory
                                    };

            Int64 Count = AccountCategories.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = AccountCategories.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}