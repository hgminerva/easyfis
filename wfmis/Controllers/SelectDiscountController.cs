using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectDiscountController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectDiscount
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Discounts = from d in data.MstDiscounts
                            where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                  d.Discount.Contains(searchTerm == null ? "" : searchTerm)
                            select new Models.SelectObject
                            {
                                id = d.Id,
                                text = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                                            new Models.MstDiscount {
                                                Id = d.Id,
                                                Discount = d.Discount,
                                                DiscountRate = d.DiscountRate
                                            }
                                       )
                            };

            Int64 Count = Discounts.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Discounts.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}