<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="wfmis.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">

        <div class="container">
         
            <div class="row">
                <h2>Login</h2>
            </div>

            <div class="row">
                <section id="Section1">
                    <asp:Login ID="Login1" runat="server" ViewStateMode="Disabled" RenderOuterTable="false">
                        <LayoutTemplate>
                           
                        <p class="validation-summary-errors">
                            <asp:Literal runat="server" ID="FailureText" />
                        </p>

                        <fieldset>

                        <div class="control-group">
                            <asp:Label ID="Label1" runat="server" AssociatedControlID="UserName">Username</asp:Label>
                            <div class="controls">
                                <asp:TextBox runat="server" ID="UserName" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserName" CssClass="field-validation-error" ErrorMessage="The user name field is required." />
                            </div>
                        </div>
                            
                        <div class="control-group">
                            <asp:Label ID="Label2" runat="server" AssociatedControlID="Password">Password</asp:Label>
                            <div class="controls">
                                <asp:TextBox runat="server" ID="Password" TextMode="Password" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Password" CssClass="field-validation-error" ErrorMessage="The password field is required." />
                            </div>
                        </div>

                        <div class="control-group">
                            <div class="controls">
                                <asp:CheckBox runat="server" ID="RememberMe" /> Remember me?
                            </div>
                        </div>

                        <asp:Button ID="Button1" runat="server" CommandName="Login" Text="Login" class="btn btn-primary"/>

                        </fieldset>

                        </LayoutTemplate>
                        
                    </asp:Login>

                </section>
            </div>
            <br />
            <div class="row">
                <p>
                    <asp:HyperLink runat="server" ID="RegisterHyperLink" ViewStateMode="Disabled">Register</asp:HyperLink>
                    if you don't have an account.
                </p>
            </div>

        </div>

    </div>

</asp:Content>