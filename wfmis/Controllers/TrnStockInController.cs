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
    public class TrnStockInController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Inventory inventory = new Business.Inventory();

        // ==================
        // GET api/TrnStockIn
        // ==================

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

            var Count = db.TrnStockIns.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                  d.MstBranch.Id == BranchId).Count();

            var StockIns = from d in db.TrnStockIns
                           where d.MstBranch.Id == BranchId &&
                                 d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                           select new Models.TrnStockIn
                           {
                                Id = d.Id,
                                PeriodId = d.PeriodId,
                                Period = d.MstPeriod.Period,
                                BranchId = d.BranchId,
                                Branch = d.MstBranch.Branch,
                                INNumber = d.INNumber,
                                INManualNumber = d.INManualNumber,
                                INDate = Convert.ToString(d.INDate.Year) + "-" + Convert.ToString(d.INDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.INDate.Day + 100).Substring(1, 2),
                                PIId = d.PIId == null ? 0 : d.PIId.Value,
                                PINumber = d.PIId == null ? "" : d.TrnPurchaseInvoice.PINumber,
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
                                IsProduced = d.IsProduced,
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
                    if (sSortDir == "asc") StockIns = StockIns.OrderBy(d => d.INDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockIns = StockIns.OrderByDescending(d => d.INDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") StockIns = StockIns.OrderBy(d => d.INNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockIns = StockIns.OrderByDescending(d => d.INNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") StockIns = StockIns.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else StockIns = StockIns.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    StockIns = StockIns.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var StockInPaged = new Models.SysDataTablePager();

            StockInPaged.sEcho = sEcho;
            StockInPaged.iTotalRecords = Count;
            StockInPaged.iTotalDisplayRecords = Count;
            StockInPaged.TrnStockInData = StockIns.ToList();

            return StockInPaged;
        }

        // ============================
        // GET api/TrnStockIn/5/StockIn
        // ============================

        [HttpGet]
        [ActionName("StockIn")]
        public Models.TrnStockIn Get(Int64 Id)
        {
            var StockIns = from d in db.TrnStockIns
                           where d.Id == Id &&
                                 d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                           select new Models.TrnStockIn
                           {
                               Id = d.Id,
                               PeriodId = d.PeriodId,
                               Period = d.MstPeriod.Period,
                               BranchId = d.BranchId,
                               Branch = d.MstBranch.Branch,
                               INNumber = d.INNumber,
                               INManualNumber = d.INManualNumber,
                               INDate = Convert.ToString(d.INDate.Month) + "/" + Convert.ToString(d.INDate.Day) + "/" + Convert.ToString(d.INDate.Year),
                               PIId = d.PIId == null ? 0 : d.PIId.Value,
                               PINumber = d.PIId == null ? "" : d.TrnPurchaseInvoice.PINumber,
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
                               IsProduced = d.IsProduced,
                               CreatedById = d.CreatedById,
                               CreatedBy = d.MstUser3.FullName,
                               CreatedDateTime = Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                               UpdatedById = d.UpdatedById,
                               UpdatedBy = d.MstUser4.FullName,
                               UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                           };

            if (StockIns.Any())
            {
                return StockIns.First();
            }
            else
            {
                return new Models.TrnStockIn();
            }
        }

        // =================================
        // GET api/TrnStockIn/5/StockInLines
        // =================================

        [HttpGet]
        [ActionName("StockInLines")]
        public Models.SysDataTablePager StockInLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnStockInLines.Where(d => d.INId == Id &&
                                                      d.TrnStockIn.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var StockInLines = (from d in db.TrnStockInLines
                                where d.INId == Id &&
                                      d.TrnStockIn.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select new Models.TrnStockInLine
                                {
                                       LineId = d.Id,
                                       LineINId = d.INId,
                                       LineItemId = d.ItemId,
                                       LineItem = d.MstArticle.Article,
                                       LineItemInventoryId = d.ItemInventoryId == null ? 0 : d.ItemInventoryId.Value,
                                       LineItemInventoryNumber = d.ItemInventoryId == null ? "" : d.MstArticleItemInventory.InventoryNumber,
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

            var StockInLinePaged = new Models.SysDataTablePager();

            StockInLinePaged.sEcho = sEcho;
            StockInLinePaged.iTotalRecords = Count;
            StockInLinePaged.iTotalDisplayRecords = Count;
            StockInLinePaged.TrnStockInLineData = StockInLines.ToList();

            return StockInLinePaged;
        }

        // ===================
        // POST api/TrnStockIn
        // ===================

        [HttpPost]
        public Models.TrnStockIn Post(Models.TrnStockIn value)
        {
            try
            {
                Data.TrnStockIn NewStockIn = new Data.TrnStockIn();
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLINDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.INDate).Year, +
                                                                     Convert.ToDateTime(value.INDate).Month, +
                                                                     Convert.ToDateTime(value.INDate).Day));
                var StockIn = from d in db.TrnStockIns
                              where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                    d.BranchId == BranchId
                              select d;

                if (StockIn != null)
                {
                    var MaxINNumber = Convert.ToDouble(StockIn.Max(d => d.INNumber)) + 10000000001;
                    NewStockIn.INNumber = MaxINNumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewStockIn.INNumber = "0000000001";
                }
                NewStockIn.PeriodId = value.PeriodId;
                NewStockIn.BranchId = value.BranchId;
                NewStockIn.INManualNumber = value.INManualNumber;
                NewStockIn.INDate = SQLINDate.Value;
                if(value.PIId>0) NewStockIn.PIId = value.PIId;
                NewStockIn.AccountId = value.AccountId;
                NewStockIn.ArticleId = value.ArticleId;
                NewStockIn.Particulars = value.Particulars;
                NewStockIn.PreparedById = value.PreparedById;
                NewStockIn.CheckedById = value.CheckedById;
                NewStockIn.ApprovedById = value.ApprovedById;
                NewStockIn.IsLocked = false;
                NewStockIn.IsProduced = value.IsProduced;
                NewStockIn.CreatedById = secure.GetCurrentUser();
                NewStockIn.CreatedDateTime = SQLNow.Value;
                NewStockIn.UpdatedById = secure.GetCurrentUser();
                NewStockIn.UpdatedDateTime = SQLNow.Value;

                db.TrnStockIns.InsertOnSubmit(NewStockIn);
                db.SubmitChanges();

                return Get(NewStockIn.Id);
            }
            catch
            {
                return new Models.TrnStockIn();
            }
        }

        // ===========================
        // PUT api/TrnStockIn/5/Update
        // ===========================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnStockIn value)
        {
            try
            {
                var StockIns = from d in db.TrnStockIns
                               where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                               select d;

                if (StockIns.Any())
                {
                    var UpdatedStockIn = StockIns.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                    SqlDateTime SQLINDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.INDate).Year, +
                                                                         Convert.ToDateTime(value.INDate).Month, +
                                                                         Convert.ToDateTime(value.INDate).Day));

                    UpdatedStockIn.INManualNumber = value.INManualNumber;
                    UpdatedStockIn.INDate = SQLINDate.Value;
                    if (value.PIId > 0) UpdatedStockIn.PIId = value.PIId;
                    UpdatedStockIn.AccountId = value.AccountId;
                    UpdatedStockIn.ArticleId = value.ArticleId;
                    UpdatedStockIn.Particulars = value.Particulars;
                    UpdatedStockIn.PreparedById = value.PreparedById;
                    UpdatedStockIn.CheckedById = value.CheckedById;
                    UpdatedStockIn.ApprovedById = value.ApprovedById;
                    UpdatedStockIn.IsLocked = false;
                    UpdatedStockIn.IsProduced = value.IsProduced;
                    UpdatedStockIn.UpdatedById = secure.GetCurrentUser();
                    UpdatedStockIn.UpdatedDateTime = SQLNow.Value;                    

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
        // PUT api/TrnStockIn/5/Approval
        // ==============================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var StockIns = from d in db.TrnStockIns
                               where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                               select d;

                if (StockIns.Any())
                {
                    var UpdatedStockIn = StockIns.FirstOrDefault();

                    UpdatedStockIn.IsLocked = Approval;

                    db.SubmitChanges();

                    journal.JournalizedIN(Id);

                    inventory.InsertInventoryIn(Id);

                    if (UpdatedStockIn.IsProduced == true)
                    {
                        inventory.CreateStockOut(Id, true);
                    }
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

        // =======================
        // DELETE api/TrnStockIn/5
        // =======================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnStockIn DeleteStockIn = db.TrnStockIns.Where(d => d.Id == Id &&
                                                                      d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteStockIn != null)
            {
                if (DeleteStockIn.IsLocked == false)
                {
                    db.TrnStockIns.DeleteOnSubmit(DeleteStockIn);
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