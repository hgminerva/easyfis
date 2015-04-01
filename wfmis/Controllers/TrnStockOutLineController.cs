using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnStockOutLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // =======================
        // GET api/TrnStockOutLine
        // =======================

        [HttpGet]
        public List<Models.TrnStockOutLine> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var TrnStockOutLines = from d in db.TrnStockOutLines
                                   where d.Id == BranchId &&
                                         d.TrnStockOut.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                   select new Models.TrnStockOutLine
                                   {
                                      LineId = d.Id,
                                      LineOTId = d.OTId,
                                      LineItemId = d.ItemId,
                                      LineItem = d.MstArticle.Article,
                                      LineItemInventoryId = d.ItemInventoryId,
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
            return TrnStockOutLines.ToList();
        }

        // ==================================
        // GET api/TrnStockOutLine/5/StockOut
        // ==================================

        [HttpGet]
        [ActionName("StockOutLine")]
        public Models.TrnStockOutLine Get(Int64 Id)
        {
            var StockOutLines = from d in db.TrnStockOutLines
                                where d.Id == Id &&
                                      d.TrnStockOut.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select new Models.TrnStockOutLine
                                {
                                   LineId = d.Id,
                                   LineOTId = d.OTId,
                                   LineItemId = d.ItemId,
                                   LineItem = d.MstArticle.Article,
                                   LineItemInventoryId = d.ItemInventoryId == null ? 0 : d.ItemInventoryId,
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

            if (StockOutLines.Any())
            {
                return StockOutLines.First();
            }
            else
            {
                return new Models.TrnStockOutLine();
            }
        }

        // ========================
        // POST api/TrnStockOutLine
        // ========================

        [HttpPost]
        public Models.TrnStockOutLine Post(Models.TrnStockOutLine value)
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
                    Data.TrnStockOutLine NewStockOutLine = new Data.TrnStockOutLine();

                    NewStockOutLine.OTId = value.LineOTId;
                    NewStockOutLine.ItemId = value.LineItemId;
                    NewStockOutLine.ItemInventoryId = value.LineItemInventoryId;
                    NewStockOutLine.UnitId = value.LineUnitId;
                    NewStockOutLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    NewStockOutLine.Cost = value.LineCost;
                    NewStockOutLine.Quantity = value.LineQuantity;
                    NewStockOutLine.Amount = value.LineAmount;

                    if (value.LineQuantity > 0)
                    {
                        NewStockOutLine.BaseUnitId = Items.First().UnitId;
                        NewStockOutLine.BaseQuantity = value.LineQuantity * ItemUnits.First().Multiplier;
                        NewStockOutLine.BaseCost = value.LineAmount / (value.LineQuantity * ItemUnits.First().Multiplier);
                    }
                    else
                    {
                        NewStockOutLine.BaseUnitId = Items.First().UnitId;
                        NewStockOutLine.BaseQuantity = 0;
                        NewStockOutLine.BaseCost = 0;
                    }

                    db.TrnStockOutLines.InsertOnSubmit(NewStockOutLine);
                    db.SubmitChanges();

                    //journal.JournalizedOT(value.LineOTId);

                    //inventory.InsertInventoryOut(value.LineOTId);

                    return value;

                }
                else
                {
                    return new Models.TrnStockOutLine();
                }
            }
            else
            {
                return new Models.TrnStockOutLine();
            }
        }

        // =========================
        // PUT api/TrnStockOutLine/5
        // =========================
        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnStockOutLine value)
        {
            try
            {
                var StockOutLines = from d in db.TrnStockOutLines
                                    where d.Id == id &&
                                         d.TrnStockOut.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                if (StockOutLines.Any())
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
                        var UpdatedStockOutLine = StockOutLines.FirstOrDefault();

                        UpdatedStockOutLine.OTId = value.LineOTId;
                        UpdatedStockOutLine.ItemId = value.LineItemId;
                        if (value.LineItemInventoryId > 0) UpdatedStockOutLine.ItemInventoryId = value.LineItemInventoryId;
                        UpdatedStockOutLine.UnitId = value.LineUnitId;
                        UpdatedStockOutLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                        UpdatedStockOutLine.Cost = value.LineCost;
                        UpdatedStockOutLine.Quantity = value.LineQuantity;
                        UpdatedStockOutLine.Amount = value.LineAmount;

                        if (value.LineQuantity > 0)
                        {
                            UpdatedStockOutLine.BaseUnitId = Items.First().UnitId;
                            UpdatedStockOutLine.BaseQuantity = value.LineQuantity * ItemUnits.First().Multiplier;
                            UpdatedStockOutLine.BaseCost = value.LineAmount / (value.LineQuantity * ItemUnits.First().Multiplier);
                        }
                        else
                        {
                            UpdatedStockOutLine.BaseUnitId = Items.First().UnitId;
                            UpdatedStockOutLine.BaseQuantity = 0;
                            UpdatedStockOutLine.BaseCost = 0;
                        }

                        db.SubmitChanges();

                        //journal.JournalizedOT(value.LineOTId);

                        //inventory.InsertInventoryOut(value.LineOTId);

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

        // ============================
        // DELETE api/TrnStockOutLine/5
        // ============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnStockOutLine DeleteLine = db.TrnStockOutLines.Where(d => d.Id == Id &&
                                                                             d.TrnStockOut.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnStockOutLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    db.SubmitChanges();

                    //journal.JournalizedOT(DeleteLine.OTId);

                    //inventory.InsertInventoryOut(DeleteLine.OTId);

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