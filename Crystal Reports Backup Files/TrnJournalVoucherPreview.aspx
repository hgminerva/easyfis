<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnJournalVoucherPreview.aspx.cs" Inherits="wfmis.View.TrnJournalVoucherPreview" %>
<%@ Register assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">

        <div class="container">

            <h2>Journal Voucher Detail Report</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div class="row-fluid">

                <CR:CrystalReportSource ID="TrnJournalVoucher" runat ="server">
                    <Report FileName="Reports\TrnJournalVoucher.rpt"></Report>
                </CR:CrystalReportSource>

                <div class="span12 pagination-centered">
                    <CR:CrystalReportViewer ID="TrnJournalVoucherViewer" 
                                            runat="server" 
                                            AutoDataBind="true" 
                                            ReportSourceID="TrnJournalVoucherReport" 
                                            EnableDatabaseLogonPrompt="False" 
                                            EnableParameterPrompt="False"
                                            ReuseParameterValuesOnRefresh="True"
                                            BestFitPage="False"
                                            Width="100%"
                                            Height="600px"
                                            ToolPanelView="None" />
                </div>
            </div>

        </div>
    </div>
</asp:Content>
