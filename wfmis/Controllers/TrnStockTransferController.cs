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
    public class TrnStockTransferController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Inventory inventory = new Business.Inventory();

        // ========================
        // GET api/TrnStockTransfer
        // ========================

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

            var Count = db.TrnStockTransfers.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                        d.MstBranch.Id == BranchId).Count();

            var StockTransfers = from d in db.TrnStockTransfers
                                 where d.MstBranch.Id == BranchId &&
                                       d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                 select new Models.TrnStockTransfer
                                 {
                                    Id = d.Id,
                                    PeriodId = d.PeriodId,
                                    Period = d.MstPeriod.Period,
                                    BranchId = d.BranchId,
                                    Branch = d.MstBranch.Branch,
                                    STNumber = d.STNumber,
                                    STManualNumber = d.STManualNumber,
                                    STDate = Convert.ToString(d.STDate.Month) + "/" + Convert.ToString(d.STDate.Day) + "/" + Convert.ToString(d.STDate.Year),
                                    ToBranchId = d.ToBranchId,
                                    ToBranch = d.MstBranch1.Branch,
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
                    if (sSortDir == "asc") StockTransfers = StockTransfers.OrderBy(d => d.STDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockTransfers = StockTransfers.OrderByDescending(d => d.STDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") StockTransfers = StockTransfers.OrderBy(d => d.STNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockTransfers = StockTransfers.OrderByDescending(d => d.STNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") StockTransfers = StockTransfers.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockTransfers = StockTransfers.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    StockTransfers = StockTransfers.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var StockTransferPaged = new Models.SysDataTablePager();

            StockTransferPaged.sEcho = sEcho;
            StockTransferPaged.iTotalRecords = Count;
            StockTransferPaged.iTotalDisplayRecords = Count;
            StockTransferPaged.TrnStockTransferData = StockTransfers.ToList();

            return StockTransferPaged;
        }

        // ========================================
        // GET api/TrnStockTransfer/5/StockTransfer
        // ========================================

        [HttpGet]
        [ActionName("StockTransfer")]
        public Models.TrnStockTransfer Get(Int64 Id)
        {
            var StockTransfers = from d in db.TrnStockTransfers
                                 where d.Id == Id &&
                                       d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                 select new Models.TrnStockTransfer
                                 {
                                    Id = d.Id,
                                    PeriodId = d.PeriodId,
                                    Period = d.MstPeriod.Period,
                                    BranchId = d.BranchId,
                                    Branch = d.MstBranch.Branch,
                                    STNumber = d.STNumber,
                                    STManualNumber = d.STManualNumber,
                                    STDate = Convert.ToString(d.STDate.Month) + "/" + Convert.ToString(d.STDate.Day) + "/" + Convert.ToString(d.STDate.Year),
                                    ToBranchId = d.ToBranchId,
                                    ToBranch = d.MstBranch1.Branch,
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

            if (StockTransfers.Any())
            {
                return StockTransfers.First();
            }
            else
            {
                return new Models.TrnStockTransfer();
            }
        }

        // =============================================
        // GET api/TrnStockTransfer/5/StockTransferLines
        // =============================================

        [HttpGet]
        [ActionName("StockTransferLines")]
        public Models.SysDataTablePager StockTransferLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnStockTransferLines.Where(d => d.STId == Id &&
                                                            d.TrnStockTransfer.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var StockTransferLines = (from d in db.TrnStockTransferLines
                                      where d.STId == Id &&
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
                                         LineBaseCost = d.BaseCost,
                                         LineBaseQuantity = d.BaseQuantity
                                      });

            var StockTransferLinePaged = new Models.SysDataTablePager();

            StockTransferLinePaged.sEcho = sEcho;
            StockTransferLinePaged.iTotalRecords = Count;
            StockTransferLinePaged.iTotalDisplayRecords = Count;
            StockTransferLinePaged.TrnStockTransferLineData = StockTransferLines.ToList();

            return StockTransferLinePaged;
        }

        // =========================
        // POST api/TrnStockTransfer
        // =========================

        [HttpPost]
        public Models.TrnStockTransfer Post(Models.TrnStockTransfer value)
        {
            try
            {
                Data.TrnStockTransfer NewStockTransfer = new Data.TrnStockTransfer();
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLSTDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.STDate).Year, +
                                                                     Convert.ToDateTime(value.STDate).Month, +
                                                                     Convert.ToDateTime(value.STDate).Day));
                var StockTransfer = from d in db.TrnStockTransfers
                               where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                     d.BranchId == BranchId
                               select d;

                if (StockTransfer != null)
                {
                    var MaxSTNumber = Convert.ToDouble(StockTransfer.Max(d => d.STNumber)) + 10000000001;
                    NewStockTransfer.STNumber = MaxSTNumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewStockTransfer.STNumber = "0000000001";
                }
                NewStockTransfer.PeriodId = value.PeriodId;
                NewStockTransfer.BranchId = value.BranchId;
                NewStockTransfer.STManualNumber = value.STManualNumber;
                NewStockTransfer.STDate = SQLSTDate.Value;
                NewStockTransfer.ToBranchId = value.ToBranchId;
                NewStockTransfer.AccountId = value.AccountId;
                NewStockTransfer.ArticleId = value.ArticleId;
                NewStockTransfer.Particulars = value.Particulars;
                NewStockTransfer.PreparedById = value.PreparedById;
                NewStockTransfer.CheckedById = value.CheckedById;
                NewStockTransfer.ApprovedById = value.ApprovedById;
                NewStockTransfer.IsLocked = false;
                NewStockTransfer.CreatedById = secure.GetCurrentUser();
                NewStockTransfer.CreatedDateTime = SQLNow.Value;
                NewStockTransfer.UpdatedById = secure.GetCurrentUser();
                NewStockTransfer.UpdatedDateTime = SQLNow.Value;

                db.TrnStockTransfers.InsertOnSubmit(NewStockTransfer);
                db.SubmitChanges();

                return Get(NewStockTransfer.Id);
            }
            catch
            {
                return new Models.TrnStockTransfer();
            }
        }

        // ==========================
        // PUT api/TrnStockTransfer/5
        // ==========================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnStockTransfer value)
        {
            try
            {
                var StockTransfers = from d in db.TrnStockTransfers
                                where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select d;

                if (StockTransfers.Any())
                {
                    var UpdatedStockTransfer = StockTransfers.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                    SqlDateTime SQLSTDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.STDate).Year, +
                                                                         Convert.ToDateTime(value.STDate).Month, +
                                                                         Convert.ToDateTime(value.STDate).Day));

                    UpdatedStockTransfer.STManualNumber = value.STManualNumber;
                    UpdatedStockTransfer.STDate = SQLSTDate.Value;
                    UpdatedStockTransfer.ToBranchId = value.ToBranchId;
                    UpdatedStockTransfer.AccountId = value.AccountId;
                    UpdatedStockTransfer.ArticleId = value.ArticleId;
                    UpdatedStockTransfer.Particulars = value.Particulars;
                    UpdatedStockTransfer.PreparedById = value.PreparedById;
                    UpdatedStockTransfer.CheckedById = value.CheckedById;
                    UpdatedStockTransfer.ApprovedById = value.ApprovedById;
                    UpdatedStockTransfer.IsLocked = false;
                    UpdatedStockTransfer.UpdatedById = secure.GetCurrentUser();
                    UpdatedStockTransfer.UpdatedDateTime = SQLNow.Value;

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
        // PUT api/TrnStockTransfer/5/Approval
        // ===================================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var StockTransfers = from d in db.TrnStockTransfers
                                     where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                     select d;

                if (StockTransfers.Any())
                {
                    var UpdatedStockTransfer = StockTransfers.FirstOrDefault();

                    UpdatedStockTransfer.IsLocked = Approval;

                    db.SubmitChanges();

                    journal.JournalizedST(Id);

                    inventory.InsertInventoryTransfer(Id);
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

        // =============================
        // DELETE api/TrnStockTransfer/5
        // =============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnStockTransfer DeleteStockTransfer = db.TrnStockTransfers.Where(d => d.Id == Id &&
                                                                                        d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteStockTransfer != null)
            {
                if (DeleteStockTransfer.IsLocked == false)
                {
                    db.TrnStockTransfers.DeleteOnSubmit(DeleteStockTransfer);
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