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
    public class MstUnitController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ===============
        // GET api/MstUnit
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

            var Count = db.MstUnits.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Units = from d in db.MstUnits
                        where d.UserId == secure.GetCurrentSubscriberUser() &&
                              d.Unit.Contains(sSearch == null ? "" : sSearch)
                        select new Models.MstUnit
                        {
                            Id = d.Id,
                            UserId = d.UserId,
                            Unit = d.Unit,
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
                    if (sSortDir == "asc") Units = Units.OrderBy(d => d.Unit).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Units = Units.OrderByDescending(d => d.Unit).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Units = Units.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var UnitPaged = new Models.SysDataTablePager();

            UnitPaged.sEcho = sEcho;
            UnitPaged.iTotalRecords = Count;
            UnitPaged.iTotalDisplayRecords = Count;
            UnitPaged.MstUnitData = Units.ToList();

            return UnitPaged;
        }

        // ======================
        // GET api/MstUnit/5/Unit
        // ======================

        [HttpGet]
        [ActionName("Unit")]
        public Models.MstUnit Get(Int64 id)
        {
            var Units = from d in db.MstUnits
                        where d.Id == id && d.UserId == secure.GetCurrentSubscriberUser()
                        select new Models.MstUnit
                        {
                            Id = d.Id,
                            UserId = d.UserId,
                            Unit = d.Unit,
                            IsLocked = d.IsLocked,
                            CreatedById = d.CreatedById,
                            CreatedBy = d.MstUser1.FullName,
                            CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                            UpdatedById = d.UpdatedById,
                            UpdatedBy = d.MstUser2.FullName,
                            UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                        };
            if (Units.Any())
            {
                return Units.First();
            }
            else
            {
                return new Models.MstUnit();
            }
        }

        // ================
        // POST api/MstUnit
        // ================

        [HttpPost]
        public Models.MstUnit Post(Models.MstUnit value)
        {
            if (secure.GetCurrentSubscriberUser() > 0)
            {
                try
                {
                    Data.MstUnit NewUnit = new Data.MstUnit();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    NewUnit.UserId = secure.GetCurrentSubscriberUser();
                    NewUnit.Unit = value.Unit;
                    NewUnit.IsLocked = true;
                    NewUnit.CreatedById = secure.GetCurrentUser();
                    NewUnit.CreatedDateTime = SQLNow.Value;
                    NewUnit.UpdatedById = secure.GetCurrentUser();
                    NewUnit.UpdatedDateTime = SQLNow.Value;

                    db.MstUnits.InsertOnSubmit(NewUnit);
                    db.SubmitChanges();

                    return Get(NewUnit.Id);
                }
                catch
                {
                    return new Models.MstUnit();
                }
            }
            else
            {
                return new Models.MstUnit();
            }
        }

        // =================
        // PUT api/MstUnit/5
        // =================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstUnit value)
        {
            try
            {
                var Units = from d in db.MstUnits
                            where d.Id == Id &&
                                  d.UserId == secure.GetCurrentSubscriberUser()
                            select d;

                if (Units.Any())
                {
                    var UpdatedUnit = Units.FirstOrDefault();

                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedUnit.Unit = value.Unit;
                    UpdatedUnit.IsLocked = true;
                    UpdatedUnit.UpdatedById = secure.GetCurrentUser();
                    UpdatedUnit.UpdatedDateTime = SQLNow.Value;

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
        // DELETE api/MstUnit/5
        // ====================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstUnit DeleteUnit = db.MstUnits.Where(d => d.Id == Id &&
                                                             d.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeleteUnit != null)
            {
                db.MstUnits.DeleteOnSubmit(DeleteUnit);
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