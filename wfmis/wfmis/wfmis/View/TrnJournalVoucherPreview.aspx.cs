using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Web;
using CrystalDecisions.Shared;

namespace wfmis.View
{
    public partial class TrnJournalVoucherPreview : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Set Report Document
            var crystalReport = new ReportDocument();
            crystalReport.Load(Server.MapPath("~\\Reports\\TrnJournalVoucher.rpt"));
            crystalReport.SetDatabaseLogon("innosoft", "innosoft", "localhost\\sqlexpress", "wfmis");
            
            // Set Report Viewer
            TrnJournalVoucherViewer.ReportSource = crystalReport;
            TrnJournalVoucherViewer.RefreshReport();
            TrnJournalVoucherViewer.ToolPanelView = ToolPanelViewType.None;
            TrnJournalVoucherViewer.HasCrystalLogo = false;
            TrnJournalVoucherViewer.HasToggleGroupTreeButton = false;

            // Set Parameter
            ParameterFields ParamFields = this.TrnJournalVoucherViewer.ParameterFieldInfo;
            ParameterField JVId = new ParameterField();
            ParameterDiscreteValue JVIdValue = new ParameterDiscreteValue();

            JVId.Name = "JVId";
            JVIdValue.Value = Convert.ToInt32(Request["Id"]);

            JVId.CurrentValues.Add(JVIdValue);

            ParamFields.Add(JVId);

            // Refresh the viewer
            TrnJournalVoucherViewer.RefreshReport();
        }


    }
}