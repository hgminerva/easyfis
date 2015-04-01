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
    public class TrnSalesOrderController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // =====================
        // GET api/TrnSalesOrder
        // =====================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var Count = db.TrnSalesOrders.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                     d.MstBranch.Id == BranchId).Count();

            var SalesOrders = from d in db.TrnSalesOrders
                                 where d.MstBranch.Id == BranchId &&
                                       d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                 select new Models.TrnSalesOrder
                                 {
                                     Id = d.Id,
                                     PeriodId = d.PeriodId,
                                     Period = d.MstPeriod.Period,
                                     BranchId = d.BranchId,
                                     Branch = d.MstBranch.Branch,
                                     SONumber = d.SONumber,
                                     SOManualNumber = d.SOManualNumber,
                                     SODate = Convert.ToString(d.SODate.Month) + "/" + Convert.ToString(d.SODate.Day) + "/" + Convert.ToString(d.SODate.Year),
                                     CustomerId = d.CustomerId,
                                     Customer = d.MstArticle.Article,
                                     TermId = d.TermId,
                                     Term = d.MstTerm.Term,
                                     OrderNumber = d.OrderNumber,
                                     DateNeeded = Convert.ToString(d.DateNeeded.Month) + "/" + Convert.ToString(d.DateNeeded.Day) + "/" + Convert.ToString(d.DateNeeded.Year),
                                     Particulars = d.Particulars,
                                     OrderedById = d.OrderedById,
                                     OrderedBy = d.MstUser.FullName,
                                     IsClosed = d.IsClosed,
                                     PreparedById = d.PreparedById,
                                     PreparedBy = d.MstUser.FullName,
                                     CheckedById = d.CheckedById,
                                     CheckedBy = d.MstUser1.FullName,
                                     ApprovedById = d.ApprovedById,
                                     ApprovedBy = d.MstUser2.FullName,
                                     IsLocked = d.IsLocked,
                                     CreatedById = d.CreatedById,
                                     CreatedBy = d.MstUser3.FullName,
                                     CreatedDateTime = Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                     UpdatedById = d.UpdatedById,
                                     UpdatedBy = d.MstUser4.FullName,
                                     UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                                 };
            
            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") SalesOrders = SalesOrders.OrderBy(d => d.SODate).Skip(iDisplayStart).Take(10);
                    else SalesOrders = SalesOrders.OrderByDescending(d => d.SODate).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") SalesOrders = SalesOrders.OrderBy(d => d.SONumber).Skip(iDisplayStart).Take(10);
                    else SalesOrders = SalesOrders.OrderByDescending(d => d.SONumber).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") SalesOrders = SalesOrders.OrderBy(d => d.Customer).Skip(iDisplayStart).Take(10);
                    else SalesOrders = SalesOrders.OrderByDescending(d => d.Customer).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    SalesOrders = SalesOrders.Skip(iDisplayStart).Take(10);
                    break;
            }

            var SalesOrderPaged = new Models.SysDataTablePager();

            SalesOrderPaged.sEcho = sEcho;
            SalesOrderPaged.iTotalRecords = Count;
            SalesOrderPaged.iTotalDisplayRecords = Count;
            SalesOrderPaged.TrnSalesOrderData = SalesOrders.ToList();

            return SalesOrderPaged;
        }

        // ==================================
        // GET api/TrnSalesOrder/5/SalesOrder
        // ==================================

        [HttpGet]
        [ActionName("SalesOrder")]
        public Models.TrnSalesOrder Get(Int64 Id)
        {
            var SalesOrders = from d in db.TrnSalesOrders
                                   where d.Id == Id &&
                                         d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                   select new Models.TrnSalesOrder
                                   {
                                       Id = d.Id,
                                       PeriodId = d.PeriodId,
                                       Period = d.MstPeriod.Period,
                                       BranchId = d.BranchId,
                                       Branch = d.MstBranch.Branch,
                                       SONumber = d.SONumber,
                                       SOManualNumber = d.SOManualNumber,
                                       SODate = Convert.ToString(d.SODate.Month) + "/" + Convert.ToString(d.SODate.Day) + "/" + Convert.ToString(d.SODate.Year),
                                       CustomerId = d.CustomerId,
                                       Customer = d.MstArticle.Article,
                                       TermId = d.TermId,
                                       Term = d.MstTerm.Term,
                                       OrderNumber = d.OrderNumber,
                                       DateNeeded = Convert.ToString(d.DateNeeded.Month) + "/" + Convert.ToString(d.DateNeeded.Day) + "/" + Convert.ToString(d.DateNeeded.Year),
                                       Particulars = d.Particulars,
                                       OrderedById = d.OrderedById,
                                       OrderedBy = d.MstUser.FullName,
                                       IsClosed = d.IsClosed,
                                       PreparedById = d.PreparedById,
                                       PreparedBy = d.MstUser.FullName,
                                       CheckedById = d.CheckedById,
                                       CheckedBy = d.MstUser1.FullName,
                                       ApprovedById = d.ApprovedById,
                                       ApprovedBy = d.MstUser2.FullName,
                                       IsLocked = d.IsLocked,
                                       CreatedById = d.CreatedById,
                                       CreatedBy = d.MstUser3.FullName,
                                       CreatedDateTime = Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                       UpdatedById = d.UpdatedById,
                                       UpdatedBy = d.MstUser4.FullName,
                                       UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                                   };

            if (SalesOrders.Any())
            {
                return SalesOrders.First();
            }
            else
            {
                return new Models.TrnSalesOrder();
            }
        }

        // =======================================
        // GET api/TrnSalesOrder/5/SalesOrderLines
        // =======================================  

        [HttpGet]
        [ActionName("SalesOrderLines")]
        public Models.SysDataTablePager SalesOrderLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnSalesOrderLines.Where(d => d.SOId == Id && 
                                                         d.TrnSalesOrder.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var SalesOrderLines = (from d in db.TrnSalesOrderLines
                                      where d.SOId == Id &&
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
                                        });

            var SalesOrderPaged = new Models.SysDataTablePager();

            SalesOrderPaged.sEcho = sEcho;
            SalesOrderPaged.iTotalRecords = Count;
            SalesOrderPaged.iTotalDisplayRecords = Count;
            SalesOrderPaged.TrnSalesOrderLineData = SalesOrderLines.ToList();

            return SalesOrderPaged;
        }

        // ======================
        // POST api/TrnSalesOrder
        // ======================
      
        [HttpPost]
        public Models.TrnSalesOrder Post(Models.TrnSalesOrder value)
        {
            try
            {
                Data.TrnSalesOrder NewSalesOrder = new Data.TrnSalesOrder();
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLSODate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.SODate).Year, +
                                                                     Convert.ToDateTime(value.SODate).Month, +
                                                                     Convert.ToDateTime(value.SODate).Day));
                SqlDateTime SQLDateNeeded = new SqlDateTime(new DateTime(Convert.ToDateTime(value.DateNeeded).Year, +
                                                                        Convert.ToDateTime(value.DateNeeded).Month, +
                                                                        Convert.ToDateTime(value.DateNeeded).Day));

                var SalesOrder = from d in db.TrnSalesOrders
                                    where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                          d.BranchId == BranchId
                                    select d;

                if (SalesOrder != null)
                {
                    var MaxSONumber = Convert.ToDouble(SalesOrder.Max(d => d.SONumber)) + 10000000001;
                    NewSalesOrder.SONumber = MaxSONumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewSalesOrder.SONumber = "0000000001";
                }
                NewSalesOrder.PeriodId = PeriodId;
                NewSalesOrder.BranchId = BranchId;
                NewSalesOrder.SOManualNumber = value.SOManualNumber;
                NewSalesOrder.SODate = SQLSODate.Value;
                NewSalesOrder.CustomerId = value.CustomerId;
                NewSalesOrder.TermId = value.TermId;
                NewSalesOrder.OrderNumber = value.OrderNumber;
                NewSalesOrder.DateNeeded = SQLDateNeeded.Value;
                NewSalesOrder.Particulars = value.Particulars;
                NewSalesOrder.OrderedById = value.OrderedById;
                NewSalesOrder.IsClosed = false;
                NewSalesOrder.PreparedById = value.PreparedById;
                NewSalesOrder.CheckedById = value.CheckedById;
                NewSalesOrder.ApprovedById = value.ApprovedById;
                NewSalesOrder.IsLocked = false;
                NewSalesOrder.CreatedById = secure.GetCurrentUser();
                NewSalesOrder.CreatedDateTime = SQLNow.Value;
                NewSalesOrder.UpdatedById = secure.GetCurrentUser();
                NewSalesOrder.UpdatedDateTime = SQLNow.Value;

                db.TrnSalesOrders.InsertOnSubmit(NewSalesOrder);
                db.SubmitChanges();

                return Get(NewSalesOrder.Id);
            }
            catch
            {
                return new Models.TrnSalesOrder();
            }
        }

        // =======================
        // PUT api/TrnSalesOrder/5
        // =======================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 id, Models.TrnSalesOrder value)
        {
            try
            {
                var SalesOrders = from d in db.TrnSalesOrders
                                  where d.Id == id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                  select d;

                if (SalesOrders.Any())
                {
                    var UpdatedSalesOrder = SalesOrders.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                    SqlDateTime SQLSODate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.SODate).Year, +
                                                                         Convert.ToDateTime(value.SODate).Month, +
                                                                         Convert.ToDateTime(value.SODate).Day));
                    SqlDateTime SQLDateNeeded = new SqlDateTime(new DateTime(Convert.ToDateTime(value.DateNeeded).Year, +
                                                                            Convert.ToDateTime(value.DateNeeded).Month, +
                                                                            Convert.ToDateTime(value.DateNeeded).Day));

                    UpdatedSalesOrder.SOManualNumber = value.SOManualNumber;
                    UpdatedSalesOrder.SODate = SQLSODate.Value;
                    UpdatedSalesOrder.CustomerId = value.CustomerId;
                    UpdatedSalesOrder.TermId = value.TermId;
                    UpdatedSalesOrder.OrderNumber = value.OrderNumber;
                    UpdatedSalesOrder.DateNeeded = SQLDateNeeded.Value;
                    UpdatedSalesOrder.Particulars = value.Particulars;
                    UpdatedSalesOrder.OrderedById = value.OrderedById;
                    UpdatedSalesOrder.IsClosed = value.IsClosed;
                    UpdatedSalesOrder.PreparedById = value.PreparedById;
                    UpdatedSalesOrder.CheckedById = value.CheckedById;
                    UpdatedSalesOrder.ApprovedById = value.ApprovedById;
                    UpdatedSalesOrder.IsLocked = false;
                    UpdatedSalesOrder.UpdatedById = secure.GetCurrentUser();
                    UpdatedSalesOrder.UpdatedDateTime = SQLNow.Value;

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

                var SalesOrders = from d in db.TrnSalesOrders
                                  where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                  select d;

                if (SalesOrders.Any())
                {
                    var UpdatedSalesOrder = SalesOrders.FirstOrDefault();

                    UpdatedSalesOrder.IsLocked = Approval;

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

        // ==========================
        // DELETE api/TrnSalesOrder/5
        // ==========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnSalesOrder DeleteSalesOrder = db.TrnSalesOrders.Where(d => d.Id == Id &&
                                                                               d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteSalesOrder != null)
            {
                if (DeleteSalesOrder.IsLocked == false)
                {
                    db.TrnSalesOrders.DeleteOnSubmit(DeleteSalesOrder);
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