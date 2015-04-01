using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Web;

namespace wfmis.View
{
    public partial class MstAccountPreview : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var crystalReport = new ReportDocument();

            crystalReport.Load(Server.MapPath("~\\Reports\\MstAccount.rpt"));
            crystalReport.SetDatabaseLogon("innosoft", "innosoft", "localhost\\sqlexpress", "wfmis");

            MstAccountReportViewer.ReportSource = crystalReport;

            MstAccountReportViewer.RefreshReport();

            MstAccountReportViewer.ToolPanelView = ToolPanelViewType.None;
            MstAccountReportViewer.HasCrystalLogo = false;
            MstAccountReportViewer.HasToggleGroupTreeButton = false;
        }
    }
}
