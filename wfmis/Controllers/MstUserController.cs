using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstUserController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/MstUser/5/User
        // ======================

        [HttpGet]
        [ActionName("User")]
        public Models.MstUser Get(Int64 Id)
        {
            var Users = (from d in db.MstUsers
                         where d.Id == secure.GetCurrentUser()
                         select new Models.MstUser
                         {
                             Id = d.Id,
                             UserAccountNumber = d.UserAccountNumber,
                             FullName = d.FullName,
                             Address = d.Address,
                             ContactNumber = d.ContactNumber,
                             EmailAddress = d.EmailAddress,
                             DefaultBranchId = d.DefaultBranchId == null? 0 : d.DefaultBranchId.Value,
                             DefaultBranch = d.DefaultBranchId == null ? "" : d.MstBranch.Branch,
                             DefaultPeriodId = d.DefaultPeriodId == null ? 0 : d.DefaultPeriodId.Value,
                             DefaultPeriod = d.DefaultPeriodId == null ? "" : d.MstPeriod.Period,
                             IsTemplate = d.IsTemplate,
                             Particulars = d.Particulars,
                             FSIncomeStatementAccountId = d.FSIncomeStatementAccountId == null ? 0 : d.FSIncomeStatementAccountId.Value,
                             FSIncomeStatementAccount = d.FSIncomeStatementAccountId == null ? "" : d.MstAccount.Account,
                             SupplierAccountId = d.SupplierAccountId == null ? 0 : d.SupplierAccountId.Value,
                             SupplierAccount = d.SupplierAccountId == null ? "" : d.MstAccount1.Account,
                             CustomerAccountId = d.CustomerAccountId == null ? 0 : d.CustomerAccountId.Value,
                             CustomerAccount = d.CustomerAccountId == null ? "" : d.MstAccount2.Account,
                             ItemPurchaseAccountId = d.ItemPurchaseAccountId == null ? 0 : d.ItemPurchaseAccountId.Value,
                             ItemPurchaseAccount = d.ItemPurchaseAccountId == null ? "" : d.MstAccount3.Account,
                             ItemSalesAccountId = d.ItemSalesAccountId == null ? 0 : d.ItemSalesAccountId.Value,
                             ItemSalesAccount = d.ItemSalesAccountId == null ? "" : d.MstAccount4.Account,
                             ItemCostAccountId = d.ItemCostAccountId == null ? 0 : d.ItemCostAccountId.Value,
                             ItemCostAccount = d.ItemCostAccountId == null ? "" : d.MstAccount6.Account,
                             ItemAssetAccountId = d.ItemAssetAccountId == null ? 0 : d.ItemAssetAccountId.Value,
                             ItemAssetAccount = d.ItemAssetAccountId == null ? "" : d.MstAccount5.Account,
                             IsAutoInventory = d.IsAutoInventory,
                             TemplateUserId = d.TemplateUserId == null ? 0 : d.TemplateUserId.Value,
                             TemplateUser = d.TemplateUserId == null ? "" : d.MstUser1.FullName,
                             InventoryValuationMethod = d.InventoryValuationMethod,
                             IsLocked = d.IsLocked
                         });
            if (Users.Any())
            {
                return Users.First();
            }
            else
            {
                return new Models.MstUser();
            }
        }

        // ======================
        // PUT api/MstUser/5/Info
        // ======================

        [HttpPut]
        [ActionName("Info")]
        public HttpResponseMessage PutInfo(Int64 Id, Models.MstUser value)
        {
            try
            {
                var Users = from d in db.MstUsers
                            where d.Id == secure.GetCurrentUser()
                            select d;

                if (Users.Any())
                {
                    var UpdatedUser = Users.FirstOrDefault();

                    UpdatedUser.FullName = value.FullName;
                    UpdatedUser.Address = value.Address;
                    UpdatedUser.ContactNumber = value.ContactNumber;
                    UpdatedUser.EmailAddress = value.EmailAddress;

                    db.SubmitChanges();
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // =========================
        // PUT api/MstUser/5/Default
        // =========================

        [HttpPut]
        [ActionName("Default")]
        public HttpResponseMessage PutDefault(Int64 Id, Models.MstUser value)
        {
            try
            {
                var Users = from d in db.MstUsers
                            where d.Id == secure.GetCurrentUser()
                            select d;

                if (Users.Any())
                {
                    var UpdatedUser = Users.FirstOrDefault();


                    if(value.DefaultBranchId>0) UpdatedUser.DefaultBranchId = value.DefaultBranchId;
                    if(value.DefaultPeriodId>0) UpdatedUser.DefaultPeriodId = value.DefaultPeriodId;

                    UpdatedUser.IsTemplate = value.IsTemplate;
                    UpdatedUser.Particulars = value.Particulars;

                    if (value.FSIncomeStatementAccountId > 0)
                    {
                        UpdatedUser.FSIncomeStatementAccountId = value.FSIncomeStatementAccountId;
                    }
                    else
                    {
                        if (value.DefaultBranchId > 0)
                        {
                            var Branches = from d in db.MstBranches where d.Id == value.DefaultBranchId select d;
                            if(Branches.Any()) 
                            {
                                if (Branches.First().MstUser.FSIncomeStatementAccountId > 0)
                                {
                                    UpdatedUser.FSIncomeStatementAccountId = Branches.First().MstUser.FSIncomeStatementAccountId;
                                }
                            } 
                        }
                    }

                    if (value.SupplierAccountId > 0)
                    {
                        UpdatedUser.SupplierAccountId = value.SupplierAccountId;
                    }
                    else
                    {
                        if (value.DefaultBranchId > 0)
                        {
                            var Branches = from d in db.MstBranches where d.Id == value.DefaultBranchId select d;
                            if (Branches.Any())
                            {
                                if (Branches.First().MstUser.SupplierAccountId > 0)
                                {
                                    UpdatedUser.SupplierAccountId = Branches.First().MstUser.SupplierAccountId;
                                }
                            }
                        }
                    }

                    if (value.CustomerAccountId > 0)
                    {
                        UpdatedUser.CustomerAccountId = value.CustomerAccountId;
                    }
                    else
                    {
                        if (value.DefaultBranchId > 0)
                        {
                            var Branches = from d in db.MstBranches where d.Id == value.DefaultBranchId select d;
                            if (Branches.Any())
                            {
                                if (Branches.First().MstUser.CustomerAccountId > 0)
                                {
                                    UpdatedUser.CustomerAccountId = Branches.First().MstUser.CustomerAccountId;
                                }
                            }
                        }
                    }

                    if (value.ItemPurchaseAccountId > 0)
                    {
                        UpdatedUser.ItemPurchaseAccountId = value.ItemPurchaseAccountId;
                    }
                    else
                    {
                        if (value.DefaultBranchId > 0)
                        {
                            var Branches = from d in db.MstBranches where d.Id == value.DefaultBranchId select d;
                            if (Branches.Any())
                            {
                                if (Branches.First().MstUser.ItemPurchaseAccountId > 0)
                                {
                                    UpdatedUser.ItemPurchaseAccountId = Branches.First().MstUser.ItemPurchaseAccountId;
                                }
                            }
                        }
                    }

                    if (value.ItemSalesAccountId > 0)
                    {
                        UpdatedUser.ItemSalesAccountId = value.ItemSalesAccountId;
                    }
                    else
                    {
                        if (value.DefaultBranchId > 0)
                        {
                            var Branches = from d in db.MstBranches where d.Id == value.DefaultBranchId select d;
                            if (Branches.Any())
                            {
                                if (Branches.First().MstUser.ItemSalesAccountId > 0)
                                {
                                    UpdatedUser.ItemSalesAccountId = Branches.First().MstUser.ItemSalesAccountId;
                                }
                            }
                        }
                    }

                    if (value.ItemCostAccountId > 0)
                    {
                        UpdatedUser.ItemCostAccountId = value.ItemCostAccountId;
                    }
                    else
                    {
                        if (value.DefaultBranchId > 0)
                        {
                            var Branches = from d in db.MstBranches where d.Id == value.DefaultBranchId select d;
                            if (Branches.Any())
                            {
                                if (Branches.First().MstUser.ItemCostAccountId > 0)
                                {
                                    UpdatedUser.ItemCostAccountId = Branches.First().MstUser.ItemCostAccountId;
                                }
                            }
                        }
                    }

                    if (value.ItemAssetAccountId > 0)
                    {
                        UpdatedUser.ItemAssetAccountId = value.ItemAssetAccountId;
                    }
                    else
                    {
                        if (value.DefaultBranchId > 0)
                        {
                            var Branches = from d in db.MstBranches where d.Id == value.DefaultBranchId select d;
                            if (Branches.Any())
                            {
                                if (Branches.First().MstUser.ItemAssetAccountId > 0)
                                {
                                    UpdatedUser.ItemAssetAccountId = Branches.First().MstUser.ItemAssetAccountId;
                                }
                            }
                        }
                    }

                    UpdatedUser.IsAutoInventory = value.IsAutoInventory;
                    UpdatedUser.InventoryValuationMethod = value.InventoryValuationMethod;
                    if(value.TemplateUserId>0) UpdatedUser.TemplateUserId = value.TemplateUserId;

                    db.SubmitChanges();
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // ==========================
        // PUT api/MstUser/5/Template
        // ==========================

        [HttpPut]
        [ActionName("Template")]
        public HttpResponseMessage PutTemplate(Int64 Id, Models.MstUser value)
        {
            try
            {
                var Users = from d in db.MstUsers
                            where d.Id == secure.GetCurrentUser()
                            select d;

                if (Users.Any())
                {
                    var UpdatedUser = Users.FirstOrDefault();

                    if (value.TemplateUserId > 0)
                    {
                        UpdatedUser.TemplateUserId = value.TemplateUserId;
                    }
                    else
                    {
                        UpdatedUser.TemplateUserId = null;
                    }

                    db.SubmitChanges();
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }
    
    }
}