using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Security;

namespace wfmis.Controllers
{
    public class AdminUserController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // =================
        // GET api/AdminUser
        // =================

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

            var Count = db.MstUsers.Count();

            var Users = from d in db.MstUsers
                        where d.FullName.Contains(sSearch == null ? "" : sSearch)
                        select new Models.AdminUser
                        {
                            Id = d.Id,
                            UserAccountNumber = d.UserAccountNumber,
                            UserName = d.Membership.User.UserName,
                            FullName = d.FullName,
                            Address = d.Address,
                            ContactNumber = d.ContactNumber,
                            EmailAddress = d.EmailAddress,
                            DefaultBranchId = d.DefaultBranchId == null ? 0 : d.DefaultBranchId.Value,
                            DefaultBranch = d.DefaultBranchId == null ? "NA" : d.MstBranch.Branch,
                            DefaultPeriodId = d.DefaultPeriodId == null ? 0 : d.DefaultPeriodId.Value,
                            DefaultPeriod = d.DefaultPeriodId == null ? "NA" : d.MstPeriod.Period,
                            IsTemplate = d.IsTemplate,
                            TemplateUserId = d.TemplateUserId == null ? 0 : d.TemplateUserId.Value,
                            TemplateUser = d.TemplateUserId == null ? "NA" : d.MstUser1.FullName
                        };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Users = Users.OrderBy(d => d.UserAccountNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Users = Users.OrderByDescending(d => d.UserAccountNumber).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Users = Users.OrderBy(d => d.UserName).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Users = Users.OrderByDescending(d => d.UserName).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Users = Users.OrderBy(d => d.FullName).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Users = Users.OrderByDescending(d => d.FullName).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Users = Users.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var UserPaged = new Models.SysDataTablePager();

            UserPaged.sEcho = sEcho;
            UserPaged.iTotalRecords = Count;
            UserPaged.iTotalDisplayRecords = Count;
            UserPaged.AdminUserData = Users.ToList();

            return UserPaged;
        }
    
        // ===================================
        // POST api/AdminUser/5/ChangeTemplate
        // ===================================
        
        [HttpPost]
        public bool Post()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            Int64 UserId = Convert.ToInt64(nvc["UserId"]); 
            Int64 TemplateUserId = Convert.ToInt64(nvc["TemplateUserId"]); 
            SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                              DateTime.Now.Month, +
                                                              DateTime.Now.Day, +
                                                              DateTime.Now.Hour, +
                                                              DateTime.Now.Minute, +
                                                              DateTime.Now.Second));
            try
            {
                if (db.MstArticles.Where(d => d.UserId == UserId).Count() == 0)
                {
                    // Update Null Defaults
                    var UpdateNullUsers = from d in db.MstUsers where d.Id == UserId select d;
                    if (UpdateNullUsers.Any())
                    {
                        var UpdateNullUser = UpdateNullUsers.First();
                        UpdateNullUser.DefaultBranchId = null;
                        UpdateNullUser.DefaultPeriodId = null;
                        UpdateNullUser.FSIncomeStatementAccountId = null;
                        UpdateNullUser.SupplierAccountId = null;
                        UpdateNullUser.CustomerAccountId = null;
                        UpdateNullUser.ItemPurchaseAccountId = null;
                        UpdateNullUser.ItemSalesAccountId = null;
                        UpdateNullUser.ItemCostAccountId = null;
                        UpdateNullUser.ItemAssetAccountId = null;
                        UpdateNullUser.IsAutoInventory = false;
                        UpdateNullUser.TemplateUserId = null;
                        db.SubmitChanges();
                    }
                    // Remove PayType
                    var PayTypes = from d in db.MstPayTypes where d.UserId == UserId select d;
                    if (PayTypes.Any())
                    {
                        foreach (var PayType in PayTypes)
                        {
                            db.MstPayTypes.DeleteOnSubmit(PayType);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Tax
                    var Taxes = from d in db.MstTaxes where d.UserId == UserId select d;
                    if (Taxes.Any())
                    {
                        foreach (var Tax in Taxes)
                        {
                            db.MstTaxes.DeleteOnSubmit(Tax);
                            db.SubmitChanges();
                        }
                    }
                    var TaxTypes = from d in db.MstTaxTypes where d.UserId == UserId select d;
                    if (TaxTypes.Any())
                    {
                        foreach (var TaxType in TaxTypes)
                        {
                            db.MstTaxTypes.DeleteOnSubmit(TaxType);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Accounts
                    var AccountBudgets = from d in db.MstAccountBudgets where d.MstAccount.UserId == UserId select d;
                    if (AccountBudgets.Any())
                    {
                        foreach(var AccountBudget in AccountBudgets) 
                        {
                            db.MstAccountBudgets.DeleteOnSubmit(AccountBudget);
                            db.SubmitChanges();
                        }
                    }
                    var Accounts = from d in db.MstAccounts where d.UserId == UserId select d;
                    if (Accounts.Any())
                    {
                        foreach(var Account in Accounts) 
                        {
                            db.MstAccounts.DeleteOnSubmit(Account);
                            db.SubmitChanges();
                        }
                    }
                    var AccountTypes = from d in db.MstAccountTypes where d.UserId == UserId select d;
                    if (AccountTypes.Any())
                    {
                        foreach (var AccountType in AccountTypes)
                        {
                            db.MstAccountTypes.DeleteOnSubmit(AccountType);
                            db.SubmitChanges();
                        }
                    }
                    var AccountCashFlows = from d in db.MstAccountCashFlows where d.UserId == UserId select d;
                    if (AccountCashFlows.Any())
                    {
                        foreach (var AccountCashFlow in AccountCashFlows)
                        {
                            db.MstAccountCashFlows.DeleteOnSubmit(AccountCashFlow);
                            db.SubmitChanges();
                        }
                    }
                    var AccountCategories = from d in db.MstAccountCategories where d.UserId == UserId select d;
                    if (AccountCategories.Any())
                    {
                        foreach (var AccountCategory in AccountCategories)
                        {
                            db.MstAccountCategories.DeleteOnSubmit(AccountCategory);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Branch
                    var Branches = from d in db.MstBranches where d.UserId == UserId select d;
                    if (Branches.Any())
                    {
                        foreach (var Branch in Branches)
                        {
                            db.MstBranches.DeleteOnSubmit(Branch);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Company
                    var Companies = from d in db.MstCompanies where d.UserId == UserId select d;
                    if (Companies.Any())
                    {
                        foreach (var Company in Companies)
                        {
                            db.MstCompanies.DeleteOnSubmit(Company);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Discount
                    var Discounts = from d in db.MstDiscounts where d.UserId == UserId select d;
                    if (Discounts.Any())
                    {
                        foreach (var Discount in Discounts)
                        {
                            db.MstDiscounts.DeleteOnSubmit(Discount);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Period
                    var Periods = from d in db.MstPeriods where d.UserId == UserId select d;
                    if (Periods.Any())
                    {
                        foreach (var Period in Periods)
                        {
                            db.MstPeriods.DeleteOnSubmit(Period);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Term
                    var Terms = from d in db.MstTerms where d.UserId == UserId select d;
                    if (Terms.Any())
                    {
                        foreach (var Term in Terms)
                        {
                            db.MstTerms.DeleteOnSubmit(Term);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Unit
                    var Units = from d in db.MstUnits where d.UserId == UserId select d;
                    if (Units.Any())
                    {
                        foreach (var Unit in Units)
                        {
                            db.MstUnits.DeleteOnSubmit(Unit);
                            db.SubmitChanges();
                        }
                    }
                    // Remove Article Type
                    var ArticleTypes = from d in db.MstArticleTypes where d.UserId == UserId select d;
                    if (ArticleTypes.Any())
                    {
                        foreach (var ArticleType in ArticleTypes)
                        {
                            db.MstArticleTypes.DeleteOnSubmit(ArticleType);
                            db.SubmitChanges();
                        }
                    }

                    // Add Accounts
                    var AddAccountCategories = from d in db.MstAccountCategories where d.UserId == TemplateUserId select d;
                    if (AddAccountCategories.Any())
                    {
                        foreach (var AddAccountCategory in AddAccountCategories)
                        {
                            Data.MstAccountCategory NewAccountCategory = new Data.MstAccountCategory();
                            NewAccountCategory.UserId = UserId;
                            NewAccountCategory.AccountCategoryCode = AddAccountCategory.AccountCategoryCode;
                            NewAccountCategory.AccountCategory = AddAccountCategory.AccountCategory;
                            NewAccountCategory.IsLocked = true;
                            NewAccountCategory.CreatedById = secure.GetCurrentUser();
                            NewAccountCategory.CreatedDateTime = SQLNow.Value;
                            NewAccountCategory.UpdatedById = secure.GetCurrentUser();
                            NewAccountCategory.UpdatedDateTime = SQLNow.Value;
                            db.MstAccountCategories.InsertOnSubmit(NewAccountCategory);
                            db.SubmitChanges();
                        }
                    }
                    var AddAccountTypes = from d in db.MstAccountTypes where d.UserId == TemplateUserId select d;
                    if (AddAccountTypes.Any())
                    {
                        foreach (var AddAccountType in AddAccountTypes)
                        {
                            Data.MstAccountType NewAccountType = new Data.MstAccountType();
                            NewAccountType.UserId = UserId;
                            NewAccountType.AccountTypeCode = AddAccountType.AccountTypeCode;
                            NewAccountType.AccountType = AddAccountType.AccountType;
                            NewAccountType.AccountCategoryId = db.MstAccountCategories.Where(d => d.UserId == UserId && d.AccountCategoryCode == AddAccountType.MstAccountCategory.AccountCategoryCode).First().Id;
                            NewAccountType.IsLocked = true;
                            NewAccountType.CreatedById = secure.GetCurrentUser();
                            NewAccountType.CreatedDateTime = SQLNow.Value;
                            NewAccountType.UpdatedById = secure.GetCurrentUser();
                            NewAccountType.UpdatedDateTime = SQLNow.Value;
                            db.MstAccountTypes.InsertOnSubmit(NewAccountType);
                            db.SubmitChanges();
                        }
                    }
                    var AddAccountCashFlows = from d in db.MstAccountCashFlows where d.UserId == TemplateUserId select d;
                    if (AddAccountCashFlows.Any())
                    {
                        foreach (var AddAccountCashFlow in AddAccountCashFlows)
                        {
                            Data.MstAccountCashFlow NewAccountCashFlow = new Data.MstAccountCashFlow();
                            NewAccountCashFlow.UserId = UserId;
                            NewAccountCashFlow.AccountCashFlowCode = AddAccountCashFlow.AccountCashFlowCode;
                            NewAccountCashFlow.AccountCashFlow = AddAccountCashFlow.AccountCashFlow;
                            NewAccountCashFlow.IsLocked = true;
                            NewAccountCashFlow.CreatedById = secure.GetCurrentUser();
                            NewAccountCashFlow.CreatedDateTime = SQLNow.Value;
                            NewAccountCashFlow.UpdatedById = secure.GetCurrentUser();
                            NewAccountCashFlow.UpdatedDateTime = SQLNow.Value;
                            db.MstAccountCashFlows.InsertOnSubmit(NewAccountCashFlow);
                            db.SubmitChanges();
                        }
                    }
                    var AddAccounts = from d in db.MstAccounts where d.UserId == TemplateUserId select d;
                    if (AddAccounts.Any())
                    {
                        foreach (var AddAccount in AddAccounts)
                        {
                            Data.MstAccount NewAccount = new Data.MstAccount();
                            NewAccount.UserId = UserId;
                            NewAccount.AccountCode = AddAccount.AccountCode;
                            NewAccount.Account = AddAccount.Account;
                            NewAccount.AccountTypeId = db.MstAccountTypes.Where(d => d.UserId == UserId && d.AccountTypeCode == AddAccount.MstAccountType.AccountTypeCode).First().Id;
                            if (AddAccount.AccountCashFlowId > 0)
                            {
                                NewAccount.AccountCashFlowId = db.MstAccountCashFlows.Where(d => d.UserId == UserId && d.AccountCashFlowCode == AddAccount.MstAccountCashFlow.AccountCashFlowCode).First().Id;
                            }
                            NewAccount.IsLocked = true;
                            NewAccount.CreatedById = secure.GetCurrentUser();
                            NewAccount.CreatedDateTime = SQLNow.Value;
                            NewAccount.UpdatedById = secure.GetCurrentUser();
                            NewAccount.UpdatedDateTime = SQLNow.Value;                            
                            db.MstAccounts.InsertOnSubmit(NewAccount);
                            db.SubmitChanges();
                        }
                    }
                    // Add Companies
                    var AddCompanies = from d in db.MstCompanies where d.UserId == TemplateUserId select d;
                    if (AddCompanies.Any())
                    {
                        foreach (var AddCompany in AddCompanies)
                        {
                            Data.MstCompany NewCompany = new Data.MstCompany();
                            NewCompany.UserId = UserId;
                            NewCompany.CompanyCode = AddCompany.CompanyCode;
                            NewCompany.Company = AddCompany.Company;
                            NewCompany.Address = AddCompany.Address;
                            NewCompany.ContactNumber = AddCompany.ContactNumber;
                            NewCompany.IsLocked = true;
                            NewCompany.CreatedById = secure.GetCurrentUser();
                            NewCompany.CreatedDateTime = SQLNow.Value;
                            NewCompany.UpdatedById = secure.GetCurrentUser();
                            NewCompany.UpdatedDateTime = SQLNow.Value;
                            db.MstCompanies.InsertOnSubmit(NewCompany);
                            db.SubmitChanges();
                        }
                    }
                    // Add Branches
                    var AddBranches = from d in db.MstBranches where d.UserId == TemplateUserId select d;
                    if (AddBranches.Any())
                    {
                        foreach (var AddBranch in AddBranches)
                        {
                            Data.MstBranch NewBranch = new Data.MstBranch();
                            NewBranch.UserId = UserId;
                            NewBranch.BranchCode = AddBranch.BranchCode;
                            NewBranch.Branch = AddBranch.Branch;
                            NewBranch.CompanyId = db.MstCompanies.Where(d => d.UserId == UserId && d.CompanyCode == AddBranch.MstCompany.CompanyCode).First().Id;
                            NewBranch.IsLocked = true;
                            NewBranch.CreatedById = secure.GetCurrentUser();
                            NewBranch.CreatedDateTime = SQLNow.Value;
                            NewBranch.UpdatedById = secure.GetCurrentUser();
                            NewBranch.UpdatedDateTime = SQLNow.Value;
                            db.MstBranches.InsertOnSubmit(NewBranch);
                            db.SubmitChanges();
                        }
                    }
                    // Add Discounts
                    var AddDiscounts = from d in db.MstDiscounts where d.UserId == TemplateUserId select d;
                    if (AddDiscounts.Any())
                    {
                        foreach (var AddDiscount in AddDiscounts)
                        {
                            Data.MstDiscount NewDiscount = new Data.MstDiscount();
                            NewDiscount.UserId = UserId;
                            NewDiscount.Discount = AddDiscount.Discount;
                            NewDiscount.DiscountRate = AddDiscount.DiscountRate;
                            NewDiscount.IsTaxLess = AddDiscount.IsTaxLess;
                            NewDiscount.IsLocked = true;
                            NewDiscount.CreatedById = secure.GetCurrentUser();
                            NewDiscount.CreatedDateTime = SQLNow.Value;
                            NewDiscount.UpdatedById = secure.GetCurrentUser();
                            NewDiscount.UpdatedDateTime = SQLNow.Value;
                            db.MstDiscounts.InsertOnSubmit(NewDiscount);
                            db.SubmitChanges();
                        }
                    }
                    // Add PayTypes
                    var AddPayTypes = from d in db.MstPayTypes where d.UserId == TemplateUserId select d;
                    if (AddPayTypes.Any())
                    {
                        foreach (var AddPayType in AddPayTypes)
                        {
                            Data.MstPayType NewPayType = new Data.MstPayType();
                            NewPayType.UserId = UserId;
                            NewPayType.PayType = AddPayType.PayType;
                            NewPayType.AccountId = db.MstAccounts.Where(d => d.UserId == UserId && d.AccountCode == AddPayType.MstAccount.AccountCode).First().Id;
                            NewPayType.IsLocked = true;
                            NewPayType.CreatedById = secure.GetCurrentUser();
                            NewPayType.CreatedDateTime = SQLNow.Value;
                            NewPayType.UpdatedById = secure.GetCurrentUser();
                            NewPayType.UpdatedDateTime = SQLNow.Value;
                            db.MstPayTypes.InsertOnSubmit(NewPayType);
                            db.SubmitChanges();
                        }
                    }
                    // Add Periods
                    var AddPeriods = from d in db.MstPeriods where d.UserId == TemplateUserId select d;
                    if (AddPeriods.Any())
                    {
                        foreach (var AddPeriod in AddPeriods)
                        {
                            Data.MstPeriod NewPeriod = new Data.MstPeriod();
                            NewPeriod.UserId = UserId;
                            NewPeriod.PeriodCode = AddPeriod.PeriodCode;
                            NewPeriod.Period = AddPeriod.Period;
                            NewPeriod.IsLocked = true;
                            NewPeriod.CreatedById = secure.GetCurrentUser();
                            NewPeriod.CreatedDateTime = SQLNow.Value;
                            NewPeriod.UpdatedById = secure.GetCurrentUser();
                            NewPeriod.UpdatedDateTime = SQLNow.Value;
                            db.MstPeriods.InsertOnSubmit(NewPeriod);
                            db.SubmitChanges();
                        }
                    }
                    // Add Taxes
                    var AddTaxTypes = from d in db.MstTaxTypes where d.UserId == TemplateUserId select d;
                    if (AddTaxTypes.Any())
                    {
                        foreach (var AddTaxType in AddTaxTypes)
                        {
                            Data.MstTaxType NewTaxType = new Data.MstTaxType();
                            NewTaxType.UserId = UserId;
                            NewTaxType.TaxType = AddTaxType.TaxType;
                            NewTaxType.IsLocked = true;
                            NewTaxType.CreatedById = secure.GetCurrentUser();
                            NewTaxType.CreatedDateTime = SQLNow.Value;
                            NewTaxType.UpdatedById = secure.GetCurrentUser();
                            NewTaxType.UpdatedDateTime = SQLNow.Value;
                            db.MstTaxTypes.InsertOnSubmit(NewTaxType);
                            db.SubmitChanges();
                        }
                    }
                    var AddTaxes = from d in db.MstTaxes where d.UserId == TemplateUserId select d;
                    if (AddTaxes.Any())
                    {
                        foreach (var AddTax in AddTaxes)
                        {
                            Data.MstTax NewTax = new Data.MstTax();
                            NewTax.UserId = UserId;
                            NewTax.TaxCode = AddTax.TaxCode;
                            NewTax.TaxTypeId = db.MstTaxTypes.Where(d => d.UserId == UserId && d.TaxType == AddTax.MstTaxType.TaxType).First().Id;
                            NewTax.TaxRate = AddTax.TaxRate;
                            NewTax.AccountId = db.MstAccounts.Where(d => d.UserId == UserId && d.AccountCode == AddTax.MstAccount.AccountCode).First().Id;
                            NewTax.IsLocked = true;
                            NewTax.CreatedById = secure.GetCurrentUser();
                            NewTax.CreatedDateTime = SQLNow.Value;
                            NewTax.UpdatedById = secure.GetCurrentUser();
                            NewTax.UpdatedDateTime = SQLNow.Value;
                            db.MstTaxes.InsertOnSubmit(NewTax);
                            db.SubmitChanges();
                        }
                    }
                    // Add Term
                    var AddTerms = from d in db.MstTerms where d.UserId == TemplateUserId select d;
                    if (AddTerms.Any())
                    {
                        foreach (var AddTerm in AddTerms)
                        {
                            Data.MstTerm NewTerm = new Data.MstTerm();
                            NewTerm.UserId = UserId;
                            NewTerm.Term = AddTerm.Term;
                            NewTerm.NumberOfDays = AddTerm.NumberOfDays;
                            NewTerm.IsLocked = true;
                            NewTerm.CreatedById = secure.GetCurrentUser();
                            NewTerm.CreatedDateTime = SQLNow.Value;
                            NewTerm.UpdatedById = secure.GetCurrentUser();
                            NewTerm.UpdatedDateTime = SQLNow.Value;
                            db.MstTerms.InsertOnSubmit(NewTerm);
                            db.SubmitChanges();
                        }
                    }
                    // Add Unit
                    var AddUnits = from d in db.MstUnits where d.UserId == TemplateUserId select d;
                    if (AddUnits.Any())
                    {
                        foreach (var AddUnit in AddUnits)
                        {
                            Data.MstUnit NewUnit = new Data.MstUnit();
                            NewUnit.UserId = UserId;
                            NewUnit.Unit = AddUnit.Unit;
                            NewUnit.IsLocked = true;
                            NewUnit.CreatedById = secure.GetCurrentUser();
                            NewUnit.CreatedDateTime = SQLNow.Value;
                            NewUnit.UpdatedById = secure.GetCurrentUser();
                            NewUnit.UpdatedDateTime = SQLNow.Value;
                            db.MstUnits.InsertOnSubmit(NewUnit);
                            db.SubmitChanges();
                        }
                    }
                    // Add Article Types
                    var AddArticleTypes = from d in db.MstArticleTypes where d.UserId == TemplateUserId select d;
                    if (AddArticleTypes.Any())
                    {
                        foreach (var AddArticleType in AddArticleTypes)
                        {
                            Data.MstArticleType NewArticleType = new Data.MstArticleType();
                            NewArticleType.UserId = UserId;
                            NewArticleType.ArticleType = AddArticleType.ArticleType;
                            NewArticleType.IsLocked = true;
                            NewArticleType.CreatedById = secure.GetCurrentUser();
                            NewArticleType.CreatedDateTime = SQLNow.Value;
                            NewArticleType.UpdatedById = secure.GetCurrentUser();
                            NewArticleType.UpdatedDateTime = SQLNow.Value;
                            db.MstArticleTypes.InsertOnSubmit(NewArticleType);
                            db.SubmitChanges();
                        }
                    }
                    // Update Defaults
                    var UpdateUsers = from d in db.MstUsers where d.Id == UserId select d;
                    if (UpdateUsers.Any())
                    {
                        var UpdateUser = UpdateUsers.First();
                        var TemplateUser = db.MstUsers.Where(d => d.Id == TemplateUserId).First();
                        UpdateUser.DefaultBranchId = db.MstBranches.Where(d => d.BranchCode == TemplateUser.MstBranch.BranchCode && d.UserId == UserId).First().Id;
                        UpdateUser.DefaultPeriodId = db.MstPeriods.Where(d => d.PeriodCode == TemplateUser.MstPeriod.PeriodCode && d.UserId == UserId).First().Id;
                        UpdateUser.FSIncomeStatementAccountId = db.MstAccounts.Where(d => d.AccountCode == TemplateUser.MstAccount.AccountCode && d.UserId == UserId).First().Id;
                        UpdateUser.SupplierAccountId = db.MstAccounts.Where(d => d.AccountCode == TemplateUser.MstAccount1.AccountCode && d.UserId == UserId).First().Id;
                        UpdateUser.CustomerAccountId = db.MstAccounts.Where(d => d.AccountCode == TemplateUser.MstAccount2.AccountCode && d.UserId == UserId).First().Id;
                        UpdateUser.ItemPurchaseAccountId = db.MstAccounts.Where(d => d.AccountCode == TemplateUser.MstAccount3.AccountCode && d.UserId == UserId).First().Id;
                        UpdateUser.ItemSalesAccountId = db.MstAccounts.Where(d => d.AccountCode == TemplateUser.MstAccount4.AccountCode && d.UserId == UserId).First().Id;
                        UpdateUser.ItemCostAccountId = db.MstAccounts.Where(d => d.AccountCode == TemplateUser.MstAccount6.AccountCode && d.UserId == UserId).First().Id;
                        UpdateUser.ItemAssetAccountId = db.MstAccounts.Where(d => d.AccountCode == TemplateUser.MstAccount5.AccountCode && d.UserId == UserId).First().Id;
                        UpdateUser.IsAutoInventory = TemplateUser.IsAutoInventory;
                        UpdateUser.TemplateUserId = TemplateUserId;
                        db.SubmitChanges();
                    }
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        // ===================================
        // POST api/AdminUser/5/ChangePassword
        // ===================================

        [HttpPost]
        [ActionName("ChangePassword")]
        public bool ChangePassword(Int64 Id) 
        {
            try
            {
                NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
                string NewPassword = nvc["NewPassword"].ToString();
                var Users = from d in db.MstUsers where d.Id == Id select d;
                if (Users.Any())
                {
                    MembershipUser User = Membership.GetUser(Users.First().Membership.User.UserName);
                    User.ChangePassword(User.ResetPassword(), NewPassword);
                    User.UnlockUser();

                    return true;
                }
                else
                {
                    return false;
                }
                
            }
            catch
            {
                return false;
            }
        }

        // ======================================
        // POST api/AdminUser/5/ClearTransactions
        // ======================================

        [HttpPost]
        [ActionName("ClearTransactions")]
        public bool ClearTransactions(Int64 Id)
        {
            try
            {
                var TrnInventory = from d in db.TrnInventories where d.MstBranch.UserId == Id select d;
                var TrnJournal = from d in db.TrnJournals where d.MstBranch.UserId == Id select d;
                var TrnStockTransfer = from d in db.TrnStockTransfers where d.MstBranch.UserId == Id select d;
                var TrnStockOut = from d in db.TrnStockOuts where d.MstBranch.UserId == Id select d;
                var TrnStockIn = from d in db.TrnStockIns where d.MstBranch.UserId == Id select d;
                var TrnBank = from d in db.TrnBanks where d.MstArticle.UserId == Id select d;
                var TrnCollection = from d in db.TrnCollections where d.MstBranch.UserId == Id select d;
                var TrnDisbursement = from d in db.TrnDisbursements where d.MstBranch.UserId == Id select d;
                var TrnJournalVoucher = from d in db.TrnJournalVouchers where d.MstBranch.UserId == Id select d;
                var TrnPurchaseInvoice = from d in db.TrnPurchaseInvoices where d.MstBranch.UserId == Id select d;
                var TrnPurchaseOrder = from d in db.TrnPurchaseOrders where d.MstBranch.UserId == Id select d;
                var TrnSalesInvoice = from d in db.TrnSalesInvoices where d.MstBranch.UserId == Id select d;
                var TrnSalesOrder = from d in db.TrnSalesOrders where d.MstBranch.UserId == Id select d;
                var MstArticleItemInventory = from d in db.MstArticleItemInventories where d.MstBranch.UserId == Id select d;

                foreach (var del in TrnInventory) db.TrnInventories.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnJournal) db.TrnJournals.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnStockTransfer) db.TrnStockTransfers.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnStockOut) db.TrnStockOuts.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnBank) db.TrnBanks.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnCollection) db.TrnCollections.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnDisbursement) db.TrnDisbursements.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnJournalVoucher) db.TrnJournalVouchers.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnSalesOrder) db.TrnSalesOrders.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnSalesInvoice) db.TrnSalesInvoices.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in MstArticleItemInventory) db.MstArticleItemInventories.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnStockIn) db.TrnStockIns.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnPurchaseInvoice) db.TrnPurchaseInvoices.DeleteOnSubmit(del);
                db.SubmitChanges();

                foreach (var del in TrnPurchaseOrder) db.TrnPurchaseOrders.DeleteOnSubmit(del);
                db.SubmitChanges();

                return true;
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
                return false;
            }
        }
    }
}