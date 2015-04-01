using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstArticleItemInventoryController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ===========================================
        // GET api/MstArticleItemInventory/5/Inventory
        // ===========================================

        [HttpGet]
        [ActionName("Inventory")]
        public Models.MstArticleItemInventory Get(Int64 Id)
        {
            var ItemInventories = (from d in data.MstArticleItemInventories
                                   where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                         d.MstArticle.MstArticleType.ArticleType == "Item" &&
                                         d.Id == Id
                                   select new Models.MstArticleItemInventory
                                   {
                                        Id = d.Id,
                                        ItemId = d.MstArticle.Id,
                                        Item = d.MstArticle.Article,
                                        INId = d.INId.Value,
                                        STId = d.STId.Value,
                                        InventoryNumber = d.InventoryNumber,
                                        Cost = d.Cost,
                                        UnitId = d.UnitId,
                                        Unit = d.MstUnit.Unit,
                                        TotalQuantityIn = d.TotalQuantityIn,
                                        TotalQuantityOut = d.TotalQuantityOut,
                                        BalanceQuantity = d.BalanceQuantity,
                                        Amount = d.Amount
                                   });

            if (ItemInventories.Any())
            {
                return ItemInventories.First();
            }
            else
            {
                return new Models.MstArticleItemInventory();
            }
        }
    }
}