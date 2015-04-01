using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectItemInventoryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectItemInventory
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, Int64 ItemId, Int64 BranchId)
        {
            var ItemInventories = from d in db.MstArticleItemInventories
                                  where d.MstArticle.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                        d.MstArticle.Id == ItemId && 
                                        d.BranchId == BranchId &&
                                        d.InventoryNumber.Contains(searchTerm == null ? "" : searchTerm)
                                  orderby d.InventoryNumber
                                  select new Models.SelectObject
                                  {
                                     id = d.Id,
                                     text = string.Join(" ", d.InventoryNumber, "-", String.Format("{0:0.00}", d.BalanceQuantity), d.MstUnit.Unit, "@", String.Format("{0:0.00}", d.Cost))
                                  };

            Int64 Count = ItemInventories.Count();
            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = ItemInventories.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }   
    }
}