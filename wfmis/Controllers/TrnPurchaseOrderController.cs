using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnPurchaseOrderController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ========================
        // GET api/TrnPurchaseOrder
        // ========================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();
            int NumberOfRecords = 20;

            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var Count = db.TrnPurchaseOrders.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                        d.MstBranch.Id == BranchId).Count();

            var PurchaseOrders = from d in db.TrnPurchaseOrders
                                 where d.MstBranch.Id == BranchId &&
                                       d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                                 select new Models.TrnPurchaseOrder
                                 {
                                     Id = d.Id,
                                     PeriodId = d.PeriodId,
                                     Period = d.MstPeriod.Period,
                                     BranchId = d.BranchId,
                                     Branch = d.MstBranch.Branch,
                                     PONumber = d.PONumber,
                                     POManualNumber = d.POManualNumber,
                                     PODate = Convert.ToString(d.PODate.Year) + "-" + Convert.ToString(d.PODate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.PODate.Day + 100).Substring(1, 2),
                                     SupplierId = d.SupplierId,
                                     Supplier = d.MstArticle.Article,
                                     TermId = d.TermId,
                                     Term = d.MstTerm.Term,
                                     RequestNumber = d.RequestNumber,
                                     DateNeeded = Convert.ToString(d.DateNeeded.Month) + "/" + Convert.ToString(d.DateNeeded.Day) + "/" + Convert.ToString(d.DateNeeded.Year),
                                     Particulars = d.Particulars,
                                     RequestedById = d.RequestedById == null ? 0 : d.RequestedById.Value,
                                     RequestedBy = d.MstUser.FullName,
                                     IsClosed = d.IsClosed,
                                     PreparedById = d.PreparedById,
                                     PreparedBy = d.MstUser1.FullName,
                                     CheckedById = d.CheckedById,
                                     CheckedBy = d.MstUser2.FullName,
                                     ApprovedById = d.ApprovedById,
                                     ApprovedBy = d.MstUser3.FullName,
                                     IsLocked = d.IsLocked,
                                     CreatedById = d.CreatedById,
                                     CreatedBy = d.MstUser4.FullName,
                                     CreatedDateTime = Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                     UpdatedById = d.UpdatedById,
                                     UpdatedBy = d.MstUser5.FullName,
                                     UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                                 };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") PurchaseOrders = PurchaseOrders.OrderBy(d => d.PODate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseOrders = PurchaseOrders.OrderByDescending(d => d.PODate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") PurchaseOrders = PurchaseOrders.OrderBy(d => d.PONumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseOrders = PurchaseOrders.OrderByDescending(d => d.PONumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") PurchaseOrders = PurchaseOrders.OrderBy(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseOrders = PurchaseOrders.OrderByDescending(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 5:
                    if (sSortDir == "asc") PurchaseOrders = PurchaseOrders.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseOrders = PurchaseOrders.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 6:
                    if (sSortDir == "asc") PurchaseOrders = PurchaseOrders.OrderBy(d => d.IsLocked).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseOrders = PurchaseOrders.OrderByDescending(d => d.IsLocked).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    PurchaseOrders = PurchaseOrders.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var PurchaseOrderPaged = new Models.SysDataTablePager();

            PurchaseOrderPaged.sEcho = sEcho;
            PurchaseOrderPaged.iTotalRecords = Count;
            PurchaseOrderPaged.iTotalDisplayRecords = Count;
            PurchaseOrderPaged.TrnPurchaseOrderData = PurchaseOrders.ToList();

            return PurchaseOrderPaged;
        }

        // ========================================
        // GET api/TrnPurchaseOrder/5/PurchaseOrder
        // ========================================

        [HttpGet]
        [ActionName("PurchaseOrder")]
        public Models.TrnPurchaseOrder Get(Int64 Id)
        {
            var PurchaseOrders = from d in db.TrnPurchaseOrders
                                 where d.Id == Id &&
                                       d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                 select new Models.TrnPurchaseOrder
                                 {
                                     Id = d.Id,
                                     PeriodId = d.PeriodId,
                                     Period = d.MstPeriod.Period,
                                     BranchId = d.BranchId,
                                     Branch = d.MstBranch.Branch,
                                     PONumber = d.PONumber,
                                     POManualNumber = d.POManualNumber,
                                     PODate = Convert.ToString(d.PODate.Month) + "/" + Convert.ToString(d.PODate.Day) + "/" + Convert.ToString(d.PODate.Year),
                                     SupplierId = d.SupplierId,
                                     Supplier = d.MstArticle.Article,
                                     TermId = d.TermId,
                                     Term = d.MstTerm.Term,
                                     RequestNumber = d.RequestNumber,
                                     DateNeeded = Convert.ToString(d.DateNeeded.Month) + "/" + Convert.ToString(d.DateNeeded.Day) + "/" + Convert.ToString(d.DateNeeded.Year),
                                     Particulars = d.Particulars,
                                     RequestedById = d.RequestedById == null ? 0 : d.RequestedById.Value,
                                     RequestedBy = d.MstUser.FullName,
                                     IsClosed = d.IsClosed,
                                     PreparedById = d.PreparedById,
                                     PreparedBy = d.MstUser1.FullName,
                                     CheckedById = d.CheckedById,
                                     CheckedBy = d.MstUser2.FullName,
                                     ApprovedById = d.ApprovedById,
                                     ApprovedBy = d.MstUser3.FullName,
                                     IsLocked = d.IsLocked,
                                     CreatedById = d.CreatedById,
                                     CreatedBy = d.MstUser4.FullName,
                                     CreatedDateTime = Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                     UpdatedById = d.UpdatedById,
                                     UpdatedBy = d.MstUser5.FullName,
                                     UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                                 };

            if (PurchaseOrders.Any())
            {
                return PurchaseOrders.First();
            }
            else
            {
                return new Models.TrnPurchaseOrder();
            }
        }

        // =============================================
        // GET api/TrnPurchaseOrder/5/PurchaseOrderLines
        // =============================================     

        [HttpGet]
        [ActionName("PurchaseOrderLines")]
        public Models.SysDataTablePager PurchaseOrderLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnPurchaseOrderLines.Where(d => d.TrnPurchaseOrder.Id == Id).Count();

            var PurchaseOrderLines = (from d in db.TrnPurchaseOrderLines
                                      where d.TrnPurchaseOrder.Id == Id &&
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
                                      });

            var PurchaseOrderPaged = new Models.SysDataTablePager();

            PurchaseOrderPaged.sEcho = sEcho;
            PurchaseOrderPaged.iTotalRecords = Count;
            PurchaseOrderPaged.iTotalDisplayRecords = Count;
            PurchaseOrderPaged.TrnPurchaseOrderLineData = PurchaseOrderLines.ToList();

            return PurchaseOrderPaged;
        }

        // =========================
        // POST api/TrnPurchaseOrder
        // =========================

        [HttpPost]
        public Models.TrnPurchaseOrder Post(Models.TrnPurchaseOrder value)
        {
            try
            {
                Data.TrnPurchaseOrder NewPurchaseOrder = new Data.TrnPurchaseOrder();

                var UserId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId);
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLPODate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.PODate).Year, +
                                                                     Convert.ToDateTime(value.PODate).Month, +
                                                                     Convert.ToDateTime(value.PODate).Day));
                SqlDateTime SQLDateNeeded = new SqlDateTime(new DateTime(Convert.ToDateTime(value.DateNeeded).Year, +
                                                                        Convert.ToDateTime(value.DateNeeded).Month, +
                                                                        Convert.ToDateTime(value.DateNeeded).Day));

                var PurchaseOrder = from d in db.TrnPurchaseOrders
                                    where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                          d.MstBranch.Id == BranchId
                                    select d;
                if (PurchaseOrder != null)
                {
                    var MaxPONumber = Convert.ToDouble(PurchaseOrder.Max(d => d.PONumber)) + 10000000001;
                    NewPurchaseOrder.PONumber = MaxPONumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewPurchaseOrder.PONumber = "0000000001";
                }
                NewPurchaseOrder.PeriodId = PeriodId;
                NewPurchaseOrder.BranchId = BranchId;
                NewPurchaseOrder.POManualNumber = value.POManualNumber;
                NewPurchaseOrder.PODate = SQLPODate.Value;
                NewPurchaseOrder.SupplierId = value.SupplierId;
                NewPurchaseOrder.TermId = value.TermId;
                NewPurchaseOrder.RequestNumber = value.RequestNumber;
                NewPurchaseOrder.DateNeeded = SQLDateNeeded.Value;
                NewPurchaseOrder.Particulars = value.Particulars;
                NewPurchaseOrder.RequestedById = value.RequestedById;
                NewPurchaseOrder.IsClosed = false;
                NewPurchaseOrder.PreparedById = value.PreparedById;
                NewPurchaseOrder.CheckedById = value.CheckedById;
                NewPurchaseOrder.ApprovedById = value.ApprovedById;
                NewPurchaseOrder.IsLocked = false;
                NewPurchaseOrder.CreatedById = secure.GetCurrentUser();
                NewPurchaseOrder.CreatedDateTime = SQLNow.Value;
                NewPurchaseOrder.UpdatedById = secure.GetCurrentUser();
                NewPurchaseOrder.UpdatedDateTime = SQLNow.Value;

                db.TrnPurchaseOrders.InsertOnSubmit(NewPurchaseOrder);
                db.SubmitChanges();

                return Get(NewPurchaseOrder.Id);
            }
            catch
            {
                return new Models.TrnPurchaseOrder();
            }
        }

        // =================================
        // PUT api/TrnPurchaseOrder/5/Update
        // =================================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnPurchaseOrder value)
        {
            try
            {
                var PurchaseOrders = from d in db.TrnPurchaseOrders
                                     where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                     select d;

                if (PurchaseOrders.Any())
                {
                    var UpdatedPurchaseOrder = PurchaseOrders.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                    SqlDateTime SQLPODate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.PODate).Year, +
                                                                         Convert.ToDateTime(value.PODate).Month, +
                                                                         Convert.ToDateTime(value.PODate).Day));
                    SqlDateTime SQLDateNeeded = new SqlDateTime(new DateTime(Convert.ToDateTime(value.DateNeeded).Year, +
                                                                            Convert.ToDateTime(value.DateNeeded).Month, +
                                                                            Convert.ToDateTime(value.DateNeeded).Day));

                    UpdatedPurchaseOrder.POManualNumber = value.POManualNumber;
                    UpdatedPurchaseOrder.PODate = SQLPODate.Value;
                    UpdatedPurchaseOrder.SupplierId = value.SupplierId;
                    UpdatedPurchaseOrder.TermId = value.TermId;
                    UpdatedPurchaseOrder.RequestNumber = value.RequestNumber;
                    UpdatedPurchaseOrder.DateNeeded = SQLDateNeeded.Value;
                    UpdatedPurchaseOrder.Particulars = value.Particulars;
                    UpdatedPurchaseOrder.RequestedById = value.RequestedById;
                    UpdatedPurchaseOrder.IsClosed = value.IsClosed;
                    UpdatedPurchaseOrder.PreparedById = value.PreparedById;
                    UpdatedPurchaseOrder.CheckedById = value.CheckedById;
                    UpdatedPurchaseOrder.ApprovedById = value.ApprovedById;
                    UpdatedPurchaseOrder.IsLocked = false;
                    UpdatedPurchaseOrder.UpdatedById = value.UpdatedById;
                    UpdatedPurchaseOrder.UpdatedDateTime = SQLNow.Value;

                    db.SubmitChanges();
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // ===================================
        // PUT api/TrnPurchaseOrder/5/Approval
        // ===================================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var PurchaseOrders = from d in db.TrnPurchaseOrders
                                     where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                     select d;

                if (PurchaseOrders.Any())
                {
                    var UpdatedPurchaseOrder = PurchaseOrders.FirstOrDefault();

                    UpdatedPurchaseOrder.IsLocked = Approval;

                    db.SubmitChanges();
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // ==============================
        // DELETE api/TrnPurchaseOrder/5
        // ==============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnPurchaseOrder DeletePurchaseOrder = db.TrnPurchaseOrders.Where(d => d.Id == Id &&
                                                                                        d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeletePurchaseOrder != null)
            {
                if (DeletePurchaseOrder.IsLocked == false)
                {
                    db.TrnPurchaseOrders.DeleteOnSubmit(DeletePurchaseOrder);
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
            else
            {
                return false;
            }
        }  

    }
}