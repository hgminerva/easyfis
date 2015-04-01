using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

using wfmis.Models;

namespace wfmis.Business
{
    public class Security
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        public Int64 GetCurrentUser()
        {
            string UserName = Membership.GetUser().UserName;
            string UserId = "";

            var Users = from u in db.Users where u.UserName == UserName select u;

            if (Users != null)
            {
                UserId = Users.FirstOrDefault().UserId.ToString();

                var MstUser = db.MstUsers.FirstOrDefault(u => u.Membership.UserId.ToString().Equals(UserId));
                if (MstUser != null)
                {
                    return MstUser.Id;
                }
                else
                {
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