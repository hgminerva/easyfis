using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectItemController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectItem
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, bool IsInventory = false, Int64 POId = 0)
        {
            if (IsInventory == true) { 
                var Items = from d in data.MstArticles
                            where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                  d.MstArticleType.ArticleType == "Item" && 
                                  d.MstArticleItems.First().IsAsset == true &&
                                  d.Article.Contains(searchTerm == null ? "" : searchTerm)
                            orderby d.Article
                            select new Models.SelectObject
                            {
                                id = d.Id,
                                text = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                                            new Models.MstArticleItem
                                            {
                                                Item = d.Article,
                                                UnitId = d.MstArticleItems.First().UnitId,
                                                Unit = d.MstArticleItems.First().MstUnit.Unit,
                                                PurchaseTaxId = d.MstArticleItems.First().PurchaseTaxId,
                                                PurchaseTax = d.MstArticleItems.First().MstTax.TaxCode,
                                                PurchaseTaxRate = d.MstArticleItems.First().MstTax.TaxRate,
                                                PurchaseTaxType = d.MstArticleItems.First().MstTax.MstTaxType.TaxType,
                                                SalesTaxId = d.MstArticleItems.First().SalesTaxId,
                                                SalesTax = d.MstArticleItems.First().MstTax1.TaxCode,
                                                SalesTaxRate = d.MstArticleItems.First().MstTax1.TaxRate,
                                                SalesTaxType = d.MstArticleItems.First().MstTax1.MstTaxType.TaxType,
                                                DefaultPriceId = d.MstArticleItemPrices.Count() > 0 ? d.MstArticleItemPrices.First().Id : 0,
                                                DefaultPriceDescription = d.MstArticleItemPrices.Count() > 0 ? d.MstArticleItemPrices.First().PriceDescription : "",
                                                DefaultPrice = d.MstArticleItemPrices.Count() > 0 ? d.MstArticleItemPrices.First().Price : 0,
                                                DefaultCost = d.MstArticleItemComponents.Count() > 0 ? d.MstArticleItemComponents.Sum(c => c.Quantity * c.MstArticle1.MstArticleItemInventories.Count() > 0 ? c.MstArticle1.MstArticleItemInventories.First().Cost : 0) : 0
                                            }
                                       )
                            };

                Int64 Count = Items.Count();

                Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

                PagedResult.Total = Count;
                PagedResult.Results = Items.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

                return PagedResult;
            }
            else
            {
                if (POId > 0)
                {
                    var Items = from d in data.TrnPurchaseOrderLines
                                where d.TrnPurchaseOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                      d.MstArticle.MstArticleType.ArticleType == "Item" &&
                                      d.POId == POId && 
                                      d.MstArticle.Article.Contains(searchTerm == null ? "" : searchTerm)
                                orderby d.MstArticle.Article
                                select new Models.SelectObject
                                {
                                    id = d.ItemId,
                                    text = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                                                new Models.MstArticleItem
                                                {
                                                    Item = d.MstArticle.Article,
                                                    UnitId = d.MstArticle.MstArticleItems.First().UnitId,
                                                    Unit = d.MstArticle.MstArticleItems.First().MstUnit.Unit,
                                                    PurchaseTaxId = d.MstArticle.MstArticleItems.First().PurchaseTaxId,
                                                    PurchaseTax = d.MstArticle.MstArticleItems.First().MstTax.TaxCode,
                                                    PurchaseTaxRate = d.MstArticle.MstArticleItems.First().MstTax.TaxRate,
                                                    PurchaseTaxType = d.MstArticle.MstArticleItems.First().MstTax.MstTaxType.TaxType,
                                                    SalesTaxId = d.MstArticle.MstArticleItems.First().SalesTaxId,
                                                    SalesTax = d.MstArticle.MstArticleItems.First().MstTax1.TaxCode,
                                                    SalesTaxRate = d.MstArticle.MstArticleItems.First().MstTax1.TaxRate,
                                                    SalesTaxType = d.MstArticle.MstArticleItems.First().MstTax1.MstTaxType.TaxType,
                                                    DefaultPriceId = d.MstArticle.MstArticleItemPrices.Count() > 0 ? d.MstArticle.MstArticleItemPrices.First().Id : 0,
                                                    DefaultPriceDescription = d.MstArticle.MstArticleItemPrices.Count() > 0 ? d.MstArticle.MstArticleItemPrices.First().PriceDescription : "",
                                                    DefaultPrice = d.MstArticle.MstArticleItemPrices.Count() > 0 ? d.MstArticle.MstArticleItemPrices.First().Price : 0,
                                                    DefaultCost = 0
                                                }
                                           )
                                };

                    Int64 Count = Items.Count();

                    Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

                    PagedResult.Total = Count;
                    PagedResult.Results = Items.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

                    return PagedResult;
                }
                else
                {
                    var Items = from d in data.MstArticles
                                where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                      d.MstArticleType.ArticleType == "Item" &&
                                      d.Article.Contains(searchTerm == null ? "" : searchTerm)
                                orderby d.Article
                                select new Models.SelectObject
                                {
                                    id = d.Id,
                                    text = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                                                new Models.MstArticleItem
                                                {
                                                    Item = d.Article,
                                                    UnitId = d.MstArticleItems.First().UnitId,
                                                    Unit = d.MstArticleItems.First().MstUnit.Unit,
                                                    PurchaseTaxId = d.MstArticleItems.First().PurchaseTaxId,
                                                    PurchaseTax = d.MstArticleItems.First().MstTax.TaxCode,
                                                    PurchaseTaxRate = d.MstArticleItems.First().MstTax.TaxRate,
                                                    PurchaseTaxType = d.MstArticleItems.First().MstTax.MstTaxType.TaxType,
                                                    SalesTaxId = d.MstArticleItems.First().SalesTaxId,
                                                    SalesTax = d.MstArticleItems.First().MstTax1.TaxCode,
                                                    SalesTaxRate = d.MstArticleItems.First().MstTax1.TaxRate,
                                                    SalesTaxType = d.MstArticleItems.First().MstTax1.MstTaxType.TaxType,
                                                    DefaultPriceId = d.MstArticleItemPrices.Count() > 0 ? d.MstArticleItemPrices.First().Id : 0,
                                                    DefaultPriceDescription = d.MstArticleItemPrices.Count() > 0 ? d.MstArticleItemPrices.First().PriceDescription : "",
                                                    DefaultPrice = d.MstArticleItemPrices.Count() > 0 ? d.MstArticleItemPrices.First().Price : 0,
                                                    DefaultCost = 0
                                                }
                                           )
                                };

                    Int64 Count = Items.Count();

                    Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

                    PagedResult.Total = Count;
                    PagedResult.Results = Items.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

                    return PagedResult;
                }
            }
        }

    }
}