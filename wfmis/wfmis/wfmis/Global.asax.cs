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
        public string CurrentUserId;
        public string CurrentUser;

        public string CurrentPeriodId;
        public string CurrentPeriod;

        public string CurrentCompanyId;
        public string CurrentCompany;

        public string CurrentBranchId;
        public string CurrentBranch;

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
            this.CurrentUserId = "";
            this.CurrentUser = "";

            this.CurrentPeriodId = "";
            this.CurrentPeriod = "";

            this.CurrentBranchId = "";
            this.CurrentBranch = "";
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown
            this.CurrentUserId = "";
            this.CurrentUser = "";

            this.CurrentPeriodId = "";
            this.CurrentPeriod = "";

            this.CurrentBranchId = "";
            this.CurrentBranch = "";
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

                        this.CurrentPeriodId = MstUser.DefaultPeriodId.ToString();
                        var MstPeriod = data.MstPeriods.FirstOrDefault(p => p.Id.ToString().Equals(MstUser.DefaultPeriodId.ToString()));
                        this.CurrentPeriod = MstPeriod.Period;

                        this.CurrentBranchId = MstUser.DefaultBranchId.ToString();
                        var MstBranch = data.MstBranches.FirstOrDefault(b => b.Id.ToString().Equals(MstUser.DefaultBranchId.ToString()));
                        this.CurrentBranch = MstBranch.Branch;

                        this.CurrentCompanyId = MstBranch.MstCompany.Id.ToString();
                        this.CurrentCompany = MstBranch.MstCompany.Company;
                    }
                }
            }
            
        }

    }
}
