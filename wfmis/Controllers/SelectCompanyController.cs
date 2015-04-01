using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectCompanyController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectCompany
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Companies = from d in db.MstCompanies
                            where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                  d.Company.Contains(searchTerm == null ? "" : searchTerm)
                            select new Models.SelectObject
                            {
                               id = d.Id,
                               text = d.Company
                            };

            Int64 Count = Companies.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Companies.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}