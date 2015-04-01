<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="SysMenu.aspx.cs" Inherits="wfmis.View.SysMenu" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Main Menu</h2>
            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div class="row">
                <div class="span3"><a class="btn btn-success" href="#"><img src="/Images/buttons/Supplier.png" alt="Supplier" /></a></div>
                <div class="span3"><a class="btn btn-success" href="#"><img src="/Images/buttons/Customer.png" alt="Customer" /></a></div>
                <div class="span3"><a class="btn btn-success" href="#"><img src="/Images/buttons/Item.png" alt="Item" /></a></div>
                <div class="span3"><a class="btn btn-warning" href="#"><img src="/Images/buttons/Settings.png" alt="Settings" /></a></div>
            </div>

            <br />

            <div class="row">
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/PurchaseOrder.png" alt="PO" /></a></div>
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/SalesOrder.png" alt="SO" /></a></div>
                <div class="span3"><a class="btn btn-success" href="MstAccount.aspx"><img src="/Images/buttons/ChartOfAccounts.png" alt="COA" /></a></div>
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/PurchasesReport.png" alt="PurchasesReport" /></a></div>
            </div>
            
            <br />

            <div class="row">
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/PurchaseInvoice.png" alt="PI" /></a></div>
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/SalesInvoice.png" alt="SI" /></a></div>
                <div class="span3"><a class="btn btn-primary" href="TrnJournalVoucherList.aspx"><img src="/Images/buttons/JournalVoucher.png" alt="JV" /></a></div>
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/SalesReport.png" alt="SalesReport" /></a></div>
            </div>

            <br />

            <div class="row">
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/AccountsPayable.png" alt="AP" /></a></div>
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/AccountsReceivable.png" alt="AR" /></a></div>
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/FinancialStatements.png" alt="FS" /></a></div>
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/CollectionReport.png" alt="CollectionReport" /></a></div>
            </div>

            <br />

            <div class="row">
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/Disbursement.png" alt="CV" /></a></div>
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/Collection.png" alt="OR" /></a></div>
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/BankReconciliation.png" alt="BR" /></a></div>
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/DisbursementReport.png" alt="DisbursementReport" /></a></div>
            </div>
            
            <br />

            <div class="row">
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/StockIn.png" alt="StockIn" /></a></div>
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/StockOut.png" alt="StockOut" /></a></div>
                <div class="span3"><a class="btn btn-primary" href="#"><img src="/Images/buttons/StockTransfer.png" alt="StockTransfer" /></a></div>
                <div class="span3"><a class="btn btn-info" href="#"><img src="/Images/buttons/Inventory.png" alt="Inventory" /></a></div>
            </div>

        </div>
    </div>
</asp:Content>
