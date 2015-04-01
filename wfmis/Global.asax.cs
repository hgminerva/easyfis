using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.Http;
using wfmis;
using System.Web.Mvc;

namespace wfmis
{
    public class Global : HttpApplication
    {
        public string CurrentSubscriberUserId;
        public string CurrentSubscriberUser;
        public string CurrentUserId;
        public string CurrentUser;
        public string CurrentPeriodId;
        public string CurrentPeriod;
        public string CurrentCompanyId;
        public string CurrentCompany;
        public string CurrentBranchId;
        public string CurrentBranch;
        public string CurrentFSIncomeStatementAccountId;
        public string CurrentFSIncomeStatementAccount;
        public string CurrentSupplierAccountId;
        public string CurrentSupplierAccount;
        public string CurrentCustomerAccountId;
        public string CurrentCustomerAccount;
        public string CurrentItemPurchaseAccountId;
        public string CurrentItemPurchaseAccount;
        public string CurrentItemSalesAccountId;
        public string CurrentItemSalesAccount;
        public string CurrentItemCostAccountId;
        public string CurrentItemCostAccount;
        public string CurrentItemAssetAccountId;
        public string CurrentItemAssetAccount;
        public string CurrentIsAutoInventory;

        public string CurrentCaptchaString;

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterOpenAuth();

            // Routing table for the controller to /api
            // RouteTable.Routes.MapHttpRoute(name: "DefaultAPI", routeTemplate: "api/{controller}/{id}", defaults: new { id = System.Web.Http.RouteParameter.Optional });
            RouteTable.Routes.MapHttpRoute(
                                            name: "DefaultAPI",
                                            routeTemplate: "api/{controller}/{id}/{action}",
                                            defaults: new { action = System.Web.Http.RouteParameter.Optional, 
                                                            id = System.Web.Http.RouteParameter.Optional }
                                          );

            // Initialize global variables
            this.CurrentSubscriberUserId = "";
            this.CurrentSubscriberUser = "";
            this.CurrentUserId = "";
            this.CurrentUser = "";
            this.CurrentPeriodId = "";
            this.CurrentPeriod = "";
            this.CurrentBranchId = "";
            this.CurrentBranch = "";
            this.CurrentFSIncomeStatementAccountId = "";
            this.CurrentFSIncomeStatementAccount = "";
            this.CurrentSupplierAccountId = "";
            this.CurrentSupplierAccount = "";
            this.CurrentCustomerAccountId = "";
            this.CurrentCustomerAccount = "";
            this.CurrentItemPurchaseAccountId = "";
            this.CurrentItemPurchaseAccount = "";
            this.CurrentItemSalesAccountId = "";
            this.CurrentItemSalesAccount = "";
            this.CurrentItemCostAccountId = "";
            this.CurrentItemCostAccount = "";
            this.CurrentItemAssetAccountId = "";
            this.CurrentItemAssetAccount = "";
            this.CurrentIsAutoInventory = "";

            this.CurrentCaptchaString = "";
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown
            this.CurrentSubscriberUserId = "";
            this.CurrentSubscriberUser = "";
            this.CurrentUserId = "";
            this.CurrentUser = "";
            this.CurrentPeriodId = "";
            this.CurrentPeriod = "";
            this.CurrentBranchId = "";
            this.CurrentBranch = "";
            this.CurrentFSIncomeStatementAccountId = "";
            this.CurrentFSIncomeStatementAccount = "";
            this.CurrentSupplierAccountId = "";
            this.CurrentSupplierAccount = "";
            this.CurrentCustomerAccountId = "";
            this.CurrentCustomerAccount = "";
            this.CurrentItemPurchaseAccountId = "";
            this.CurrentItemPurchaseAccount = "";
            this.CurrentItemSalesAccountId = "";
            this.CurrentItemSalesAccount = "";
            this.CurrentItemCostAccountId = "";
            this.CurrentItemCostAccount = "";
            this.CurrentItemAssetAccountId = "";
            this.CurrentItemAssetAccount = "";
            this.CurrentIsAutoInventory = "";

            this.CurrentCaptchaString = "";
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs

        }

        void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            Data.wfmisDataContext data = new Data.wfmisDataContext();

            string UserName = "";
            string UserId = "";

            try
            {
                UserName = Membership.GetUser().UserName;
            }
            catch (NullReferenceException)
            {
                UserName = "";
            }

            var Users = from u in data.Users where u.UserName == UserName select u;

            if (Users.Any())
            {
                UserId = Users.FirstOrDefault().UserId.ToString();

                var MstUser = data.MstUsers.FirstOrDefault(u => u.Membership.UserId.ToString().Equals(UserId));
                if (MstUser != null)
                {
                    if (this.CurrentUserId != "")
                    {
                        this.CurrentUserId = Convert.ToString(MstUser.Id);
                        this.CurrentUser = MstUser.FullName;
                        if (MstUser.DefaultPeriodId > 0)
                        {
                            this.CurrentPeriodId = MstUser.DefaultPeriodId.ToString();
                            var MstPeriod = data.MstPeriods.FirstOrDefault(p => p.Id.ToString().Equals(MstUser.DefaultPeriodId.ToString()));
                            this.CurrentPeriod = MstPeriod.Period;
                        }
                        else
                        {
                            this.CurrentPeriod = "";
                        }
                        if (MstUser.DefaultBranchId > 0)
                        {
                            this.CurrentBranchId = MstUser.DefaultBranchId.ToString();
                            var MstBranch = data.MstBranches.FirstOrDefault(b => b.Id.ToString().Equals(MstUser.DefaultBranchId.ToString()));
                            this.CurrentBranch = MstBranch.Branch;

                            this.CurrentCompanyId = MstBranch.MstCompany.Id.ToString();
                            this.CurrentCompany = MstBranch.MstCompany.Company;

                            this.CurrentSubscriberUserId = MstBranch.UserId.ToString();
                            this.CurrentSubscriberUser = MstBranch.MstUser.FullName;
                        }
                        else
                        {
                            this.CurrentBranch = "";

                            this.CurrentCompanyId = "";
                            this.CurrentCompany = "";

                            this.CurrentSubscriberUserId = "";
                            this.CurrentSubscriberUser = "";
                        }

                        this.CurrentFSIncomeStatementAccountId = MstUser.FSIncomeStatementAccountId > 0 ? MstUser.FSIncomeStatementAccountId.ToString() : "";
                        this.CurrentFSIncomeStatementAccount = MstUser.FSIncomeStatementAccountId > 0 ? MstUser.MstAccount.Account : "";
                        this.CurrentSupplierAccountId = MstUser.SupplierAccountId > 0 ? MstUser.SupplierAccountId.ToString() : "";
                        this.CurrentSupplierAccount = MstUser.SupplierAccountId > 0 ? MstUser.MstAccount1.Account : "";
                        this.CurrentCustomerAccountId = MstUser.CustomerAccountId > 0 ? MstUser.CustomerAccountId.ToString() : "";
                        this.CurrentCustomerAccount = MstUser.CustomerAccountId > 0 ? MstUser.MstAccount2.Account : "";
                        this.CurrentItemPurchaseAccountId = MstUser.ItemPurchaseAccountId > 0 ? MstUser.ItemPurchaseAccountId.ToString() : "";
                        this.CurrentItemPurchaseAccount = MstUser.ItemPurchaseAccountId > 0 ? MstUser.MstAccount3.Account : "";
                        this.CurrentItemSalesAccountId = MstUser.ItemSalesAccountId > 0 ? MstUser.ItemSalesAccountId.ToString() : "";
                        this.CurrentItemSalesAccount = MstUser.ItemSalesAccountId > 0 ? MstUser.MstAccount4.Account : "";
                        this.CurrentItemCostAccountId = MstUser.ItemCostAccountId > 0 ? MstUser.ItemCostAccountId.ToString() : "";
                        this.CurrentItemCostAccount = MstUser.ItemCostAccountId > 0 ? MstUser.MstAccount6.Account : "";
                        this.CurrentItemAssetAccountId = MstUser.ItemAssetAccountId > 0 ? MstUser.ItemAssetAccountId.ToString() : "";
                        this.CurrentItemAssetAccount = MstUser.ItemAssetAccountId > 0 ? MstUser.MstAccount5.Account : "";
                        this.CurrentIsAutoInventory = MstUser.IsAutoInventory.ToString();                        
                    }
                }
            }
            
        }

    }
}
