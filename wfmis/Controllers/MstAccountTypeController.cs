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
    public class MstAccountTypeController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/MstAccountType
        // ======================

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

            var Count = db.MstAccountTypes.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var AccountTypes = from d in db.MstAccountTypes
                               where d.UserId == secure.GetCurrentSubscriberUser() &&
                                     d.AccountType.Contains(sSearch == null ? "" : sSearch)
                                  select new Models.MstAccountType
                                  {
                                      Id = d.Id,
                                      AccountTypeCode = d.AccountTypeCode,
                                      AccountType = d.AccountType,
                                      AccountCategoryId = d.AccountCategoryId,
                                      AccountCategory = d.MstAccountCategory.AccountCategory,
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
                    if (sSortDir == "asc") AccountTypes = AccountTypes.OrderBy(d => d.AccountTypeCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else AccountTypes = AccountTypes.OrderByDescending(d => d.AccountTypeCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") AccountTypes = AccountTypes.OrderBy(d => d.AccountType).Skip(iDisplayStart).Take(NumberOfRecords);
                    else AccountTypes = AccountTypes.OrderByDescending(d => d.AccountType).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") AccountTypes = AccountTypes.OrderBy(d => d.AccountCategory).Skip(iDisplayStart).Take(NumberOfRecords);
                    else AccountTypes = AccountTypes.OrderByDescending(d => d.AccountCategory).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    AccountTypes = AccountTypes.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var AccountTypePaged = new Models.SysDataTablePager();

            AccountTypePaged.sEcho = sEcho;
            AccountTypePaged.iTotalRecords = Count;
            AccountTypePaged.iTotalDisplayRecords = Count;
            AccountTypePaged.MstAccountTypeData = AccountTypes.ToList();

            return AccountTypePaged;
        }

        // ====================================
        // GET api/MstAccountType/5/AccountType
        // ====================================

        [HttpGet]
        [ActionName("AccountType")]
        public Models.MstAccountType Get(Int64 id)
        {
            var AccountTypes = from a in db.MstAccountTypes
                               where a.Id == id &&
                                     a.UserId == secure.GetCurrentSubscriberUser()
                               select new Models.MstAccountType
                               {
                                   Id = a.Id,
                                   AccountTypeCode = a.AccountTypeCode,
                                   AccountType = a.AccountType,
                                   AccountCategoryId = a.AccountCategoryId,
                                   AccountCategory = a.MstAccountCategory.AccountCategory,
                                   IsLocked = a.IsLocked,
                                   CreatedById = a.CreatedById,
                                   CreatedBy = a.MstUser1.FullName,
                                   CreatedDateTime = Convert.ToString(a.CreatedDateTime.Day) + "/" + Convert.ToString(a.CreatedDateTime.Month) + "/" + Convert.ToString(a.CreatedDateTime.Year),
                                   UpdatedById = a.UpdatedById,
                                   UpdatedBy = a.MstUser2.FullName,
                                   UpdatedDateTime = Convert.ToString(a.UpdatedDateTime.Day) + "/" + Convert.ToString(a.UpdatedDateTime.Month) + "/" + Convert.ToString(a.UpdatedDateTime.Year)
                               };
            if (AccountTypes.Any())
            {
                return AccountTypes.First();
            }
            else
            {
                return new Models.MstAccountType();
            }
        }

        // =======================
        // POST api/MstAccountType
        // =======================

        [HttpPost]
        public Models.MstAccountType Post(Models.MstAccountType value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    Data.MstAccountType NewAccountType = new Data.MstAccountType();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewAccountType.AccountTypeCode = value.AccountTypeCode;
                    NewAccountType.UserId = secure.GetCurrentSubscriberUser();
                    NewAccountType.AccountType = value.AccountType;
                    NewAccountType.AccountCategoryId = value.AccountCategoryId;
                    NewAccountType.IsLocked = true;
                    NewAccountType.CreatedById = secure.GetCurrentUser();
                    NewAccountType.CreatedDateTime = SQLNow.Value;
                    NewAccountType.UpdatedById = secure.GetCurrentUser();
                    NewAccountType.UpdatedDateTime = SQLNow.Value;

                    db.MstAccountTypes.InsertOnSubmit(NewAccountType);
                    db.SubmitChanges();

                    return Get(NewAccountType.Id);
                }
                catch
                {
                    return new Models.MstAccountType();
                }
            }
            else
            {
                return new Models.MstAccountType();
            }
        }

        // ========================
        // PUT api/MstAccountType/5
        // ========================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstAccountType value)
        {
            try
            {
                var AccountTypes = from d in db.MstAccountTypes
                                   where d.Id == Id && d.UserId == secure.GetCurrentSubscriberUser()
                                   select d;

                if (AccountTypes.Any())
                {
                    var UpdatedAccountType = AccountTypes.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedAccountType.AccountTypeCode = value.AccountTypeCode;
                    UpdatedAccountType.AccountType = value.AccountType;
                    UpdatedAccountType.AccountCategoryId = value.AccountCategoryId;
                    UpdatedAccountType.IsLocked = true;
                    UpdatedAccountType.UpdatedById = secure.GetCurrentUser();
                    UpdatedAccountType.UpdatedDateTime = SQLNow.Value;

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

        // ===========================
        // DELETE api/MstAccountType/5
        // ===========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstAccountType DeleteAccountType = db.MstAccountTypes.Where(d => d.Id == Id &&
                                                                                  d.UserId == secure.GetCurrentSubscriberUser()).First();
            if (DeleteAccountType != null)
            {
                db.MstAccountTypes.DeleteOnSubmit(DeleteAccountType);
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