using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace wfmis.View
{
    public partial class TrnDisbursementDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Business.Security secure = new Business.Security();

            this.PageName.Value = "TrnDisbursementDetail";
            this.PageCompanyId.Value = ((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentCompanyId;
            this.PageId.Value = Request.QueryString["Id"] == null ? "0" : Request.QueryString["Id"];

            if (secure.SecurePage(this) == false)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Alert", "alert('You have no rights to open this page.');window.open('" + Request.UrlReferrer.LocalPath + "','_self');", true);
            }
        }
    }
}