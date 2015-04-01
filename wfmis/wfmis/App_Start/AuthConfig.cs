using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Membership.OpenAuth;

namespace wfmis
{
    internal static class AuthConfig
    {
        public static void RegisterOpenAuth()
        {
            // See http://go.microsoft.com/fwlink/?LinkId=252803 for details on setting up this ASP.NET
            // application to support logging in via external services.

            //OpenAuth.AuthenticationClients.AddTwitter(
            //    consumerKey: "your Twitter consumer key",
            //    consumerSecret: "your Twitter consumer secret");

            OpenAuth.AuthenticationClients.AddFacebook(
                appId: "438914516213507",
                appSecret: "7197ce3e27d4cad25ea74bcdb754a9d3");

            //OpenAuth.AuthenticationClients.AddMicrosoft(
            //    clientId: "your Microsoft account client id",
            //    clientSecret: "your Microsoft account client secret");

            //OpenAuth.AuthenticationClients.AddGoogle();
        }
    }
}