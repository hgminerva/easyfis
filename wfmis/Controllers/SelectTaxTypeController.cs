using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectTaxTypeController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // =====================
        // GET api/SelectTaxType
        // =====================

        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var TaxTypes = from d in data.MstTaxTypes
                           where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                 d.TaxType.Contains(searchTerm == null ? "" : searchTerm)
                           select new Models.SelectObject
                           {
                                id = d.Id,
                                text = d.TaxType
                           };

            Int64 Count = TaxTypes.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = TaxTypes.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}