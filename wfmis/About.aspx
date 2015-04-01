<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="wfmis.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <div class="row">
                <h2>About</h2>
                <%--<hr />--%>
                <img src="Images/about.jpg" alt="about" />
                <%--<hr />--%>
                <br />
                <br />
                <div class="span8">
                    <p><b>EasyFIS.com</b></p>
                    <br />
                    <p>EasyFIS is a multi-tenant cloud-based Software-as-a-Service (SaaS) business app that caters to micro, small and medium trading businesses.</p>  
                    <p>You can manage your sales, purchases, disbursements, collections, warehouse inventories, banks and financials in the cloud using any device.</p>
                    <p><b>Sales</b></p>
                    <p>
                        You can perform customer orders and invoices of products and services in the cloud.<br />
                        You are provided with the list of products with its on-hand inventory in real-time.<br />
                        Automated posting of Accounts Receivable (AR), Journal Entries and Inventory.<br />
                        In-line tax computation.<br />
                        Comprehensive discounting.<br />
                    </p>
                    <p><b>Purchases</b></p>
                    <p>
                        You can perform supplier orders and invoices of your expenses in the cloud.<br />
                        Automated posting of Accounts Payable (AP), Journal Entries and Inventory.<br />
                        Automated inventory batch cost posting of products.<br />
                        In-line tax computation.<br />
                        Provides you with an order status report.<br />
                    </p>
                    <p><b>Warehouse Inventory</b></p>
                    <p>
                        Unlimited warehouse or branch creation.<br />
                        You can perform stock in and out as well as transfer of products from one warehouse or branch to another.<br />
                        You can perform consignment procedures.<br />
                    </p>
                    <p><b>Product Management</b></p>
                    <p>
                        Allows multiple product prices, e.g., SRP, Wholesale, etc.<br />
                        Allows multiple units of measure.<br />
                        You can perform product ingredients and components.<br />
                    </p>
                    <p><b>Bank Management</b></p>
                    <p>
                        Unlimited bank creation.<br />
                        Automated posting of deposit and withdrawal from collection and disbursement.<br />
                        Real-time bank reconciliation report.<br />
                    </p>
                    <p><b>Financials</b></p>
                    <p>
                        Real-time Balance Sheet and Income Statement report per branch or consolidated.<br />
                        Drill down report from Trial Balance to Ledger and then to the transaction itself.<br />
                        You can perform comprehensive account adjustments through Journal Voucher.<br />
                    </p>
                    <p><b>Mutli-user Setup</b></p>
                    <p>
                        If you have multiple user and staff, you can give rights and access to your company.<br />
                        Unlimited user registration.<br />
                        Automated transaction tagging of user, e.g., who first created the transaction and who last updated it.<br />
                    </p>
                    <p><b>What are you waiting for?</b></p>
                    <p>
                        Contact us for a demo. +63 32 2663773<br />
                    </p>
                </div>
                <div class="span4">
                    <div><p><a class="btn btn-primary" href="/Account/Register.aspx">Register</a> an account for <strong>FREE!</strong></p></div>
                    <div class="alert alert-info">
                        <p><b>News:</b></p>
                        <p>We are still on testing phase.  For inquiries you can call directly Innosoft @ +63 32 2663773</p>
                        <p><a href="http://www.innosoft.ph">www.innosoft.ph</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>