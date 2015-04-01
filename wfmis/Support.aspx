<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="Support.aspx.cs" Inherits="wfmis.Support1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <div class="row">
                <h2>Support</h2>
                <%--<hr />--%>
                <img src="Images/support.jpg" alt="support" />
                <%--<hr />--%>
                <br />
                <br />
                <div class="span8">
                    <p><b>Annual Subscription Support</b></p>
                    <br />
                    <ul>
                        <li>Telephone Call, Call Ticket, Forum</li>
                        <li>One-hour response time</li>
                        <li>Remote support, e.g., Teamviewer, Logmein, etc.</li>
                        <li>Deployment of on-site technical support if necessary </li>
                    </ul>
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
