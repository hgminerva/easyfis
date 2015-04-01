using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnDisbursementLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();

        private void UpdateHeaderTotalAmount(Int64 CVId)
        {
            var Disbursements = from d in db.TrnDisbursements where d.Id == CVId select d;
            if (Disbursements.Any())
            {
                var UpdatedDisbursement = Disbursements.First();
                UpdatedDisbursement.TotalAmount = UpdatedDisbursement.TrnDisbursementLines.Count() > 0 ?
                                                  UpdatedDisbursement.TrnDisbursementLines.Sum(a => a.Amount) : 0;
                db.SubmitChanges();
            }
        }
        
        // ==============================================
        // GET api/TrnDisbursementLine/5/DisbursementLine
        // ==============================================

        [HttpGet]
        [ActionName("DisbursementLine")]
        public Models.TrnDisbursementLine Get(Int64 Id)
        {
            var DisbursementLines = from d in db.TrnDisbursementLines
                                    where d.Id == Id &&
                                          d.TrnDisbursement.MstBranch.MstCompany.UserId == secure.GetCurrentSubscriberUser()
                                    select new Models.TrnDisbursementLine
                                       {
                                           LineId = d.Id,
                                           LineCVId = d.CVId,
                                           LineAccountId = d.AccountId,
                                           LineAccount = d.MstAccount.MstAccountType.AccountType + " - " + d.MstAccount.Account,
                                           LinePIId = d.PIId == null ? 0 : d.PIId.Value,
                                           LinePINumber = d.PIId == null ? "" : d.TrnPurchaseInvoice.PINumber,
                                           LineParticulars = d.Particulars,
                                           LineAmount = d.Amount,
                                           LineBranchId = d.BranchId,
                                           LineBranch = d.MstBranch.Branch
                                       };

            if (DisbursementLines.Any())
            {
                return DisbursementLines.First();
            }
            else
            {
                return new Models.TrnDisbursementLine();
            }
        }

        // ============================
        // POST api/TrnDisbursementLine
        // ============================

        [HttpPost]
        public Models.TrnDisbursementLine Post(Models.TrnDisbursementLine value)
        {
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (secure.GetCurrentUser() > 0)
            {
                Data.TrnDisbursementLine NewDisbursementLine = new Data.TrnDisbursementLine();

                NewDisbursementLine.CVId = value.LineCVId;
                NewDisbursementLine.AccountId = value.LineAccountId;
                if (value.LinePIId > 0) NewDisbursementLine.PIId = value.LinePIId;
                NewDisbursementLine.Particulars = value.LineParticulars;
                NewDisbursementLine.Amount = value.LineAmount;
                NewDisbursementLine.BranchId = value.LineBranchId;

                db.TrnDisbursementLines.InsertOnSubmit(NewDisbursementLine);
                db.SubmitChanges();

                UpdateHeaderTotalAmount(value.LineCVId);

                //UpdateAP(value.LineCVId);

                //journal.JournalizedCV(value.LineCVId);

                return value;
            }
            else
            {
                return new Models.TrnDisbursementLine();
            }
        }

        // =============================
        // PUT api/TrnDisbursementLine/5
        // =============================
        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.TrnDisbursementLine value)
        {
            try
            {
                var DisbursementLines = from d in db.TrnDisbursementLines
                                          where d.Id == Id &&
                                                d.TrnDisbursement.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                          select d;

                if (DisbursementLines.Any())
                {
                    var UpdatedDisbursementLine = DisbursementLines.FirstOrDefault();

                    UpdatedDisbursementLine.AccountId = value.LineAccountId;
                    if (value.LineCVId > 0) UpdatedDisbursementLine.CVId = value.LineCVId;
                    if (value.LinePIId > 0) UpdatedDisbursementLine.PIId = value.LinePIId;
                    UpdatedDisbursementLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    UpdatedDisbursementLine.Amount = value.LineAmount;
                    UpdatedDisbursementLine.BranchId = value.LineBranchId;
                    
                    db.SubmitChanges();

                    UpdateHeaderTotalAmount(value.LineCVId);
                    
                    // UpdateAP(value.LineCVId);
                    
                    // journal.JournalizedCV(value.LineCVId);

                    return Request.CreateResponse(HttpStatusCode.OK);
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
            }
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // ================================
        // DELETE api/TrnDisbursementLine/5
        // ================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnDisbursementLine DeleteLine = db.TrnDisbursementLines.Where(d => d.Id == Id &&
                                                                                     d.TrnDisbursement.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnDisbursementLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    // Delete
                    db.SubmitChanges();

                    UpdateHeaderTotalAmount(DeleteLine.CVId);
                    
                    // UpdateAP(DeleteLine.CVId);
                    
                    // journal.JournalizedCV(DeleteLine.CVId);

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

    }
}