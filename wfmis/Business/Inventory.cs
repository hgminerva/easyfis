using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Web;
using wfmis.Data;
using wfmis.Models;

namespace wfmis.Business
{
    public class Inventory
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();

        private Int64 GetInventoryNumber(Int64 ArticleId, decimal Quantity)
        {
            var MstArticleItemInventories = from d in db.MstArticleItemInventories
                                            where d.ArticleId == ArticleId &&
                                                  d.BalanceQuantity >= Quantity
                                            orderby d.BalanceQuantity descending
                                            select d;
            if (MstArticleItemInventories.Any())
            {
                return MstArticleItemInventories.First().Id;
            } 
            else 
            {
                return 0;
            }
        }

        public void CalculateMstArticleInventoryBalance(Int64 ItemInventoryId)
        {
            decimal TotalQuantityIn, TotalQuantityOut;
            decimal TotalAmountIn, TotalAmountOut;

            var MstArticleItemInventories = from d in db.MstArticleItemInventories 
                                            where d.Id == ItemInventoryId
                                            select d;

            if (MstArticleItemInventories.Any())
            {
                string InventoryValuationMethod = MstArticleItemInventories.First().MstBranch.MstUser.InventoryValuationMethod;

                var TrnInventories = from d in db.TrnInventories 
                                     where d.ItemInventoryId == ItemInventoryId 
                                     select d;
                if (TrnInventories.Any())
                {
                    TotalQuantityIn = TrnInventories.Sum(d => d.QuantityIn);
                    TotalQuantityOut = TrnInventories.Sum(d => d.QuantityOut);
                    TotalAmountIn = TrnInventories.Sum(d => d.Amount > 0 ? d.Amount : 0);
                    TotalAmountOut = TrnInventories.Sum(d => d.Amount < 0? d.Amount : 0);
                }
                else
                {
                    TotalQuantityIn = 0;
                    TotalQuantityOut = 0;
                    TotalAmountIn = 0;
                    TotalAmountOut = 0;
                }

                var UpdatedMstArticleItemInventory = MstArticleItemInventories.First();

                UpdatedMstArticleItemInventory.TotalQuantityIn = TotalQuantityIn;
                UpdatedMstArticleItemInventory.TotalQuantityOut = TotalQuantityOut;
                UpdatedMstArticleItemInventory.BalanceQuantity = TotalQuantityIn - TotalQuantityOut;

                if (InventoryValuationMethod == "AVERAGE")
                {
                    if ((TotalQuantityIn - TotalQuantityOut) != 0)
                    {
                        UpdatedMstArticleItemInventory.Amount = TotalAmountIn + TotalAmountOut;
                        UpdatedMstArticleItemInventory.Cost = (TotalAmountIn + TotalAmountOut) / (TotalQuantityIn - TotalQuantityOut);
                    }
                    else
                    {
                        UpdatedMstArticleItemInventory.Amount = 0;
                        UpdatedMstArticleItemInventory.Cost = 0;
                    }
                }

                db.SubmitChanges();
            }
        }

        public bool FlushInventory(string Document, Int64 Id)
        {
            try
            {
                switch (Document)
                {
                    case "IN":
                        // Delete TrnInventories
                        var DeleteTrnInventoriesIN = db.TrnInventories.Where(d => d.INId == Id && 
                                                                                  d.OTId == null && 
                                                                                  d.STId == null );
                        if (DeleteTrnInventoriesIN.Any())
                        {
                            foreach (Data.TrnInventory DeleteTrnInventory in DeleteTrnInventoriesIN)
                            {
                                db.TrnInventories.DeleteOnSubmit(DeleteTrnInventory);
                                db.SubmitChanges();
                            }
                        }
                        // Recalculate MstArticleItemInventories
                        var RecalcTrnStockInLines = db.TrnStockInLines.Where(d => d.INId == Id);
                        if (RecalcTrnStockInLines.Any())
                        {
                            foreach (Data.TrnStockInLine RecalcTrnStockInLine in RecalcTrnStockInLines)
                            {
                                if (RecalcTrnStockInLine.ItemInventoryId > 0)
                                {
                                    this.CalculateMstArticleInventoryBalance(RecalcTrnStockInLine.ItemInventoryId.Value);
                                }
                            }
                        }
                        // Remove MstArticleItemInventories
                        var MstArticleItemInventories = from d in db.MstArticleItemInventories
                                                        where d.INId == Id
                                                        select d;
                        if (MstArticleItemInventories.Any())
                        {
                            foreach (Data.MstArticleItemInventory MstArticleItemInventory in MstArticleItemInventories)
                            {
                                db.MstArticleItemInventories.DeleteOnSubmit(MstArticleItemInventory);
                                db.SubmitChanges();
                            }
                        }
                        break;
                    case "OT":
                        // Delete TrnInventories
                        var DeleteTrnInventoriesOT = db.TrnInventories.Where(d => d.INId == null &&
                                                                                  d.OTId == Id && 
                                                                                  d.STId == null );
                        if (DeleteTrnInventoriesOT.Any())
                        {
                            foreach (Data.TrnInventory DeleteTrnInventory in DeleteTrnInventoriesOT)
                            {
                                db.TrnInventories.DeleteOnSubmit(DeleteTrnInventory);
                                db.SubmitChanges();
                            }
                        }
                        // Recalculate MstArticleItemInventories
                        var RecalcTrnStockOutLines = db.TrnStockOutLines.Where(d => d.OTId == Id);
                        if (RecalcTrnStockOutLines.Any())
                        {
                            foreach (Data.TrnStockOutLine RecalcTrnStockOutLine in RecalcTrnStockOutLines)
                            {
                                if (RecalcTrnStockOutLine.ItemInventoryId > 0)
                                {
                                    this.CalculateMstArticleInventoryBalance(RecalcTrnStockOutLine.ItemInventoryId);
                                }
                            }
                        }
                        break;
                    case "ST":
                        // Delete TrnInventories
                        var DeleteTrnInventoriesST = db.TrnInventories.Where(d => d.INId == null &&
                                                                                  d.OTId == null && 
                                                                                  d.STId == Id );
                        if (DeleteTrnInventoriesST.Any())
                        {
                            foreach (Data.TrnInventory DeleteTrnInventory in DeleteTrnInventoriesST)
                            {
                                db.TrnInventories.DeleteOnSubmit(DeleteTrnInventory);
                                db.SubmitChanges();
                            }
                        }
                        // Recalculate MstArticleItemInventories
                        var RecalcTrnStockTransferLines = db.TrnStockTransferLines.Where(d => d.STId == Id);
                        if (RecalcTrnStockTransferLines.Any())
                        {
                            foreach (Data.TrnStockTransferLine RecalcTrnStockTransferLine in RecalcTrnStockTransferLines)
                            {
                                if (RecalcTrnStockTransferLine.ItemInventoryId > 0)
                                {
                                    this.CalculateMstArticleInventoryBalance(RecalcTrnStockTransferLine.ItemInventoryId);
                                }
                            }
                        }
                        break;
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool InsertInventoryIn(Int64 INId)
        {
            Int64 ItemInventoryId = 0;
            try
            {
                // Get the branch
                Int64 BranchId = 0;
                var TrnStockIn = from d in db.TrnStockIns where d.Id == INId select d;
                if (TrnStockIn.Any()) BranchId = TrnStockIn.First().BranchId;

                if (BranchId > 0)
                {
                    this.FlushInventory("IN",INId);

                    var TrnStockInLines = from d in db.TrnStockInLines
                                          where d.INId == INId && 
                                                d.TrnStockIn.IsLocked == true
                                          group d by new  
                                          {
                                              d.TrnStockIn.MstBranch.UserId,
                                              d.INId,
                                              d.TrnStockIn.INNumber,
                                              d.TrnStockIn.PeriodId,
                                              d.TrnStockIn.INDate,
                                              d.ItemId,
                                              d.ItemInventoryId,
                                              d.BaseUnitId,
                                              d.BaseCost
                                          } into g
                                          select new 
                                          {
                                              UserId = g.Key.UserId,
                                              INId = g.Key.INId,
                                              INNumber = g.Key.INNumber,
                                              PeriodId = g.Key.PeriodId,
                                              InventoryDate = g.Key.INDate,
                                              ItemId =g.Key.ItemId,
                                              ItemInventoryId = g.Key.ItemInventoryId,
                                              UnitId = g.Key.BaseUnitId,
                                              Cost = g.Key.BaseCost,
                                              QuantityIn = g.Sum(a=>a.BaseQuantity),
                                              QuantityOut = 0
                                          };

                    if (TrnStockInLines.Any())
                    {
                        var UserSettings = from d in db.MstUsers 
                                           where d.Id == TrnStockInLines.First().UserId 
                                           select d;

                        foreach (var Line in TrnStockInLines)
                        {
                            if (Line.QuantityIn > 0)
                            {
                                // Add MstArticleItemInventory
                                ItemInventoryId = 0;
                                if (UserSettings.First().InventoryValuationMethod == "AVERAGE")
                                { // AVERAGE
                                    if (Line.ItemInventoryId == null) 
                                    {
                                        var MstArticleInventories = from d in db.MstArticleItemInventories
                                                                    where d.ArticleId == Line.ItemId
                                                                    select d;
                                        if (MstArticleInventories.Any())
                                        {
                                            ItemInventoryId = MstArticleInventories.First().Id;
                                        }
                                        else
                                        {
                                            Data.MstArticleItemInventory NewArticleItemInventory = new Data.MstArticleItemInventory();
                                            
                                            NewArticleItemInventory.ArticleId = Line.ItemId;
                                            NewArticleItemInventory.BranchId = BranchId;
                                            NewArticleItemInventory.INId = INId;
                                            NewArticleItemInventory.InventoryNumber = "IN-" + Line.INNumber;
                                            NewArticleItemInventory.Cost = Line.Cost;
                                            NewArticleItemInventory.TotalQuantityIn = 0;
                                            NewArticleItemInventory.TotalQuantityOut = 0;
                                            NewArticleItemInventory.BalanceQuantity = 0;
                                            NewArticleItemInventory.UnitId = Line.UnitId;
                                            NewArticleItemInventory.Amount = 0;

                                            db.MstArticleItemInventories.InsertOnSubmit(NewArticleItemInventory);
                                            db.SubmitChanges();

                                            ItemInventoryId = NewArticleItemInventory.Id;
                                        }
                                    }
                                    else
                                    {
                                        ItemInventoryId = Line.ItemInventoryId.Value;
                                    }
                                }
                                else
                                { // SPECIFIC
                                    if (Line.ItemInventoryId == null)
                                    {
                                        Data.MstArticleItemInventory NewArticleItemInventory = new Data.MstArticleItemInventory();

                                        NewArticleItemInventory.ArticleId = Line.ItemId;
                                        NewArticleItemInventory.BranchId = BranchId;
                                        NewArticleItemInventory.INId = INId;
                                        NewArticleItemInventory.InventoryNumber = "IN-" + Line.INNumber;
                                        NewArticleItemInventory.Cost = Line.Cost;
                                        NewArticleItemInventory.TotalQuantityIn = 0;
                                        NewArticleItemInventory.TotalQuantityOut = 0;
                                        NewArticleItemInventory.BalanceQuantity = 0;
                                        NewArticleItemInventory.UnitId = Line.UnitId;
                                        NewArticleItemInventory.Amount = 0;

                                        db.MstArticleItemInventories.InsertOnSubmit(NewArticleItemInventory);
                                        db.SubmitChanges();

                                        ItemInventoryId = NewArticleItemInventory.Id;
                                    }
                                    else
                                    {
                                        ItemInventoryId = Line.ItemInventoryId.Value;
                                    }
                                }

                                // Insert TrnInventory
                                if (ItemInventoryId > 0)
                                {
                                    Data.TrnInventory NewInventory = new Data.TrnInventory();

                                    NewInventory.INId = INId;
                                    NewInventory.PeriodId = Line.PeriodId;
                                    NewInventory.InventoryDate = Line.InventoryDate;
                                    NewInventory.BranchId = BranchId;
                                    NewInventory.ItemId = Line.ItemId;
                                    NewInventory.ItemInventoryId = ItemInventoryId;
                                    NewInventory.Particulars = "NA";
                                    NewInventory.UnitId = Line.UnitId;
                                    NewInventory.Cost = Line.Cost;
                                    NewInventory.QuantityIn = Line.QuantityIn;
                                    NewInventory.QuantityOut = 0;
                                    NewInventory.Quantity = Line.QuantityIn;
                                    NewInventory.Amount = Line.Cost * Line.QuantityIn;

                                    db.TrnInventories.InsertOnSubmit(NewInventory);
                                    db.SubmitChanges();
                                }

                                // Update MstArticleItemInventory
                                if (ItemInventoryId > 0)
                                {
                                    this.CalculateMstArticleInventoryBalance(ItemInventoryId);
                                }
                            }
                        }
                    }
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool InsertInventoryOut(Int64 OTId)
        {
            Int64 ItemInventoryId = 0;
            try
            {
                // Get the branch
                Int64 BranchId = 0;
                var TrnStockOut = from d in db.TrnStockOuts where d.Id == OTId select d;
                if (TrnStockOut.Any()) BranchId = TrnStockOut.First().BranchId;

                if (BranchId > 0)
                {
                    this.FlushInventory("OT", OTId);

                    var TrnStockOutLines = from d in db.TrnStockOutLines
                                          where d.OTId == OTId &&
                                                d.TrnStockOut.IsLocked == true
                                          group d by new
                                          {
                                              d.OTId,
                                              d.TrnStockOut.OTNumber,
                                              d.TrnStockOut.PeriodId,
                                              d.TrnStockOut.OTDate,
                                              d.ItemId,
                                              d.ItemInventoryId,
                                              d.BaseUnitId,
                                              d.BaseCost
                                          } into g
                                          select new
                                          {
                                              OTId = g.Key.OTId,
                                              INNumber = g.Key.OTNumber,
                                              PeriodId = g.Key.PeriodId,
                                              InventoryDate = g.Key.OTDate,
                                              ItemId = g.Key.ItemId,
                                              ItemInventoryId = g.Key.ItemInventoryId,
                                              UnitId = g.Key.BaseUnitId,
                                              Cost = g.Key.BaseCost,
                                              QuantityIn = 0,
                                              QuantityOut = g.Sum(a => a.BaseQuantity)
                                          };

                    if (TrnStockOutLines.Any())
                    {
                        foreach (var Line in TrnStockOutLines)
                        {
                            if (Line.QuantityOut > 0)
                            {
                                Data.TrnInventory NewInventory = new Data.TrnInventory();

                                NewInventory.OTId = OTId;
                                NewInventory.PeriodId = Line.PeriodId;
                                NewInventory.InventoryDate = Line.InventoryDate;
                                NewInventory.BranchId = BranchId;
                                NewInventory.ItemId = Line.ItemId;
                                NewInventory.ItemInventoryId = Line.ItemInventoryId;
                                NewInventory.Particulars = "NA";
                                NewInventory.UnitId = Line.UnitId;
                                NewInventory.Cost = Line.Cost;
                                NewInventory.QuantityIn = 0;
                                NewInventory.QuantityOut = Line.QuantityOut;
                                NewInventory.Quantity = Line.QuantityOut * -1;
                                NewInventory.Amount = (Line.Cost * Line.QuantityOut) * -1;

                                db.TrnInventories.InsertOnSubmit(NewInventory);
                                db.SubmitChanges();

                                this.CalculateMstArticleInventoryBalance(ItemInventoryId);
                            }
                        }
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }
        
        public bool InsertInventoryTransfer(Int64 STId)
        {
            Int64 ItemInventoryId = 0;
            try
            {
                // Get the branch
                Int64 FromBranchId = 0;
                Int64 ToBranchId = 0;

                var TrnStockTransfer = from d in db.TrnStockTransfers where d.Id == STId select d;
                if (TrnStockTransfer.Any()) 
                {
                    FromBranchId = TrnStockTransfer.First().BranchId;
                    ToBranchId= TrnStockTransfer.First().ToBranchId;
                }

                if (FromBranchId > 0)
                {
                    this.FlushInventory("ST", STId);

                    var TrnStockTransferLines = from d in db.TrnStockTransferLines
                                                where d.STId == STId &&
                                                      d.TrnStockTransfer.IsLocked == true
                                                group d by new
                                                {
                                                    d.STId,
                                                    d.TrnStockTransfer.STNumber,
                                                    d.TrnStockTransfer.PeriodId,
                                                    d.TrnStockTransfer.STDate,
                                                    d.ItemId,
                                                    d.ItemInventoryId,
                                                    d.BaseUnitId,
                                                    d.BaseCost
                                                } into g
                                                select new
                                                {
                                                    STId = g.Key.STId,
                                                    STNumber = g.Key.STNumber,
                                                    PeriodId = g.Key.PeriodId,
                                                    InventoryDate = g.Key.STDate,
                                                    ItemId = g.Key.ItemId,
                                                    ItemInventoryId = g.Key.ItemInventoryId,
                                                    UnitId = g.Key.BaseUnitId,
                                                    Cost = g.Key.BaseCost,
                                                    QuantityIn = g.Sum(a => a.BaseQuantity),
                                                    QuantityOut = g.Sum(a => a.BaseQuantity)
                                                };

                    if (TrnStockTransferLines.Any())
                    {
                        foreach (var Line in TrnStockTransferLines)
                        {
                            // Stock Out
                            if (Line.QuantityOut > 0) 
                            {
                                ItemInventoryId = Line.ItemInventoryId;

                                if (ItemInventoryId > 0)
                                {
                                    Data.TrnInventory NewInventory = new Data.TrnInventory();

                                    NewInventory.STId = STId;
                                    NewInventory.PeriodId = Line.PeriodId;
                                    NewInventory.InventoryDate = Line.InventoryDate;
                                    NewInventory.BranchId = FromBranchId;
                                    NewInventory.ItemId = Line.ItemId;
                                    NewInventory.ItemInventoryId = ItemInventoryId;
                                    NewInventory.Particulars = "NA";
                                    NewInventory.UnitId = Line.UnitId;
                                    NewInventory.Cost = Line.Cost;
                                    NewInventory.QuantityIn = 0;
                                    NewInventory.QuantityOut = Line.QuantityOut;
                                    NewInventory.Quantity = Line.QuantityOut * -1;
                                    NewInventory.Amount = (Line.Cost * Line.QuantityOut) * -1;

                                    db.TrnInventories.InsertOnSubmit(NewInventory);
                                    db.SubmitChanges();

                                    this.CalculateMstArticleInventoryBalance(ItemInventoryId);
                                }
                            }

                            // Stock In
                            if (Line.QuantityIn > 0)
                            {
                               
                                ItemInventoryId = 0;

                                var ArticleItemInventories = from d in db.MstArticleItemInventories
                                                             where d.Id == Line.ItemInventoryId &&
                                                                   d.BranchId == ToBranchId
                                                             select d;

                                if (ArticleItemInventories.Any())
                                {
                                    ItemInventoryId = Line.ItemInventoryId;
                                }
                                else
                                {
                                    // Create a batch
                                    Data.MstArticleItemInventory NewArticleItemInventory = new Data.MstArticleItemInventory();

                                    NewArticleItemInventory.ArticleId = Line.ItemId;
                                    NewArticleItemInventory.BranchId = ToBranchId;
                                    NewArticleItemInventory.STId = STId;
                                    NewArticleItemInventory.InventoryNumber = "ST-" + Line.STNumber;
                                    NewArticleItemInventory.Cost = Line.Cost;
                                    NewArticleItemInventory.TotalQuantityIn = 0;
                                    NewArticleItemInventory.TotalQuantityOut = 0;
                                    NewArticleItemInventory.BalanceQuantity = 0;
                                    NewArticleItemInventory.UnitId = Line.UnitId;
                                    NewArticleItemInventory.Amount = 0;

                                    db.MstArticleItemInventories.InsertOnSubmit(NewArticleItemInventory);
                                    db.SubmitChanges();

                                    ItemInventoryId = NewArticleItemInventory.Id;
                                }

                                if (ItemInventoryId > 0)
                                {
                                    Data.TrnInventory NewInventory = new Data.TrnInventory();

                                    NewInventory.STId = STId;
                                    NewInventory.PeriodId = Line.PeriodId;
                                    NewInventory.InventoryDate = Line.InventoryDate;
                                    NewInventory.BranchId = ToBranchId;
                                    NewInventory.ItemId = Line.ItemId;
                                    NewInventory.ItemInventoryId = ItemInventoryId;
                                    NewInventory.Particulars = "NA";
                                    NewInventory.UnitId = Line.UnitId;
                                    NewInventory.Cost = Line.Cost;
                                    NewInventory.QuantityIn = Line.QuantityIn;
                                    NewInventory.QuantityOut = 0;
                                    NewInventory.Quantity = Line.QuantityIn;
                                    NewInventory.Amount = Line.Cost * Line.QuantityIn;

                                    db.TrnInventories.InsertOnSubmit(NewInventory);
                                    db.SubmitChanges();

                                    this.CalculateMstArticleInventoryBalance(ItemInventoryId);
                                }
                            }


                        }
                    }
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool CreateStockIn(Int64 PIId)
        {
            try
            {
                Int64 BranchId = 0;
                bool IsAutoInventory = false;

                var TrnPurchaseInvoices = from d in db.TrnPurchaseInvoices 
                                          where d.Id == PIId && d.IsLocked == true
                                          select d;

                if (TrnPurchaseInvoices.Any())
                {
                    if (TrnPurchaseInvoices.First().TrnPurchaseInvoiceLines.Where(d=>d.MstArticle.MstArticleItems.First().IsAsset == true).Count() > 0)
                    {
                        BranchId = TrnPurchaseInvoices.First().BranchId;
                        IsAutoInventory = TrnPurchaseInvoices.First().MstBranch.MstUser.IsAutoInventory;

                        if (BranchId > 0 && IsAutoInventory == true && TrnPurchaseInvoices.First().TrnStockIns.Count() == 0)
                        {
                            // Stock In Header

                            Data.TrnStockIn NewStockIn = new Data.TrnStockIn();
                            string INNumber = "0000000001";
                            SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                              DateTime.Now.Month, +
                                                                              DateTime.Now.Day));
                            var TrnStockIns = from d in db.TrnStockIns
                                              where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() && 
                                                    d.BranchId == BranchId
                                              select d;

                            if (TrnStockIns.Any())
                            {
                                var MaxINNumber = Convert.ToDouble(TrnStockIns.Max(d => d.INNumber)) + 10000000001;
                                INNumber = MaxINNumber.ToString().Trim().Substring(1);
                            }
                            NewStockIn.INNumber = INNumber;
                            NewStockIn.PeriodId = TrnPurchaseInvoices.First().PeriodId;
                            NewStockIn.BranchId = BranchId;
                            NewStockIn.INManualNumber = INNumber;
                            NewStockIn.INDate = TrnPurchaseInvoices.First().PIDate;
                            NewStockIn.PIId = PIId;
                            NewStockIn.AccountId = TrnPurchaseInvoices.First().MstBranch.MstUser.ItemPurchaseAccountId.Value;
                            NewStockIn.ArticleId = TrnPurchaseInvoices.First().SupplierId;
                            NewStockIn.Particulars = "Auto insert - PI No.: " + TrnPurchaseInvoices.First().PINumber;
                            NewStockIn.PreparedById = secure.GetCurrentUser();
                            NewStockIn.CheckedById = secure.GetCurrentUser();
                            NewStockIn.ApprovedById = secure.GetCurrentUser();
                            NewStockIn.IsLocked = false;
                            NewStockIn.IsProduced = false;
                            NewStockIn.CreatedById = secure.GetCurrentUser();
                            NewStockIn.CreatedDateTime = SQLNow.Value;
                            NewStockIn.UpdatedById = secure.GetCurrentUser();
                            NewStockIn.UpdatedDateTime = SQLNow.Value;

                            db.TrnStockIns.InsertOnSubmit(NewStockIn);
                            db.SubmitChanges();

                            // Stock In Lines

                            var TrnPurchaseInvoiceLines = from d in db.TrnPurchaseInvoiceLines
                                                          where d.PIId == PIId && 
                                                                d.TrnPurchaseInvoice.IsLocked == true && 
                                                                d.Quantity > 0 &&
                                                                d.MstArticle.MstArticleItems.First().IsAsset == true
                                                          select d;

                            foreach (var Line in TrnPurchaseInvoiceLines) 
                            {
                                Data.TrnStockInLine NewStockInLine = new Data.TrnStockInLine();

                                NewStockInLine.INId = NewStockIn.Id;
                                NewStockInLine.ItemId = Line.ItemId;
                                NewStockInLine.Particulars = Line.Particulars;
                                NewStockInLine.UnitId = Line.UnitId;
                                NewStockInLine.Quantity = Line.Quantity;
                                // Tax Rate
                                decimal TaxRate = Line.TaxRate;
                                decimal Cost = Line.Cost;
                                if (TaxRate > 0)
                                {
                                    Cost = Line.Cost / (1 + TaxRate); 
                                }
                                NewStockInLine.Cost = Math.Round(Cost,2);
                                NewStockInLine.Amount = Math.Round(Cost * Line.Quantity,2);
                                // Base Unit
                                Int64 BaseUnitId = Line.MstArticle.MstArticleItems.First().UnitId;
                                decimal Multiplier = 1;

                                if (Line.UnitId != BaseUnitId)
                                {
                                    var Conversions = from d in Line.MstArticle.MstArticleItemUnits
                                                      where d.UnitId == BaseUnitId
                                                      select d;
                                    if (Conversions.Any()) Multiplier = Conversions.First().Multiplier;
                                }
                                NewStockInLine.BaseUnitId = BaseUnitId;
                                NewStockInLine.BaseQuantity = Line.Quantity * Multiplier;
                                NewStockInLine.BaseCost = Math.Round((Cost * Line.Quantity) / (Line.Quantity * Multiplier),2);

                                db.TrnStockInLines.InsertOnSubmit(NewStockInLine);
                                db.SubmitChanges();
                            }

                            // Approved Stock In

                            var StockIns = from d in db.TrnStockIns where d.Id == NewStockIn.Id select d;
                            if (StockIns.Any()) {
                                var ApprovedStockIn = StockIns.First();
                                ApprovedStockIn.IsLocked = true;
                                db.SubmitChanges();
                            }
                            
                            journal.JournalizedIN(NewStockIn.Id);

                            this.InsertInventoryIn(NewStockIn.Id);

                            return true;
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        public bool CreateStockOut(Int64 Id, bool IsProduced)
        {
            //try
            //{
                Int64 BranchId = 0;
                bool IsAutoInventory = false;

                if (IsProduced == false)
                {
                    // From Sales Invoice
                    var TrnSalesInvoices = from d in db.TrnSalesInvoices
                                           where d.Id == Id && d.IsLocked == true
                                           select d;

                    if (TrnSalesInvoices.Any())
                    {
                        if (TrnSalesInvoices.First().TrnSalesInvoiceLines.Where(d => d.MstArticle.MstArticleItems.First().IsAsset == true).Count() > 0)
                        {
                            BranchId = TrnSalesInvoices.First().BranchId;
                            IsAutoInventory = TrnSalesInvoices.First().MstBranch.MstUser.IsAutoInventory;

                            if (BranchId > 0 && IsAutoInventory == true && TrnSalesInvoices.First().TrnStockOuts.Count() == 0)
                            {
                                // Stock Out Header

                                Data.TrnStockOut NewStockOut = new Data.TrnStockOut();
                                string OTNumber = "0000000001";
                                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                                  DateTime.Now.Month, +
                                                                                  DateTime.Now.Day));
                                var TrnStockOuts = from d in db.TrnStockOuts
                                                   where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                         d.BranchId == BranchId
                                                   select d;

                                if (TrnStockOuts.Any())
                                {
                                    var MaxOTNumber = Convert.ToDouble(TrnStockOuts.Max(d => d.OTNumber)) + 10000000001;
                                    OTNumber = MaxOTNumber.ToString().Trim().Substring(1);
                                }
                                NewStockOut.OTNumber = OTNumber;
                                NewStockOut.PeriodId = TrnSalesInvoices.First().PeriodId;
                                NewStockOut.BranchId = BranchId;
                                NewStockOut.OTManualNumber = OTNumber;
                                NewStockOut.OTDate = SQLNow.Value;
                                NewStockOut.SIId = Id;
                                NewStockOut.AccountId = TrnSalesInvoices.First().MstArticle.AccountId;
                                NewStockOut.ArticleId = TrnSalesInvoices.First().CustomerId;
                                NewStockOut.Particulars = "Auto insert - SI No.: " + TrnSalesInvoices.First().SINumber;
                                NewStockOut.PreparedById = secure.GetCurrentUser();
                                NewStockOut.CheckedById = secure.GetCurrentUser();
                                NewStockOut.ApprovedById = secure.GetCurrentUser();
                                NewStockOut.IsLocked = false;
                                NewStockOut.CreatedById = secure.GetCurrentUser();
                                NewStockOut.CreatedDateTime = SQLNow.Value;
                                NewStockOut.UpdatedById = secure.GetCurrentUser();
                                NewStockOut.UpdatedDateTime = SQLNow.Value;

                                db.TrnStockOuts.InsertOnSubmit(NewStockOut);
                                db.SubmitChanges();

                                // Stock Out Lines

                                var TrnSalesInvoiceLines = from d in db.TrnSalesInvoiceLines
                                                           where d.SIId == Id &&
                                                                 d.TrnSalesInvoice.IsLocked == true &&
                                                                 d.Quantity > 0
                                                           select d;

                                foreach (var Line in TrnSalesInvoiceLines)
                                {
                                    if (Line.MstArticle.MstArticleItems.First().IsAsset == true)
                                    {
                                        // Inventory Item
                                        Data.TrnStockOutLine NewStockOutLine = new Data.TrnStockOutLine();

                                        NewStockOutLine.OTId = NewStockOut.Id;
                                        NewStockOutLine.ItemId = Line.ItemId;
                                        NewStockOutLine.ItemInventoryId = Line.ItemInventoryId.Value;
                                        NewStockOutLine.Particulars = Line.Particulars;
                                        NewStockOutLine.UnitId = Line.UnitId;
                                        NewStockOutLine.Quantity = Line.Quantity;

                                        decimal Cost = Line.ItemInventoryId > 0 ? Line.MstArticleItemInventory.Cost : 0;
                                        NewStockOutLine.Cost = Math.Round(Cost, 2);
                                        NewStockOutLine.Amount = Math.Round(Cost * Line.Quantity, 2);

                                        Int64 BaseUnitId = Line.MstArticle.MstArticleItems.First().UnitId;
                                        decimal Multiplier = 1;

                                        if (Line.UnitId != BaseUnitId)
                                        {
                                            var Conversions = from d in Line.MstArticle.MstArticleItemUnits
                                                              where d.UnitId == BaseUnitId
                                                              select d;
                                            if (Conversions.Any()) Multiplier = Conversions.First().Multiplier;
                                        }
                                        NewStockOutLine.BaseUnitId = BaseUnitId;
                                        NewStockOutLine.BaseQuantity = Line.Quantity * Multiplier;
                                        NewStockOutLine.BaseCost = Math.Round((Cost * Line.Quantity) / (Line.Quantity * Multiplier), 2);

                                        db.TrnStockOutLines.InsertOnSubmit(NewStockOutLine);
                                        db.SubmitChanges();
                                    }
                                    else
                                    {
                                        // Non-inventory Item with components
                                        var MstArticleItemComponents = from d in db.MstArticleItemComponents
                                                                       where d.ArticleId == Line.ItemId
                                                                       select d;
                                        if (MstArticleItemComponents.Any())
                                        {
                                            foreach (var Component in MstArticleItemComponents)
                                            {
                                                decimal Quantity = Component.Quantity * Line.Quantity;
                                                Int64 ItemInventoryId = GetInventoryNumber(Component.ComponentArticleId, Quantity);
                                                if (ItemInventoryId > 0)
                                                {
                                                    Data.TrnStockOutLine NewStockOutLine = new Data.TrnStockOutLine();

                                                    NewStockOutLine.OTId = NewStockOut.Id;
                                                    NewStockOutLine.ItemId = Component.ComponentArticleId;
                                                    NewStockOutLine.Particulars = Line.Particulars;
                                                    NewStockOutLine.UnitId = Component.UnitId;
                                                    NewStockOutLine.Quantity = Quantity;
                                                    NewStockOutLine.BaseUnitId = Component.UnitId;
                                                    NewStockOutLine.BaseQuantity = Quantity;

                                                    NewStockOutLine.ItemInventoryId = ItemInventoryId;

                                                    decimal Cost = db.MstArticleItemInventories.Where(d => d.Id == ItemInventoryId).First().Cost;
                                                    NewStockOutLine.Cost = Math.Round(Cost, 2);
                                                    NewStockOutLine.Amount = Math.Round(Cost * Quantity, 2);
                                                    NewStockOutLine.BaseCost = Math.Round(Cost, 2);

                                                    db.TrnStockOutLines.InsertOnSubmit(NewStockOutLine);
                                                    db.SubmitChanges();
                                                }
                                            }
                                        }
                                    }
                                }

                                // Approved Stock Out

                                var StockOuts = from d in db.TrnStockOuts where d.Id == NewStockOut.Id select d;
                                if (StockOuts.Any())
                                {
                                    var ApprovedStockOut = StockOuts.First();
                                    ApprovedStockOut.IsLocked = true;
                                    db.SubmitChanges();
                                }

                                journal.JournalizedOT(NewStockOut.Id);

                                this.InsertInventoryOut(NewStockOut.Id);

                                return true;
                            }
                            else
                            {
                                return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    // From Stock In (Produced Internally)
                    var TrnStockIns = from d in db.TrnStockIns
                                      where d.Id == Id && d.IsLocked == true && d.IsProduced == true
                                      select d;

                    if (TrnStockIns.Any())
                    {
                        if (TrnStockIns.First().TrnStockInLines.Where(d => d.MstArticle.MstArticleItems.First().IsAsset == true).Count() > 0)
                        {
                            BranchId = TrnStockIns.First().BranchId;

                            if (BranchId > 0 && TrnStockIns.First().TrnStockOuts.Count() == 0)
                            {
                                // Stock Out Header

                                Data.TrnStockOut NewStockOut = new Data.TrnStockOut();
                                string OTNumber = "0000000001";
                                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                                  DateTime.Now.Month, +
                                                                                  DateTime.Now.Day));
                                var TrnStockOuts = from d in db.TrnStockOuts
                                                   where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                         d.BranchId == BranchId
                                                   select d;

                                if (TrnStockOuts.Any())
                                {
                                    var MaxOTNumber = Convert.ToDouble(TrnStockOuts.Max(d => d.OTNumber)) + 10000000001;
                                    OTNumber = MaxOTNumber.ToString().Trim().Substring(1);
                                }
                                NewStockOut.OTNumber = OTNumber;
                                NewStockOut.PeriodId = TrnStockIns.First().PeriodId;
                                NewStockOut.BranchId = BranchId;
                                NewStockOut.OTManualNumber = OTNumber;
                                NewStockOut.OTDate = SQLNow.Value;
                                NewStockOut.INId = Id;
                                NewStockOut.AccountId = TrnStockIns.First().AccountId;
                                NewStockOut.ArticleId = TrnStockIns.First().ArticleId;
                                NewStockOut.Particulars = "Auto insert - IN No.: " + TrnStockIns.First().INNumber;
                                NewStockOut.PreparedById = secure.GetCurrentUser();
                                NewStockOut.CheckedById = secure.GetCurrentUser();
                                NewStockOut.ApprovedById = secure.GetCurrentUser();
                                NewStockOut.IsLocked = false;
                                NewStockOut.CreatedById = secure.GetCurrentUser();
                                NewStockOut.CreatedDateTime = SQLNow.Value;
                                NewStockOut.UpdatedById = secure.GetCurrentUser();
                                NewStockOut.UpdatedDateTime = SQLNow.Value;

                                db.TrnStockOuts.InsertOnSubmit(NewStockOut);
                                db.SubmitChanges();

                                // Stock Out Lines

                                var TrnStockInLines = from d in db.TrnStockInLines
                                                      where d.INId == Id &&
                                                            d.TrnStockIn.IsLocked == true &&
                                                            d.TrnStockIn.IsProduced == true &&
                                                            d.Quantity > 0
                                                     select d;

                                foreach (var Line in TrnStockInLines)
                                {
                                    if (Line.MstArticle.MstArticleItems.First().IsAsset == true)
                                    {
                                        // Raw Materials 
                                        var MstArticleItemComponents = from d in db.MstArticleItemComponents
                                                                       where d.ArticleId == Line.ItemId
                                                                       select d;
                                        if (MstArticleItemComponents.Any())
                                        {
                                            foreach (var Component in MstArticleItemComponents)
                                            {
                                                decimal Quantity = Component.Quantity * Line.Quantity;
                                                Int64 ItemInventoryId = GetInventoryNumber(Component.ComponentArticleId, Quantity);
                                                if (ItemInventoryId > 0)
                                                {
                                                    Data.TrnStockOutLine NewStockOutLine = new Data.TrnStockOutLine();

                                                    NewStockOutLine.OTId = NewStockOut.Id;
                                                    NewStockOutLine.ItemId = Component.ComponentArticleId;
                                                    NewStockOutLine.Particulars = Line.Particulars;
                                                    NewStockOutLine.UnitId = Component.UnitId;
                                                    NewStockOutLine.Quantity = Quantity;
                                                    NewStockOutLine.BaseUnitId = Component.UnitId;
                                                    NewStockOutLine.BaseQuantity = Quantity;

                                                    NewStockOutLine.ItemInventoryId = ItemInventoryId;

                                                    decimal Cost = db.MstArticleItemInventories.Where(d => d.Id == ItemInventoryId).First().Cost;
                                                    NewStockOutLine.Cost = Math.Round(Cost, 2);
                                                    NewStockOutLine.Amount = Math.Round(Cost * Quantity, 2);
                                                    NewStockOutLine.BaseCost = Math.Round(Cost, 2);

                                                    db.TrnStockOutLines.InsertOnSubmit(NewStockOutLine);
                                                    db.SubmitChanges();
                                                }
                                            }
                                        }
                                    }
                                }

                                // Approved Stock Out

                                var StockOuts = from d in db.TrnStockOuts where d.Id == NewStockOut.Id select d;
                                if (StockOuts.Any())
                                {
                                    var ApprovedStockOut = StockOuts.First();
                                    ApprovedStockOut.IsLocked = true;
                                    db.SubmitChanges();
                                }

                                journal.JournalizedOT(NewStockOut.Id);

                                this.InsertInventoryOut(NewStockOut.Id);

                                return true;
                            }
                            else
                            {
                                return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            //}
            //catch
            //{
            //    return false;
            //}
        }
    }
}