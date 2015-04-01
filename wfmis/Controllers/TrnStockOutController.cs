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
    public class TrnStockOutController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Inventory inventory = new Business.Inventory();

        // ===================
        // GET api/TrnStockOut
        // ===================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var Count = db.TrnStockOuts.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                   d.MstBranch.Id == BranchId).Count();

            var StockOuts = from d in db.TrnStockOuts
                            where d.MstBranch.Id == BranchId &&
                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                            select new Models.TrnStockOut
                            {
                               Id = d.Id,
                               PeriodId = d.PeriodId,
                               Period = d.MstPeriod.Period,
                               BranchId = d.BranchId,
                               Branch = d.MstBranch.Branch,
                               OTNumber = d.OTNumber,
                               OTManualNumber = d.OTManualNumber,
                               OTDate = Convert.ToString(d.OTDate.Year) + "-" + Convert.ToString(d.OTDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.OTDate.Day + 100).Substring(1, 2),
                               SIId = d.SIId == null ? 0 : d.SIId.Value,
                               SINumber = d.SIId == null ? "" : d.TrnSalesInvoice.SINumber,
                               INId = d.INId == null ? 0 : d.INId.Value,
                               INNumber = d.INId == null ? "" : d.TrnStockIn.INNumber,
                               AccountId = d.AccountId,
                               Account = d.MstAccount.Account,
                               ArticleId = d.ArticleId,
                               Article = d.MstArticle.Article,
                               Particulars = d.Particulars,
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
                    if (sSortDir == "asc") StockOuts = StockOuts.OrderBy(d => d.OTDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockOuts = StockOuts.OrderByDescending(d => d.OTDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") StockOuts = StockOuts.OrderBy(d => d.OTNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockOuts = StockOuts.OrderByDescending(d => d.OTNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") StockOuts = StockOuts.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockOuts = StockOuts.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    StockOuts = StockOuts.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var StockOutPaged = new Models.SysDataTablePager();

            StockOutPaged.sEcho = sEcho;
            StockOutPaged.iTotalRecords = Count;
            StockOutPaged.iTotalDisplayRecords = Count;
            StockOutPaged.TrnStockOutData = StockOuts.ToList();

            return StockOutPaged;
        }

        // ==============================
        // GET api/TrnStockOut/5/StockOut
        // ==============================

        [HttpGet]
        [ActionName("StockOut")]
        public Models.TrnStockOut Get(Int64 Id)
        {
            var StockOuts = from d in db.TrnStockOuts
                            where d.Id == Id &&
                                 d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                            select new Models.TrnStockOut
                            {
                               Id = d.Id,
                               PeriodId = d.PeriodId,
                               Period = d.MstPeriod.Period,
                               BranchId = d.BranchId,
                               Branch = d.MstBranch.Branch,
                               OTNumber = d.OTNumber,
                               OTManualNumber = d.OTManualNumber,
                               OTDate = Convert.ToString(d.OTDate.Month) + "/" + Convert.ToString(d.OTDate.Day) + "/" + Convert.ToString(d.OTDate.Year),
                               SIId = d.SIId == null ? 0 : d.SIId.Value,
                               SINumber = d.SIId == null ? "" : d.TrnSalesInvoice.SINumber,
                               INId = d.INId == null ? 0 : d.INId.Value,
                               INNumber = d.INId == null ? "" : d.TrnStockIn.INNumber,
                               AccountId = d.AccountId,
                               Account = d.MstAccount.Account,
                               ArticleId = d.ArticleId,
                               Article = d.MstArticle.Article,
                               Particulars = d.Particulars,
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

            if (StockOuts.Any())
            {
                return StockOuts.First();
            }
            else
            {
                return new Models.TrnStockOut();
            }
        }

        // ===================================
        // GET api/TrnStockOut/5/StockOutLines
        // ===================================

        [HttpGet]
        [ActionName("StockOutLines")]
        public Models.SysDataTablePager StockOutLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnStockOutLines.Where(d => d.OTId == Id &&
                                                       d.TrnStockOut.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var StockOutLines = (from d in db.TrnStockOutLines
                                 where d.OTId == Id &&
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
                                    LineBaseCost = d.BaseCost,
                                    LineBaseQuantity = d.BaseQuantity
                                 });

            var StockOutLinePaged = new Models.SysDataTablePager();

            StockOutLinePaged.sEcho = sEcho;
            StockOutLinePaged.iTotalRecords = Count;
            StockOutLinePaged.iTotalDisplayRecords = Count;
            StockOutLinePaged.TrnStockOutLineData = StockOutLines.ToList();

            return StockOutLinePaged;
        }

        // ====================
        // POST api/TrnStockOut
        // ====================

        [HttpPost]
        public Models.TrnStockOut Post(Models.TrnStockOut value)
        {
            try
            {
                Data.TrnStockOut NewStockOut = new Data.TrnStockOut();
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLOTDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.OTDate).Year, +
                                                                     Convert.ToDateTime(value.OTDate).Month, +
                                                                     Convert.ToDateTime(value.OTDate).Day));
                var StockOut = from d in db.TrnStockOuts
                               where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                     d.BranchId == BranchId
                               select d;

                if (StockOut != null)
                {
                    var MaxOTNumber = Convert.ToDouble(StockOut.Max(d => d.OTNumber)) + 10000000001;
                    NewStockOut.OTNumber = MaxOTNumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewStockOut.OTNumber = "0000000001";
                }
                NewStockOut.PeriodId = value.PeriodId;
                NewStockOut.BranchId = value.BranchId;
                NewStockOut.OTManualNumber = value.OTManualNumber;
                NewStockOut.OTDate = SQLOTDate.Value;
                if (value.SIId > 0) NewStockOut.SIId = value.SIId;
                if (value.INId > 0) NewStockOut.INId = value.INId;
                NewStockOut.AccountId = value.AccountId;
                NewStockOut.ArticleId = value.ArticleId;
                NewStockOut.Particulars = value.Particulars;
                NewStockOut.PreparedById = value.PreparedById;
                NewStockOut.CheckedById = value.CheckedById;
                NewStockOut.ApprovedById = value.ApprovedById;
                NewStockOut.IsLocked = false;
                NewStockOut.CreatedById = secure.GetCurrentUser();
                NewStockOut.CreatedDateTime = SQLNow.Value;
                NewStockOut.UpdatedById = secure.GetCurrentUser();
                NewStockOut.UpdatedDateTime = SQLNow.Value;

                db.TrnStockOuts.InsertOnSubmit(NewStockOut);
                db.SubmitChanges();

                return Get(NewStockOut.Id);
            }
            catch
            {
                return new Models.TrnStockOut();
            }
        }

        // ============================
        // PUT api/TrnStockOut/5/Update
        // ============================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnStockOut value)
        {
            try
            {
                var StockOuts = from d in db.TrnStockOuts
                                where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select d;

                if (StockOuts.Any())
                {
                    var UpdatedStockOut = StockOuts.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                    SqlDateTime SQLINDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.OTDate).Year, +
                                                                         Convert.ToDateTime(value.OTDate).Month, +
                                                                         Convert.ToDateTime(value.OTDate).Day));

                    UpdatedStockOut.OTManualNumber = value.OTManualNumber;
                    UpdatedStockOut.OTDate = SQLINDate.Value;
                    if (value.SIId > 0) UpdatedStockOut.SIId = value.SIId;
                    if (value.INId > 0) UpdatedStockOut.INId = value.INId;
                    UpdatedStockOut.AccountId = value.AccountId;
                    UpdatedStockOut.ArticleId = value.ArticleId;
                    UpdatedStockOut.Particulars = value.Particulars;
                    UpdatedStockOut.PreparedById = value.PreparedById;
                    UpdatedStockOut.CheckedById = value.CheckedById;
                    UpdatedStockOut.ApprovedById = value.ApprovedById;
                    UpdatedStockOut.IsLocked = false;
                    UpdatedStockOut.UpdatedById = secure.GetCurrentUser();
                    UpdatedStockOut.UpdatedDateTime = SQLNow.Value;

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
        // PUT api/TrnStockOut/5/Approval
        // ==============================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var StockOuts = from d in db.TrnStockOuts
                                where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select d;

                if (StockOuts.Any())
                {
                    var UpdatedStockOut = StockOuts.FirstOrDefault();

                    UpdatedStockOut.IsLocked = Approval;

                    db.SubmitChanges();

                    journal.JournalizedOT(Id);

                    inventory.InsertInventoryOut(Id);
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

        // ========================
        // DELETE api/TrnStockOut/5
        // ========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnStockOut DeleteStockOut = db.TrnStockOuts.Where(d => d.Id == Id &&
                                                                         d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteStockOut != null)
            {
                if (DeleteStockOut.IsLocked == false)
                {
                    db.TrnStockOuts.DeleteOnSubmit(DeleteStockOut);
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