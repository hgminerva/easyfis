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
    public class MstPayTypeController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ==================
        // GET api/MstPayType
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

            var Count = db.MstPayTypes.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var PayTypes = from d in db.MstPayTypes
                           where d.UserId == secure.GetCurrentSubscriberUser() &&
                                 d.PayType.Contains(sSearch == null ? "" : sSearch)
                           select new Models.MstPayType
                           {
                                Id = d.Id,
                                UserId = d.UserId,
                                PayType = d.PayType,
                                AccountId = d.AccountId,
                                Account = d.MstAccount.Account,
                                IsLocked = d.IsLocked,
                                CreatedById = d.CreatedById,
                                CreatedBy = d.MstUser1.FullName,
                                CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                UpdatedById = d.UpdatedById,
                                UpdatedBy = d.MstUser2.FullName,
                                UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                           };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") PayTypes = PayTypes.OrderBy(d => d.PayType).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PayTypes = PayTypes.OrderByDescending(d => d.PayType).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") PayTypes = PayTypes.OrderBy(d => d.Account).Skip(iDisplayStart).Take(NumberOfRecords);
                    else PayTypes = PayTypes.OrderByDescending(d => d.Account).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    PayTypes = PayTypes.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var PayTypePaged = new Models.SysDataTablePager();

            PayTypePaged.sEcho = sEcho;
            PayTypePaged.iTotalRecords = Count;
            PayTypePaged.iTotalDisplayRecords = Count;
            PayTypePaged.MstPayTypeData = PayTypes.ToList();

            return PayTypePaged;
        }

        // ============================
        // GET api/MstPayType/5/PayType
        // ============================

        [HttpGet]
        [ActionName("PayType")]
        public Models.MstPayType Get(Int64 Id)
        {
            var PayTypes = (from d in db.MstPayTypes
                            where d.UserId == secure.GetCurrentSubscriberUser() &&
                                  d.Id == Id
                            select new Models.MstPayType
                            {
                                 Id = d.Id,
                                 UserId = d.UserId,
                                 PayType = d.PayType,
                                 AccountId = d.AccountId,
                                 Account = d.MstAccount.Account,
                                 IsLocked = d.IsLocked,
                                 CreatedById = d.CreatedById,
                                 CreatedBy = d.MstUser1.FullName,
                                 CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                 UpdatedById = d.UpdatedById,
                                 UpdatedBy = d.MstUser2.FullName,
                                 UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                            });

            if (PayTypes.Any())
            {
                return PayTypes.First();
            }
            else
            {
                return new Models.MstPayType();
            }
        }

        // ===================
        // POST api/MstPayType
        // ===================

        [HttpPost]
        public Models.MstPayType Post(Models.MstPayType value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    Data.MstPayType NewPayType = new Data.MstPayType();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewPayType.UserId = secure.GetCurrentSubscriberUser();
                    NewPayType.PayType = value.PayType;
                    NewPayType.AccountId = value.AccountId;
                    NewPayType.IsLocked = true;
                    NewPayType.CreatedById = secure.GetCurrentUser();
                    NewPayType.CreatedDateTime = SQLNow.Value;
                    NewPayType.UpdatedById = secure.GetCurrentUser();
                    NewPayType.UpdatedDateTime = SQLNow.Value;

                    db.MstPayTypes.InsertOnSubmit(NewPayType);
                    db.SubmitChanges();

                    return Get(NewPayType.Id);
                }
                catch
                {
                    return new Models.MstPayType();
                }
            }
            else
            {
                return new Models.MstPayType();
            }
        }

        // ====================
        // PUT api/MstPayType/5
        // ====================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstPayType value)
        {
            try
            {
                var PayTypes = from d in db.MstPayTypes
                               where d.Id == Id &&
                                     d.UserId == secure.GetCurrentSubscriberUser()
                               select d;

                if (PayTypes.Any())
                {
                    var UpdatedPayType = PayTypes.FirstOrDefault();

                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedPayType.PayType = value.PayType;
                    UpdatedPayType.AccountId = value.AccountId;
                    UpdatedPayType.IsLocked = true;
                    UpdatedPayType.UpdatedById = secure.GetCurrentUser();
                    UpdatedPayType.UpdatedDateTime = SQLNow.Value;

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
        // DELETE api/MstPayType/5
        // =======================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstPayType DeletePayType = db.MstPayTypes.Where(d => d.Id == Id &&
                                                                      d.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeletePayType != null)
            {
                db.MstPayTypes.DeleteOnSubmit(DeletePayType);
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