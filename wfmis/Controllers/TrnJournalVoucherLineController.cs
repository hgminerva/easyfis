using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnJournalVoucherLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ==================================================
        // GET api/TrnJournalVoucherLine/5/JournalVoucherLine
        // ==================================================

        [HttpGet]
        [ActionName("JournalVoucherLine")]
        public Models.TrnJournalVoucherLine Get(Int64 Id)
        {
            var JournalVoucherLines = from d in db.TrnJournalVoucherLines
                                      where d.Id == Id &&
                                            d.TrnJournalVoucher.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                      select new Models.TrnJournalVoucherLine
                                      {
                                          LineId = d.Id,
                                          LineJVId = d.JVId,
                                          LineBranchId = d.MstBranch.Id,
                                          LineBranch = d.MstBranch.Branch,
                                          LineAccountId = d.MstAccount.Id,
                                          LineAccount = d.MstAccount.Account,
                                          LineArticleId = (d.MstArticle == null) ? 0 : d.MstArticle.Id,
                                          LineArticle = (d.MstArticle == null) ? "" : d.MstArticle.Article,
                                          LineDebitAmount = d.DebitAmount,
                                          LineCreditAmount = d.CreditAmount,
                                          LineParticulars = d.Particulars,
                                          LinePIId = d.PIId == null ? 0 : d.PIId.Value,
                                          LinePINumber = d.PIId == null ? "" : d.TrnPurchaseInvoice.PINumber,
                                          LineSIId = d.SIId == null ? 0 : d.SIId.Value,
                                          LineSINumber = d.SIId == null ? "" : d.TrnSalesInvoice.SINumber
                                      };

            if (JournalVoucherLines.Any())
            {
                return JournalVoucherLines.First();
            }
            else
            {
                return new Models.TrnJournalVoucherLine();
            }
        }

        // ==============================
        // POST api/TrnJournalVoucherLine
        // ==============================

        [HttpPost]
        public Models.TrnJournalVoucherLine Post(Models.TrnJournalVoucherLine value)
        {
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    Data.TrnJournalVoucherLine NewJournalVoucherLine = new Data.TrnJournalVoucherLine();

                    NewJournalVoucherLine.JVId = value.LineJVId;
                    if (value.LineBranchId > 0) NewJournalVoucherLine.BranchId = value.LineBranchId;
                    if (value.LineAccountId > 0) NewJournalVoucherLine.AccountId = value.LineAccountId;
                    if (value.LineArticleId > 0) NewJournalVoucherLine.ArticleId = value.LineArticleId;
                    NewJournalVoucherLine.DebitAmount = value.LineDebitAmount;
                    NewJournalVoucherLine.CreditAmount = value.LineCreditAmount;
                    NewJournalVoucherLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    if (value.LinePIId > 0) NewJournalVoucherLine.PIId = value.LinePIId;
                    if (value.LineSIId > 0) NewJournalVoucherLine.SIId = value.LineSIId;

                    db.TrnJournalVoucherLines.InsertOnSubmit(NewJournalVoucherLine);
                    db.SubmitChanges();

                    //J.JournalizedJV(value.LineJVId);

                    return value;
                }
                catch
                {
                    return new Models.TrnJournalVoucherLine();
                }
            }
            else
            {
                return new Models.TrnJournalVoucherLine();
            }
        }

        // ===============================
        // PUT api/TrnJournalVoucherLine/5
        // ===============================

        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnJournalVoucherLine value)
        {
            try
            {
                var JournalVoucherLines = from d in db.TrnJournalVoucherLines
                                          where d.Id == id && 
                                                d.TrnJournalVoucher.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                          select d;

                if (JournalVoucherLines.Any())
                {
                    var UpdatedJournalVoucherLine = JournalVoucherLines.FirstOrDefault();

                    UpdatedJournalVoucherLine.BranchId = value.LineBranchId;
                    UpdatedJournalVoucherLine.AccountId = value.LineAccountId;
                    if (value.LineArticleId > 0) UpdatedJournalVoucherLine.ArticleId = value.LineArticleId;
                    UpdatedJournalVoucherLine.DebitAmount = value.LineDebitAmount;
                    UpdatedJournalVoucherLine.CreditAmount = value.LineCreditAmount;
                    UpdatedJournalVoucherLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    if (value.LinePIId > 0) UpdatedJournalVoucherLine.PIId = value.LinePIId;
                    if (value.LineSIId > 0) UpdatedJournalVoucherLine.SIId = value.LineSIId;

                    db.SubmitChanges();

                    //J.JournalizedJV(value.LineJVId);

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

        // ==================================
        // DELETE api/TrnJournalVoucherLine/5
        // ==================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnJournalVoucherLine DeleteJournalVoucherLine = db.TrnJournalVoucherLines.Where(d => d.Id == Id &&
                                                                                                       d.TrnJournalVoucher.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteJournalVoucherLine != null)
            {
                db.TrnJournalVoucherLines.DeleteOnSubmit(DeleteJournalVoucherLine);
                Int64 JVId = DeleteJournalVoucherLine.JVId;
                try
                {
                    db.SubmitChanges();

                    //J.JournalizedJV(JVId);

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