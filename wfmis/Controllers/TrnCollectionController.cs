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
    public class TrnCollectionController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Bank bank = new Business.Bank();

        private void UpdateAR(Int64 ORId)
        {
            var CollectionLines = from d in db.TrnCollectionLines
                                  where d.ORId == ORId && d.SIId > 0
                                  select d;
            if (CollectionLines.Any())
            {
                foreach (var Line in CollectionLines)
                {
                    var SalesInvoices = from d in db.TrnSalesInvoices
                                        where d.Id == Line.SIId
                                        select d;
                    if (SalesInvoices.Any())
                    {
                        var UpdatedSalesInvoice = SalesInvoices.First();
                        UpdatedSalesInvoice.TotalCollectedAmount = UpdatedSalesInvoice.TrnCollectionLines.Where(d => d.TrnCollection.IsLocked == true).Sum(a => a.Amount);
                        UpdatedSalesInvoice.TotalDebitAmount = UpdatedSalesInvoice.TrnJournalVoucherLines.Where(d => d.TrnJournalVoucher.IsLocked == true).Sum(a => a.DebitAmount);
                        UpdatedSalesInvoice.TotalCreditAmount = UpdatedSalesInvoice.TrnJournalVoucherLines.Where(d => d.TrnJournalVoucher.IsLocked == true).Sum(a => a.CreditAmount);
                        db.SubmitChanges();
                    }
                }
            }
        }

        // =====================
        // GET api/TrnCollection
        // =====================

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

            var Count = db.TrnCollections.Where(d => d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                                     d.MstBranch.Id == BranchId).Count();

            var Collections = from d in db.TrnCollections
                                where d.MstBranch.Id == BranchId &&
                                      d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                              select new Models.TrnCollection
                                {
                                    Id = d.Id,
                                    PeriodId = d.PeriodId,
                                    Period = d.MstPeriod.Period,
                                    BranchId = d.BranchId,
                                    Branch = d.MstBranch.Branch,
                                    ORNumber = d.ORNumber,
                                    ORManualNumber = d.ORManualNumber,
                                    ORDate = Convert.ToString(d.ORDate.Year) + "-" + Convert.ToString(d.ORDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.ORDate.Day + 100).Substring(1, 2),
                                    CustomerId = d.CustomerId,
                                    Customer = d.MstArticle.Article,
                                    Particulars = d.Particulars,
                                    TotalAmount = d.TotalAmount,
                                    PreparedById = d.MstUser.Id,
                                    CheckedById = d.MstUser1.Id,
                                    ApprovedById = d.MstUser2.Id,
                                    PreparedBy = d.MstUser.FullName,
                                    CheckedBy = d.MstUser1.FullName,
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
                    if (sSortDir == "asc") Collections = Collections.OrderBy(d => d.ORDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Collections = Collections.OrderByDescending(d => d.ORDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Collections = Collections.OrderBy(d => d.ORNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Collections = Collections.OrderByDescending(d => d.ORNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Collections = Collections.OrderBy(d => d.Customer).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Collections = Collections.OrderByDescending(d => d.Customer).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 5:
                    if (sSortDir == "asc") Collections = Collections.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Collections = Collections.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 6:
                    if (sSortDir == "asc") Collections = Collections.OrderBy(d => d.TotalAmount).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Collections = Collections.OrderByDescending(d => d.TotalAmount).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Collections = Collections.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var CollectionPaged = new Models.SysDataTablePager();

            CollectionPaged.sEcho = sEcho;
            CollectionPaged.iTotalRecords = Count;
            CollectionPaged.iTotalDisplayRecords = Count;
            CollectionPaged.TrnCollectionData = Collections.ToList();

            return CollectionPaged;
        }

        // ==================================
        // GET api/TrnCollection/5/Collection
        // ==================================

        [HttpGet]
        [ActionName("Collection")]
        public Models.TrnCollection Get(Int64 Id)
        {
            var Collections = from d in db.TrnCollections
                                where d.Id == Id &&
                                      d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                                select new Models.TrnCollection
                                {
                                    Id = d.Id,
                                    PeriodId = d.PeriodId,
                                    Period = d.MstPeriod.Period,
                                    BranchId = d.BranchId,
                                    Branch = d.MstBranch.Branch,
                                    ORNumber = d.ORNumber,
                                    ORManualNumber = d.ORManualNumber,
                                    ORDate = Convert.ToString(d.ORDate.Month) + "/" + Convert.ToString(d.ORDate.Day) + "/" + Convert.ToString(d.ORDate.Year),
                                    CustomerId = d.CustomerId,
                                    Customer = d.MstArticle.Article,
                                    Particulars = d.Particulars,
                                    TotalAmount = d.TrnCollectionLines.Count() > 0 ? d.TrnCollectionLines.Sum(l => l.Amount) : 0,
                                    PreparedById = d.MstUser.Id,
                                    CheckedById = d.MstUser1.Id,
                                    ApprovedById = d.MstUser2.Id,
                                    PreparedBy = d.MstUser.FullName,
                                    CheckedBy = d.MstUser1.FullName,
                                    ApprovedBy = d.MstUser2.FullName,
                                    IsLocked = d.IsLocked,
                                    CreatedById = d.CreatedById,
                                    CreatedBy = d.MstUser3.FullName,
                                    CreatedDateTime = Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                    UpdatedById = d.UpdatedById,
                                    UpdatedBy = d.MstUser4.FullName,
                                    UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                                };

            if (Collections.Any())
            {
                return Collections.First();
            }
            else
            {
                return new Models.TrnCollection();
            }
        }

        // =======================================
        // GET api/TrnCollection/5/CollectionLines
        // =======================================    

        [HttpGet]
        [ActionName("CollectionLines")]
        public Models.SysDataTablePager CollectionLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnCollectionLines.Where(d => d.TrnCollection.Id == Id).Count();

            var CollectionsLines = (from d in db.TrnCollectionLines
                                     where d.TrnCollection.Id == Id &&
                                           d.TrnCollection.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                                     select new Models.TrnCollectionLine
                                     {
                                         LineId = d.Id,
                                         LineORId = d.ORId,
                                         LineAccountId = d.AccountId,
                                         LineAccount = d.MstAccount.MstAccountType.AccountType + " - " + d.MstAccount.Account,
                                         LineSIId = d.SIId.Value,
                                         LineSINumber = d.SIId == null ? "NA" : d.TrnSalesInvoice.SINumber,
                                         LineParticulars = d.Particulars,
                                         LineAmount = d.Amount,
                                         LinePayTypeId = d.PayTypeId,
                                         LinePayType = d.MstPayType.PayType,
                                         LineCheckNumber = d.CheckNumber == null ? "" : d.CheckNumber,
                                         LineCheckDate = d.CheckDate == null ? "" : Convert.ToString(d.CheckDate.Month) + "/" + Convert.ToString(d.CheckDate.Day) + "/" + Convert.ToString(d.CheckDate.Year),
                                         LineCheckBank = d.CheckNumber == null ? "" : d.CheckNumber,
                                         LineBankId = d.BankId == null ? 0 : d.BankId.Value,
                                         LineBank = d.BankId == null ? "" : d.MstArticle.Article
                                     });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") CollectionsLines = CollectionsLines.OrderBy(d => d.LineSIId).Skip(iDisplayStart).Take(10);
                    else CollectionsLines = CollectionsLines.OrderByDescending(d => d.LineSIId).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") CollectionsLines = CollectionsLines.OrderBy(d => d.LineParticulars).Skip(iDisplayStart).Take(10);
                    else CollectionsLines = CollectionsLines.OrderByDescending(d => d.LineParticulars).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    CollectionsLines = CollectionsLines.Skip(iDisplayStart).Take(10);
                    break;
            }

            var CollectionLinePaged = new Models.SysDataTablePager();

            CollectionLinePaged.sEcho = sEcho;
            CollectionLinePaged.iTotalRecords = Count;
            CollectionLinePaged.iTotalDisplayRecords = Count;
            CollectionLinePaged.TrnCollectionLineData = CollectionsLines.ToList();

            return CollectionLinePaged;
        }

        // ======================
        // POST api/TrnCollection
        // ======================

        [HttpPost]
        public Models.TrnCollection Post(Models.TrnCollection value)
        {
            try
            {
                // Add new collection
                Data.TrnCollection NewCollection = new Data.TrnCollection();
                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLORDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.ORDate).Year, +
                                                                     Convert.ToDateTime(value.ORDate).Month, +
                                                                     Convert.ToDateTime(value.ORDate).Day));
                var Collections = from d in db.TrnCollections
                                  where d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                        d.MstPeriod.Id == PeriodId &&
                                        d.MstBranch.Id == BranchId
                                  select d;

                if (Collections != null)
                {
                    var MaxORNumber = Convert.ToDouble(Collections.Max(n => n.ORNumber)) + 10000000001;
                    NewCollection.ORNumber = MaxORNumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewCollection.ORNumber = "0000000001";
                }
                NewCollection.PeriodId = PeriodId;
                NewCollection.BranchId = BranchId;
                NewCollection.ORManualNumber = value.ORManualNumber;
                NewCollection.ORDate = SQLORDate.Value;
                NewCollection.CustomerId = value.CustomerId;
                NewCollection.Particulars = value.Particulars;
                NewCollection.TotalAmount = 0;
                NewCollection.PreparedById = value.PreparedById;
                NewCollection.CheckedById = value.CheckedById;
                NewCollection.ApprovedById = value.ApprovedById;
                NewCollection.IsLocked = false;
                NewCollection.CreatedById = secure.GetCurrentUser();
                NewCollection.CreatedDateTime = SQLNow.Value;
                NewCollection.UpdatedById = secure.GetCurrentUser();
                NewCollection.UpdatedDateTime = SQLNow.Value;

                db.TrnCollections.InsertOnSubmit(NewCollection);
                db.SubmitChanges();

                // Journalized collection
                journal.JournalizedOR(value.Id);

                return Get(NewCollection.Id);
            }
            catch
            {
                return new Models.TrnCollection();
            }
        }

        // ==============================
        // PUT api/TrnCollection/5/Update
        // ==============================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnCollection value)
        {
            try
            {
                var Collections = from d in db.TrnCollections
                                  where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                  select d;

                if (Collections.Any())
                {
                    var UpdatedCollection = Collections.FirstOrDefault();
                    SqlDateTime SQLORDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.ORDate).Year, +
                                                                         Convert.ToDateTime(value.ORDate).Month, +
                                                                         Convert.ToDateTime(value.ORDate).Day));
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedCollection.ORManualNumber = value.ORManualNumber;
                    UpdatedCollection.ORDate = SQLORDate.Value;
                    UpdatedCollection.CustomerId = value.CustomerId;
                    UpdatedCollection.Particulars = value.Particulars;
                    UpdatedCollection.TotalAmount = UpdatedCollection.TrnCollectionLines.Count() > 0 ?
                                                    UpdatedCollection.TrnCollectionLines.Sum(a => a.Amount) : 0;
                    UpdatedCollection.PreparedById = value.PreparedById;
                    UpdatedCollection.CheckedById = value.CheckedById;
                    UpdatedCollection.ApprovedById = value.ApprovedById;
                    UpdatedCollection.IsLocked = false;
                    UpdatedCollection.UpdatedById = secure.GetCurrentUser();
                    UpdatedCollection.UpdatedDateTime = SQLNow.Value;

                    db.SubmitChanges();

                    // Journalized
                    journal.JournalizedOR(value.Id);
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

        // ================================
        // PUT api/TrnCollection/5/Approval
        // ================================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var Collections = from d in db.TrnCollections
                                  where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                  select d;

                if (Collections.Any())
                {
                    var UpdatedCollection = Collections.FirstOrDefault();

                    UpdatedCollection.IsLocked = Approval;

                    db.SubmitChanges();

                    UpdateAR(Id);

                    journal.JournalizedOR(Id);

                    bank.BankRecordOR(Id);
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
        // DELETE api/TrnCollection/5
        // ==========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnCollection DeleteCollection = db.TrnCollections.Where(d => d.Id == Id && 
                                                                               d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteCollection != null)
            {
                if (DeleteCollection.IsLocked == false)
                {
                    db.TrnCollections.DeleteOnSubmit(DeleteCollection);
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