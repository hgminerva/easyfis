using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using wfmis.Models;

namespace wfmis.Controllers
{
    public class MstArticleItemController : ApiController
    {

        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private SysSecurity secure = new SysSecurity();

        // ======================
        // GET api/MstArticleItem
        // ======================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = data.MstArticles.Where(d => d.MstUser.Id == secure.GetCurrentUser() &&
                                                    d.MstArticleType.ArticleType == "Item" &&
                                                    d.MstArticleItems.Count() > 0).Count();


            var Items = (from d in data.MstArticles
                             where d.MstUser.Id == secure.GetCurrentUser() &&
                                   d.MstArticleType.ArticleType == "Item" &&
                                   d.MstArticleItems.Count() > 0 &&
                                   d.Article.Contains(sSearch)
                             select new Models.MstArticleItem
                             {
                                 Id = d.MstArticleItems.First().Id,
                                 ArticleId = d.Id,
                                 AccountId = d.MstAccount.Id,
                                 Account = d.MstAccount.Account,
                                 ItemCode = d.ArticleCode,
                                 ItemManualCode = d.ArticleManualCode,
                                 Item = d.Article,
                                 BarCode = d.MstArticleItems.First().BarCode,
                                 Category = d.MstArticleItems.First().Category,
                                 UnitId = d.MstArticleItems.First().UnitId,
                                 Unit = d.MstArticleItems.First().MstUnit.Unit,
                                 PurchaseTaxId = d.MstArticleItems.First().PurchaseTaxId,
                                 PurchaseTax = d.MstArticleItems.First().MstTax.TaxCode,
                                 SalesTaxId = d.MstArticleItems.First().SalesTaxId,
                                 SalesTax = d.MstArticleItems.First().MstTax1.TaxCode,
                                 IsAsset = d.MstArticleItems.First().IsAsset,
                                 Remarks = d.MstArticleItems.First().Remarks
                             });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.ItemCode).Skip(iDisplayStart).Take(10);
                    else Items = Items.OrderByDescending(d => d.ItemCode).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.Item).Skip(iDisplayStart).Take(10);
                    else Items = Items.OrderByDescending(d => d.Item).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.Category).Skip(iDisplayStart).Take(10);
                    else Items = Items.OrderByDescending(d => d.Category).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    Items = Items.Skip(iDisplayStart).Take(10);
                    break;
            }

            var ItemPaged = new Models.SysDataTablePager();

            ItemPaged.sEcho = sEcho;
            ItemPaged.iTotalRecords = Count;
            ItemPaged.iTotalDisplayRecords = Count;
            ItemPaged.MstArticleItemData = Items.ToList();

            return ItemPaged;
        }

        // =============================
        // GET api/MstArticleItem/5/Item
        // =============================

        [HttpGet]
        [ActionName("Item")]
        public Models.MstArticleItem Get(Int64 Id)
        {
            var Items = (from d in data.MstArticles
                         where d.MstUser.Id == secure.GetCurrentUser() &&
                               d.MstArticleType.ArticleType == "Item" &&
                               d.MstArticleItems.Count() > 0 &&
                               d.MstArticleItems.First().Id == Id
                         select new Models.MstArticleItem
                         {
                             Id = d.MstArticleItems.First().Id,
                             ArticleId = d.Id,
                             AccountId = d.MstAccount.Id,
                             Account = d.MstAccount.Account,
                             ItemCode = d.ArticleCode,
                             ItemManualCode = d.ArticleManualCode,
                             Item = d.Article,
                             BarCode = d.MstArticleItems.First().BarCode,
                             Category = d.MstArticleItems.First().Category,
                             UnitId = d.MstArticleItems.First().UnitId,
                             Unit = d.MstArticleItems.First().MstUnit.Unit,
                             PurchaseTaxId = d.MstArticleItems.First().PurchaseTaxId,
                             PurchaseTax = d.MstArticleItems.First().MstTax.TaxCode,
                             SalesTaxId = d.MstArticleItems.First().SalesTaxId,
                             SalesTax = d.MstArticleItems.First().MstTax1.TaxCode,
                             IsAsset = d.MstArticleItems.First().IsAsset,
                             Remarks = d.MstArticleItems.First().Remarks
                         });

            if (Items.Any())
            {
                return Items.First();
            }
            else
            {
                return new Models.MstArticleItem();
            }
        }

        // ===================================
        // GET api/MstArticleItem/5/ItemPrices
        // ===================================

        [HttpGet]
        [ActionName("ItemPrices")]
        public Models.SysDataTablePager ItemPrices(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var ArticleId = data.MstArticleItems.Where(d => d.Id == Id).First().ArticleId;

            var Count = data.MstArticleItemPrices.Where(d => d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                                             d.ArticleId == ArticleId).Count();

            var ItemPrices = (from d in data.MstArticleItemPrices
                              where d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                    d.ArticleId == ArticleId &&
                                    d.PriceDescription.Contains(sSearch)
                                 select new Models.MstArticleItemPrice
                                 {
                                     Id = d.Id,
                                     ArticleId = d.Id,
                                     PriceDescription = d.PriceDescription,
                                     Price = d.Price
                                 });
            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") ItemPrices = ItemPrices.OrderBy(d => d.PriceDescription).Skip(iDisplayStart).Take(10);
                    else ItemPrices = ItemPrices.OrderByDescending(d => d.PriceDescription).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") ItemPrices = ItemPrices.OrderBy(d => d.Price).Skip(iDisplayStart).Take(10);
                    else ItemPrices = ItemPrices.OrderByDescending(d => d.Price).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    ItemPrices = ItemPrices.Skip(iDisplayStart).Take(10);
                    break;
            }

            var ItemPaged = new Models.SysDataTablePager();

            ItemPaged.sEcho = sEcho;
            ItemPaged.iTotalRecords = Count;
            ItemPaged.iTotalDisplayRecords = Count;
            ItemPaged.MstArticleItemPriceData = ItemPrices.ToList();

            return ItemPaged;
        }

        // ==================================
        // GET api/MstArticleItem/5/ItemUnits
        // ==================================

        [HttpGet]
        [ActionName("ItemUnits")]
        public Models.SysDataTablePager ItemUnits(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var ArticleId = data.MstArticleItems.Where(d => d.Id == Id).First().ArticleId;

            var Count = data.MstArticleItemUnits.Where(d => d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                                            d.ArticleId == ArticleId).Count();

            var ItemUnits = (from d in data.MstArticleItemUnits
                             where d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                   d.ArticleId == ArticleId &&
                                   d.MstUnit.Unit.Contains(sSearch)
                             select new Models.MstArticleItemUnit
                            {
                                Id = d.Id,
                                ArticleId = d.Id,
                                UnitId = d.UnitId,
                                Unit = d.MstUnit.Unit,
                                Multiplier = d.Multiplier
                            });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") ItemUnits = ItemUnits.OrderBy(d => d.Unit).Skip(iDisplayStart).Take(10);
                    else ItemUnits = ItemUnits.OrderByDescending(d => d.Unit).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") ItemUnits = ItemUnits.OrderBy(d => d.Multiplier).Skip(iDisplayStart).Take(10);
                    else ItemUnits = ItemUnits.OrderByDescending(d => d.Multiplier).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    ItemUnits = ItemUnits.Skip(iDisplayStart).Take(10);
                    break;
            }

            var ItemPaged = new Models.SysDataTablePager();

            ItemPaged.sEcho = sEcho;
            ItemPaged.iTotalRecords = Count;
            ItemPaged.iTotalDisplayRecords = Count;
            ItemPaged.MstArticleItemUnitData = ItemUnits.ToList();

            return ItemPaged;
        }

        // =======================
        // POST api/MstArticleItem
        // =======================

        [HttpPost]
        public Models.MstArticleItem Post(Models.MstArticleItem value)
        {
            var MstArticleItemModel = new Models.MstArticleItem();
            try
            {
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.MstArticle NewMstArticle = new Data.MstArticle();
                Data.MstArticleItem NewMstArticleItem = new Data.MstArticleItem();

                var UserId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId);

                // ==========
                // MstArticle
                // ==========
                // MstArticle->ArticleCode
                var Articles = from d in data.MstArticles
                               where d.MstUser.Id == UserId && d.MstArticleType.ArticleType == "Item"
                               select d;

                var MaxArticleCodeString = "";
                if (Articles != null)
                {
                    var MaxArticleCode = Convert.ToDouble(Articles.Max(a => a.ArticleCode)) + 10000000001;
                    MaxArticleCodeString = MaxArticleCode.ToString().Trim().Substring(1);
                    NewMstArticle.ArticleCode = MaxArticleCodeString;
                }
                else
                {
                    MaxArticleCodeString = "0000000001";
                    NewMstArticle.ArticleCode = MaxArticleCodeString;
                }
                // MstArticle->ArticleManualCode
                NewMstArticle.ArticleManualCode = MaxArticleCodeString;
                // MstArticle->Article
                NewMstArticle.Article = value.Item;
                // MstArticle->ArticleTypeId
                NewMstArticle.ArticleTypeId = data.MstArticleTypes.Where(a => a.MstUser.Id == UserId && a.ArticleType == "Item").First().Id;
                // MstArticle->AccountId
                NewMstArticle.AccountId = value.AccountId;
                // MstArticle->IsLocked
                NewMstArticle.IsLocked = true;
                // MstArticle->UserId
                NewMstArticle.UserId = UserId;
                // MstArticle->CreatedById
                NewMstArticle.CreatedById = UserId;
                // MstArticle->UpdatedById
                NewMstArticle.UpdatedById = UserId;
                // MstArticle->CreatedDateTime
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                NewMstArticle.CreatedDateTime = SQLNow.Value;
                // MstArticle->UpdatedDateTime
                NewMstArticle.UpdatedDateTime = SQLNow.Value;
                // MstArticle.Save
                newData.MstArticles.InsertOnSubmit(NewMstArticle);
                newData.SubmitChanges();

                // ==============
                // MstArticleItem
                // ==============
                // MstArticleItem->ArticleId
                NewMstArticleItem.ArticleId = data.MstArticles.Where(a => a.MstUser.Id == UserId && 
                                                                          a.MstArticleType.ArticleType == "Item" &&
                                                                          a.ArticleCode == MaxArticleCodeString).First().Id;
                // MstArticleItem->BarCode
                NewMstArticleItem.BarCode = value.BarCode == null ? MaxArticleCodeString : value.BarCode;
                // MstArticleItem->Category
                NewMstArticleItem.Category = value.Category == null ? "NA" : value.Category;
                // MstArticleItem->UnitId
                NewMstArticleItem.UnitId = value.UnitId;
                // MstArticleItem->PurchaseTaxId
                NewMstArticleItem.PurchaseTaxId = value.PurchaseTaxId;
                // MstArticleItem->SalesTaxId
                NewMstArticleItem.SalesTaxId = value.SalesTaxId;
                // MstArticleItem->IsAsset
                NewMstArticleItem.IsAsset = value.IsAsset;
                // MstArticleCustomer.Save
                newData.MstArticleItems.InsertOnSubmit(NewMstArticleItem);
                newData.SubmitChanges();
                // Return the saved article item
                return Get(newData.MstArticleItems.Where(d => d.ArticleId == NewMstArticleItem.ArticleId).First().Id);
            }
            catch
            {
                return MstArticleItemModel;
            }
        }

        // ========================
        // PUT api/MstArticleItem/5
        // ========================

        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.MstArticleItem value)
        {
            try
            {
                // Update Article Item
                var ArticleItem = from d in data.MstArticleItems
                                  where d.Id == id
                                  select d;

                if (ArticleItem.Any())
                {
                    var UpdatedArticleItem = ArticleItem.FirstOrDefault();

                    UpdatedArticleItem.BarCode = value.BarCode == null ? value.ItemCode : value.BarCode;
                    UpdatedArticleItem.Category = value.Category == null ? "NA" : value.Category;
                    UpdatedArticleItem.UnitId = value.UnitId;
                    UpdatedArticleItem.PurchaseTaxId = value.PurchaseTaxId;
                    UpdatedArticleItem.SalesTaxId = value.SalesTaxId;
                    UpdatedArticleItem.IsAsset = value.IsAsset;
                    UpdatedArticleItem.Remarks = value.Remarks == null ? "NA" : value.Remarks;

                    data.SubmitChanges();

                    // Update Article
                    var Article = from d in data.MstArticles
                                  where d.Id == value.ArticleId
                                  select d;

                    if (Article.Any())
                    {
                        var UpdatedArticle = Article.FirstOrDefault();

                        UpdatedArticle.Article = value.Item == null ? "NA" : value.Item;
                        UpdatedArticle.ArticleManualCode = value.ItemManualCode == null ? value.ItemCode : value.ItemManualCode;
                        UpdatedArticle.AccountId = value.AccountId;

                        data.SubmitChanges();

                        return Request.CreateResponse(HttpStatusCode.OK);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.NotFound);
                    }
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
            }
            catch
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // ===========================
        // DELETE api/MstArticleItem/5
        // ===========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstArticle DeleteArticle = data.MstArticles.Where(d => d.MstUser.Id == secure.GetCurrentUser() &&
                                                                        d.MstArticleType.ArticleType == "Item" &&
                                                                        d.MstArticleItems.Count() > 0 &&
                                                                        d.MstArticleItems.First().Id == Id).First();

            if (DeleteArticle != null)
            {
                data.MstArticles.DeleteOnSubmit(DeleteArticle);
                try
                {
                    data.SubmitChanges();
                }
                catch
                {
                    returnVariable = false;
                }
            }
            else
            {
                returnVariable = false;
            }
            return returnVariable;
        }
    }

}