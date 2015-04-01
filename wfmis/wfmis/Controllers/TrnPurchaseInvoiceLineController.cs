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

        // ================================================
        // GET api/TrnPurchaseInvoiceLine/5/PurchaseInvoice
        // ================================================

        [HttpGet]
        [ActionName("PurchaseInvoiceLine")]
        public Models.TrnPurchaseInvoiceLine Get(Int64 Id)
        {
            var PurchaseInvoiceLines = from d in db.TrnPurchaseInvoiceLines
                                       where d.Id == Id &&
                                             d.TrnPurchaseInvoice.MstBranch.MstCompany.MstUser.Id == secure.GetCurrentUser()
                                       select new Models.TrnPurchaseInvoiceLine
                                        {
                                            LineId = d.Id,
                                            LinePIId = d.PIId,
                                            LinePOId = d.POId.Value,
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
            var UserId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId);
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (UserId > 0)
            {
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
            return Request.CreateResponse(HttpStatusCode.BadRequest);
        }

        // ===================================
        // DELETE api/TrnPurchaseInvoiceLine/5
        // ===================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnPurchaseInvoiceLine DeleteLine = db.TrnPurchaseInvoiceLines.Where(d => d.Id == Id &&
                                                                                           d.TrnPurchaseInvoice.MstBranch.MstCompany.MstUser.Id == secure.GetCurrentUser()).First();
            if (DeleteLine != null)
            {
                db.TrnPurchaseInvoiceLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    db.SubmitChanges();
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