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
    public class TrnSalesInvoiceController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Inventory inventory = new Business.Inventory();

        // =======================
        // GET api/TrnSalesInvoice
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

            var Count = db.TrnSalesInvoices.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                       d.BranchId == BranchId).Count();

            var SalesInvoices = from d in db.TrnSalesInvoices
                                where d.BranchId == BranchId &&
                                      d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select new Models.TrnSalesInvoice
                                   {
                                       Id = d.Id,
                                       PeriodId = d.PeriodId,
                                       Period = d.MstPeriod.Period,
                                       BranchId = d.BranchId,
                                       Branch = d.MstBranch.Branch,
                                       SINumber = d.SINumber,
                                       SIManualNumber = d.SIManualNumber,
                                       SIDate = Convert.ToString(d.SIDate.Year) + "-" + Convert.ToString(d.SIDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.SIDate.Day + 100).Substring(1, 2),
                                       CustomerId = d.CustomerId,
                                       Customer = d.MstArticle.Article,
                                       TermId = d.TermId,
                                       Term = d.MstTerm.Term,
                                       DocumentReference = d.DocumentReference,
                                       Particulars = d.Particulars,
                                       SoldById = d.SoldById,
                                       SoldBy = d.MstUser.FullName,
                                       TotalAmount = d.TotalAmount,
                                       TotalCollectedAmount = d.TotalCollectedAmount,
                                       TotalCreditAmount = d.TotalCreditAmount,
                                       TotalDebitAmount = d.TotalDebitAmount,
                                       PreparedById = d.MstUser1.Id,
                                       CheckedById = d.MstUser2.Id,
                                       ApprovedById = d.MstUser3.Id,
                                       PreparedBy = d.MstUser1.FullName,
                                       CheckedBy = d.MstUser2.FullName,
                                       ApprovedBy = d.MstUser3.FullName,
                                       IsLocked = d.IsLocked,
                                       CreatedById = d.CreatedById,
                                       CreatedBy = d.MstUser4.FullName,
                                       CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                       UpdatedById = d.UpdatedById,
                                       UpdatedBy = d.MstUser4.FullName,
                                       UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                                   };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") SalesInvoices = SalesInvoices.OrderBy(d => d.SINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else SalesInvoices = SalesInvoices.OrderByDescending(d => d.SINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") SalesInvoices = SalesInvoices.OrderBy(d => d.SIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else SalesInvoices = SalesInvoices.OrderByDescending(d => d.SIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") SalesInvoices = SalesInvoices.OrderBy(d => d.Customer).Skip(iDisplayStart).Take(NumberOfRecords);
                    else SalesInvoices = SalesInvoices.OrderByDescending(d => d.Customer).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    SalesInvoices = SalesInvoices.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var SalesInvoicePaged = new Models.SysDataTablePager();

            SalesInvoicePaged.sEcho = sEcho;
            SalesInvoicePaged.iTotalRecords = Count;
            SalesInvoicePaged.iTotalDisplayRecords = Count;
            SalesInvoicePaged.TrnSalesInvoiceData = SalesInvoices.ToList();

            return SalesInvoicePaged;
        }

        // ======================================
        // GET api/TrnSalesInvoice/5/SalesInvoice
        // ======================================

        [HttpGet]
        [ActionName("SalesInvoice")]
        public Models.TrnSalesInvoice Get(Int64 Id)
        {
            var SalesInvoices = from d in db.TrnSalesInvoices
                                where d.Id == Id &&
                                      d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select new Models.TrnSalesInvoice
                                {
                                       Id = d.Id,
                                       PeriodId = d.PeriodId,
                                       Period = d.MstPeriod.Period,
                                       BranchId = d.BranchId,
                                       Branch = d.MstBranch.Branch,
                                       SINumber = d.SINumber,
                                       SIManualNumber = d.SIManualNumber,
                                       SIDate = d.SIDate.ToShortDateString(),
                                       CustomerId = d.CustomerId,
                                       Customer = d.MstArticle.Article,
                                       TermId = d.TermId,
                                       Term = d.MstTerm.Term,
                                       DocumentReference = d.DocumentReference,
                                       Particulars = d.Particulars,
                                       SoldById = d.SoldById,
                                       SoldBy = d.MstUser.FullName,
                                       TotalAmount = d.TrnSalesInvoiceLines.Count() > 0 ? d.TrnSalesInvoiceLines.Sum(l => l.Amount) : 0,
                                       TotalCollectedAmount = d.TotalCollectedAmount,
                                       TotalCreditAmount = d.TotalCreditAmount,
                                       TotalDebitAmount = d.TotalDebitAmount,
                                       PreparedById = d.MstUser1.Id,
                                       CheckedById = d.MstUser2.Id,
                                       ApprovedById = d.MstUser3.Id,
                                       PreparedBy = d.MstUser1.FullName,
                                       CheckedBy = d.MstUser2.FullName,
                                       ApprovedBy = d.MstUser3.FullName,
                                       IsLocked = d.IsLocked,
                                       CreatedById = d.CreatedById,
                                       CreatedBy = d.MstUser4.FullName,
                                       CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                       UpdatedById = d.UpdatedById,
                                       UpdatedBy = d.MstUser5.FullName,
                                       UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                                   };

            if (SalesInvoices.Any())
            {
                return SalesInvoices.First();
            }
            else
            {
                return new Models.TrnSalesInvoice();
            }
        }

        // ===============================================
        // GET api/TrnSalesInvoice/5/CustomerSalesInvoices
        // ===============================================

        [HttpGet]
        [ActionName("CustomerSalesInvoices")]
        public Models.SysDataTablePager CustomerSalesInvoices(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnSalesInvoices.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                       d.CustomerId == Id).Count();

            var SalesInvoices = from d in db.TrnSalesInvoices
                                where d.CustomerId == Id &&
                                      d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                select new Models.TrnSalesInvoice
                                {
                                    Id = d.Id,
                                    PeriodId = d.PeriodId,
                                    Period = d.MstPeriod.Period,
                                    BranchId = d.BranchId,
                                    Branch = d.MstBranch.Branch,
                                    SINumber = d.SINumber,
                                    SIManualNumber = d.SIManualNumber,
                                    SIDate = Convert.ToString(d.SIDate.Year) + "-" + Convert.ToString(d.SIDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.SIDate.Day + 100).Substring(1, 2),
                                    CustomerId = d.CustomerId,
                                    Customer = d.MstArticle.Article,
                                    TermId = d.TermId,
                                    Term = d.MstTerm.Term,
                                    DocumentReference = d.DocumentReference,
                                    Particulars = d.Particulars,
                                    SoldById = d.SoldById,
                                    SoldBy = d.MstUser.FullName,
                                    TotalAmount = d.TotalAmount,
                                    TotalCollectedAmount = d.TotalCollectedAmount,
                                    TotalCreditAmount = d.TotalCreditAmount,
                                    TotalDebitAmount = d.TotalDebitAmount,
                                    PreparedById = d.MstUser1.Id,
                                    CheckedById = d.MstUser2.Id,
                                    ApprovedById = d.MstUser3.Id,
                                    PreparedBy = d.MstUser1.FullName,
                                    CheckedBy = d.MstUser2.FullName,
                                    ApprovedBy = d.MstUser3.FullName,
                                    IsLocked = d.IsLocked,
                                    CreatedById = d.CreatedById,
                                    CreatedBy = d.MstUser4.FullName,
                                    CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                    UpdatedById = d.UpdatedById,
                                    UpdatedBy = d.MstUser4.FullName,
                                    UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                                };

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") SalesInvoices = SalesInvoices.OrderBy(d => d.SINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else SalesInvoices = SalesInvoices.OrderByDescending(d => d.SINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") SalesInvoices = SalesInvoices.OrderBy(d => d.SIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else SalesInvoices = SalesInvoices.OrderByDescending(d => d.SIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 2:
                    if (sSortDir == "asc") SalesInvoices = SalesInvoices.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else SalesInvoices = SalesInvoices.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    SalesInvoices = SalesInvoices.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var SalesInvoicePaged = new Models.SysDataTablePager();

            SalesInvoicePaged.sEcho = sEcho;
            SalesInvoicePaged.iTotalRecords = Count;
            SalesInvoicePaged.iTotalDisplayRecords = Count;
            SalesInvoicePaged.TrnSalesInvoiceData = SalesInvoices.ToList();

            return SalesInvoicePaged;
        }

        // ===========================================
        // GET api/TrnSalesInvoice/5/SalesInvoiceLines
        // ===========================================     
        
        [HttpGet]
        [ActionName("SalesInvoiceLines")]
        public Models.SysDataTablePager SalesInvoiceLines(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnSalesInvoiceLines.Where(d => d.SIId == Id && 
                                                           d.TrnSalesInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var SalesInvoiceLines = (from d in db.TrnSalesInvoiceLines
                                     where d.SIId == Id &&
                                           d.TrnSalesInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                     select new Models.TrnSalesInvoiceLine
                                        {
                                            LineId = d.Id,
                                            LineSIId = d.SIId,
                                            LineSOId = d.SOId == null ? 0 : d.SOId.Value,
                                            LineSONumber = d.SOId == null ? "NA" : d.TrnSalesOrder.SONumber,
                                            LineItemId = d.ItemId,
                                            LineItem = d.MstArticle.Article,
                                            LineItemInventoryId = d.ItemInventoryId == null ? 0 : d.ItemInventoryId.Value,
                                            LineItemInventoryNumber = d.ItemInventoryId == null ? "NA" : d.MstArticleItemInventory.InventoryNumber,
                                            LineParticulars = d.Particulars,
                                            LineUnitId = d.UnitId,
                                            LineUnit = d.MstUnit.Unit,
                                            LinePriceId = d.PriceId,
                                            LinePriceDescription = d.MstArticleItemPrice.PriceDescription,
                                            LinePrice = d.Price,
                                            LineDiscountId = d.DiscountId == null ? 0 : d.DiscountId.Value,
                                            LineDiscount = d.MstDiscount.Discount,
                                            LineDiscountRate = d.DiscountRate,
                                            LineDiscountAmount = d.DiscountAmount,
                                            LineNetPrice = d.NetPrice,
                                            LineQuantity = d.Quantity,
                                            LineAmount = d.Amount,
                                            LineTaxId = d.TaxId,
                                            LineTax = d.MstTax.TaxCode,
                                            LineTaxRate = d.TaxRate,
                                            LineTaxAmount = d.TaxAmount,
                                            LineTaxAmountInclusive = d.TaxAmountInclusive
                                        });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") SalesInvoiceLines = SalesInvoiceLines.OrderBy(d => d.LineItem).Skip(iDisplayStart).Take(10);
                    else SalesInvoiceLines = SalesInvoiceLines.OrderByDescending(d => d.LineItem).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") SalesInvoiceLines = SalesInvoiceLines.OrderBy(d => d.LineParticulars).Skip(iDisplayStart).Take(10);
                    else SalesInvoiceLines = SalesInvoiceLines.OrderByDescending(d => d.LineParticulars).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    SalesInvoiceLines = SalesInvoiceLines.Skip(iDisplayStart).Take(10);
                    break;
            }

            var SalesInvoiceLinePaged = new Models.SysDataTablePager();

            SalesInvoiceLinePaged.sEcho = sEcho;
            SalesInvoiceLinePaged.iTotalRecords = Count;
            SalesInvoiceLinePaged.iTotalDisplayRecords = Count;
            SalesInvoiceLinePaged.TrnSalesInvoiceLineData = SalesInvoiceLines.ToList();

            return SalesInvoiceLinePaged;
        }

        // ========================
        // POST api/TrnSalesInvoice
        // ========================

        [HttpPost]
        public Models.TrnSalesInvoice Post(Models.TrnSalesInvoice value)
        {
            try
            {
                // Add new sales invoice
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.TrnSalesInvoice NewSalesInvoice = new Data.TrnSalesInvoice();

                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLSIDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.SIDate).Year, +
                                                                     Convert.ToDateTime(value.SIDate).Month, +
                                                                     Convert.ToDateTime(value.SIDate).Day));
                var SalesInvoices = from d in db.TrnSalesInvoices
                                    where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() && 
                                          d.BranchId == BranchId
                                    select d;

                if (SalesInvoices != null)
                {
                    var MaxSINumber = Convert.ToDouble(SalesInvoices.Max(n => n.SINumber)) + 10000000001;
                    NewSalesInvoice.SINumber = MaxSINumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewSalesInvoice.SINumber = "0000000001";
                }
                NewSalesInvoice.PeriodId = PeriodId;
                NewSalesInvoice.BranchId = BranchId;
                NewSalesInvoice.SIManualNumber = value.SIManualNumber;
                NewSalesInvoice.SIDate = SQLSIDate.Value;
                NewSalesInvoice.CustomerId = value.CustomerId;
                NewSalesInvoice.TermId = value.TermId;
                NewSalesInvoice.DocumentReference = value.DocumentReference;
                NewSalesInvoice.SoldById = value.SoldById;
                NewSalesInvoice.Particulars = value.Particulars;
                NewSalesInvoice.TotalAmount = 0;
                NewSalesInvoice.TotalCollectedAmount = 0;
                NewSalesInvoice.TotalCreditAmount = 0;
                NewSalesInvoice.TotalDebitAmount = 0;
                NewSalesInvoice.PreparedById = value.PreparedById;
                NewSalesInvoice.CheckedById = value.CheckedById;
                NewSalesInvoice.ApprovedById = value.ApprovedById;
                NewSalesInvoice.IsLocked = false;
                NewSalesInvoice.CreatedById = secure.GetCurrentUser();
                NewSalesInvoice.CreatedDateTime = SQLNow.Value;
                NewSalesInvoice.UpdatedById = secure.GetCurrentUser();
                NewSalesInvoice.UpdatedDateTime = SQLNow.Value;

                newData.TrnSalesInvoices.InsertOnSubmit(NewSalesInvoice);
                newData.SubmitChanges();

                // Journalized sales invoice
                journal.JournalizedSI(value.Id);

                return Get(NewSalesInvoice.Id);
            }
            catch
            {
                return new Models.TrnSalesInvoice();
            }
        }

        // ================================
        // PUT api/TrnSalesInvoice/5/Update
        // ================================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnSalesInvoice value)
        {
            try
            {
                var SalesInvoices = from d in db.TrnSalesInvoices
                                    where d.Id == Id &&
                                          d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                if (SalesInvoices.Any())
                {
                    var UpdatedSalesInvoice = SalesInvoices.FirstOrDefault();
                    SqlDateTime SQLSIDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.SIDate).Year, +
                                                                         Convert.ToDateTime(value.SIDate).Month, +
                                                                         Convert.ToDateTime(value.SIDate).Day));
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedSalesInvoice.SIManualNumber = value.SIManualNumber;
                    UpdatedSalesInvoice.SIDate = SQLSIDate.Value;
                    UpdatedSalesInvoice.CustomerId = value.CustomerId;
                    UpdatedSalesInvoice.TermId = value.TermId;
                    UpdatedSalesInvoice.DocumentReference = value.DocumentReference;
                    UpdatedSalesInvoice.Particulars = value.Particulars;
                    UpdatedSalesInvoice.SoldById = value.SoldById;
                    UpdatedSalesInvoice.TotalAmount = UpdatedSalesInvoice.TrnSalesInvoiceLines.Count() > 0 ?
                                                      UpdatedSalesInvoice.TrnSalesInvoiceLines.Sum(a => a.Amount) : 0;
                    UpdatedSalesInvoice.PreparedById = value.PreparedById;
                    UpdatedSalesInvoice.CheckedById = value.CheckedById;
                    UpdatedSalesInvoice.ApprovedById = value.ApprovedById;
                    UpdatedSalesInvoice.IsLocked = false;
                    UpdatedSalesInvoice.UpdatedById = secure.GetCurrentUser();
                    UpdatedSalesInvoice.UpdatedDateTime = SQLNow.Value;

                    db.SubmitChanges();

                    // Journalized
                    journal.JournalizedSI(value.Id);
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
        // POST api/TrnSalesInvoice/5/Approval
        // ===================================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var SalesInvoices = from d in db.TrnSalesInvoices
                                    where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                if (SalesInvoices.Any())
                {
                    var UpdatedSalesInvoice = SalesInvoices.FirstOrDefault();

                    if (Approval == true)
                    {
                        UpdatedSalesInvoice.IsLocked = Approval;

                        db.SubmitChanges();

                        journal.JournalizedSI(Id);

                        inventory.CreateStockOut(Id,false);
                    }
                    else
                    {
                        if (UpdatedSalesInvoice.TrnStockOuts.Count() == 0)
                        {
                            UpdatedSalesInvoice.IsLocked = Approval;

                            db.SubmitChanges();

                            journal.JournalizedSI(Id);
                        }
                        else
                        {
                            return Request.CreateResponse(HttpStatusCode.BadRequest);
                        }
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

        // ============================
        // DELETE api/TrnSalesInvoice/5
        // ============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnSalesInvoice DeleteSalesInvoice = db.TrnSalesInvoices.Where(d => d.Id == Id &&
                                                                                     d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteSalesInvoice != null)
            {
                if (DeleteSalesInvoice.IsLocked == false)
                {
                    db.TrnSalesInvoices.DeleteOnSubmit(DeleteSalesInvoice);
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