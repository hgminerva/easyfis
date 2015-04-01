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
    public class TrnCollectionLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();
        private Business.JournalEntry journal = new Business.JournalEntry();

        private void UpdateHeaderTotalAmount(Int64 ORId)
        {
            var Collections = from d in db.TrnCollections where d.Id == ORId select d;
            if (Collections.Any())
            {
                var UpdatedCollection = Collections.First();
                UpdatedCollection.TotalAmount = UpdatedCollection.TrnCollectionLines.Count() > 0 ?
                                                UpdatedCollection.TrnCollectionLines.Sum(a => a.Amount) : 0;
                db.SubmitChanges();
            }
        }

        // ==========================================
        // GET api/TrnCollectionLine/5/CollectionLine
        // ==========================================

        [HttpGet]
        [ActionName("CollectionLine")]
        public Models.TrnCollectionLine Get(Int64 Id)
        {
            var CollectionLines = from d in db.TrnCollectionLines
                                  where d.Id == Id &&
                                        d.TrnCollection.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                  select new Models.TrnCollectionLine
                                  {
                                        LineId = d.Id,
                                        LineORId = d.ORId,
                                        LineAccountId = d.AccountId,
                                        LineAccount = d.MstAccount.MstAccountType.AccountType + " - " + d.MstAccount.Account,
                                        LineSIId = d.SIId == null ? 0 : d.SIId.Value,
                                        LineSINumber = d.SIId == null ? "" : d.TrnSalesInvoice.SINumber,
                                        LineParticulars = d.Particulars,
                                        LineAmount = d.Amount,
                                        LinePayTypeId = d.PayTypeId,
                                        LinePayType = d.MstPayType.PayType,
                                        LineCheckNumber = d.CheckNumber == null ? "" : d.CheckNumber,
                                        LineCheckDate = d.CheckDate.ToShortDateString(),
                                        LineCheckBank = d.CheckBank == null ? "" : d.CheckBank,
                                        LineBankId = d.BankId == null ? 0 : d.BankId.Value,
                                        LineBank = d.BankId == null ? "" : d.MstArticle.Article
                                  };

            if (CollectionLines.Any())
            {
                return CollectionLines.First();
            }
            else
            {
                return new Models.TrnCollectionLine();
            }
        }

        // ==========================
        // POST api/TrnCollectionLine
        // ==========================

        [HttpPost]
        public Models.TrnCollectionLine Post(Models.TrnCollectionLine value)
        {
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (secure.GetCurrentUser() > 0)
            {
                // Add new line record
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.TrnCollectionLine NewCollectionLine = new Data.TrnCollectionLine();
                SqlDateTime SQLCheckDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.LineCheckDate).Year, +
                                                                        Convert.ToDateTime(value.LineCheckDate).Month, +
                                                                        Convert.ToDateTime(value.LineCheckDate).Day));

                NewCollectionLine.ORId = value.LineORId;
                NewCollectionLine.AccountId = value.LineAccountId;
                if (value.LineSIId > 0) NewCollectionLine.SIId = value.LineSIId;
                NewCollectionLine.Particulars = value.LineParticulars;
                NewCollectionLine.Amount = value.LineAmount;
                NewCollectionLine.PayTypeId = value.LinePayTypeId;
                NewCollectionLine.CheckNumber = value.LineCheckNumber;
                NewCollectionLine.CheckDate = SQLCheckDate.Value;
                NewCollectionLine.CheckBank = value.LineCheckBank;
                if (value.LineBankId > 0) NewCollectionLine.BankId = value.LineBankId;

                newData.TrnCollectionLines.InsertOnSubmit(NewCollectionLine);
                newData.SubmitChanges();

                UpdateHeaderTotalAmount(value.LineORId);

                // UpdateAR(value.LineORId);

                // journal.JournalizedOR(value.LineORId);

                return value;
            }
            else
            {
                return new Models.TrnCollectionLine();
            }
        }

        // ===========================
        // PUT api/TrnCollectionLine/5
        // ===========================
        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.TrnCollectionLine value)
        {
            try
            {
                var CollectionLines = from d in db.TrnCollectionLines
                                      where d.Id == id &&
                                            d.TrnCollection.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                                      select d;

                if (CollectionLines.Any())
                {
                    // Update line record
                    var UpdatedCollectionLine = CollectionLines.FirstOrDefault();
                    SqlDateTime SQLCheckDate = new SqlDateTime(new DateTime(Convert.ToDateTime(value.LineCheckDate).Year, +
                                                                            Convert.ToDateTime(value.LineCheckDate).Month, +
                                                                            Convert.ToDateTime(value.LineCheckDate).Day));

                    UpdatedCollectionLine.AccountId = value.LineAccountId;
                    if (value.LineSIId > 0) UpdatedCollectionLine.SIId = value.LineSIId;
                    UpdatedCollectionLine.Particulars = (value.LineParticulars == null) ? "NA" : value.LineParticulars;
                    UpdatedCollectionLine.Amount = value.LineAmount;
                    UpdatedCollectionLine.PayTypeId = value.LinePayTypeId;
                    UpdatedCollectionLine.CheckNumber = value.LineCheckNumber;
                    UpdatedCollectionLine.CheckDate = SQLCheckDate.Value;
                    UpdatedCollectionLine.CheckBank = value.LineCheckBank;
                    if (value.LineBankId > 0) UpdatedCollectionLine.BankId = value.LineBankId;

                    db.SubmitChanges();

                    UpdateHeaderTotalAmount(value.LineORId);

                    // UpdateAR(value.LineORId);

                    // journal.JournalizedOR(value.LineORId);

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

        // ==============================
        // DELETE api/TrnCollectionLine/5
        // ==============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.TrnCollectionLine DeleteLine = db.TrnCollectionLines.Where(d => d.Id == Id &&
                                                                                 d.TrnCollection.MstBranch.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.TrnCollectionLines.DeleteOnSubmit(DeleteLine);
                try
                {
                    db.SubmitChanges();

                    UpdateHeaderTotalAmount(DeleteLine.ORId);

                    // UpdateAR(DeleteLine.ORId);

                    // journal.JournalizedOR(DeleteLine.ORId);

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