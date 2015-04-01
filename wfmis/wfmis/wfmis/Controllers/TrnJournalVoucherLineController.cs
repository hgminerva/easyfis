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
        // Data context
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        // Controller security
        private SysSecurity secure = new SysSecurity();

        private Business.JournalEntry J = new Business.JournalEntry();

        // GET api/TrnJournalVoucherLine
        [HttpGet]
        public List<Models.TrnJournalVoucherLine> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var TrnJournalVoucherLines  = from d in data.TrnJournalVoucherLines
                                          where d.MstBranch.Id == BranchId && 
                                                d.MstBranch.MstCompany.MstUser.Id == secure.GetCurrentUser()
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
                                              LineParticulars = d.Particulars                                             
                                          };

            return TrnJournalVoucherLines.ToList();
        }

        // GET api/TrnJournalVoucherLine/5
        public Models.TrnJournalVoucherLine Get(Int64 Id)
        {
            var JournalVoucherLines = from d in data.TrnJournalVoucherLines
                                      where d.Id == Id &&
                                            d.TrnJournalVoucher.MstBranch.MstCompany.MstUser.Id == secure.GetCurrentUser()
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
                                          LineParticulars = d.Particulars   
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

        // POST api/TrnJournalVoucherLine
        [HttpPost]
        public Models.TrnJournalVoucherLine Post(Models.TrnJournalVoucherLine value)
        {
            try
            {
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.TrnJournalVoucherLine NewJournalVoucherLine = new Data.TrnJournalVoucherLine();

                var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

                NewJournalVoucherLine.JVId = value.LineJVId;
                if (value.LineBranchId > 0) NewJournalVoucherLine.BranchId = value.LineBranchId;
                if (value.LineAccountId > 0) NewJournalVoucherLine.AccountId = value.LineAccountId;
                if (value.LineArticleId > 0) NewJournalVoucherLine.ArticleId = value.LineArticleId;
                NewJournalVoucherLine.DebitAmount = value.LineDebitAmount;
                NewJournalVoucherLine.CreditAmount = value.LineCreditAmount;
                NewJournalVoucherLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;

                newData.TrnJournalVoucherLines.InsertOnSubmit(NewJournalVoucherLine);
                newData.SubmitChanges();

                J.JournalizedJV(value.LineJVId);

                return value;
            }
            catch
            {
                return value;
            }
        }

        // PUT api/TrnJournalVoucherLine/5
        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnJournalVoucherLine value)
        {
            try
            {
                var JournalVoucherLines = from d in data.TrnJournalVoucherLines
                                          where d.Id == id && 
                                                d.TrnJournalVoucher.MstBranch.MstCompany.MstUser.Id == secure.GetCurrentUser()
                                          select d;

                if (JournalVoucherLines.Any())
                {
                    var UpdatedJournalVoucherLine = JournalVoucherLines.FirstOrDefault();

                    if (value.LineJVId > 0) UpdatedJournalVoucherLine.JVId = value.LineJVId;
                    if (value.LineBranchId > 0) UpdatedJournalVoucherLine.BranchId = value.LineBranchId;
                    if (value.LineAccountId > 0) UpdatedJournalVoucherLine.AccountId = value.LineAccountId;
                    if (value.LineArticleId > 0) UpdatedJournalVoucherLine.ArticleId = value.LineArticleId;
                    UpdatedJournalVoucherLine.DebitAmount = value.LineDebitAmount;
                    UpdatedJournalVoucherLine.CreditAmount = value.LineCreditAmount;
                    UpdatedJournalVoucherLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;

                    data.SubmitChanges();

                    J.JournalizedJV(value.LineJVId);

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

        // DELETE api/TrnJournalVoucherLine/5
        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnJournalVoucherLine DeleteJournalVoucherLine = data.TrnJournalVoucherLines.Where(d => d.Id == Id &&
                                                                                                         d.TrnJournalVoucher.MstBranch.MstCompany.MstUser.Id == secure.GetCurrentUser()).First();
            if (DeleteJournalVoucherLine != null)
            {
                data.TrnJournalVoucherLines.DeleteOnSubmit(DeleteJournalVoucherLine);
                Int64 JVId = DeleteJournalVoucherLine.JVId;
                try
                {
                    data.SubmitChanges();

                    J.JournalizedJV(JVId);

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