<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="SysUtilities.aspx.cs" Inherits="wfmis.View.SysUtilities" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>System Utilities</h2>

            <input runat="server" id="PageName" type="hidden" value="" class="text" />
            <input runat="server" id="PageCompanyId" type="hidden" value="0" class="text" />
            <input runat="server" id="PageId" type="hidden" value="0" class="text" />

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div id="tab" class="btn-group" data-toggle="buttons-radio">
                <a href="#TabTransaction" class="btn" data-toggle="tab" id="tab1">Transaction</a>
                <a href="#TabMasterFiles" class="btn" data-toggle="tab" id="tab2">Master Files</a>
            </div>

            <br />

            <br />

            <div class="tab-content">
            </div>

        </div>
    </div>
</asp:Content>
