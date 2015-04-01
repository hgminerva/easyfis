using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectItemPriceController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectItemPrice
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, Int64 itemId)
        {
            var ItemPrices = from d in db.MstArticleItemPrices
                             where d.MstArticle.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                   d.MstArticle.Id == itemId &&
                                   d.PriceDescription.Contains(searchTerm == null ? "" : searchTerm)
                             orderby d.PriceDescription
                             select new Models.SelectObject
                             {
                                id = d.Id,
                                text = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                                            new Models.MstArticleItemPrice
                                            {
                                                Line1Id = d.Id,
                                                Line1PriceDescription = d.PriceDescription,
                                                Line1Price = d.Price
                                            }
                                       )
                             };

            Int64 Count = ItemPrices.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = ItemPrices.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }        
    }
}