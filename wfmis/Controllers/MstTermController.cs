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
    public class MstTermController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ===============
        // GET api/MstTerm
        // ===============

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

            var Count = db.MstTerms.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Terms = from d in db.MstTerms
                        where d.UserId == secure.GetCurrentSubscriberUser() &&
                              d.Term.Contains(sSearch == null ? "" : sSearch)
                        select new Models.MstTerm
                        {
                            Id = d.Id,
                            UserId = d.UserId,
                            Term = d.Term,
                            NumberOfDays = d.NumberOfDays,
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
                    if (sSortDir == "asc") Terms = Terms.OrderBy(d => d.Term).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Terms = Terms.OrderByDescending(d => d.Term).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Terms = Terms.OrderBy(d => d.NumberOfDays).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Terms = Terms.OrderByDescending(d => d.NumberOfDays).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Terms = Terms.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var TermPaged = new Models.SysDataTablePager();

            TermPaged.sEcho = sEcho;
            TermPaged.iTotalRecords = Count;
            TermPaged.iTotalDisplayRecords = Count;
            TermPaged.MstTermData = Terms.ToList();

            return TermPaged;
        }

        // ======================
        // GET api/MstTerm/5/Term
        // ======================

        [HttpGet]
        [ActionName("Term")]
        public Models.MstTerm Get(Int64 Id)
        {
            var Terms = (from d in db.MstTerms
                         where d.UserId == secure.GetCurrentSubscriberUser() &&
                               d.Id == Id
                         select new Models.MstTerm
                         {
                             Id = d.Id,
                             UserId = d.UserId,
                             Term = d.Term,
                             NumberOfDays = d.NumberOfDays,
                             IsLocked = d.IsLocked,
                             CreatedById = d.CreatedById,
                             CreatedBy = d.MstUser1.FullName,
                             CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                             UpdatedById = d.UpdatedById,
                             UpdatedBy = d.MstUser2.FullName,
                             UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                         });

            if (Terms.Any())
            {
                return Terms.First();
            }
            else
            {
                return new Models.MstTerm();
            }
        }

        // ================
        // POST api/MstTerm
        // ================

        [HttpPost]
        public Models.MstTerm Post(Models.MstTerm value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    Data.MstTerm NewTerm = new Data.MstTerm();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewTerm.UserId = secure.GetCurrentSubscriberUser();
                    NewTerm.Term = value.Term;
                    NewTerm.NumberOfDays = value.NumberOfDays;
                    NewTerm.IsLocked = true;
                    NewTerm.CreatedById = secure.GetCurrentUser();
                    NewTerm.CreatedDateTime = SQLNow.Value;
                    NewTerm.UpdatedById = secure.GetCurrentUser();
                    NewTerm.UpdatedDateTime = SQLNow.Value;

                    db.MstTerms.InsertOnSubmit(NewTerm);
                    db.SubmitChanges();

                    return Get(NewTerm.Id);
                }
                catch
                {
                    return new Models.MstTerm();
                }
            }
            else
            {
                return new Models.MstTerm();
            }
        }

        // =================
        // PUT api/MstTerm/5
        // =================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstTerm value)
        {
            try
            {
                var Terms = from d in db.MstTerms
                            where d.Id == Id &&
                                  d.UserId == secure.GetCurrentSubscriberUser()
                            select d;

                if (Terms.Any())
                {
                    var UpdatedTerm = Terms.FirstOrDefault();

                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));


                    UpdatedTerm.Term = value.Term;
                    UpdatedTerm.NumberOfDays = value.NumberOfDays; 
                    UpdatedTerm.IsLocked = true;
                    UpdatedTerm.UpdatedById = secure.GetCurrentUser();
                    UpdatedTerm.UpdatedDateTime = SQLNow.Value;

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

        // ====================
        // DELETE api/MstTerm/5
        // ====================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstTerm DeleteTerm = db.MstTerms.Where(d => d.Id == Id &&
                                                             d.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeleteTerm != null)
            {
                db.MstTerms.DeleteOnSubmit(DeleteTerm);
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