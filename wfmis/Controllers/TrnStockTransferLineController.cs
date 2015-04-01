using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnStockTransferLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ============================
        // GET api/TrnStockTransferLine
        // ============================

        [HttpGet]
        public List<Models.TrnStockTransferLine> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var TrnStockTransferLines = from d in db.TrnStockTransferLines
                                        where d.Id == BranchId &&
                                              d.TrnStockTransfer.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                        select new Models.TrnStockTransferLine
                                        {
                                           LineId = d.Id,
                                           LineSTId = d.STId,
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
            return TrnStockTransferLines.ToList();
        }

        // ============================================
        // GET api/TrnStockTransferLine/5/StockTransfer
        // ============================================

        [HttpGet]
        [ActionName("StockTransferLine")]
        public Models.TrnStockTransferLine Get(Int64 Id)
        {
            var StockTransferLines = from d in db.TrnStockTransferLines
                                     where d.Id == Id &&
                                           d.TrnStockTransfer.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                     select new Models.TrnStockTransferLine
                                     {
                                        LineId = d.Id,
                                        LineSTId = d.STId,
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

            if (StockTransferLines.Any())
            {
                return StockTransferLines.First();
            }
            else
            {
                return new Models.TrnStockTransferLine();
            }
        }

        // =============================
        // POST api/TrnStockTransferLine
        // =============================

        [HttpPost]
        public Models.TrnStockTransferLine Post(Models.TrnStockTransferLine value)
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
                    Data.TrnStockTransferLine NewStockTransferLine = new Data.TrnStockTransferLine();

                    NewStockTransferLine.STId = value.LineSTId;
                    NewStockTransferLine.ItemId = value.LineItemId;
                    NewStockTransferLine.ItemInventoryId = value.LineItemInventoryId;
                    NewStockTransferLine.UnitId = value.LineUnitId;
                    NewStockTransferLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    NewStockTransferLine.Cost = value.LineCost;
                    NewStockTransferLine.Quantity = value.LineQuantity;
                    NewStockTransferLine.Amount = value.LineAmount;

                    if (value.LineQuantity > 0)
                    {
                        NewStockTransferLine.BaseUnitId = Items.First().UnitId;
                        NewStockTransferLine.BaseQuantity = value.LineQuantity * ItemUnits.First().Multiplier;
                        NewStockTransferLine.BaseCost = value.LineAmount / (value.LineQuantity * ItemUnits.First().Multiplier);
                    }
                    else
                    {
                        NewStockTransferLine.BaseUnitId = Items.First().UnitId;
                        NewStockTransferLine.BaseQuantity = 0;
                        NewStockTransferLine.BaseCost = 0;
                    }

                    db.TrnStockTransferLines.InsertOnSubmit(NewStockTransferLine);
                    db.SubmitChanges();

                    // journal.JournalizedST(value.LineSTId);

                    // inventory.InsertInventoryTransfer(value.LineSTId);

                    return value;

                }
                else
                {
                    return new Models.TrnStockTransferLine();
                }
            }
            else
            {
                return new Models.TrnStockTransferLine();
            }
        }

        // ==============================
        // PUT api/TrnStockTransferLine/5
        // ==============================
        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnStockTransferLine value)
        {
            try
            {
                var StockTransferLines = from d in db.TrnStockTransferLines
                                    where d.Id == id &&
                                         d.TrnStockTransfer.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                if (StockTransferLines.Any())
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
                        var UpdatedStockTransferLine = StockTransferLines.FirstOrDefault();

                        UpdatedStockTransferLine.STId = value.LineSTId;
                        UpdatedStockTransferLine.ItemId = value.LineItemId;
                        if (value.LineItemInventoryId > 0) UpdatedStockTransferLine.ItemInventoryId = value.LineItemInventoryId;
                        UpdatedStockTransferLine.UnitId = value.LineUnitId;
                        UpdatedStockTransferLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                        UpdatedStockTransferLine.Cost = value.LineCost;
                        UpdatedStockTransferLine.Quantity = value.LineQuantity;
                        UpdatedStockTransferLine.Amount = value.LineAmount;

                        if (value.LineQuantity > 0)
                        {
                            UpdatedStockTransferLine.BaseUnitId = Items.First().UnitId;
                            UpdatedStockTransferLine.BaseQuantity = value.LineQuantity * ItemUnits.First().Multiplier;
                            UpdatedStockTransferLine.BaseCost = value.LineAmount / (value.LineQuantity * ItemUnits.First().Multiplier);
                        }
                        else
                        {
                            UpdatedStockTransferLine.BaseUnitId = Items.First().UnitId;
                            UpdatedStockTransferLine.BaseQuantity = 0;
                            UpdatedStockTransferLine.BaseCost = 0;
                        }

                        db.SubmitChanges();

                        // journal.JournalizedST(value.LineSTId);

                        // inventory.InsertInventoryTransfer(value.LineSTId);

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

        // =================================
        // DELETE api/TrnStockTransferLine/5
        // =================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnStockTransferLine DeleteLine = db.TrnStockTransferLines.Where(d => d.Id == Id &&
                                                                                       d.TrnStockTransfer.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnStockTransferLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    db.SubmitChanges();

                    // journal.JournalizedST(DeleteLine.STId);

                    // inventory.InsertInventoryTransfer(DeleteLine.STId);

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