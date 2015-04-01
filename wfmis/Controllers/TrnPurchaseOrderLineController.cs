using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnPurchaseOrderLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ============================
        // GET api/TrnPurchaseOrderLine
        // ============================
        [HttpGet]
        public List<Models.TrnPurchaseOrderLine> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var TrnPurchaseOrderLines = from d in db.TrnPurchaseOrderLines
                                        where d.Id == BranchId &&
                                              d.TrnPurchaseOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                        select new Models.TrnPurchaseOrderLine
                                        {
                                            LineId = d.Id,
                                            LinePOId = d.POId,
                                            LineItemId = d.ItemId,
                                            LineItem = d.MstArticle.Article,
                                            LineParticulars = d.Particulars,
                                            LineUnitId = d.UnitId,
                                            LineUnit = d.MstUnit.Unit,
                                            LineCost = d.Cost,
                                            LineQuantity = d.Quantity,
                                            LineAmount = d.Amount
                                        };
            return TrnPurchaseOrderLines.ToList();
        }

        // ================================================
        // GET api/TrnPurchaseOrderLine/5/PurchaseOrderLine
        // ================================================

        [HttpGet]
        [ActionName("PurchaseOrderLine")]
        public Models.TrnPurchaseOrderLine Get(Int64 Id)
        {
            var PurchaseOrderLines = from d in db.TrnPurchaseOrderLines
                                     where d.Id == Id &&
                                           d.TrnPurchaseOrder.MstBranch.MstCompany.UserId == secure.GetCurrentSubscriberUser()
                                     select new Models.TrnPurchaseOrderLine
                                     {
                                         LineId = d.Id,
                                         LinePOId = d.POId,
                                         LineItemId = d.ItemId,
                                         LineItem = d.MstArticle.Article,
                                         LineParticulars = d.Particulars,
                                         LineUnitId = d.UnitId,
                                         LineUnit = d.MstUnit.Unit,
                                         LineCost = d.Cost,
                                         LineQuantity = d.Quantity,
                                         LineAmount = d.Amount
                                     };

            if (PurchaseOrderLines.Any())
            {
                return PurchaseOrderLines.First();
            }
            else
            {
                return new Models.TrnPurchaseOrderLine();
            }
        }

        // =============================
        // POST api/TrnPurchaseOrderLine
        // =============================

        [HttpPost]
        public Models.TrnPurchaseOrderLine Post(Models.TrnPurchaseOrderLine value)
        {
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (secure.GetCurrentSubscriberUser() > 0)
            {
                Data.TrnPurchaseOrderLine NewPurchaseOrderLine = new Data.TrnPurchaseOrderLine();

                NewPurchaseOrderLine.POId = value.LinePOId;
                NewPurchaseOrderLine.ItemId = value.LineItemId;
                NewPurchaseOrderLine.UnitId = value.LineUnitId;
                NewPurchaseOrderLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                NewPurchaseOrderLine.Cost = value.LineCost;
                NewPurchaseOrderLine.Quantity = value.LineQuantity;
                NewPurchaseOrderLine.Amount = value.LineAmount;

                db.TrnPurchaseOrderLines.InsertOnSubmit(NewPurchaseOrderLine);
                db.SubmitChanges();

                return value;
            }
            else
            {
                return new Models.TrnPurchaseOrderLine();
            }
        }

        // ==============================
        // PUT api/TrnPurchaseOrderLine/5
        // ==============================
        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.TrnPurchaseOrderLine value)
        {
            try
            {
                var PurchaseOrderLines = from d in db.TrnPurchaseOrderLines
                                         where d.Id == Id &&
                                               d.TrnPurchaseOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                         select d;

                if (PurchaseOrderLines.Any())
                {
                    var UpdatedPurchaseOrderLine = PurchaseOrderLines.FirstOrDefault();

                    UpdatedPurchaseOrderLine.POId = value.LinePOId;
                    UpdatedPurchaseOrderLine.ItemId = value.LineItemId;
                    UpdatedPurchaseOrderLine.UnitId = value.LineUnitId;
                    UpdatedPurchaseOrderLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    UpdatedPurchaseOrderLine.Cost = value.LineCost;
                    UpdatedPurchaseOrderLine.Quantity = value.LineQuantity;
                    UpdatedPurchaseOrderLine.Amount = value.LineAmount;

                    db.SubmitChanges();
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

        // =================================
        // DELETE api/TrnPurchaseOrderLine/5
        // =================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnPurchaseOrderLine DeleteLine = db.TrnPurchaseOrderLines.Where(d => d.Id == Id &&
                                                                                  d.TrnPurchaseOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnPurchaseOrderLines.DeleteOnSubmit(DeleteLine);
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