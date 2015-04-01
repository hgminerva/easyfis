using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectItemUnitController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectItemUnit
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, Int64 itemId)
        {
            var ItemUnits = from d in db.MstArticleItemUnits
                            where d.MstArticle.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                  d.MstArticle.Id == itemId &&
                                  d.MstUnit.Unit.Contains(searchTerm == null ? "" : searchTerm)
                        orderby d.MstUnit.Unit
                        select new Models.SelectObject
                        {
                            id = d.MstUnit.Id,
                            text = d.MstUnit.Unit
                        };

            Int64 Count = ItemUnits.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = ItemUnits.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}