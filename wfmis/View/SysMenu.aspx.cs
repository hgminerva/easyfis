using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wfmis.View
{
    public partial class SysMenu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Data.wfmisDataContext db = new Data.wfmisDataContext();
            Business.Security secure = new Business.Security();

            var Users = from d in db.MstUsers
                        where d.Id == secure.GetCurrentUser()
                        select d;

            if (Users.Any())
            {
                if (Users.First().DefaultBranchId == null || Users.First().DefaultPeriodId == null)
                {
                    Response.Redirect("/Account/Manage.aspx");
                }
            }
            else
            {
                Response.Redirect("/Account/Manage.aspx");
            }
        }
    }
}