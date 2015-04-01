using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnSalesOrderLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // =========================
        // GET api/TrnSalesOrderLine
        // =========================
        [HttpGet]
        public List<Models.TrnSalesOrderLine> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var TrnSalesOrderLines = from d in db.TrnSalesOrderLines
                                     where d.Id == BranchId &&
                                           d.TrnSalesOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                     select new Models.TrnSalesOrderLine
                                     {
                                         LineId = d.Id,
                                         LineSOId = d.SOId,
                                         LineItemId = d.ItemId,
                                         LineItem = d.MstArticle.Article,
                                         LineParticulars = d.Particulars,
                                         LineUnitId = d.UnitId,
                                         LineUnit = d.MstUnit.Unit,
                                         LinePrice = d.Price,
                                         LineQuantity = d.Quantity,
                                         LineAmount = d.Amount
                                     };
            return TrnSalesOrderLines.ToList();
        }

        // ======================================
        // GET api/TrnSalesOrderLine/5/SalesOrder
        // ======================================

        [HttpGet]
        [ActionName("SalesOrderLine")]
        public Models.TrnSalesOrderLine Get(Int64 Id)
        {
            var SalesOrderLines = from d in db.TrnSalesOrderLines
                                  where d.Id == Id &&
                                        d.TrnSalesOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                  select new Models.TrnSalesOrderLine
                                  {
                                      LineId = d.Id,
                                      LineSOId = d.SOId,
                                      LineItemId = d.ItemId,
                                      LineItem = d.MstArticle.Article,
                                      LineParticulars = d.Particulars,
                                      LineUnitId = d.UnitId,
                                      LineUnit = d.MstUnit.Unit,
                                      LinePrice = d.Price,
                                      LineQuantity = d.Quantity,
                                      LineAmount = d.Amount
                                  };

            if (SalesOrderLines.Any())
            {
                return SalesOrderLines.First();
            }
            else
            {
                return new Models.TrnSalesOrderLine();
            }
        }

        // =============================
        // POST api/TrnSalesOrderLine
        // =============================

        [HttpPost]
        public Models.TrnSalesOrderLine Post(Models.TrnSalesOrderLine value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                Data.TrnSalesOrderLine NewSalesOrderLine = new Data.TrnSalesOrderLine();

                NewSalesOrderLine.SOId = value.LineSOId;
                NewSalesOrderLine.ItemId = value.LineItemId;
                NewSalesOrderLine.UnitId = value.LineUnitId;
                NewSalesOrderLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                NewSalesOrderLine.Price = value.LinePrice;
                NewSalesOrderLine.Quantity = value.LineQuantity;
                NewSalesOrderLine.Amount = value.LineAmount;

                db.TrnSalesOrderLines.InsertOnSubmit(NewSalesOrderLine);
                db.SubmitChanges();

                return value;
            }
            else
            {
                return new Models.TrnSalesOrderLine();
            }
        }

        // ===========================
        // PUT api/TrnSalesOrderLine/5
        // ===========================
        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnSalesOrderLine value)
        {
            try
            {
                var SalesOrderLines = from d in db.TrnSalesOrderLines
                                      where d.Id == id &&
                                            d.TrnSalesOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                      select d;

                if (SalesOrderLines.Any())
                {
                    var UpdatedSalesOrderLine = SalesOrderLines.FirstOrDefault();

                    UpdatedSalesOrderLine.SOId = value.LineSOId;
                    UpdatedSalesOrderLine.ItemId = value.LineItemId;
                    UpdatedSalesOrderLine.UnitId = value.LineUnitId;
                    UpdatedSalesOrderLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    UpdatedSalesOrderLine.Price = value.LinePrice;
                    UpdatedSalesOrderLine.Quantity = value.LineQuantity;
                    UpdatedSalesOrderLine.Amount = value.LineAmount;

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

        // ==============================
        // DELETE api/TrnSalesOrderLine/5
        // ==============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnSalesOrderLine DeleteLine = db.TrnSalesOrderLines.Where(d => d.Id == Id &&
                                                                                 d.TrnSalesOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnSalesOrderLines.DeleteOnSubmit(DeleteLine);
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