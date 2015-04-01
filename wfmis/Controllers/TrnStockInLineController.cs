using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnStockInLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/TrnStockInLine
        // ======================
        [HttpGet]
        public List<Models.TrnStockInLine> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var TrnStockInLines = from d in db.TrnStockInLines
                                  where d.Id == BranchId &&
                                        d.TrnStockIn.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                  select new Models.TrnStockInLine
                                  {
                                        LineId = d.Id,
                                        LineINId = d.INId,
                                        LineItemId = d.ItemId,
                                        LineItem = d.MstArticle.Article,
                                        LineItemInventoryId = d.ItemInventoryId.Value,
                                        LineItemInventoryNumber = d.MstArticleItemInventory.InventoryNumber,
                                        LineParticulars = d.Particulars,
                                        LineUnitId = d.UnitId,
                                        LineUnit = d.MstUnit.Unit,
                                        LineCost = d.Cost,
                                        LineQuantity = d.Quantity,
                                        LineAmount = d.Amount,
                                        LineBaseUnitId = d.BaseUnitId,
                                        LineBaseUnit = d.MstUnit1.Unit,
                                        LineBaseQuantity = d.BaseQuantity,
                                        LineBaseCost = d.BaseCost
                                  };
            return TrnStockInLines.ToList();
        }

        // ================================
        // GET api/TrnStockInLine/5/StockIn
        // ================================

        [HttpGet]
        [ActionName("StockInLine")]
        public Models.TrnStockInLine Get(Int64 Id)
        {
            var StockInLines = from d in db.TrnStockInLines
                               where d.Id == Id &&
                                     d.TrnStockIn.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                               select new Models.TrnStockInLine
                               {
                                    LineId = d.Id,
                                    LineINId = d.INId,
                                    LineItemId = d.ItemId,
                                    LineItem = d.MstArticle.Article,
                                    LineItemInventoryId = d.ItemInventoryId == null ? 0 : d.ItemInventoryId.Value,
                                    LineItemInventoryNumber = d.ItemInventoryId == null ? "" : d.MstArticleItemInventory.InventoryNumber,
                                    LineParticulars = d.Particulars,
                                    LineUnitId = d.UnitId,
                                    LineUnit = d.MstUnit.Unit,
                                    LineCost = d.Cost,
                                    LineQuantity = d.Quantity,
                                    LineAmount = d.Amount,
                                    LineBaseUnitId = d.BaseUnitId,
                                    LineBaseUnit = d.MstUnit1.Unit,
                                    LineBaseQuantity = d.BaseQuantity,
                                    LineBaseCost = d.BaseCost
                               };

            if (StockInLines.Any())
            {
                return StockInLines.First();
            }
            else
            {
                return new Models.TrnStockInLine();
            }
        }

        // =======================
        // POST api/TrnStockInLine
        // =======================

        [HttpPost]
        public Models.TrnStockInLine Post(Models.TrnStockInLine value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                var Items = from d in db.MstArticleItems
                            where d.ArticleId == value.LineItemId &&
                                  d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                            select d;

                var ItemUnits = from d in db.MstArticleItemUnits
                                where d.UnitId == value.LineUnitId &&
                                      d.ArticleId == value.LineItemId &&
                                      d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                                select d;

                if (Items.Any() && ItemUnits.Any())
                {
                    Data.TrnStockInLine NewStockInLine = new Data.TrnStockInLine();

                    NewStockInLine.INId = value.LineINId;
                    NewStockInLine.ItemId = value.LineItemId;
                    if (value.LineItemInventoryId > 0) NewStockInLine.ItemInventoryId = value.LineItemInventoryId;
                    NewStockInLine.UnitId = value.LineUnitId;
                    NewStockInLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    NewStockInLine.Cost = value.LineCost;
                    NewStockInLine.Quantity = value.LineQuantity;
                    NewStockInLine.Amount = value.LineAmount;

                    if (value.LineQuantity > 0)
                    {
                        NewStockInLine.BaseUnitId = Items.First().UnitId;
                        NewStockInLine.BaseQuantity = value.LineQuantity * ItemUnits.First().Multiplier;
                        NewStockInLine.BaseCost = value.LineAmount / (value.LineQuantity * ItemUnits.First().Multiplier);
                    }
                    else
                    {
                        NewStockInLine.BaseUnitId = Items.First().UnitId;
                        NewStockInLine.BaseQuantity = 0;
                        NewStockInLine.BaseCost = 0;
                    }

                    db.TrnStockInLines.InsertOnSubmit(NewStockInLine);
                    db.SubmitChanges();

                    //journal.JournalizedIN(value.LineINId);

                    //inventory.InsertInventoryIn(value.LineINId);

                    return value;
                    
                } else {
                    return new Models.TrnStockInLine();
                }


            }
            else
            {
                return new Models.TrnStockInLine();
            }
        }

        // ========================
        // PUT api/TrnStockInLine/5
        // ========================
        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnStockInLine value)
        {
            try
            {
                var StockInLines = from d in db.TrnStockInLines
                                   where d.Id == id &&
                                         d.TrnStockIn.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                   select d;

                if (StockInLines.Any())
                {
                    var Items = from d in db.MstArticleItems
                                where d.ArticleId == value.LineItemId &&
                                      d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                                select d;

                    var ItemUnits = from d in db.MstArticleItemUnits
                                    where d.UnitId == value.LineUnitId &&
                                          d.ArticleId == value.LineItemId &&
                                          d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                    if (Items.Any() && ItemUnits.Any())
                    {
                        var UpdatedStockInLine = StockInLines.FirstOrDefault();

                        UpdatedStockInLine.INId = value.LineINId;
                        UpdatedStockInLine.ItemId = value.LineItemId;
                        if (value.LineItemInventoryId > 0) UpdatedStockInLine.ItemInventoryId = value.LineItemInventoryId;
                        UpdatedStockInLine.UnitId = value.LineUnitId;
                        UpdatedStockInLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                        UpdatedStockInLine.Cost = value.LineCost;
                        UpdatedStockInLine.Quantity = value.LineQuantity;
                        UpdatedStockInLine.Amount = value.LineAmount;

                        if (value.LineQuantity > 0)
                        {
                            UpdatedStockInLine.BaseUnitId = Items.First().UnitId;
                            UpdatedStockInLine.BaseQuantity = value.LineQuantity * ItemUnits.First().Multiplier;
                            UpdatedStockInLine.BaseCost = value.LineAmount / (value.LineQuantity * ItemUnits.First().Multiplier);
                        }
                        else
                        {
                            UpdatedStockInLine.BaseUnitId = Items.First().UnitId;
                            UpdatedStockInLine.BaseQuantity = 0;
                            UpdatedStockInLine.BaseCost = 0;
                        }

                        db.SubmitChanges();

                        //journal.JournalizedIN(value.LineINId);

                        //inventory.InsertInventoryIn(value.LineINId);

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
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // ===========================
        // DELETE api/TrnStockInLine/5
        // ===========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnStockInLine DeleteLine = db.TrnStockInLines.Where(d => d.Id == Id &&
                                                                           d.TrnStockIn.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnStockInLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    db.SubmitChanges();

                    //journal.JournalizedIN(DeleteLine.INId);

                    //inventory.InsertInventoryIn(DeleteLine.INId);

                    return true;
                }
                catch
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
    }
}