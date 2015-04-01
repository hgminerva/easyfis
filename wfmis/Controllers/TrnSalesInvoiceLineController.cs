using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnSalesInvoiceLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        private void UpdateHeaderTotalAmount(Int64 SIId)
        {
            var SalesInvoices = from d in db.TrnSalesInvoices where d.Id == SIId select d;
            if (SalesInvoices.Any())
            {
                var UpdatedSalesInvoice = SalesInvoices.First();
                UpdatedSalesInvoice.TotalAmount = UpdatedSalesInvoice.TrnSalesInvoiceLines.Count() > 0 ?
                                                  UpdatedSalesInvoice.TrnSalesInvoiceLines.Sum(a => a.Amount) : 0;
                db.SubmitChanges();
            }
        }

        // ==========================================
        // GET api/TrnSalesInvoiceLine/5/SalesInvoice
        // ==========================================

        [HttpGet]
        [ActionName("SalesInvoiceLine")]
        public Models.TrnSalesInvoiceLine Get(Int64 Id)
        {
            var SalesInvoiceLines = from d in db.TrnSalesInvoiceLines
                                    where d.Id == Id &&
                                          d.TrnSalesInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                    select new Models.TrnSalesInvoiceLine
                                    {
                                        LineId = d.Id,
                                        LineSIId = d.SIId,
                                        LineSOId = d.SOId == null ? 0 : d.SOId.Value,
                                        LineSONumber = d.SOId == null ? "" : d.TrnSalesOrder.SONumber,
                                        LineItemId = d.ItemId,
                                        LineItem = d.MstArticle.Article,
                                        LineItemInventoryId = d.ItemInventoryId==null? 0 : d.ItemInventoryId.Value,
                                        LineItemInventoryNumber = d.ItemInventoryId == null ? "" : d.MstArticleItemInventory.InventoryNumber,
                                        LineParticulars = d.Particulars,
                                        LineUnitId = d.UnitId,
                                        LineUnit = d.MstUnit.Unit,
                                        LinePriceId = d.PriceId,
                                        LinePriceDescription = d.MstArticleItemPrice.PriceDescription,
                                        LinePrice = d.Price,
                                        LineDiscountId = d.DiscountId == null ? 0 : d.DiscountId.Value,
                                        LineDiscount = d.MstDiscount.Discount,
                                        LineDiscountRate = d.DiscountRate,
                                        LineDiscountAmount = d.DiscountAmount,
                                        LineNetPrice = d.NetPrice,
                                        LineQuantity = d.Quantity,
                                        LineAmount = d.Amount,
                                        LineTaxId = d.TaxId,
                                        LineTax = d.MstTax.TaxCode,
                                        LineTaxRate = d.TaxRate,
                                        LineTaxAmount = d.TaxAmount,
                                        LineTaxAmountInclusive = d.TaxAmountInclusive
                                    };

            if (SalesInvoiceLines.Any())
            {
                return SalesInvoiceLines.First();
            }
            else
            {
                return new Models.TrnSalesInvoiceLine();
            }
        }

        // ============================
        // POST api/TrnSalesInvoiceLine
        // ============================

        [HttpPost]
        public Models.TrnSalesInvoiceLine Post(Models.TrnSalesInvoiceLine value)
        {
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (secure.GetCurrentSubscriberUser() > 0)
            {
                // Add new sales invoice line
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.TrnSalesInvoiceLine NewSalesInvoiceLine = new Data.TrnSalesInvoiceLine();

                NewSalesInvoiceLine.SIId = value.LineSIId;
                if (value.LineSOId > 0) NewSalesInvoiceLine.SOId = value.LineSOId;
                NewSalesInvoiceLine.ItemId = value.LineItemId;
                if (value.LineItemInventoryId > 0) NewSalesInvoiceLine.ItemInventoryId = value.LineItemInventoryId;
                NewSalesInvoiceLine.Particulars = value.LineParticulars;
                NewSalesInvoiceLine.UnitId = value.LineUnitId;
                NewSalesInvoiceLine.PriceId = value.LinePriceId;
                NewSalesInvoiceLine.Price = value.LinePrice;
                if (value.LineDiscountId > 0)
                {
                    NewSalesInvoiceLine.DiscountId = value.LineDiscountId;
                    NewSalesInvoiceLine.DiscountRate = value.LineDiscountRate;
                    NewSalesInvoiceLine.DiscountAmount = value.LineDiscountAmount;
                }
                else
                {
                    NewSalesInvoiceLine.DiscountRate = 0;
                    NewSalesInvoiceLine.DiscountAmount = 0;
                }
                NewSalesInvoiceLine.NetPrice = value.LineNetPrice;
                NewSalesInvoiceLine.Quantity = value.LineQuantity;
                NewSalesInvoiceLine.Amount = value.LineAmount;
                NewSalesInvoiceLine.TaxId = value.LineTaxId;
                NewSalesInvoiceLine.TaxRate = value.LineTaxRate;
                NewSalesInvoiceLine.TaxAmount = value.LineTaxAmount;

                var Taxes = from t in db.MstTaxes where t.Id == value.LineTaxId select t;
                if (Taxes.Any()) {
                    if (Taxes.First().MstTaxType.TaxType == "INCLUSIVE")
                    {
                        NewSalesInvoiceLine.TaxAmountInclusive = true;
                    }
                    else
                    {
                        NewSalesInvoiceLine.TaxAmountInclusive = false;
                    }
                } else {
                    NewSalesInvoiceLine.TaxAmountInclusive = false;
                }

                newData.TrnSalesInvoiceLines.InsertOnSubmit(NewSalesInvoiceLine);
                newData.SubmitChanges();

                // Update header total amount
                this.UpdateHeaderTotalAmount(value.LineSIId);

                return value;
            }
            else
            {
                return new Models.TrnSalesInvoiceLine();
            }
        }

        // =============================
        // PUT api/TrnSalesInvoiceLine/5
        // =============================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.TrnSalesInvoiceLine value)
        {
            try
            {
                var SalesInvoiceLines = from d in db.TrnSalesInvoiceLines
                                        where d.Id == Id &&
                                              d.TrnSalesInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                        select d;

                if (SalesInvoiceLines.Any())
                {
                    // Update sales invoice line
                    var UpdatedLine = SalesInvoiceLines.FirstOrDefault();

                    if (value.LineSOId > 0) UpdatedLine.SOId = value.LineSOId;
                    UpdatedLine.ItemId = value.LineItemId;
                    if (value.LineItemInventoryId > 0) UpdatedLine.ItemInventoryId = value.LineItemInventoryId;
                    UpdatedLine.Particulars = value.LineParticulars;
                    UpdatedLine.UnitId = value.LineUnitId;
                    UpdatedLine.PriceId = value.LinePriceId;
                    UpdatedLine.Price = value.LinePrice;
                    if (value.LineDiscountId > 0)
                    {
                        UpdatedLine.DiscountId = value.LineDiscountId;
                        UpdatedLine.DiscountRate = value.LineDiscountRate;
                        UpdatedLine.DiscountAmount = value.LineDiscountAmount;
                    }
                    else
                    {
                        UpdatedLine.DiscountRate = 0;
                        UpdatedLine.DiscountAmount = 0;
                    }
                    UpdatedLine.NetPrice = value.LineNetPrice;
                    UpdatedLine.Quantity = value.LineQuantity;
                    UpdatedLine.Amount = value.LineAmount;
                    UpdatedLine.TaxId = value.LineTaxId;
                    UpdatedLine.TaxRate = value.LineTaxRate;
                    UpdatedLine.TaxAmount = value.LineTaxAmount;
                    
                    var Taxes = from t in db.MstTaxes where t.Id == value.LineTaxId select t;
                    if (Taxes.Any())
                    {
                        if (Taxes.First().MstTaxType.TaxType == "INCLUSIVE")
                        {
                            UpdatedLine.TaxAmountInclusive = true;
                        }
                        else
                        {
                            UpdatedLine.TaxAmountInclusive = false;
                        }
                    }
                    else
                    {
                        UpdatedLine.TaxAmountInclusive = false;
                    }

                    db.SubmitChanges();

                    // Update header total amount
                    this.UpdateHeaderTotalAmount(value.LineSIId);

                    return Request.CreateResponse(HttpStatusCode.OK);
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
        
        // ===================================
        // DELETE api/TrnPurchaseInvoiceLine/5
        // ===================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnSalesInvoiceLine DeleteLine = db.TrnSalesInvoiceLines.Where(d => d.Id == Id &&
                                                                                     d.TrnSalesInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnSalesInvoiceLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    // Delete
                    db.SubmitChanges();

                    // Update header total amount
                    this.UpdateHeaderTotalAmount(DeleteLine.SIId);

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