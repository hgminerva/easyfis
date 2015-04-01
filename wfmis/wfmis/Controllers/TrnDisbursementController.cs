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

        private Business.JournalEntry J = new Business.JournalEntry();

        // =======================
        // GET api/TrnDisbursement
        // =======================

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

            var Count = db.TrnDisbursements.Where(d => d.MstUser.Id == secure.GetCurrentUser() && 
                                                       d.MstBranch.Id == BranchId).Count();

            var Disbursements = from d in db.TrnDisbursements
                                   where d.MstBranch.Id == BranchId &&
                                         d.MstBranch.MstUser.Id == secure.GetCurrentUser()
                                   select new Models.TrnDisbursement
                                   {
                                        Id = d.Id,
                                        PeriodId = d.PeriodId,
                                        Period = d.MstPeriod.Period,
                                        BranchId = d.BranchId,
                                        Branch = d.MstBranch.Branch,
                                        CVNumber = d.CVNumber,
                                        CVManualNumber = d.CVManualNumber,
                                        CVDate = "",
                                        Particulars = d.Particulars,
                                        SupplierId = d.SupplierId,
                                        Supplier = d.MstArticle.Article,
                                        BankId = d.BankId,
                                        Bank = d.MstArticle1.Article,
                                        PayTypeId = d.PayTypeId,
                                        PayType = d.MstPayType.PayType,
                                        CheckNumber = d.CheckNumber,
                                        CheckDate = "",
                                        CheckPayee = d.CheckPayee,
                                        TotalAmount = d.TotalAmount,
                                        IsCleared = d.IsCleared,
                                        DateCleared = "",
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
                                        CreatedDateTime = "",
                                        UpdatedById = d.UpdatedById,
                                        UpdatedBy = d.MstUser4.FullName,
                                        UpdatedDateTime = ""
                                   };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Disbursements = Disbursements.OrderBy(d => d.CVDate).Skip(iDisplayStart).Take(10);
                    else Disbursements = Disbursements.OrderByDescending(d => d.CVNumber).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") Disbursements = Disbursements.OrderBy(d => d.CVNumber).Skip(iDisplayStart).Take(10);
                    else Disbursements = Disbursements.OrderByDescending(d => d.CVDate).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") Disbursements = Disbursements.OrderBy(d => d.Supplier).Skip(iDisplayStart).Take(10);
                    else Disbursements = Disbursements.OrderByDescending(d => d.Supplier).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    Disbursements = Disbursements.Skip(iDisplayStart).Take(10);
                    break;
            }

            var DisbursementPaged = new Models.SysDataTablePager();

            DisbursementPaged.sEcho = sEcho;
            DisbursementPaged.iTotalRecords = Count;
            DisbursementPaged.iTotalDisplayRecords = Count;
            DisbursementPaged.TrnDisbursementData = Disbursements.ToList();

            return DisbursementPaged;
        }

        // ========================
        // POST api/TrnDisbursement
        // ========================

        [HttpPost]
        public Models.TrnDisbursement Post(Models.TrnDisbursement value)
        {
            try
            {
                Data.wfmisDataContext newData = new Data.wfmisDataContext();

                Data.TrnDisbursement NewDisbursement = new Data.TrnDisbursement();

                var UserId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId);
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

                var Disbursement = from d in db.TrnDisbursements
                                   where d.MstUser.Id == UserId &&
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
                NewDisbursement.IsLocked = true;
                NewDisbursement.CreatedById = value.CreatedById;
                NewDisbursement.CreatedDateTime = SQLNow.Value;
                NewDisbursement.UpdatedById = value.UpdatedById;
                NewDisbursement.UpdatedDateTime = SQLNow.Value;

                newData.TrnDisbursements.InsertOnSubmit(NewDisbursement);
                newData.SubmitChanges();

                var SavedDisbursement = from d in db.TrnDisbursements
                                        where d.CVNumber.Equals(NewDisbursement.CVNumber) &&
                                              d.MstUser.Id == UserId &&
                                              d.MstPeriod.Id == PeriodId &&
                                              d.MstBranch.Id == BranchId
                                        select new Models.TrnDisbursement
                                        {
                                            Id = d.Id,
                                            PeriodId = d.PeriodId,
                                            Period = d.MstPeriod.Period,
                                            BranchId = d.BranchId,
                                            Branch = d.MstBranch.Branch,
                                            CVNumber = d.CVNumber,
                                            CVManualNumber = d.CVManualNumber,
                                            CVDate = d.CVDate.ToShortDateString(),
                                            Particulars = d.Particulars,
                                            SupplierId = d.SupplierId,
                                            Supplier = d.MstArticle.Article,
                                            BankId = d.BankId,
                                            Bank = d.MstArticle1.Article,
                                            PayTypeId = d.PayTypeId,
                                            PayType = d.MstPayType.PayType,
                                            CheckNumber = d.CheckNumber,
                                            CheckDate = d.CheckDate.ToShortDateString(),
                                            CheckPayee = d.CheckPayee,
                                            TotalAmount = d.TotalAmount,
                                            IsCleared = d.IsCleared,
                                            DateCleared = d.DateCleared.ToShortDateString(),
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
                                            CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                            UpdatedById = d.UpdatedById,
                                            UpdatedBy = d.MstUser4.FullName,
                                            UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                                        };

                if (SavedDisbursement.Any())
                {
                    return SavedDisbursement.First();
                }
                else
                {
                    return new Models.TrnDisbursement();
                }
            }
            catch
            {
                return new Models.TrnDisbursement();
            }
        }

    
    }
}