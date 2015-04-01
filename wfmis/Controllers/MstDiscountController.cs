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
    public class MstDiscountController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ===================
        // GET api/MstDiscount
        // ===================

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

            var Count = db.MstDiscounts.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Discounts = from d in db.MstDiscounts
                            where d.UserId == secure.GetCurrentSubscriberUser() &&
                                  d.Discount.Contains(sSearch == null ? "" : sSearch)
                            select new Models.MstDiscount
                            {
                                 Id = d.Id,
                                 UserId = d.UserId,
                                 Discount = d.Discount,
                                 DiscountRate = d.DiscountRate,
                                 IsTaxLess = d.IsTaxLess,
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
                    if (sSortDir == "asc") Discounts = Discounts.OrderBy(d => d.Discount).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Discounts = Discounts.OrderByDescending(d => d.Discount).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Discounts = Discounts.OrderBy(d => d.DiscountRate).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Discounts = Discounts.OrderByDescending(d => d.DiscountRate).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Discounts = Discounts.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var UserStaffPaged = new Models.SysDataTablePager();

            UserStaffPaged.sEcho = sEcho;
            UserStaffPaged.iTotalRecords = Count;
            UserStaffPaged.iTotalDisplayRecords = Count;
            UserStaffPaged.MstDiscountData = Discounts.ToList();

            return UserStaffPaged;
        }

        // ==============================
        // GET api/MstDiscount/5/Discount
        // ==============================

        [HttpGet]
        [ActionName("Discount")]
        public Models.MstDiscount Get(Int64 Id)
        {
            var Discounts = (from d in db.MstDiscounts
                             where d.UserId == secure.GetCurrentSubscriberUser() &&
                               d.Id == Id
                             select new Models.MstDiscount
                             {
                                 Id = d.Id,
                                 UserId = d.UserId,
                                 Discount = d.Discount,
                                 DiscountRate = d.DiscountRate,
                                 IsTaxLess = d.IsTaxLess,
                                 IsLocked = d.IsLocked,
                                 CreatedById = d.CreatedById,
                                 CreatedBy = d.MstUser1.FullName,
                                 CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                 UpdatedById = d.UpdatedById,
                                 UpdatedBy = d.MstUser2.FullName,
                                 UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                             });

            if (Discounts.Any())
            {
                return Discounts.First();
            }
            else
            {
                return new Models.MstDiscount();
            }
        }

        // ====================
        // POST api/MstDiscount
        // ====================

        [HttpPost]
        public Models.MstDiscount Post(Models.MstDiscount value)
        {
            if (secure.GetCurrentUser() > 0)
            {
                try
                {
                    Data.MstDiscount NewDiscount = new Data.MstDiscount();

                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewDiscount.UserId = secure.GetCurrentSubscriberUser();
                    NewDiscount.Discount = value.Discount;
                    NewDiscount.DiscountRate = value.DiscountRate;
                    NewDiscount.IsTaxLess = value.IsTaxLess;
                    NewDiscount.IsLocked = true;
                    NewDiscount.CreatedById = secure.GetCurrentUser();
                    NewDiscount.CreatedDateTime = SQLNow.Value;
                    NewDiscount.UpdatedById = secure.GetCurrentUser();
                    NewDiscount.UpdatedDateTime = SQLNow.Value;

                    db.MstDiscounts.InsertOnSubmit(NewDiscount);
                    db.SubmitChanges();

                    return Get(NewDiscount.Id);
                }
                catch
                {
                    return new Models.MstDiscount();
                }
            }
            else
            {
                return new Models.MstDiscount();
            }
        }

        // =====================
        // PUT api/MstDiscount/5
        // =====================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstDiscount value)
        {
            try
            {
                var Discounts = from d in db.MstDiscounts
                                where d.Id == Id &&
                                      d.UserId == secure.GetCurrentSubscriberUser()
                                select d;

                if (Discounts.Any())
                {
                    var UpdatedDiscounts = Discounts.FirstOrDefault();

                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedDiscounts.Discount = value.Discount;
                    UpdatedDiscounts.DiscountRate = value.DiscountRate;
                    UpdatedDiscounts.IsTaxLess = value.IsTaxLess;
                    UpdatedDiscounts.IsLocked = true;
                    UpdatedDiscounts.UpdatedById = secure.GetCurrentUser();
                    UpdatedDiscounts.UpdatedDateTime = SQLNow.Value;

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

        // ========================
        // DELETE api/MstDiscount/5
        // ========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstDiscount DeleteDiscount = db.MstDiscounts.Where(d => d.Id == Id &&
                                                                         d.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeleteDiscount != null)
            {
                db.MstDiscounts.DeleteOnSubmit(DeleteDiscount);
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