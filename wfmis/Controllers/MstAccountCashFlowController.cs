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
    public class MstAccountCashFlowController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ==========================
        // GET api/MstAccountCashFlow
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

            var Count = db.MstAccountCashFlows.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var AccountCashFlows = from d in db.MstAccountCashFlows
                                   where d.UserId == secure.GetCurrentSubscriberUser() &&
                                         d.AccountCashFlow.Contains(sSearch == null ? "" : sSearch)
                                   select new Models.MstAccountCashFlow
                                   {
                                       Id = d.Id,
                                       AccountCashFlowCode = d.AccountCashFlowCode,
                                       AccountCashFlow = d.AccountCashFlow,
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
                    if (sSortDir == "asc") AccountCashFlows = AccountCashFlows.OrderBy(d => d.AccountCashFlowCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else AccountCashFlows = AccountCashFlows.OrderByDescending(d => d.AccountCashFlowCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") AccountCashFlows = AccountCashFlows.OrderBy(d => d.AccountCashFlow).Skip(iDisplayStart).Take(NumberOfRecords);
                    else AccountCashFlows = AccountCashFlows.OrderByDescending(d => d.AccountCashFlow).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    AccountCashFlows = AccountCashFlows.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var AccountCashFlowPaged = new Models.SysDataTablePager();

            AccountCashFlowPaged.sEcho = sEcho;
            AccountCashFlowPaged.iTotalRecords = Count;
            AccountCashFlowPaged.iTotalDisplayRecords = Count;
            AccountCashFlowPaged.MstAccountCashFlowData = AccountCashFlows.ToList();

            return AccountCashFlowPaged;
        }

        // ============================================
        // GET api/MstAccountCashFlow/5/AccountCashFlow
        // ============================================

        [HttpGet]
        [ActionName("AccountCashFlow")]
        public Models.MstAccountCashFlow Get(Int64 id)
        {
            var AccountCashFlows = from a in db.MstAccountCashFlows
                                   where a.Id == id &&
                                         a.UserId == secure.GetCurrentSubscriberUser()
                                   select new Models.MstAccountCashFlow
                                   {
                                       Id = a.Id,
                                       AccountCashFlowCode = a.AccountCashFlowCode,
                                       AccountCashFlow = a.AccountCashFlow,
                                       IsLocked = a.IsLocked,
                                       CreatedById = a.CreatedById,
                                       CreatedBy = a.MstUser1.FullName,
                                       CreatedDateTime = Convert.ToString(a.CreatedDateTime.Day) + "/" + Convert.ToString(a.CreatedDateTime.Month) + "/" + Convert.ToString(a.CreatedDateTime.Year),
                                       UpdatedById = a.UpdatedById,
                                       UpdatedBy = a.MstUser2.FullName,
                                       UpdatedDateTime = Convert.ToString(a.UpdatedDateTime.Day) + "/" + Convert.ToString(a.UpdatedDateTime.Month) + "/" + Convert.ToString(a.UpdatedDateTime.Year)
                                   };
            if (AccountCashFlows.Any())
            {
                return AccountCashFlows.First();
            }
            else
            {
                return new Models.MstAccountCashFlow();
            }
        }

        // ===========================
        // POST api/MstAccountCashFlow
        // ===========================

        [HttpPost]
        public Models.MstAccountCashFlow Post(Models.MstAccountCashFlow value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    Data.MstAccountCashFlow NewAccountCashFlow = new Data.MstAccountCashFlow();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewAccountCashFlow.UserId = secure.GetCurrentSubscriberUser();
                    NewAccountCashFlow.AccountCashFlowCode = value.AccountCashFlowCode;
                    NewAccountCashFlow.AccountCashFlow = value.AccountCashFlow;
                    NewAccountCashFlow.IsLocked = true;
                    NewAccountCashFlow.CreatedById = secure.GetCurrentUser();
                    NewAccountCashFlow.CreatedDateTime = SQLNow.Value;
                    NewAccountCashFlow.UpdatedById = secure.GetCurrentUser();
                    NewAccountCashFlow.UpdatedDateTime = SQLNow.Value;

                    db.MstAccountCashFlows.InsertOnSubmit(NewAccountCashFlow);
                    db.SubmitChanges();

                    return Get(NewAccountCashFlow.Id);
                }
                catch
                {
                    return new Models.MstAccountCashFlow();
                }
            }
            else
            {
                return new Models.MstAccountCashFlow();
            }
        }

        // ============================
        // PUT api/MstAccountCashFlow/5
        // ============================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstAccountCashFlow value)
        {
            try
            {
                var AccountCashFlows = from d in db.MstAccountCashFlows
                                       where d.Id == Id && d.UserId == secure.GetCurrentSubscriberUser()
                                       select d;

                if (AccountCashFlows.Any())
                {
                    var UpdatedAccountCashFlow = AccountCashFlows.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedAccountCashFlow.AccountCashFlowCode = value.AccountCashFlowCode;
                    UpdatedAccountCashFlow.AccountCashFlow = value.AccountCashFlow;
                    UpdatedAccountCashFlow.IsLocked = true;
                    UpdatedAccountCashFlow.UpdatedById = secure.GetCurrentUser();
                    UpdatedAccountCashFlow.UpdatedDateTime = SQLNow.Value;

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

        // ===============================
        // DELETE api/MstAccountCashFlow/5
        // ===============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstAccountCashFlow DeleteAccountCashFlow = db.MstAccountCashFlows.Where(d => d.Id == Id &&
                                                                                              d.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteAccountCashFlow != null)
            {
                db.MstAccountCashFlows.DeleteOnSubmit(DeleteAccountCashFlow);
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