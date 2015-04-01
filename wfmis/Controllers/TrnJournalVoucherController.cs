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
    public class TrnJournalVoucherController : ApiController
    {

        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Bank bank = new Business.Bank();

        // =========================
        // GET api/TrnJournalVoucher
        // =========================

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

            var Count = db.TrnJournalVouchers.Where(d => d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                                         d.MstBranch.Id == BranchId).Count();

            var JournalVouchers = from d in db.TrnJournalVouchers
                                  where d.MstBranch.Id == BranchId &&
                                        d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                                  select new Models.TrnJournalVoucher
                                  {
                                        Id = d.Id,
                                        Period = d.MstPeriod.Period,
                                        Branch = d.MstBranch.Branch,
                                        JVNumber = d.JVNumber,
                                        JVManualNumber = d.JVManualNumber,
                                        JVDate = d.JVDate.ToShortDateString(),
                                        Particulars = d.Particulars,
                                        PreparedById = d.MstUser.Id,
                                        CheckedById = d.MstUser1.Id,
                                        ApprovedById = d.MstUser2.Id,
                                        PreparedBy = d.MstUser.FullName,
                                        CheckedBy =  d.MstUser1.FullName,
                                        ApprovedBy =  d.MstUser2.FullName,
                                        IsLocked = d.IsLocked,
                                        CreatedBy =  d.MstUser3.FullName,
                                        CreatedDateTime = d.CreatedDateTime,
                                        UpdatedBy = d.MstUser4.FullName,
                                        UpdatedDateTime = d.UpdatedByDateTime                                      
                                  };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") JournalVouchers = JournalVouchers.OrderBy(d => d.JVNumber).Skip(iDisplayStart).Take(10);
                    else JournalVouchers = JournalVouchers.OrderByDescending(d => d.JVNumber).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") JournalVouchers = JournalVouchers.OrderBy(d => d.JVNumber).Skip(iDisplayStart).Take(10);
                    else JournalVouchers = JournalVouchers.OrderByDescending(d => d.JVNumber).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") JournalVouchers = JournalVouchers.OrderBy(d => d.JVNumber).Skip(iDisplayStart).Take(10);
                    else JournalVouchers = JournalVouchers.OrderByDescending(d => d.JVNumber).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    JournalVouchers = JournalVouchers.Skip(iDisplayStart).Take(10);
                    break;
            }

            var JournalVoucherPaged = new Models.SysDataTablePager();

            JournalVoucherPaged.sEcho = sEcho;
            JournalVoucherPaged.iTotalRecords = Count;
            JournalVoucherPaged.iTotalDisplayRecords = Count;
            JournalVoucherPaged.TrnJournalVoucherData = JournalVouchers.ToList();

            return JournalVoucherPaged;
        }

        // ==========================================
        // GET api/TrnJournalVoucher/5/JournalVoucher
        // ==========================================

        [HttpGet]
        [ActionName("JournalVoucher")]
        public Models.TrnJournalVoucher Get(Int64 Id)
        {
            var JournalVouchers = from d in db.TrnJournalVouchers
                                  where d.Id == Id &&
                                        d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                                  select new Models.TrnJournalVoucher
                                  {
                                      Id = d.Id,
                                      Period = d.MstPeriod.Period,
                                      Branch = d.MstBranch.Branch,
                                      JVNumber = d.JVNumber,
                                      JVManualNumber = d.JVManualNumber,
                                      JVDate = d.JVDate.ToShortDateString(),
                                      Particulars = d.Particulars,
                                      PreparedById = d.MstUser.Id,
                                      CheckedById = d.MstUser1.Id,
                                      ApprovedById = d.MstUser2.Id,
                                      PreparedBy = d.MstUser.FullName,
                                      CheckedBy = d.MstUser1.FullName,
                                      ApprovedBy = d.MstUser2.FullName,
                                      IsLocked = d.IsLocked,
                                      CreatedBy = d.MstUser3.FullName,
                                      CreatedDateTime = d.CreatedDateTime,
                                      UpdatedBy = d.MstUser4.FullName,
                                      UpdatedDateTime = d.UpdatedByDateTime
                                  };

            if (JournalVouchers.Any())
            {
                return JournalVouchers.First();
            }
            else 
            { 
                return new Models.TrnJournalVoucher();
            }
        }

        // ===============================================
        // GET api/TrnJournalVoucher/5/JournalVoucherLines
        // ===============================================

        [HttpGet]
        [ActionName("JournalVoucherLines")]
        public Models.SysDataTablePager JournalVoucherLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournalVoucherLines.Where(d => d.TrnJournalVoucher.Id == Id && 
                                                             d.TrnJournalVoucher.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var JournalVoucherLines = (from j in db.TrnJournalVoucherLines
                                       where j.TrnJournalVoucher.Id == Id &&
                                             j.TrnJournalVoucher.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                       select new Models.TrnJournalVoucherLine
                                       {
                                           LineId = j.Id,
                                           LineJVId = j.JVId,
                                           LineBranchId = j.TrnJournalVoucher.BranchId,
                                           LineBranch = j.TrnJournalVoucher.MstBranch.Branch,
                                           LineAccountId = j.AccountId,
                                           LineAccount = j.MstAccount.Account,
                                           LineArticleId = (j.MstArticle == null) ? 0 : j.MstArticle.Id,
                                           LineArticle = (j.MstArticle == null) ? "" : j.MstArticle.Article,
                                           LineCreditAmount = j.CreditAmount,
                                           LineDebitAmount = j.DebitAmount,
                                           LineParticulars = j.Particulars
                                       });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") JournalVoucherLines = JournalVoucherLines.OrderBy(d => d.LineAccount).Skip(iDisplayStart).Take(10);
                    else JournalVoucherLines = JournalVoucherLines.OrderByDescending(d => d.LineAccount).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") JournalVoucherLines = JournalVoucherLines.OrderBy(d => d.LineArticle).Skip(iDisplayStart).Take(10);
                    else JournalVoucherLines = JournalVoucherLines.OrderByDescending(d => d.LineArticle).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    JournalVoucherLines = JournalVoucherLines.Skip(iDisplayStart).Take(10);
                    break;
            }

            var JournalVoucherLinePaged = new Models.SysDataTablePager();

            JournalVoucherLinePaged.sEcho = sEcho;
            JournalVoucherLinePaged.iTotalRecords = Count;
            JournalVoucherLinePaged.iTotalDisplayRecords = Count;
            JournalVoucherLinePaged.TrnJournalVoucherLineData = JournalVoucherLines.ToList();

            return JournalVoucherLinePaged;
        }

        // ==========================
        // POST api/TrnJournalVoucher
        // ==========================

        [HttpPost]
        public Models.TrnJournalVoucher Post(Models.TrnJournalVoucher value)
        {
            var TrnJournalVoucherModel = new Models.TrnJournalVoucher();

            try
            {
                Data.TrnJournalVoucher NewJournalVoucher = new Data.TrnJournalVoucher();
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));

                SqlDateTime SQLJVDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.JVDate).Year, +
                                                                     Convert.ToDateTime(value.JVDate).Month, +
                                                                     Convert.ToDateTime(value.JVDate).Day));
                if (secure.GetCurrentSubscriberUser() > 0)
                {
                    var JournalVouchers = from d in db.TrnJournalVouchers
                                          where d.MstUser.Id == secure.GetCurrentSubscriberUser() && 
                                                d.MstPeriod.Id == PeriodId && 
                                                d.MstBranch.Id == BranchId
                                          select d;

                    if (JournalVouchers != null)
                    {
                        var MaxJVNumber = Convert.ToDouble(JournalVouchers.Max(jv => jv.JVNumber)) + 10000000001;

                        NewJournalVoucher.JVNumber = MaxJVNumber.ToString().Trim().Substring(1);
                    }
                    else
                    {
                        NewJournalVoucher.JVNumber = "0000000001";
                    }
                    NewJournalVoucher.PeriodId = PeriodId;
                    NewJournalVoucher.BranchId = BranchId;
                    NewJournalVoucher.JVManualNumber = value.JVManualNumber;
                    NewJournalVoucher.JVDate = SQLJVDate.Value;
                    NewJournalVoucher.Particulars = value.Particulars;
                    NewJournalVoucher.PreparedById = Convert.ToInt16(value.PreparedById);
                    NewJournalVoucher.CheckedById = Convert.ToInt16(value.CheckedById);
                    NewJournalVoucher.ApprovedById = Convert.ToInt16(value.ApprovedById);
                    NewJournalVoucher.IsLocked = false;
                    NewJournalVoucher.CreatedById = secure.GetCurrentUser();
                    NewJournalVoucher.CreatedDateTime = SQLNow.Value;
                    NewJournalVoucher.UpdatedById = secure.GetCurrentUser();
                    NewJournalVoucher.UpdatedByDateTime = SQLNow.Value;

                    db.TrnJournalVouchers.InsertOnSubmit(NewJournalVoucher);
                    db.SubmitChanges();

                    return Get(NewJournalVoucher.Id);
                }
                else
                {
                    return TrnJournalVoucherModel;
                }
            }
            catch
            {
                return TrnJournalVoucherModel;
            }
        }

        // ==================================
        // PUT api/TrnJournalVoucher/5/Update
        // ==================================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnJournalVoucher value)
        {
            try
            {
                var JournalVouchers = from d in db.TrnJournalVouchers
                                      where d.Id == Id && 
                                            d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                      select d;

                if (JournalVouchers.Any())
                {
                    var UpdatedJournalVoucher = JournalVouchers.FirstOrDefault();
                    SqlDateTime SQLJVDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.JVDate).Year, +
                                                                         Convert.ToDateTime(value.JVDate).Month, +
                                                                         Convert.ToDateTime(value.JVDate).Day));
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));     
                 
                    UpdatedJournalVoucher.JVManualNumber = value.JVManualNumber;
                    UpdatedJournalVoucher.JVDate = SQLJVDate.Value;
                    UpdatedJournalVoucher.Particulars = value.Particulars;
                    UpdatedJournalVoucher.PreparedById = Convert.ToInt16(value.PreparedById);
                    UpdatedJournalVoucher.CheckedById = Convert.ToInt16(value.CheckedById);
                    UpdatedJournalVoucher.ApprovedById = Convert.ToInt16(value.ApprovedById);
                    UpdatedJournalVoucher.IsLocked = false;
                    UpdatedJournalVoucher.UpdatedById = secure.GetCurrentUser();
                    UpdatedJournalVoucher.UpdatedByDateTime = SQLNow.Value;

                    db.SubmitChanges();

                    journal.JournalizedJV(Id);
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

        // ======================================
        // POST api/TrnJournalVoucher/5/Approval
        // ======================================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var JournalVouchers = from d in db.TrnJournalVouchers
                                      where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                      select d;

                if (JournalVouchers.Any())
                {
                    var UpdatedJournalVoucher = JournalVouchers.FirstOrDefault();

                    UpdatedJournalVoucher.IsLocked = Approval;

                    db.SubmitChanges();

                    journal.JournalizedJV(Id);

                    bank.BankRecordJV(Id);
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
        // DELETE api/TrnJournalVoucher/5
        // ==============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnJournalVoucher DeleteJournalVoucher = db.TrnJournalVouchers.Where(d => d.Id == Id && 
                                                                                           d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteJournalVoucher != null)
            {
                if (DeleteJournalVoucher.IsLocked == false)
                {
                    db.TrnJournalVouchers.DeleteOnSubmit(DeleteJournalVoucher);
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