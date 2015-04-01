using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstUserStaffRoleController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ========================================
        // GET api/MstUserStaffRole/5/UserStaffRole
        // ========================================

        [HttpGet]
        [ActionName("UserStaffRole")]
        public Models.MstUserStaffRole Get(Int64 Id)
        {
            var UserStaffRole = (from d in data.MstUserStaffRoles
                                 where d.MstUserStaff.UserId == secure.GetCurrentSubscriberUser() &&
                                       d.Id == Id
                                select new Models.MstUserStaffRole
                                {
                                    LineId = d.Id,
                                    LineUserStaffId = d.UserStaffId,
                                    LineCompanyId = d.CompanyId,
                                    LineCompany = d.MstCompany.Company,
                                    LinePageId = d.PageId,
                                    LinePage = d.SysPage.Page,
                                    LineCanAdd = d.CanAdd,
                                    LineCanSave = d.CanSave,
                                    LineCanEdit = d.CanEdit,
                                    LineCanDelete = d.CanDelete,
                                    LineCanPrint = d.CanPrint,
                                    LineCanApprove = d.CanApprove,
                                    LineCanDisapprove = d.CanDisapprove
                                });

            if (UserStaffRole.Any())
            {
                return UserStaffRole.First();
            }
            else
            {
                return new Models.MstUserStaffRole();
            }
        }

        // =========================
        // POST api/MstUserStaffRole
        // =========================

        [HttpPost]
        public Models.MstUserStaffRole Post(Models.MstUserStaffRole value)
        {
            try
            {
                Data.MstUserStaffRole NewMstUserStaffRole = new Data.MstUserStaffRole();

                NewMstUserStaffRole.UserStaffId = value.LineUserStaffId;
                NewMstUserStaffRole.CompanyId = value.LineCompanyId;
                NewMstUserStaffRole.PageId = value.LinePageId;
                NewMstUserStaffRole.CanAdd = value.LineCanAdd;
                NewMstUserStaffRole.CanSave = value.LineCanSave;
                NewMstUserStaffRole.CanEdit = value.LineCanEdit;
                NewMstUserStaffRole.CanDelete = value.LineCanDelete;
                NewMstUserStaffRole.CanPrint = value.LineCanPrint;
                NewMstUserStaffRole.CanApprove = value.LineCanApprove;
                NewMstUserStaffRole.CanDisapprove = value.LineCanDisapprove;

                data.MstUserStaffRoles.InsertOnSubmit(NewMstUserStaffRole);
                data.SubmitChanges();

                return Get(NewMstUserStaffRole.Id);
            }
            catch
            {
                return new Models.MstUserStaffRole();
            }
        }

        // ==========================
        // PUT api/MstUserStaffRole/5
        // ==========================

        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.MstUserStaffRole value)
        {
            try
            {
                var UserStaffRole = from d in data.MstUserStaffRoles
                                    where d.Id == id &&
                                          d.MstUserStaff.UserId == secure.GetCurrentSubscriberUser()
                                    select d;

                if (UserStaffRole.Any())
                {
                    var UpdatedUserStaffRole = UserStaffRole.FirstOrDefault();

                    UpdatedUserStaffRole.CompanyId = value.LineCompanyId;
                    UpdatedUserStaffRole.PageId = value.LinePageId;
                    UpdatedUserStaffRole.CanAdd = value.LineCanAdd;
                    UpdatedUserStaffRole.CanSave = value.LineCanSave;
                    UpdatedUserStaffRole.CanEdit = value.LineCanEdit;
                    UpdatedUserStaffRole.CanDelete = value.LineCanDelete;
                    UpdatedUserStaffRole.CanPrint = value.LineCanPrint;
                    UpdatedUserStaffRole.CanApprove = value.LineCanApprove;
                    UpdatedUserStaffRole.CanDisapprove = value.LineCanDisapprove;

                    data.SubmitChanges();

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

        // =============================
        // DELETE api/MstUserStaffRole/5
        // =============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstUserStaffRole DeleteMstUserStaffRole = data.MstUserStaffRoles.Where(d => d.MstUserStaff.UserId == secure.GetCurrentSubscriberUser() &&
                                                                                             d.Id == Id).First();

            if (DeleteMstUserStaffRole != null)
            {
                data.MstUserStaffRoles.DeleteOnSubmit(DeleteMstUserStaffRole);
                try
                {
                    data.SubmitChanges();
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