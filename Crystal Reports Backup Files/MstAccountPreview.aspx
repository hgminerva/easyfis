<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstAccountPreview.aspx.cs" Inherits="wfmis.View.MstAccountPreview" %>
<%@ Register assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">

        <div class="container">

            <h2>Chart of Accounts - Report</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div class="row-fluid">
                <CR:CrystalReportSource ID="MstAccountReport" runat ="server">
                    <Report FileName="Reports\MstAccount.rpt"></Report>
                </CR:CrystalReportSource>
                <div class="span12 pagination-centered">
                <CR:CrystalReportViewer ID="MstAccountReportViewer" 
                                        runat="server" 
                                        AutoDataBind="true" 
                                        ReportSourceID="MstAccountReport" 
                                        EnableDatabaseLogonPrompt="False" 
                                         BestFitPage="False"
                                        Width="100%"
                                        Height="600px"
                                        ToolPanelView="None" />
                </div>
            </div>

        </div>
    </div>
</asp:Content>
