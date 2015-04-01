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
    public class MstTaxController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ==============
        // GET api/MstTax
        // ==============

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

            var Count = db.MstTaxes.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Taxes = from d in db.MstTaxes
                        where d.UserId == secure.GetCurrentSubscriberUser() &&
                              d.TaxCode.Contains(sSearch == null ? "" : sSearch)
                        select new Models.MstTax
                        {
                            Id = d.Id,
                            UserId = d.UserId,
                            TaxCode = d.TaxCode,
                            TaxRate = d.TaxRate,
                            TaxTypeId = d.TaxTypeId,
                            TaxType = d.MstTaxType.TaxType,
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
                    if (sSortDir == "asc") Taxes = Taxes.OrderBy(d => d.TaxCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Taxes = Taxes.OrderByDescending(d => d.TaxCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Taxes = Taxes.OrderBy(d => d.TaxRate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Taxes = Taxes.OrderByDescending(d => d.TaxRate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Taxes = Taxes.OrderBy(d => d.Account).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Taxes = Taxes.OrderByDescending(d => d.Account).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Taxes = Taxes.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var TaxPaged = new Models.SysDataTablePager();

            TaxPaged.sEcho = sEcho;
            TaxPaged.iTotalRecords = Count;
            TaxPaged.iTotalDisplayRecords = Count;
            TaxPaged.MstTaxData = Taxes.ToList();

            return TaxPaged;
        }

        // ====================
        // GET api/MstTax/5/Tax
        // ====================

        [HttpGet]
        [ActionName("Tax")]
        public Models.MstTax Get(Int64 Id)
        {
            var Taxes = (from d in db.MstTaxes
                         where d.UserId == secure.GetCurrentSubscriberUser() &&
                               d.Id == Id
                         select new Models.MstTax
                         {
                             Id = d.Id,
                             UserId = d.UserId,
                             User = d.MstUser.FullName,
                             TaxCode = d.TaxCode,
                             TaxTypeId = d.TaxTypeId,
                             TaxType = d.MstTaxType.TaxType,
                             TaxRate = d.TaxRate,
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

            if (Taxes.Any())
            {
                return Taxes.First();
            }
            else
            {
                return new Models.MstTax();
            }
        }

        // ===============
        // POST api/MstTax
        // ===============

        [HttpPost]
        public Models.MstTax Post(Models.MstTax value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    Data.MstTax NewTax = new Data.MstTax();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewTax.UserId = secure.GetCurrentSubscriberUser();
                    NewTax.TaxCode = value.TaxCode;
                    NewTax.TaxTypeId = value.TaxTypeId;
                    NewTax.TaxRate = value.TaxRate;
                    NewTax.AccountId = value.AccountId;
                    NewTax.IsLocked = true;
                    NewTax.CreatedById = secure.GetCurrentUser();
                    NewTax.CreatedDateTime = SQLNow.Value;
                    NewTax.UpdatedById = secure.GetCurrentUser();
                    NewTax.UpdatedDateTime = SQLNow.Value;

                    db.MstTaxes.InsertOnSubmit(NewTax);
                    db.SubmitChanges();

                    return Get(NewTax.Id);
                }
                catch
                {
                    return new Models.MstTax();
                }
            }
            else
            {
                return new Models.MstTax();
            }
        }

        // ================
        // PUT api/MstTax/5
        // ================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstTax value)
        {
            try
            {
                var Taxes = from d in db.MstTaxes
                            where d.Id == Id &&
                                  d.UserId == secure.GetCurrentSubscriberUser()
                            select d;

                if (Taxes.Any())
                {
                    var UpdatedTax = Taxes.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedTax.TaxCode = value.TaxCode;
                    UpdatedTax.TaxTypeId = value.TaxTypeId;
                    UpdatedTax.TaxRate = value.TaxRate;
                    UpdatedTax.AccountId = value.AccountId;
                    UpdatedTax.IsLocked = true;
                    UpdatedTax.UpdatedById = secure.GetCurrentUser();
                    UpdatedTax.UpdatedDateTime = SQLNow.Value;

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

        // ===================
        // DELETE api/MstTax/5
        // ===================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstTax DeleteTax = db.MstTaxes.Where(d => d.Id == Id &&
                                                           d.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeleteTax != null)
            {
                db.MstTaxes.DeleteOnSubmit(DeleteTax);
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