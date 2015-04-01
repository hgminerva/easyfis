using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnPurchaseInvoiceLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();

        private void UpdateHeaderTotalAmount(Int64 PIId)
        {
            var PurchaseInvoices = from d in db.TrnPurchaseInvoices where d.Id == PIId select d;
            if (PurchaseInvoices.Any())
            {
                var UpdatedPurchaseInvoice = PurchaseInvoices.First();
                UpdatedPurchaseInvoice.TotalAmount = UpdatedPurchaseInvoice.TrnPurchaseInvoiceLines.Count() > 0 ?
                                                     UpdatedPurchaseInvoice.TrnPurchaseInvoiceLines.Sum(a => a.Amount) : 0;
                db.SubmitChanges();
            }
        }

        // ================================================
        // GET api/TrnPurchaseInvoiceLine/5/PurchaseInvoice
        // ================================================

        [HttpGet]
        [ActionName("PurchaseInvoiceLine")]
        public Models.TrnPurchaseInvoiceLine Get(Int64 Id)
        {
            var PurchaseInvoiceLines = from d in db.TrnPurchaseInvoiceLines
                                       where d.Id == Id &&
                                             d.TrnPurchaseInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                       select new Models.TrnPurchaseInvoiceLine
                                        {
                                            LineId = d.Id,
                                            LinePIId = d.PIId,
                                            LinePOId = d.POId == null ? 0 : d.POId.Value,
                                            LinePONumber = d.TrnPurchaseOrder.PONumber,
                                            LineItemId = d.ItemId,
                                            LineItem = d.MstArticle.Article,
                                            LineParticulars = d.Particulars,
                                            LineUnitId = d.UnitId,
                                            LineUnit = d.MstUnit.Unit,
                                            LineCost = d.Cost,
                                            LineQuantity = d.Quantity,
                                            LineAmount = d.Amount,
                                            LineTaxId = d.TaxId,
                                            LineTax = d.MstTax.TaxCode,
                                            LineTaxRate = d.TaxRate,
                                            LineTaxAmount = d.TaxAmount
                                        };

            if (PurchaseInvoiceLines.Any())
            {
                return PurchaseInvoiceLines.First();
            }
            else
            {
                return new Models.TrnPurchaseInvoiceLine();
            }
        }

        // ===============================
        // POST api/TrnPurchaseInvoiceLine
        // ===============================

        [HttpPost]
        public Models.TrnPurchaseInvoiceLine Post(Models.TrnPurchaseInvoiceLine value)
        {
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (secure.GetCurrentSubscriberUser() > 0)
            {
                // Add new purchase invoice line
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.TrnPurchaseInvoiceLine NewPurchaseInvoiceLine = new Data.TrnPurchaseInvoiceLine();

                NewPurchaseInvoiceLine.PIId = value.LinePIId;
                if (value.LinePOId > 0) NewPurchaseInvoiceLine.POId = value.LinePOId;
                NewPurchaseInvoiceLine.ItemId = value.LineItemId;
                NewPurchaseInvoiceLine.Particulars = value.LineParticulars;
                NewPurchaseInvoiceLine.UnitId = value.LineUnitId;
                NewPurchaseInvoiceLine.Cost = value.LineCost;
                NewPurchaseInvoiceLine.Quantity = value.LineQuantity;
                NewPurchaseInvoiceLine.Amount = value.LineAmount;
                NewPurchaseInvoiceLine.TaxId = value.LineTaxId;
                NewPurchaseInvoiceLine.TaxRate = value.LineTaxRate;
                NewPurchaseInvoiceLine.TaxAmount = value.LineTaxAmount;

                newData.TrnPurchaseInvoiceLines.InsertOnSubmit(NewPurchaseInvoiceLine);
                newData.SubmitChanges();

                // Update header total amount
                this.UpdateHeaderTotalAmount(value.LinePIId);

                return value;
            }
            else
            {
                return new Models.TrnPurchaseInvoiceLine();
            }
        }

        // ================================
        // PUT api/TrnPurchaseInvoiceLine/5
        // ================================

        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnPurchaseInvoiceLine value)
        {
            try
            {
                var PurchaseInvoiceLines = from d in db.TrnPurchaseInvoiceLines
                                           where d.Id == id &&
                                                 d.TrnPurchaseInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                           select d;

                if (PurchaseInvoiceLines.Any())
                {
                    // Update purchase invoice line
                    var UpdatedLine = PurchaseInvoiceLines.FirstOrDefault();

                    if (value.LinePOId > 0) UpdatedLine.POId = value.LinePOId;
                    UpdatedLine.ItemId = value.LineItemId;
                    UpdatedLine.Particulars = value.LineParticulars;
                    UpdatedLine.UnitId = value.LineUnitId;
                    UpdatedLine.Cost = value.LineCost;
                    UpdatedLine.Quantity = value.LineQuantity;
                    UpdatedLine.Amount = value.LineAmount;
                    UpdatedLine.TaxId = value.LineTaxId;
                    UpdatedLine.TaxRate = value.LineTaxRate;
                    UpdatedLine.TaxAmount = value.LineTaxAmount;

                    db.SubmitChanges();

                    // Update header total amount
                    this.UpdateHeaderTotalAmount(value.LinePIId);

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
            Data.TrnPurchaseInvoiceLine DeleteLine = db.TrnPurchaseInvoiceLines.Where(d => d.Id == Id &&
                                                                                           d.TrnPurchaseInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnPurchaseInvoiceLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    // Delete
                    db.SubmitChanges();

                    // Update header total amount
                    this.UpdateHeaderTotalAmount(DeleteLine.PIId);

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