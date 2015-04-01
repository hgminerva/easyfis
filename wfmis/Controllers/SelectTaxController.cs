using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectTaxController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectTax
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Taxes = from d in data.MstTaxes
                        where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                              d.TaxCode.Contains(searchTerm == null ? "" : searchTerm)
                        select new Models.SelectObject
                        {
                            id = d.Id,
                            text = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                                new Models.MstTax
                                {
                                    TaxCode = d.TaxCode,
                                    TaxRate = d.TaxRate,
                                    TaxType = d.MstTaxType.TaxType
                                }
                            )
                        };

            Int64 Count = Taxes.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Taxes.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }

    }
}