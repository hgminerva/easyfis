using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.SqlTypes;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnPurchaseInvoiceController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();
        private Business.Inventory inventory = new Business.Inventory();

        // ==========================
        // GET api/TrnPurchaseInvoice
        // ==========================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            int NumberOfRecords = 20;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var Count = db.TrnPurchaseInvoices.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                          d.BranchId == BranchId).Count();

            var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                   where d.BranchId == BranchId &&
                                         d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                      select new Models.TrnPurchaseInvoice
                                      {
                                          Id = d.Id,
                                          PeriodId = d.PeriodId,
                                          Period = d.MstPeriod.Period,
                                          BranchId = d.BranchId,
                                          Branch = d.MstBranch.Branch,
                                          PINumber = d.PINumber,
                                          PIManualNumber = d.PIManualNumber,
                                          PIDate = Convert.ToString(d.PIDate.Year) + "-" + Convert.ToString(d.PIDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.PIDate.Day + 100).Substring(1, 2),
                                          SupplierId = d.SupplierId,
                                          Supplier = d.MstArticle.Article,
                                          TermId = d.TermId,
                                          Term = d.MstTerm.Term,
                                          DocumentReference = d.DocumentReference,
                                          Particulars = d.Particulars,
                                          TotalAmount = d.TotalAmount,
                                          TotalPaidAmount = d.TotalPaidAmount,
                                          TotalCreditAmount = d.TotalCreditAmount,
                                          TotalDebitAmount = d.TotalDebitAmount,
                                          PreparedById = d.MstUser.Id,
                                          CheckedById = d.MstUser1.Id,
                                          ApprovedById = d.MstUser2.Id,
                                          PreparedBy = d.MstUser.FullName,
                                          CheckedBy = d.MstUser1.FullName,
                                          ApprovedBy = d.MstUser2.FullName,
                                          IsLocked = d.IsLocked,
                                          CreatedById = d.CreatedById,
                                          CreatedBy = d.MstUser3.FullName,
                                          CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                          UpdatedById = d.UpdatedById,
                                          UpdatedBy = d.MstUser4.FullName,
                                          UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                                      };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") PurchaseInvoices = PurchaseInvoices.OrderBy(d => d.PINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoices = PurchaseInvoices.OrderByDescending(d => d.PINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") PurchaseInvoices = PurchaseInvoices.OrderBy(d => d.PIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoices = PurchaseInvoices.OrderByDescending(d => d.PIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") PurchaseInvoices = PurchaseInvoices.OrderBy(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoices = PurchaseInvoices.OrderByDescending(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    PurchaseInvoices = PurchaseInvoices.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var PurchaseInvoicePaged = new Models.SysDataTablePager();

            PurchaseInvoicePaged.sEcho = sEcho;
            PurchaseInvoicePaged.iTotalRecords = Count;
            PurchaseInvoicePaged.iTotalDisplayRecords = Count;
            PurchaseInvoicePaged.TrnPurchaseInvoiceData = PurchaseInvoices.ToList();

            return PurchaseInvoicePaged;
        }

        // ============================================
        // GET api/TrnPurchaseInvoice/5/PurchaseInvoice
        // ============================================

        [HttpGet]
        [ActionName("PurchaseInvoice")]
        public Models.TrnPurchaseInvoice Get(Int64 Id)
        {
            var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                   where d.Id == Id &&
                                         d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                   select new Models.TrnPurchaseInvoice
                                   {
                                       Id = d.Id,
                                       PeriodId = d.PeriodId,
                                       Period = d.MstPeriod.Period,
                                       BranchId = d.BranchId,
                                       Branch = d.MstBranch.Branch,
                                       PINumber = d.PINumber,
                                       PIManualNumber = d.PIManualNumber,
                                       PIDate = d.PIDate.ToShortDateString(),
                                       SupplierId = d.SupplierId,
                                       Supplier = d.MstArticle.Article,
                                       TermId = d.TermId,
                                       Term = d.MstTerm.Term,
                                       DocumentReference = d.DocumentReference,
                                       Particulars = d.Particulars,
                                       TotalAmount = d.TrnPurchaseInvoiceLines.Count() > 0 ? d.TrnPurchaseInvoiceLines.Sum(l => l.Amount) : 0,
                                       TotalPaidAmount = d.TotalPaidAmount,
                                       TotalCreditAmount = d.TotalCreditAmount,
                                       TotalDebitAmount = d.TotalDebitAmount,
                                       PreparedById = d.MstUser.Id,
                                       CheckedById = d.MstUser1.Id,
                                       ApprovedById = d.MstUser2.Id,
                                       PreparedBy = d.MstUser.FullName,
                                       CheckedBy = d.MstUser1.FullName,
                                       ApprovedBy = d.MstUser2.FullName,
                                       IsLocked = d.IsLocked,
                                       CreatedById = d.CreatedById,
                                       CreatedBy = d.MstUser3.FullName,
                                       CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                       UpdatedById = d.UpdatedById,
                                       UpdatedBy = d.MstUser4.FullName,
                                       UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                                    };

            if (PurchaseInvoices.Any())
            {
                return PurchaseInvoices.First();
            }
            else
            {
                return new Models.TrnPurchaseInvoice();
            }
        }

        // =====================================================
        // GET api/TrnPurchaseInvoice/5/SupplierPurchaseInvoices
        // =====================================================

        [HttpGet]
        [ActionName("SupplierPurchaseInvoices")]
        public Models.SysDataTablePager SupplierPurchaseInvoices(Int64 Id)
        {
            int NumberOfRecords = 20;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnPurchaseInvoices.Where(d => d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                                          d.SupplierId == Id).Count();

            var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                   where d.SupplierId == Id &&
                                         d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                   select new Models.TrnPurchaseInvoice
                                   {
                                       Id = d.Id,
                                       PeriodId = d.PeriodId,
                                       Period = d.MstPeriod.Period,
                                       BranchId = d.BranchId,
                                       Branch = d.MstBranch.Branch,
                                       PINumber = d.PINumber,
                                       PIManualNumber = d.PIManualNumber,
                                       PIDate = Convert.ToString(d.PIDate.Year) + "-" + Convert.ToString(d.PIDate.Month + 100).Substring(1, 2) + "-" + Convert.ToString(d.PIDate.Day + 100).Substring(1, 2),
                                       SupplierId = d.SupplierId,
                                       Supplier = d.MstArticle.Article,
                                       TermId = d.TermId,
                                       Term = d.MstTerm.Term,
                                       DocumentReference = d.DocumentReference,
                                       Particulars = d.Particulars,
                                       TotalAmount = d.TotalAmount,
                                       TotalPaidAmount = d.TotalPaidAmount,
                                       TotalCreditAmount = d.TotalCreditAmount,
                                       TotalDebitAmount = d.TotalDebitAmount,
                                       PreparedById = d.MstUser.Id,
                                       CheckedById = d.MstUser1.Id,
                                       ApprovedById = d.MstUser2.Id,
                                       PreparedBy = d.MstUser.FullName,
                                       CheckedBy = d.MstUser1.FullName,
                                       ApprovedBy = d.MstUser2.FullName,
                                       IsLocked = d.IsLocked,
                                       CreatedById = d.CreatedById,
                                       CreatedBy = d.MstUser3.FullName,
                                       CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                       UpdatedById = d.UpdatedById,
                                       UpdatedBy = d.MstUser4.FullName,
                                       UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                                   };

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") PurchaseInvoices = PurchaseInvoices.OrderBy(d => d.PIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoices = PurchaseInvoices.OrderByDescending(d => d.PIDate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") PurchaseInvoices = PurchaseInvoices.OrderBy(d => d.PINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoices = PurchaseInvoices.OrderByDescending(d => d.PINumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 2:
                    if (sSortDir == "asc") PurchaseInvoices = PurchaseInvoices.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoices = PurchaseInvoices.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    PurchaseInvoices = PurchaseInvoices.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var PurchaseInvoicePaged = new Models.SysDataTablePager();

            PurchaseInvoicePaged.sEcho = sEcho;
            PurchaseInvoicePaged.iTotalRecords = Count;
            PurchaseInvoicePaged.iTotalDisplayRecords = Count;
            PurchaseInvoicePaged.TrnPurchaseInvoiceData = PurchaseInvoices.ToList();

            return PurchaseInvoicePaged;
        }

        // =================================================
        // GET api/TrnPurchaseInvoice/5/PurchaseInvoiceLines
        // =================================================        
        
        [HttpGet]
        [ActionName("PurchaseInvoiceLines")]
        public Models.SysDataTablePager PurchaseInvoiceLines(Int64 Id)
        {
            int NumberOfRecords = 20;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnPurchaseInvoiceLines.Where(d => d.TrnPurchaseInvoice.Id == Id).Count();

            var PurchaseInvoiceLines = (from d in db.TrnPurchaseInvoiceLines
                                        where d.TrnPurchaseInvoice.Id == Id &&
                                              d.TrnPurchaseInvoice.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                        select new Models.TrnPurchaseInvoiceLine
                                        {
                                           LineId = d.Id,
                                           LinePIId = d.PIId,
                                           LinePOId = d.POId == null? 0 : d.POId.Value,
                                           LinePONumber = d.POId.Value == 0 ? "NA" : d.TrnPurchaseOrder.PONumber,
                                           LineItemId = d.ItemId,
                                           LineItem = d.MstArticle.Article,
                                           LineParticulars = d.Particulars,
                                           LineUnitId = d.UnitId,
                                           LineUnit = d.MstUnit.Unit,
                                           LineCost = d.Cost,
                                           LineQuantity = d.Quantity,
                                           LineAmount = d.Amount,
                                           LineTaxId = d.TaxId,
                                           LineTax = d.MstTax.TaxCode,
                                           LineTaxRate = d.TaxRate,
                                           LineTaxAmount = d.TaxAmount
                                        });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") PurchaseInvoiceLines = PurchaseInvoiceLines.OrderBy(d => d.LineItem).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoiceLines = PurchaseInvoiceLines.OrderByDescending(d => d.LineItem).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") PurchaseInvoiceLines = PurchaseInvoiceLines.OrderBy(d => d.LineParticulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PurchaseInvoiceLines = PurchaseInvoiceLines.OrderByDescending(d => d.LineParticulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    PurchaseInvoiceLines = PurchaseInvoiceLines.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var PurchaseInvoiceLinePaged = new Models.SysDataTablePager();

            PurchaseInvoiceLinePaged.sEcho = sEcho;
            PurchaseInvoiceLinePaged.iTotalRecords = Count;
            PurchaseInvoiceLinePaged.iTotalDisplayRecords = Count;
            PurchaseInvoiceLinePaged.TrnPurchaseInvoiceLineData = PurchaseInvoiceLines.ToList();

            return PurchaseInvoiceLinePaged;
        }

        // ===========================
        // POST api/TrnPurchaseInvoice
        // ===========================

        [HttpPost]
        public Models.TrnPurchaseInvoice Post(Models.TrnPurchaseInvoice value)
        {
            try
            {
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.TrnPurchaseInvoice NewPurchaseInvoice = new Data.TrnPurchaseInvoice();

                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                SqlDateTime SQLPIDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.PIDate).Year, +
                                                                     Convert.ToDateTime(value.PIDate).Month, +
                                                                     Convert.ToDateTime(value.PIDate).Day));

                var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

                var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                       where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() && 
                                             d.BranchId == BranchId
                                       select d;
                if (PurchaseInvoices != null)
                {
                    var MaxPINumber = Convert.ToDouble(PurchaseInvoices.Max(pi => pi.PINumber)) + 10000000001;
                    NewPurchaseInvoice.PINumber = MaxPINumber.ToString().Trim().Substring(1);
                }
                else
                {
                    NewPurchaseInvoice.PINumber = "0000000001";
                }
                NewPurchaseInvoice.PeriodId = PeriodId;
                NewPurchaseInvoice.BranchId = BranchId;
                NewPurchaseInvoice.PIManualNumber = value.PIManualNumber;
                NewPurchaseInvoice.PIDate = SQLPIDate.Value;
                NewPurchaseInvoice.SupplierId = value.SupplierId;
                NewPurchaseInvoice.TermId = value.TermId;
                NewPurchaseInvoice.DocumentReference = value.DocumentReference;
                NewPurchaseInvoice.Particulars = value.Particulars;
                NewPurchaseInvoice.TotalAmount = 0;
                NewPurchaseInvoice.TotalPaidAmount = 0;
                NewPurchaseInvoice.TotalCreditAmount = 0;
                NewPurchaseInvoice.TotalDebitAmount = 0;
                NewPurchaseInvoice.PreparedById = value.PreparedById;
                NewPurchaseInvoice.CheckedById = value.CheckedById;
                NewPurchaseInvoice.ApprovedById = value.ApprovedById;
                NewPurchaseInvoice.IsLocked = false;
                NewPurchaseInvoice.CreatedById = secure.GetCurrentUser();
                NewPurchaseInvoice.CreatedDateTime = SQLNow.Value;
                NewPurchaseInvoice.UpdatedById = secure.GetCurrentUser();
                NewPurchaseInvoice.UpdatedDateTime = SQLNow.Value;

                newData.TrnPurchaseInvoices.InsertOnSubmit(NewPurchaseInvoice);
                newData.SubmitChanges();

                return Get(NewPurchaseInvoice.Id);
            }
            catch
            {
                return new Models.TrnPurchaseInvoice();
            }
        }

        // ===================================
        // PUT api/TrnPurchaseInvoice/5/Update
        // ===================================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnPurchaseInvoice value)
        {
            try
            {
                var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                       where d.Id == Id  &&
                                             d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                       select d;

                if (PurchaseInvoices.Any())
                {
                    var UpdatedPurchaseInvoice = PurchaseInvoices.FirstOrDefault();
                    SqlDateTime SQLPIDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.PIDate).Year, +
                                                                         Convert.ToDateTime(value.PIDate).Month, +
                                                                         Convert.ToDateTime(value.PIDate).Day));
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedPurchaseInvoice.PIManualNumber = value.PIManualNumber;
                    UpdatedPurchaseInvoice.PIDate = SQLPIDate.Value;
                    UpdatedPurchaseInvoice.SupplierId = value.SupplierId;
                    UpdatedPurchaseInvoice.TermId = value.TermId;
                    UpdatedPurchaseInvoice.DocumentReference = value.DocumentReference;
                    UpdatedPurchaseInvoice.Particulars = value.Particulars;
                    UpdatedPurchaseInvoice.TotalAmount = UpdatedPurchaseInvoice.TrnPurchaseInvoiceLines.Count() > 0 ? 
                                                         UpdatedPurchaseInvoice.TrnPurchaseInvoiceLines.Sum(a => a.Amount) : 0;
                    UpdatedPurchaseInvoice.PreparedById = value.PreparedById;
                    UpdatedPurchaseInvoice.CheckedById = value.CheckedById;
                    UpdatedPurchaseInvoice.ApprovedById = value.ApprovedById;
                    UpdatedPurchaseInvoice.IsLocked = false;
                    UpdatedPurchaseInvoice.UpdatedById = secure.GetCurrentUser();
                    UpdatedPurchaseInvoice.UpdatedDateTime = SQLNow.Value;

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

        // ======================================
        // POST api/TrnPurchaseInvoice/5/Approval
        // ======================================

        [HttpPut]
        [ActionName("Approval")]
        public HttpResponseMessage Approval(Int64 Id)
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

                bool Approval = Convert.ToBoolean(nvc["Approval"]);

                var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                       where d.Id == Id && d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                       select d;

                if (PurchaseInvoices.Any())
                {
                    var UpdatedPurchaseInvoice = PurchaseInvoices.FirstOrDefault();

                    if (Approval == true)
                    {
                        UpdatedPurchaseInvoice.IsLocked = Approval;

                        db.SubmitChanges();

                        journal.JournalizedPI(Id);

                        inventory.CreateStockIn(Id);
                    }
                    else
                    {
                        if (UpdatedPurchaseInvoice.TrnStockIns.Count() == 0)
                        {
                            UpdatedPurchaseInvoice.IsLocked = Approval;

                            db.SubmitChanges();

                            journal.JournalizedPI(Id);                            
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

        // ===============================
        // DELETE api/TrnPurchaseInvoice/5
        // ===============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnPurchaseInvoice DeletePurchaseInvoice = db.TrnPurchaseInvoices.Where(d => d.Id == Id &&
                                                                                              d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeletePurchaseInvoice != null)
            {
                if (DeletePurchaseInvoice.IsLocked == false)
                {
                    db.TrnPurchaseInvoices.DeleteOnSubmit(DeletePurchaseInvoice);
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