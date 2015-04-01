using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstUserStaffController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ====================
        // GET api/MstUserStaff
        // ====================

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

            var Count = db.MstUserStaffs.Where(d => d.MstUser.Id == secure.GetCurrentSubscriberUser()).Count();

            var UserStaffs = from d in db.MstUserStaffs
                             where d.UserId == secure.GetCurrentSubscriberUser() &&
                                   d.MstUser1.FullName.Contains(sSearch == null ? "" : sSearch)
                             select new Models.MstUserStaff
                             {
                                 Id = d.Id,
                                 UserId = d.UserId,
                                 User = d.MstUser.FullName,
                                 UserStaffId = d.UserStaffId,
                                 UserStaff = d.MstUser1.FullName,
                                 RoleId = d.RoleId,
                                 Role = d.SysRole.Role
                             };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") UserStaffs = UserStaffs.OrderBy(d => d.UserStaff).Skip(iDisplayStart).Take(NumberOfRecords);
                    else UserStaffs = UserStaffs.OrderByDescending(d => d.UserStaff).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") UserStaffs = UserStaffs.OrderBy(d => d.Role).Skip(iDisplayStart).Take(NumberOfRecords);
                    else UserStaffs = UserStaffs.OrderByDescending(d => d.Role).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    UserStaffs = UserStaffs.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var UserStaffPaged = new Models.SysDataTablePager();

            UserStaffPaged.sEcho = sEcho;
            UserStaffPaged.iTotalRecords = Count;
            UserStaffPaged.iTotalDisplayRecords = Count;
            UserStaffPaged.MstUserStaffData = UserStaffs.ToList();

            return UserStaffPaged;
        }

        // ================================
        // GET api/MstUserStaff/5/UserStaff
        // ================================

        [HttpGet]
        [ActionName("UserStaff")]
        public Models.MstUserStaff Get(Int64 id)
        {
            var UserStaffs = from a in db.MstUserStaffs
                             where a.Id == id && a.MstUser.Id == secure.GetCurrentSubscriberUser()
                             select new Models.MstUserStaff
                             {
                                Id = a.Id,
                                UserId = a.UserId,
                                User = a.MstUser.FullName,
                                UserStaffId = a.UserStaffId,
                                UserStaff = a.MstUser1.FullName,
                                RoleId = a.RoleId,
                                Role = a.SysRole.Role
                             };
            if (UserStaffs.Any())
            {
                return UserStaffs.First();
            }
            else
            {
                return new Models.MstUserStaff();
            }
        }

        // =====================================
        // GET api/MstUserStaff/5/UserStaffRoles
        // =====================================

        [HttpGet]
        [ActionName("UserStaffRoles")]
        public Models.SysDataTablePager UserStaffRoles(Int64 Id)
        {
            int NumberOfRecords = 20;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.MstUserStaffRoles.Where(d => d.UserStaffId == Id &&
                                                        d.MstUserStaff.UserId == secure.GetCurrentSubscriberUser()).Count();

            var UserStaffRoles = (from d in db.MstUserStaffRoles
                                  where d.UserStaffId == Id &&
                                        d.MstUserStaff.MstUser.Id == secure.GetCurrentUser()
                                  select new Models.MstUserStaffRole
                                  {
                                        LineId = d.Id,
                                        LineUserStaffId = d.UserStaffId,
                                        LineCompanyId = d.CompanyId,
                                        LineCompany = d.MstCompany.Company,
                                        LinePageId = d.PageId,
                                        LinePage = d.SysPage.Description,
                                        LineCanAdd = d.CanAdd,
                                        LineCanEdit = d.CanEdit,
                                        LineCanDelete = d.CanDelete,
                                        LineCanSave = d.CanSave,
                                        LineCanPrint = d.CanPrint,
                                        LineCanApprove = d.CanApprove,
                                        LineCanDisapprove = d.CanDisapprove
                                  });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") UserStaffRoles = UserStaffRoles.OrderBy(d => d.LineCompany).Skip(iDisplayStart).Take(NumberOfRecords);
                    else UserStaffRoles = UserStaffRoles.OrderByDescending(d => d.LineCompany).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") UserStaffRoles = UserStaffRoles.OrderBy(d => d.LinePage).Skip(iDisplayStart).Take(NumberOfRecords);
                    else UserStaffRoles = UserStaffRoles.OrderByDescending(d => d.LinePage).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    UserStaffRoles = UserStaffRoles.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var UserRolePaged = new Models.SysDataTablePager();

            UserRolePaged.sEcho = sEcho;
            UserRolePaged.iTotalRecords = Count;
            UserRolePaged.iTotalDisplayRecords = Count;
            UserRolePaged.MstUserStaffRoleData = UserStaffRoles.ToList();

            return UserRolePaged;
        }

        // =====================
        // POST api/MstUserStaff
        // =====================

        [HttpPost]
        public Models.MstUserStaff Post(Models.MstUserStaff value)
        {
            if (secure.GetCurrentUser() > 0)
            {
                try
                {
                    Data.MstUserStaff NewUserStaff = new Data.MstUserStaff();

                    NewUserStaff.UserId = value.UserId;
                    NewUserStaff.UserStaffId = value.UserStaffId;
                    NewUserStaff.RoleId = value.RoleId;

                    db.MstUserStaffs.InsertOnSubmit(NewUserStaff);
                    db.SubmitChanges();

                    return this.Get(NewUserStaff.Id);
                }
                catch
                {
                    return new Models.MstUserStaff();
                }
            }
            else
            {
                return new Models.MstUserStaff();
            }
        }

        // ======================
        // PUT api/MstUserStaff/5
        // ======================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstUserStaff value)
        {
            try
            {
                var UserStaffs = from d in db.MstUserStaffs
                                 where d.Id == Id &&
                                       d.UserId == secure.GetCurrentSubscriberUser()
                                 select d;

                if (UserStaffs.Any())
                {
                    var UpdatedUserStaff = UserStaffs.FirstOrDefault();

                    UpdatedUserStaff.UserStaffId = value.UserStaffId;
                    UpdatedUserStaff.RoleId = value.RoleId;

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

        // =========================
        // DELETE api/MstUserStaff/5
        // =========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstUserStaff DeleteUserStaff = db.MstUserStaffs.Where(d => d.Id == Id &&
                                                                            d.UserId == secure.GetCurrentSubscriberUser()).First();

            if (DeleteUserStaff != null)
            {
                db.MstUserStaffs.DeleteOnSubmit(DeleteUserStaff);
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