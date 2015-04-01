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
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/MstArticleItem
        // ======================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            int NumberOfRecords = 20;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = data.MstArticles.Where(d => d.UserId == secure.GetCurrentSubscriberUser() &&
                                                    d.MstArticleType.ArticleType == "Item" &&
                                                    d.MstArticleItems.Count() > 0).Count();


            var Items = (from d in data.MstArticles
                         where d.UserId == secure.GetCurrentSubscriberUser() &&
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
                            BalanceQuantity = d.MstArticleItemInventories.Count() == 0 ? 0 : d.MstArticleItemInventories.Sum(q=>q.BalanceQuantity),
                            PurchaseTaxId = d.MstArticleItems.First().PurchaseTaxId,
                            PurchaseTax = d.MstArticleItems.First().MstTax.TaxCode,
                            PurchaseTaxRate = d.MstArticleItems.First().MstTax.TaxRate,
                            SalesTaxId = d.MstArticleItems.First().SalesTaxId,
                            SalesTax = d.MstArticleItems.First().MstTax1.TaxCode,
                            SalesTaxRate = d.MstArticleItems.First().MstTax1.TaxRate,
                            PurchaseAccountId = d.MstArticleItems.First().PurchaseAccountId == null ? 0 : d.MstArticleItems.First().PurchaseAccountId.Value,
                            PurchaseAccount = d.MstArticleItems.First().PurchaseAccountId == null ? "" : d.MstArticleItems.First().MstAccount1.Account,
                            SalesAccountId = d.MstArticleItems.First().SalesAccountId == null ? 0 : d.MstArticleItems.First().SalesAccountId.Value,
                            SalesAccount = d.MstArticleItems.First().SalesAccountId == null ? "" : d.MstArticleItems.First().MstAccount2.Account,
                            CostAccountId = d.MstArticleItems.First().CostAccountId == null ? 0 : d.MstArticleItems.First().CostAccountId.Value,
                            CostAccount = d.MstArticleItems.First().CostAccountId == null ? "" : d.MstArticleItems.First().MstAccount5.Account,
                            Remarks = d.MstArticleItems.First().Remarks,
                            IsAsset = d.MstArticleItems.First().IsAsset,
                            AssetManualNumber = d.MstArticleItems.First().AssetManualNumber,
                            AssetAccountId = d.MstArticleItems.First().AssetAccountId == null ? 0 : d.MstArticleItems.First().AssetAccountId.Value,
                            AssetAccount = d.MstArticleItems.First().SalesAccountId == null ? "" : d.MstArticleItems.First().MstAccount.Account,
                            AssetDateAcquired = d.MstArticleItems.First().AssetDateAcquired == null ? DateTime.Now.ToShortDateString() : d.MstArticleItems.First().AssetDateAcquired.ToString(),
                            AssetCost = d.MstArticleItems.First().AssetCost,
                            AssetLifeInYears = d.MstArticleItems.First().AssetLifeInYears,
                            AssetSalvageValue = d.MstArticleItems.First().AssetSalvageValue,
                            AssetDepreciationAccountId = d.MstArticleItems.First().AssetDepreciationAccountId == null ? 0 : d.MstArticleItems.First().AssetDepreciationAccountId.Value,
                            AssetDepreciationAccount = d.MstArticleItems.First().AssetDepreciationAccountId == null ? "" : d.MstArticleItems.First().MstAccount3.Account,
                            AssetDepreciationExpenseAccountId = d.MstArticleItems.First().AssetDepreciationExpenseAccountId == null ? 0 : d.MstArticleItems.First().AssetDepreciationExpenseAccountId.Value,
                            AssetDepreciationExpenseAccount = d.MstArticleItems.First().AssetDepreciationExpenseAccountId == null ? "" : d.MstArticleItems.First().MstAccount3.Account
                         });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.ItemCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.ItemCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.BarCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.BarCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.Item).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.Item).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 5:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.Category).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.Category).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 6:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.BalanceQuantity).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.BalanceQuantity).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 7:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.Unit).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.Unit).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 8:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.IsAsset).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.IsAsset).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Items = Items.Skip(iDisplayStart).Take(NumberOfRecords);
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
                         where d.UserId == secure.GetCurrentSubscriberUser() &&
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
                             PurchaseTaxRate = d.MstArticleItems.First().MstTax.TaxRate,
                             SalesTaxId = d.MstArticleItems.First().SalesTaxId,
                             SalesTax = d.MstArticleItems.First().MstTax1.TaxCode,
                             SalesTaxRate = d.MstArticleItems.First().MstTax1.TaxRate,
                             PurchaseAccountId = d.MstArticleItems.First().PurchaseAccountId == null ? 0 : d.MstArticleItems.First().PurchaseAccountId.Value,
                             PurchaseAccount = d.MstArticleItems.First().PurchaseAccountId == null ? "" : d.MstArticleItems.First().MstAccount1.Account,
                             SalesAccountId = d.MstArticleItems.First().SalesAccountId == null ? 0 : d.MstArticleItems.First().SalesAccountId.Value,
                             SalesAccount = d.MstArticleItems.First().SalesAccountId == null ? "" : d.MstArticleItems.First().MstAccount2.Account,
                             CostAccountId = d.MstArticleItems.First().CostAccountId == null ? 0 : d.MstArticleItems.First().CostAccountId.Value,
                             CostAccount = d.MstArticleItems.First().CostAccountId == null ? "" : d.MstArticleItems.First().MstAccount5.Account,
                             Remarks = d.MstArticleItems.First().Remarks,
                             IsAsset = d.MstArticleItems.First().IsAsset,
                             AssetManualNumber = d.MstArticleItems.First().AssetManualNumber,
                             AssetAccountId = d.MstArticleItems.First().AssetAccountId == null ? 0 : d.MstArticleItems.First().AssetAccountId.Value,
                             AssetAccount = d.MstArticleItems.First().SalesAccountId == null ? "" : d.MstArticleItems.First().MstAccount.Account,
                             AssetDateAcquired = d.MstArticleItems.First().AssetDateAcquired == null ? DateTime.Now.ToShortDateString() : d.MstArticleItems.First().AssetDateAcquired.ToString(),
                             AssetCost = d.MstArticleItems.First().AssetCost,
                             AssetLifeInYears = d.MstArticleItems.First().AssetLifeInYears,
                             AssetSalvageValue = d.MstArticleItems.First().AssetSalvageValue,
                             AssetDepreciationAccountId = d.MstArticleItems.First().AssetDepreciationAccountId == null ? 0 : d.MstArticleItems.First().AssetDepreciationAccountId.Value,
                             AssetDepreciationAccount = d.MstArticleItems.First().AssetDepreciationAccountId == null ? "" : d.MstArticleItems.First().MstAccount3.Account,
                             AssetDepreciationExpenseAccountId = d.MstArticleItems.First().AssetDepreciationExpenseAccountId == null ? 0 : d.MstArticleItems.First().AssetDepreciationExpenseAccountId.Value,
                             AssetDepreciationExpenseAccount = d.MstArticleItems.First().AssetDepreciationExpenseAccountId == null ? "" : d.MstArticleItems.First().MstAccount3.Account
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

        // ========================================
        // GET api/MstArticleItem/5/ItemByArticleId
        // ========================================

        [HttpGet]
        [ActionName("ItemByArticleId")]
        public Models.MstArticleItem ItemByArticleId(Int64 Id)
        {
            var Items = (from d in data.MstArticles
                         where d.UserId == secure.GetCurrentSubscriberUser() &&
                               d.MstArticleType.ArticleType == "Item" &&
                               d.MstArticleItems.Count() > 0 &&
                               d.Id == Id
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
                             PurchaseTaxRate = d.MstArticleItems.First().MstTax.TaxRate,
                             SalesTaxId = d.MstArticleItems.First().SalesTaxId,
                             SalesTax = d.MstArticleItems.First().MstTax1.TaxCode,
                             SalesTaxRate = d.MstArticleItems.First().MstTax1.TaxRate,
                             PurchaseAccountId = d.MstArticleItems.First().PurchaseAccountId == null ? 0 : d.MstArticleItems.First().PurchaseAccountId.Value,
                             PurchaseAccount = d.MstArticleItems.First().PurchaseAccountId == null ? "" : d.MstArticleItems.First().MstAccount1.Account,
                             SalesAccountId = d.MstArticleItems.First().SalesAccountId == null ? 0 : d.MstArticleItems.First().SalesAccountId.Value,
                             SalesAccount = d.MstArticleItems.First().SalesAccountId == null ? "" : d.MstArticleItems.First().MstAccount2.Account,
                             CostAccountId = d.MstArticleItems.First().CostAccountId == null ? 0 : d.MstArticleItems.First().CostAccountId.Value,
                             CostAccount = d.MstArticleItems.First().CostAccountId == null ? "" : d.MstArticleItems.First().MstAccount5.Account,
                             Remarks = d.MstArticleItems.First().Remarks,
                             IsAsset = d.MstArticleItems.First().IsAsset,
                             AssetManualNumber = d.MstArticleItems.First().AssetManualNumber,
                             AssetAccountId = d.MstArticleItems.First().AssetAccountId == null ? 0 : d.MstArticleItems.First().AssetAccountId.Value,
                             AssetAccount = d.MstArticleItems.First().SalesAccountId == null ? "" : d.MstArticleItems.First().MstAccount.Account,
                             AssetDateAcquired = d.MstArticleItems.First().AssetDateAcquired == null ? DateTime.Now.ToShortDateString() : d.MstArticleItems.First().AssetDateAcquired.ToString(),
                             AssetCost = d.MstArticleItems.First().AssetCost,
                             AssetLifeInYears = d.MstArticleItems.First().AssetLifeInYears,
                             AssetSalvageValue = d.MstArticleItems.First().AssetSalvageValue,
                             AssetDepreciationAccountId = d.MstArticleItems.First().AssetDepreciationAccountId == null ? 0 : d.MstArticleItems.First().AssetDepreciationAccountId.Value,
                             AssetDepreciationAccount = d.MstArticleItems.First().AssetDepreciationAccountId == null ? "" : d.MstArticleItems.First().MstAccount3.Account,
                             AssetDepreciationExpenseAccountId = d.MstArticleItems.First().AssetDepreciationExpenseAccountId == null ? 0 : d.MstArticleItems.First().AssetDepreciationExpenseAccountId.Value,
                             AssetDepreciationExpenseAccount = d.MstArticleItems.First().AssetDepreciationExpenseAccountId == null ? "" : d.MstArticleItems.First().MstAccount3.Account
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

            var ArticleId = data.MstArticleItems.Where(d => d.Id == Id && 
                                                            d.MstArticle.UserId == secure.GetCurrentSubscriberUser()).First().ArticleId;

            var Count = data.MstArticleItemPrices.Where(d => d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                                             d.ArticleId == ArticleId).Count();

            var ItemPrices = (from d in data.MstArticleItemPrices
                              where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                    d.ArticleId == ArticleId &&
                                    d.PriceDescription.Contains(sSearch)
                                 select new Models.MstArticleItemPrice
                                 {
                                     Line1Id = d.Id,
                                     Line1ArticleId = d.Id,
                                     Line1PriceDescription = d.PriceDescription,
                                     Line1Price = d.Price,
                                     Line1MarkUpPercentage = d.MarkUpPercentage
                                 });
            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") ItemPrices = ItemPrices.OrderBy(d => d.Line1PriceDescription).Skip(iDisplayStart).Take(10);
                    else ItemPrices = ItemPrices.OrderByDescending(d => d.Line1PriceDescription).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") ItemPrices = ItemPrices.OrderBy(d => d.Line1Price).Skip(iDisplayStart).Take(10);
                    else ItemPrices = ItemPrices.OrderByDescending(d => d.Line1Price).Skip(iDisplayStart).Take(10);
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

            var ArticleId = data.MstArticleItems.Where(d => d.Id == Id &&
                                                            d.MstArticle.UserId == secure.GetCurrentSubscriberUser()).First().ArticleId;

            var Count = data.MstArticleItemUnits.Where(d => d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                                            d.ArticleId == ArticleId).Count();

            var ItemUnits = (from d in data.MstArticleItemUnits
                             where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                   d.ArticleId == ArticleId &&
                                   d.MstUnit.Unit.Contains(sSearch)
                             select new Models.MstArticleItemUnit
                            {
                                Line2Id = d.Id,
                                Line2ArticleId = d.Id,
                                Line2UnitId = d.UnitId,
                                Line2Unit = d.MstUnit.Unit,
                                Line2Multiplier = d.Multiplier
                            });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") ItemUnits = ItemUnits.OrderBy(d => d.Line2Unit).Skip(iDisplayStart).Take(10);
                    else ItemUnits = ItemUnits.OrderByDescending(d => d.Line2Unit).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") ItemUnits = ItemUnits.OrderBy(d => d.Line2Multiplier).Skip(iDisplayStart).Take(10);
                    else ItemUnits = ItemUnits.OrderByDescending(d => d.Line2Multiplier).Skip(iDisplayStart).Take(10);
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


        // =======================================
        // GET api/MstArticleItem/5/ItemComponents
        // =======================================

        [HttpGet]
        [ActionName("ItemComponents")]
        public Models.SysDataTablePager ItemComponents(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var ArticleId = data.MstArticleItems.Where(d => d.Id == Id &&
                                                            d.MstArticle.UserId == secure.GetCurrentSubscriberUser()).First().ArticleId;

            var Count = data.MstArticleItemComponents.Where(d => d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                                                 d.ArticleId == ArticleId).Count();

            var ItemComponents = (from d in data.MstArticleItemComponents
                                  where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                        d.ArticleId == ArticleId &&
                                        d.MstArticle.Article.Contains(sSearch)
                                  select new Models.MstArticleItemComponent
                                  {
                                      Line3Id = d.Id,
                                      Line3ArticleId = d.ArticleId,
                                      Line3ComponentArticleId = d.ComponentArticleId,
                                      Line3ComponentArticle = d.MstArticle1.Article,
                                      Line3UnitId = d.UnitId,
                                      Line3Unit = d.MstUnit.Unit,
                                      Line3Quantity = d.Quantity
                                  });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") ItemComponents = ItemComponents.OrderBy(d => d.Line3Quantity).Skip(iDisplayStart).Take(10);
                    else ItemComponents = ItemComponents.OrderByDescending(d => d.Line3Quantity).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") ItemComponents = ItemComponents.OrderBy(d => d.Line3Unit).Skip(iDisplayStart).Take(10);
                    else ItemComponents = ItemComponents.OrderByDescending(d => d.Line3Unit).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") ItemComponents = ItemComponents.OrderBy(d => d.Line3ComponentArticle).Skip(iDisplayStart).Take(10);
                    else ItemComponents = ItemComponents.OrderByDescending(d => d.Line3ComponentArticle).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    ItemComponents = ItemComponents.Skip(iDisplayStart).Take(10);
                    break;
            }

            var ItemPaged = new Models.SysDataTablePager();

            ItemPaged.sEcho = sEcho;
            ItemPaged.iTotalRecords = Count;
            ItemPaged.iTotalDisplayRecords = Count;
            ItemPaged.MstArticleItemComponentData = ItemComponents.ToList();

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
                Data.MstArticleItemUnit NewMstArticleItemUnit = new Data.MstArticleItemUnit();

                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));

                SqlDateTime SQLAssetDateAcquired;

                if (value.AssetDateAcquired == null)
                {
                    SQLAssetDateAcquired = SQLNow;
                }
                else
                {
                    SQLAssetDateAcquired = new SqlDateTime(new DateTime(Convert.ToDateTime(value.AssetDateAcquired).Year, +
                                                                         Convert.ToDateTime(value.AssetDateAcquired).Month, +
                                                                         Convert.ToDateTime(value.AssetDateAcquired).Day));
                }
            
                // Save MstArticle
                var Articles = from d in data.MstArticles
                               where d.UserId == secure.GetCurrentSubscriberUser() && 
                                     d.MstArticleType.ArticleType == "Item"
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

                NewMstArticle.ArticleManualCode = MaxArticleCodeString;
                NewMstArticle.Article = value.Item;
                NewMstArticle.ArticleTypeId = data.MstArticleTypes.Where(a => a.UserId == secure.GetCurrentSubscriberUser() && a.ArticleType == "Item").First().Id;
                NewMstArticle.AccountId = value.AccountId;
                NewMstArticle.IsLocked = true;
                NewMstArticle.UserId = secure.GetCurrentSubscriberUser();
                NewMstArticle.CreatedById = secure.GetCurrentUser();
                NewMstArticle.UpdatedById = secure.GetCurrentUser();
                NewMstArticle.CreatedDateTime = SQLNow.Value;
                NewMstArticle.UpdatedDateTime = SQLNow.Value;

                newData.MstArticles.InsertOnSubmit(NewMstArticle);
                newData.SubmitChanges();

                // Save MstArticleItem

                //NewMstArticleItem.ArticleId = data.MstArticles.Where(a => a.UserId == secure.GetCurrentSubscriberUser() && 
                //                                                          a.MstArticleType.ArticleType == "Item" &&
                //                                                          a.ArticleCode == MaxArticleCodeString).First().Id;
                NewMstArticleItem.ArticleId = NewMstArticle.Id;
                NewMstArticleItem.BarCode = value.BarCode == null ? MaxArticleCodeString : value.BarCode;
                NewMstArticleItem.Category = value.Category == null ? "NA" : value.Category;
                NewMstArticleItem.UnitId = value.UnitId;
                NewMstArticleItem.PurchaseTaxId = value.PurchaseTaxId;
                NewMstArticleItem.SalesTaxId = value.SalesTaxId;
                if (value.PurchaseAccountId > 0) NewMstArticleItem.PurchaseAccountId = value.PurchaseAccountId;
                if (value.SalesAccountId > 0) NewMstArticleItem.SalesAccountId = value.SalesAccountId;
                if (value.CostAccountId > 0) NewMstArticleItem.CostAccountId = value.CostAccountId;
                NewMstArticleItem.Remarks = value.Remarks;
                NewMstArticleItem.IsAsset = value.IsAsset == null? false : value.IsAsset;
                NewMstArticleItem.AssetManualNumber = value.AssetManualNumber == null ? "NA" : value.AssetManualNumber;
                if (value.AssetAccountId>0) NewMstArticleItem.AssetAccountId = value.AssetAccountId;
                NewMstArticleItem.AssetDateAcquired = SQLAssetDateAcquired.Value;
                NewMstArticleItem.AssetCost = value.AssetCost == null ? 0 : value.AssetCost;
                NewMstArticleItem.AssetLifeInYears = value.AssetLifeInYears == null ? 0 : value.AssetLifeInYears;
                NewMstArticleItem.AssetSalvageValue = value.AssetSalvageValue == null ? 0 : value.AssetSalvageValue;
                if (value.AssetDepreciationAccountId > 0) NewMstArticleItem.AssetDepreciationAccountId = value.AssetDepreciationAccountId;
                if (value.AssetDepreciationExpenseAccountId > 0) NewMstArticleItem.AssetDepreciationExpenseAccountId = value.AssetDepreciationExpenseAccountId;

                newData.MstArticleItems.InsertOnSubmit(NewMstArticleItem);
                newData.SubmitChanges();

                // Default unit conversion

                NewMstArticleItemUnit.UnitId = value.UnitId;
                NewMstArticleItemUnit.ArticleId = NewMstArticle.Id;
                NewMstArticleItemUnit.Multiplier = 1;

                newData.MstArticleItemUnits.InsertOnSubmit(NewMstArticleItemUnit);
                newData.SubmitChanges();

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
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                var ArticleItem = from d in data.MstArticleItems
                                  where d.Id == id &&
                                        d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                                  select d;

                if (ArticleItem.Any())
                {
                    var UpdatedArticleItem = ArticleItem.FirstOrDefault();

                    UpdatedArticleItem.BarCode = value.BarCode == null ? value.ItemCode : value.BarCode;
                    UpdatedArticleItem.Category = value.Category == null ? "NA" : value.Category;
                    UpdatedArticleItem.UnitId = value.UnitId;
                    UpdatedArticleItem.PurchaseTaxId = value.PurchaseTaxId;
                    UpdatedArticleItem.SalesTaxId = value.SalesTaxId;
                    if (value.PurchaseAccountId > 0) UpdatedArticleItem.PurchaseAccountId = value.PurchaseAccountId;
                    if (value.SalesAccountId > 0) UpdatedArticleItem.SalesAccountId = value.SalesAccountId;
                    if (value.CostAccountId > 0) UpdatedArticleItem.CostAccountId = value.CostAccountId;
                    UpdatedArticleItem.IsAsset = value.IsAsset;
                    UpdatedArticleItem.Remarks = value.Remarks == null ? "NA" : value.Remarks;

                    data.SubmitChanges();

                    // Update Article
                    var Article = from d in data.MstArticles
                                  where d.Id == value.ArticleId &&
                                        d.UserId == secure.GetCurrentSubscriberUser()
                                  select d;

                    if (Article.Any())
                    {
                        var UpdatedArticle = Article.FirstOrDefault();

                        UpdatedArticle.Article = value.Item == null ? "NA" : value.Item;
                        UpdatedArticle.ArticleManualCode = value.ItemManualCode == null ? value.ItemCode : value.ItemManualCode;
                        UpdatedArticle.AccountId = value.AccountId;
                        UpdatedArticle.UpdatedById = secure.GetCurrentUser();
                        UpdatedArticle.UpdatedDateTime = SQLNow.Value;

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

            Data.MstArticle DeleteArticle = data.MstArticles.Where(d => d.UserId == secure.GetCurrentSubscriberUser() &&
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