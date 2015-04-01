<%@ Page Title="Register" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="wfmis.Account.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <div id="main-content">

      <div class="container">
         
          <div class="row">
             <h2>Register</h2>
         </div>

          <div class="row">

                <asp:CreateUserWizard runat="server" ID="RegisterUser" ViewStateMode="Disabled" OnCreatingUser="RegisterUser_CreatingUser" OnCreatedUser="RegisterUser_CreatedUser">
                    <LayoutTemplate>
                        <asp:PlaceHolder runat="server" ID="wizardStepPlaceholder" />
                        <asp:PlaceHolder runat="server" ID="navigationPlaceholder" />
                    </LayoutTemplate>

                    <WizardSteps>
                        <asp:CreateUserWizardStep runat="server" ID="RegisterUserWizardStep">
                            <ContentTemplate>

                                <p class="validation-summary-errors">
                                    <asp:Literal runat="server" ID="ErrorMessage" />
                                    <asp:Label id="CustomErrorMessage" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                                </p>

                                <fieldset>

                                    <div class="control-group">
                                        <!-- Username -->
                                        <asp:Label ID="Label1" runat="server" AssociatedControlID="UserName">User name</asp:Label>
                                        <div class="controls">
                                            <asp:TextBox runat="server" ID="UserName" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="UserName" 
                                                CssClass="field-validation-error" ErrorMessage="The user name field is required." />
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <!-- E-mail -->
                                        <asp:Label ID="Label2" runat="server" AssociatedControlID="Email">Email address</asp:Label>
                                        <div class="controls">
                                            <asp:TextBox runat="server" ID="Email" TextMode="Email" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Email" 
                                                CssClass="field-validation-error" ErrorMessage="The email address field is required." />
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <!-- Password -->
                                        <asp:Label ID="Label3" runat="server" AssociatedControlID="Password">Password</asp:Label>
                                        <div class="controls">
                                            <asp:TextBox runat="server" ID="Password" TextMode="Password" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="Password"
                                                CssClass="field-validation-error" ErrorMessage="The password field is required." />
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <!-- Confirm Password -->
                                        <asp:Label ID="Label4" runat="server" AssociatedControlID="ConfirmPassword">Confirm password</asp:Label>
                                        <div class="controls">
                                            <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ConfirmPassword"
                                                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The confirm password field is required." />
                                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                                                    CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The password and confirmation password do not match." />
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <!-- Captcha -->
                                        <img src="JpegImage.aspx" />
                                        <br/><br/>
                                        <asp:Label ID="Label5" runat="server" AssociatedControlID="Password">Code</asp:Label>
                                        <div class="controls">
                                            <asp:TextBox id="CodeNumberTextBox" runat="server"></asp:TextBox>
                                            <asp:Label id="MessageLabel" runat="server"></asp:Label>
                                        </div>
                                    </div>

                                    <div class="control-group">
                                        <asp:Button ID="Button1" runat="server" CommandName="MoveNext" Text="Register" class="btn btn-primary"/>
                                    </div>

                                </fieldset>
                            </ContentTemplate>
                        <CustomNavigationTemplate />
                    </asp:CreateUserWizardStep>
                </WizardSteps>
            </asp:CreateUserWizard>
        </div>

      </div>

    </div>

</asp:Content>