using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace wfmis.Controllers
{
    public class SysSecurity
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        public long GetCurrentUser()
        {
            string UserName =  Membership.GetUser().UserName;
            string UserId = "";

            var Users = from u in data.Users where u.UserName == UserName select u;

            if (Users != null)
            {
                UserId = Users.FirstOrDefault().UserId.ToString();

                var MstUser = data.MstUsers.FirstOrDefault(u => u.Membership.UserId.ToString().Equals(UserId));
                if (MstUser != null)
                {
                    return MstUser.Id;
                } else {
                    return 0;
                }
            }
            else
            {
                return 0;
            }
        }
    }
}