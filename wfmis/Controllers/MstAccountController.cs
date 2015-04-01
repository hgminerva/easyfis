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
    public class MstAccountController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ==================
        // GET api/MstAccount
        // ==================

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

            var Count = db.MstAccounts.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Accounts = from d in db.MstAccounts
                           where d.UserId == secure.GetCurrentSubscriberUser() &&
                                 d.Account.Contains(sSearch == null ? "" : sSearch)
                           select new Models.MstAccount
                            {
                                Id = d.Id,
                                AccountCode = d.AccountCode,
                                Account = d.Account,
                                AccountTypeId = d.AccountTypeId,
                                AccountType = d.MstAccountType.AccountType,
                                AccountCashFlowId = d.AccountCashFlowId == null ? 0 : d.AccountCashFlowId.Value,
                                AccountCashFlow = d.AccountCashFlowId == null ? "" : d.MstAccountCashFlow.AccountCashFlow,
                                IsLocked = d.IsLocked,
                                CreatedById = d.CreatedById,
                                CreatedBy = d.MstUser1.FullName,
                                CreatedDateTime = Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                UpdatedById = d.UpdatedById,
                                UpdatedBy = d.MstUser2.FullName,
                                UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                            };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Accounts = Accounts.OrderBy(d => d.AccountCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Accounts = Accounts.OrderByDescending(d => d.AccountCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Accounts = Accounts.OrderBy(d => d.Account).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Accounts = Accounts.OrderByDescending(d => d.Account).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Accounts = Accounts.OrderBy(d => d.AccountType).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Accounts = Accounts.OrderByDescending(d => d.AccountType).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Accounts = Accounts.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var AccountPaged = new Models.SysDataTablePager();

            AccountPaged.sEcho = sEcho;
            AccountPaged.iTotalRecords = Count;
            AccountPaged.iTotalDisplayRecords = Count;
            AccountPaged.MstAccountData = Accounts.ToList();

            return AccountPaged;
        }

        // ============================
        // GET api/MstAccount/5/Account
        // ============================

        [HttpGet]
        [ActionName("Account")]
        public Models.MstAccount Get(Int64 Id)
        {
            var Accounts = from a in db.MstAccounts
                           where a.Id == Id && a.UserId == secure.GetCurrentSubscriberUser()
                           select new Models.MstAccount
                           {
                                Id = a.Id,
                                AccountCode = a.AccountCode,
                                Account = a.Account,
                                AccountTypeId = a.AccountTypeId,
                                AccountType = a.MstAccountType.AccountType,
                                AccountCashFlowId = a.AccountCashFlowId == null ? 0 : a.AccountCashFlowId.Value,
                                AccountCashFlow = a.AccountCashFlowId == null ? "" : a.MstAccountCashFlow.AccountCashFlow,
                                IsLocked = a.IsLocked,
                                CreatedById = a.CreatedById,
                                CreatedBy = a.MstUser1.FullName,
                                CreatedDateTime = Convert.ToString(a.CreatedDateTime.Day) + "/" + Convert.ToString(a.CreatedDateTime.Month) + "/" + Convert.ToString(a.CreatedDateTime.Year),
                                UpdatedById = a.UpdatedById,
                                UpdatedBy = a.MstUser2.FullName,
                                UpdatedDateTime = Convert.ToString(a.UpdatedDateTime.Day) + "/" + Convert.ToString(a.UpdatedDateTime.Month) + "/" + Convert.ToString(a.UpdatedDateTime.Year)
                           };
            if (Accounts.Any())
            {
                return Accounts.First();
            }
            else
            {
                return new Models.MstAccount();
            }
        }

        // =======================================
        // GET api/MstAccount/5/AccountBudgetLines
        // =======================================   

        [HttpGet]
        [ActionName("AccountBudgetLines")]
        public Models.SysDataTablePager AccountBudgetLines(Int64 Id)
        {
            int NumberOfRecords = 20;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.MstAccountBudgets.Where(d => d.AccountId == Id && 
                                                        d.MstAccount.UserId == secure.GetCurrentSubscriberUser()).Count();

            var AccountBudgetLines = (from d in db.MstAccountBudgets
                                      where d.AccountId == Id &&
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
                                      });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") AccountBudgetLines = AccountBudgetLines.OrderBy(d => d.LinePeriod).Skip(iDisplayStart).Take(NumberOfRecords);
                    else AccountBudgetLines = AccountBudgetLines.OrderByDescending(d => d.LinePeriod).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") AccountBudgetLines = AccountBudgetLines.OrderBy(d => d.LineCompany).Skip(iDisplayStart).Take(NumberOfRecords);
                    else AccountBudgetLines = AccountBudgetLines.OrderByDescending(d => d.LineCompany).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    AccountBudgetLines = AccountBudgetLines.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var AccountBudgetLinePaged = new Models.SysDataTablePager();

            AccountBudgetLinePaged.sEcho = sEcho;
            AccountBudgetLinePaged.iTotalRecords = Count;
            AccountBudgetLinePaged.iTotalDisplayRecords = Count;
            AccountBudgetLinePaged.MstAccountBudgetLineData = AccountBudgetLines.ToList();

            return AccountBudgetLinePaged;
        }

        // ===================
        // POST api/MstAccount
        // ===================

        [HttpPost]
        public Models.MstAccount Post(Models.MstAccount value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    // Add new account
                    Data.wfmisDataContext newData = new Data.wfmisDataContext();
                    Data.MstAccount NewAccount = new Data.MstAccount();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewAccount.AccountCode = value.AccountCode;
                    NewAccount.UserId = secure.GetCurrentSubscriberUser();
                    NewAccount.Account = value.Account;
                    NewAccount.AccountTypeId = value.AccountTypeId;
                    NewAccount.AccountCashFlowId = value.AccountCashFlowId;
                    NewAccount.IsLocked = true;
                    NewAccount.CreatedById = secure.GetCurrentUser();
                    NewAccount.CreatedDateTime = SQLNow.Value;
                    NewAccount.UpdatedById = secure.GetCurrentUser();
                    NewAccount.UpdatedDateTime = SQLNow.Value;

                    newData.MstAccounts.InsertOnSubmit(NewAccount);
                    newData.SubmitChanges();

                    return Get(NewAccount.Id);                    
                }
                catch
                {
                    return new Models.MstAccount();
                }
            }
            else
            {
                return new Models.MstAccount();
            }
        }

        // ====================
        // PUT api/MstAccount/5
        // ====================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstAccount value)
        {
            try
            {
                var Accounts = from d in db.MstAccounts
                               where d.Id == Id && 
                                     d.UserId == secure.GetCurrentSubscriberUser()
                               select d;
                if (Accounts.Any())
                {
                    var UpdatedAccount = Accounts.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedAccount.AccountCode = value.AccountCode;
                    UpdatedAccount.Account = value.Account;
                    UpdatedAccount.AccountTypeId = value.AccountTypeId;
                    UpdatedAccount.AccountCashFlowId = value.AccountCashFlowId;
                    UpdatedAccount.IsLocked = true;
                    UpdatedAccount.UpdatedById = secure.GetCurrentUser();
                    UpdatedAccount.UpdatedDateTime = SQLNow.Value;

                    db.SubmitChanges();

                    return Request.CreateResponse(HttpStatusCode.OK);
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
            }
            catch
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // =======================
        // DELETE api/MstAccount/5
        // =======================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstAccount DeleteAccount = db.MstAccounts.Where(d => d.Id == Id && 
                                                                      d.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeleteAccount != null)
            {
                db.MstAccounts.DeleteOnSubmit(DeleteAccount);
                try
                {
                    db.SubmitChanges();
                }
                catch
                {
                    returnVariable = false;
                }
            }
            else
            {
                returnVariable = false;
            }
            return returnVariable;
        }
    }
}