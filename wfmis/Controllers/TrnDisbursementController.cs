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
    public class TrnDisbursementController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Bank bank = new Business.Bank();

        private void UpdateAP(Int64 CVId)
        {
            var DisbursementLines = from d in db.TrnDisbursementLines
                                    where d.CVId == CVId && d.PIId > 0
                                    select d;

            if (DisbursementLines.Any())
            {
                foreach (var Line in DisbursementLines)
                {
                    var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                           where d.Id == Line.PIId
                                           select d;
                    if (PurchaseInvoices.Any())
                    {
                        var UpdatedPurchaseInvoice = PurchaseInvoices.First();
                        UpdatedPurchaseInvoice.TotalPaidAmount = UpdatedPurchaseInvoice.TrnDisbursementLines.Where(d => d.TrnDisbursement.IsLocked == true).Sum(a => a.Amount);
                        UpdatedPurchaseInvoice.TotalDebitAmount = UpdatedPurchaseInvoice.TrnJournalVoucherLines.Where(d => d.TrnJournalVoucher.IsLocked == true).Sum(a => a.DebitAmount);
                        UpdatedPurchaseInvoice.TotalCreditAmount = UpdatedPurchaseInvoice.TrnJournalVoucherLines.Where(d => d.TrnJournalVoucher.IsLocked == true).Sum(a => a.CreditAmount);
                        db.SubmitChanges();
                    }
                }
            }
        }

        // =======================
        // GET api/TrnDisbursement
        // =======================

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

            var Count = db.TrnDisbursements.Where(d => d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser() && 
                                                       d.MstBranch.Id == BranchId).Count();

            var Disbursements = from d in db.TrnDisbursements
                                where d.MstBranch.Id == BranchId &&
                                     d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                                select new Models.TrnDisbursement
                                   {
                                        Id = d.Id,
                                        PeriodId = d.PeriodId,
                                        Period = d.MstPeriod.Period,
                                        BranchId = d.BranchId,
                                        Branch = d.MstBranch.Branch,
                                        CVNumber = d.CVNumber,
                                        CVManualNumber = d.CVManualNumber,
                                        CVDate = Convert.ToString(d.CVDate.Year) + "-" + Convert.ToString(d.CVDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.CVDate.Day + 100).Substring(1, 2),
                                        Supplier = d.MstArticle.Article,
                                        BankId = d.BankId,
                                        Bank = d.MstArticle1.Article,
                                        PayTypeId = d.PayTypeId,
                                        PayType = d.MstPayType.PayType,
                                        CheckNumber = d.CheckNumber,
                                        CheckDate = Convert.ToString(d.CheckDate.Month) + "/" + Convert.ToString(d.CheckDate.Day) + "/" + Convert.ToString(d.CheckDate.Year),
                                        CheckPayee = d.CheckPayee,
                                        TotalAmount = d.TotalAmount,
                                        IsCleared = d.IsCleared,
                                        DateCleared = Convert.ToString(d.DateCleared.Month) + "/" + Convert.ToString(d.DateCleared.Day) + "/" + Convert.ToString(d.DateCleared.Year),
                                        IsPrinted = d.IsPrinted,
                                        PreparedById = d.PreparedById,
                                        PreparedBy = d.MstUser.FullName,
                                        CheckedById = d.CheckedById,
                                        CheckedBy = d.MstUser1.FullName,
                                        ApprovedById = d.ApprovedById,
                                        ApprovedBy = d.MstUser2.FullName,
                                        IsLocked = d.IsLocked,
                                        CreatedById = d.CreatedById,
                                        CreatedBy = d.MstUser3.FullName,
                                        CreatedDateTime = Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                        UpdatedById = d.UpdatedById,
                                        UpdatedBy = d.MstUser4.FullName,
                                        UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                                   };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Disbursements = Disbursements.OrderBy(d => d.CVDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Disbursements = Disbursements.OrderByDescending(d => d.CVDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Disbursements = Disbursements.OrderBy(d => d.CVNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Disbursements = Disbursements.OrderByDescending(d => d.CVNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Disbursements = Disbursements.OrderBy(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Disbursements = Disbursements.OrderByDescending(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Disbursements = Disbursements.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var DisbursementPaged = new Models.SysDataTablePager();

            DisbursementPaged.sEcho = sEcho;
            DisbursementPaged.iTotalRecords = Count;
            DisbursementPaged.iTotalDisplayRecords = Count;
            DisbursementPaged.TrnDisbursementData = Disbursements.ToList();

            return DisbursementPaged;
        }

        // ======================================
        // GET api/TrnDisbursement/5/Disbursement
        // ======================================

        [HttpGet]
        [ActionName("Disbursement")]
        public Models.TrnDisbursement Get(Int64 Id)
        {
            var Disbursements = from d in db.TrnDisbursements
                                where d.Id == Id &&
                                      d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                                select new Models.TrnDisbursement
                                  {
                                      Id = d.Id,
                                      PeriodId = d.PeriodId,
                                      Period = d.MstPeriod.Period,
                                      BranchId = d.BranchId,
                                      Branch = d.MstBranch.Branch,
                                      CVNumber = d.CVNumber,
                                      CVManualNumber = d.CVManualNumber,
                                      CVDate = d.CVDate == null? "" : d.CVDate.ToShortDateString(),
                                      Particulars = d.Particulars,
                                      SupplierId = d.SupplierId,
                                      Supplier = d.MstArticle.Article,
                                      BankId = d.BankId,
                                      Bank = d.MstArticle1.Article,
                                      PayTypeId = d.PayTypeId,
                                      PayType = d.MstPayType.PayType,
                                      CheckNumber = d.CheckNumber,
                                      CheckDate = d.CheckDate == null? "" : d.CheckDate.ToShortDateString(),
                                      CheckPayee = d.CheckPayee,
                                      TotalAmount = d.TotalAmount,
                                      IsCleared = d.IsCleared,
                                      DateCleared = d.DateCleared == null? "" : d.DateCleared.ToShortDateString(),
                                      IsPrinted = d.IsPrinted,
                                      PreparedById = d.PreparedById,
                                      PreparedBy = d.MstUser.FullName,
                                      CheckedById = d.CheckedById,
                                      CheckedBy = d.MstUser1.FullName,
                                      ApprovedById = d.ApprovedById,
                                      ApprovedBy = d.MstUser2.FullName,
                                      IsLocked = d.IsLocked,
                                      CreatedById = d.CreatedById,
                                      CreatedBy = d.MstUser3.FullName,
                                      CreatedDateTime = d.CreatedDateTime == null ? "" : d.CreatedDateTime.ToShortDateString(),
                                      UpdatedById = d.UpdatedById,
                                      UpdatedBy = d.MstUser4.FullName,
                                      UpdatedDateTime = d.UpdatedDateTime == null ? "" : d.UpdatedDateTime.ToShortDateString()
                                  };

            if (Disbursements.Any())
            {
                return Disbursements.First();
            }
            else
            {
                return new Models.TrnDisbursement();
            }
        }

        // ===========================================
        // GET api/TrnDisbursement/5/DisbursementLines
        // ===========================================

        [HttpGet]
        [ActionName("DisbursementLines")]
        public Models.SysDataTablePager DisbursementLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnDisbursementLines.Where(d => d.TrnDisbursement.Id == Id && 
                                                           d.TrnDisbursement.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var DisbursementLines = (from d in db.TrnDisbursementLines
                                     where d.TrnDisbursement.Id == Id &&
                                           d.TrnDisbursement.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                     select new Models.TrnDisbursementLine
                                     {
                                           LineId = d.Id,
                                           LineCVId = d.CVId,
                                           LineAccountId = d.AccountId,
                                           LineAccount = d.MstAccount.MstAccountType.AccountType + " - " + d.MstAccount.Account,
                                           LinePIId = d.PIId == null? 0 : d.PIId.Value,
                                           LinePINumber = d.PIId == null ? "" : d.TrnPurchaseInvoice.PINumber,
                                           LineAmount = d.Amount,
                                           LineParticulars = d.Particulars,
                                           LineBranchId = d.BranchId,
                                           LineBranch = d.MstBranch.Branch
                                      });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") DisbursementLines = DisbursementLines.OrderBy(d => d.LineAccount).Skip(iDisplayStart).Take(10);
                    else DisbursementLines = DisbursementLines.OrderByDescending(d => d.LineAccount).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") DisbursementLines = DisbursementLines.OrderBy(d => d.LinePINumber).Skip(iDisplayStart).Take(10);
                    else DisbursementLines = DisbursementLines.OrderByDescending(d => d.LinePINumber).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") DisbursementLines = DisbursementLines.OrderBy(d => d.LineParticulars).Skip(iDisplayStart).Take(10);
                    else DisbursementLines = DisbursementLines.OrderByDescending(d => d.LineParticulars).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    DisbursementLines = DisbursementLines.Skip(iDisplayStart).Take(10);
                    break;
            }

            var JournalVoucherLinePaged = new Models.SysDataTablePager();

            JournalVoucherLinePaged.sEcho = sEcho;
            JournalVoucherLinePaged.iTotalRecords = Count;
            JournalVoucherLinePaged.iTotalDisplayRecords = Count;
            JournalVoucherLinePaged.TrnDisbursementLineData = DisbursementLines.ToList();

            return JournalVoucherLinePaged;
        }

        // ========================
        // POST api/TrnDisbursement
        // ========================

        [HttpPost]
        public Models.TrnDisbursement Post(Models.TrnDisbursement value)
        {
            try
            {
                Data.TrnDisbursement NewDisbursement = new Data.TrnDisbursement();
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLCVDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.CVDate).Year, +
                                                                     Convert.ToDateTime(value.CVDate).Month, +
                                                                     Convert.ToDateTime(value.CVDate).Day));
                SqlDateTime SQLCheckDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.CheckDate).Year, +
                                                                        Convert.ToDateTime(value.CheckDate).Month, +
                                                                        Convert.ToDateTime(value.CheckDate).Day));

                var Disbursement = from d in db.TrnDisbursements
                                   where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                         d.MstPeriod.Id == PeriodId &&
                                         d.MstBranch.Id == BranchId
                                   select d;
                if (Disbursement != null)
                {
                    var MaxCVNumber = Convert.ToDouble(Disbursement.Max(d => d.CVNumber)) + 10000000001;
                    NewDisbursement.CVNumber = MaxCVNumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewDisbursement.CVNumber = "0000000001";
                }
                NewDisbursement.PeriodId = PeriodId;
                NewDisbursement.BranchId = BranchId;
                NewDisbursement.CVManualNumber = value.CVManualNumber;
                NewDisbursement.CVDate = SQLCVDate.Value;
                NewDisbursement.Particulars = value.Particulars;
                NewDisbursement.SupplierId = value.SupplierId;
                NewDisbursement.BankId = value.BankId;
                NewDisbursement.PayTypeId = value.PayTypeId;
                NewDisbursement.CheckNumber = value.CheckNumber;
                NewDisbursement.CheckDate = SQLCheckDate.Value;
                NewDisbursement.CheckPayee = value.CheckPayee;
                NewDisbursement.TotalAmount = value.TotalAmount;
                NewDisbursement.IsCleared = true;
                NewDisbursement.DateCleared = SQLNow.Value;
                NewDisbursement.IsPrinted = true;
                NewDisbursement.PreparedById = value.PreparedById;
                NewDisbursement.CheckedById = value.CheckedById;
                NewDisbursement.ApprovedById = value.ApprovedById;
                NewDisbursement.IsLocked = false;
                NewDisbursement.CreatedById = secure.GetCurrentUser();
                NewDisbursement.CreatedDateTime = SQLNow.Value;
                NewDisbursement.UpdatedById = secure.GetCurrentUser();
                NewDisbursement.UpdatedDateTime = SQLNow.Value;

                db.TrnDisbursements.InsertOnSubmit(NewDisbursement);
                db.SubmitChanges();

                return Get(NewDisbursement.Id);
            }
            catch
            {
                return new Models.TrnDisbursement();
            }
        }

        // ================================
        // PUT api/TrnDisbursement/5/Update
        // ================================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnDisbursement value)
        {
            try
            {
                var Disbursements = from d in db.TrnDisbursements
                                    where d.Id == Id &&
                                          d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                if (Disbursements.Any())
                {
                    var UpdatedDisbursement = Disbursements.FirstOrDefault();
                    SqlDateTime SQLCVDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.CVDate).Year, +
                                                                         Convert.ToDateTime(value.CVDate).Month, +
                                                                         Convert.ToDateTime(value.CVDate).Day));
                    SqlDateTime SQLCheckDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.CheckDate).Year, +
                                                                         Convert.ToDateTime(value.CheckDate).Month, +
                                                                         Convert.ToDateTime(value.CheckDate).Day));
                    SqlDateTime SQLDateCleared = new SqlDateTime(new DateTime(Convert.ToDateTime(value.DateCleared).Year, +
                                                                            Convert.ToDateTime(value.DateCleared).Month, +
                                                                            Convert.ToDateTime(value.DateCleared).Day));
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedDisbursement.CVManualNumber = value.CVManualNumber;
                    UpdatedDisbursement.CVDate = SQLCVDate.Value;
                    UpdatedDisbursement.Particulars = value.Particulars;
                    UpdatedDisbursement.SupplierId = value.SupplierId;
                    UpdatedDisbursement.BankId = value.BankId;
                    UpdatedDisbursement.PayTypeId = value.PayTypeId;
                    UpdatedDisbursement.CheckNumber = value.CheckNumber;
                    UpdatedDisbursement.CheckDate = SQLCheckDate.Value;
                    UpdatedDisbursement.CheckPayee = value.CheckPayee;
                    UpdatedDisbursement.TotalAmount = value.TotalAmount;
                    UpdatedDisbursement.IsCleared = true;
                    UpdatedDisbursement.DateCleared = SQLDateCleared.Value;
                    UpdatedDisbursement.IsPrinted = true;
                    UpdatedDisbursement.PreparedById = Convert.ToInt16(value.PreparedById);
                    UpdatedDisbursement.CheckedById = Convert.ToInt16(value.CheckedById);
                    UpdatedDisbursement.ApprovedById = Convert.ToInt16(value.ApprovedById);
                    UpdatedDisbursement.IsLocked = false;
                    UpdatedDisbursement.UpdatedById = secure.GetCurrentUser();
                    UpdatedDisbursement.UpdatedDateTime = SQLNow.Value;

                    db.SubmitChanges();

                    // Journal entry
                    journal.JournalizedCV(Id);
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

        // ==================================
        // PUT api/TrnDisbursement/5/Approval
        // ==================================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var Disbursements = from d in db.TrnDisbursements
                                    where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                if (Disbursements.Any())
                {
                    var UpdatedDisbursement = Disbursements.FirstOrDefault();

                    UpdatedDisbursement.IsLocked = Approval;

                    db.SubmitChanges();

                    UpdateAP(Id);

                    journal.JournalizedCV(Id);

                    bank.BankRecordCV(Id);
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

        // ============================
        // DELETE api/TrnDisbursement/5
        // ============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnDisbursement DeleteDisbursement = db.TrnDisbursements.Where(d => d.Id == Id &&
                                                                                     d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeleteDisbursement != null)
            {
                if (DeleteDisbursement.IsLocked == false)
                {
                    db.TrnDisbursements.DeleteOnSubmit(DeleteDisbursement);
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