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
    public class MstAccountBudgetLineController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ================================================
        // GET api/MstAccountBudgetLine/5/AccountBudgetLine
        // ================================================

        [HttpGet]
        [ActionName("AccountBudgetLine")]
        public Models.MstAccountBudgetLine Get(Int64 Id)
        {
            var AccountBudgetLines = from d in db.MstAccountBudgets
                                     where d.Id == Id &&
                                           d.MstAccount.UserId == secure.GetCurrentSubscriberUser()
                                     select new Models.MstAccountBudgetLine
                                     {
                                          LineId = d.Id,
                                          LineAccountId = d.AccountId,
                                          LineAccount = d.MstAccount.Account,
                                          LinePeriodId = d.PeriodId,
                                          LinePeriod = d.MstPeriod.Period,
                                          LineCompanyId = d.CompanyId,
                                          LineCompany = d.MstCompany.Company,
                                          LineParticulars = d.Particulars,
                                          LineAmount = d.Amount
                                     };

            if (AccountBudgetLines.Any())
            {
                return AccountBudgetLines.First();
            }
            else
            {
                return new Models.MstAccountBudgetLine();
            }
        }

        // =============================
        // POST api/MstAccountBudgetLine
        // =============================

        [HttpPost]
        public Models.MstAccountBudgetLine Post(Models.MstAccountBudgetLine value)
        {
            var PeriodId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId);
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            if (secure.GetCurrentSubscriberUser() > 0)
            {
                // Add new line record
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.MstAccountBudget NewAccountBudget = new Data.MstAccountBudget();

                NewAccountBudget.AccountId = value.LineAccountId;
                NewAccountBudget.PeriodId = value.LinePeriodId;
                NewAccountBudget.CompanyId = value.LineCompanyId;
                NewAccountBudget.Particulars = value.LineParticulars;
                NewAccountBudget.Amount = value.LineAmount;

                newData.MstAccountBudgets.InsertOnSubmit(NewAccountBudget);
                newData.SubmitChanges();

                return value;
            }
            else
            {
                return new Models.MstAccountBudgetLine();
            }
        }

        // ==============================
        // PUT api/MstAccountBudgetLine/5
        // ==============================
        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstAccountBudgetLine value)
        {
            try
            {
                var AccountBudgetLines = from d in db.MstAccountBudgets
                                         where d.Id == Id &&
                                               d.MstAccount.UserId == secure.GetCurrentSubscriberUser()
                                         select d;

                if (AccountBudgetLines.Any())
                {
                    // Update line record
                    var UpdatedAccountBudget = AccountBudgetLines.FirstOrDefault();

                    UpdatedAccountBudget.PeriodId = value.LinePeriodId;
                    UpdatedAccountBudget.CompanyId = value.LineCompanyId;
                    UpdatedAccountBudget.Particulars = value.LineParticulars;
                    UpdatedAccountBudget.Amount = value.LineAmount;

                    db.SubmitChanges();

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

        // =================================
        // DELETE api/MstAccountBudgetLine/5
        // =================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstAccountBudget DeleteLine = db.MstAccountBudgets.Where(d => d.Id == Id &&
                                                                               d.MstAccount.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteLine != null)
            {
                db.MstAccountBudgets.DeleteOnSubmit(DeleteLine);
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
    }
}