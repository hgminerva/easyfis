<%@ Page Title="Manage Account" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="Manage.aspx.cs" Inherits="wfmis.Account.Manage" %>
<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Date Picker--%>
    <link href="../Content/bootstrap-datepicker/datepicker.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-datepicker/bootstrap-datepicker.js"></script>
    <%--Select2--%>
    <link href="../Content/bootstrap-select2/select2.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-select2/select2.js"></script>
    <%--Knockout--%>
    <script type='text/javascript' src="../Scripts/knockout/knockout-2.3.0.js"></script>
    <script type='text/javascript' src="../Scripts/knockout/json2.js"></script>
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_v1.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" />
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v3.js"></script>
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        var $Id = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $koNamespace = {};
        var $selectPageSize = 20;

        // User Model (Detail)
        var $koUserModel;
        $koNamespace.initUser = function (User) {
            var self = this;

            self.Id = ko.observable(!User ? $Id : User.Id);
            self.UserAccountNumber = ko.observable(!User ? "" : User.UserAccountNumber);
            self.FullName = ko.observable(!User ? "" : User.FullName);
            self.Address = ko.observable(!User ? "" : User.Address);
            self.ContactNumber = ko.observable(!User ? "" : User.ContactNumber);
            self.EmailAddress = ko.observable(!User ? "" : User.EmailAddress);
            self.DefaultBranchId = ko.observable(!User ? 0 : User.DefaultBranchId);
            self.DefaultBranch = ko.observable(!User ? "": User.DefaultBranch);
            self.DefaultPeriodId = ko.observable(!User ? 0 : User.IdDefaultPeriodId);
            self.DefaultPeriod = ko.observable(!User ? "" : User.DefaultPeriod);
            self.IsTemplate = ko.observable(!User ? false : User.IsTemplate);
            self.Particulars = ko.observable(!User ? "" : User.Particulars);
            self.FSIncomeStatementAccountId = ko.observable(!User ? 0 : User.IdFSIncomeStatementAccountId);
            self.FSIncomeStatementAccount = ko.observable(!User ? "" : User.FSIncomeStatementAccount);
            self.SupplierAccountId = ko.observable(!User ? 0 : User.SupplierAccountId);
            self.SupplierAccount = ko.observable(!User ? "" : User.SupplierAccount);
            self.CustomerAccountId = ko.observable(!User ? 0 : User.CustomerAccountId);
            self.CustomerAccount = ko.observable(!User ? "": User.CustomerAccount);
            self.ItemPurchaseAccountId = ko.observable(!User ? 0 : User.ItemPurchaseAccountId);
            self.ItemPurchaseAccount = ko.observable(!User ? "" : User.ItemPurchaseAccount);
            self.ItemSalesAccountId = ko.observable(!User ? 0 : User.ItemSalesAccountId);
            self.ItemSalesAccount = ko.observable(!User ? "" : User.ItemSalesAccount);
            self.ItemCostAccountId = ko.observable(!User ? 0 : User.ItemCostAccountId);
            self.ItemCostAccount = ko.observable(!User ? "" : User.ItemCostAccount);
            self.ItemAssetAccountId = ko.observable(!User ?0 : User.ItemAssetAccountId);
            self.ItemAssetAccount = ko.observable(!User ? "" : User.ItemAssetAccount);
            self.IsAutoInventory = ko.observable(!User ? false : User.IsAutoInventory);
            self.TemplateUserId = ko.observable(!User ? 0 : User.TemplateUserId);
            self.TemplateUser = ko.observable(!User ? "" : User.TemplateUser);
            self.InventoryValuationMethod = ko.observable(!User ? "SPECIFIC" : User.InventoryValuationMethod);

            // Select2 defaults
            $('#DefaultBranch').select2('data', { id: !User ? 0 : User.DefaultBranchId, text: !User ? "" : User.DefaultBranch });
            $('#DefaultPeriod').select2('data', { id: !User ? 0 : User.DefaultPeriodId, text: !User ? "" : User.DefaultPeriod });
            $('#TemplateUser').select2('data', { id: !User ? 0 : User.TemplateUserId, text: !User ? "" : User.TemplateUser });
            $('#FSIncomeStatementAccount').select2('data', { id: !User ? 0 : User.FSIncomeStatementAccountId, text: !User ? "" : User.FSIncomeStatementAccount });
            $('#SupplierAccount').select2('data', { id: !User ? 0 : User.SupplierAccountId, text: !User ? "" : User.SupplierAccount });
            $('#CustomerAccount').select2('data', { id: !User ? 0 : User.CustomerAccountId, text: !User ? "" : User.CustomerAccount });
            $('#ItemPurchaseAccount').select2('data', { id: !User ? 0 : User.ItemPurchaseAccountId, text: !User ? "" : User.ItemPurchaseAccount });
            $('#ItemSalesAccount').select2('data', { id: !User ? 0 : User.ItemSalesAccountId, text: !User ? "" : User.ItemSalesAccount });
            $('#ItemCostAccount').select2('data', { id: !User ? 0 : User.ItemCostAccountId, text: !User ? "" : User.ItemCostAccount });
            $('#ItemAssetAccount').select2('data', { id: !User ? 0 : User.ItemAssetAccountId, text: !User ? "" : User.ItemAssetAccount });
            $('#InventoryValuationMethod').select2('data', { id: !User ? "SPECIFIC" : User.InventoryValuationMethod, text: !User ? "SPECIFIC" : User.InventoryValuationMethod });
            // Checkbox defaults
            $("#IsTemplate").prop("checked", !User ? false : User.IsTemplate);
            $("#IsAutoInventory").prop("checked", !User ? false : User.IsAutoInventory);

            return self;
        }
        $koNamespace.bindUser = function (User) {
            var viewModel = $koNamespace.initUser(User);
            ko.applyBindings(viewModel);
            $koUserModel = viewModel;
        }
        $koNamespace.getUser = function (Id) {
            if (!Id) {
                $koNamespace.bindUser(null);
            } else {
                $.getJSON("/api/MstUser/" + Id + "/User", function (data) {
                    $koNamespace.bindUser(data);

                    RenderCompanyTable();
                });
            }
        }

        // Render Table
        function RenderCompanyTable() {
            var CompanyTable = $("#CompanyTable").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstCompany',
                "sAjaxDataProp": "MstCompanyData",
                "bProcessing": true,
                "bLengthChange": false,
                "iDisplayLength": 20,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<input runat="server" id="CmdEditCompany" type="button" class="btn btn-primary" value="Edit"/>'
                            }
                        },
                        { "mData": "CompanyCode", "sWidth": "120px" },
                        { "mData": "Company" }]
            }).fnSort([[2, 'asc']]);
        }

        // Events
        function CmdSave_onclick() {
            if (confirm('Update information?')) {
                if ($Id != "") {
                    $.ajax({
                        url: '/api/MstUser/' + $Id + '/Info',
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koUserModel),
                        success: function (data) {
                            alert("Record updated successfully!");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }
        function CmdSaveDefaultValues_onclick() {
            if (confirm('Update defaults?')) {
                if ($Id != "") {
                    $.ajax({
                        url: '/api/MstUser/' + $Id + '/Default',
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koUserModel),
                        success: function (data) {
                            alert("Record updated successfully!");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }
        function CmdChangeTemplate_onclick() {
            if (confirm('Update template?')) {
                if ($Id != "") {
                    $.ajax({
                        url: '/api/MstUser/' + $Id + '/Template',
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koUserModel),
                        success: function (data) {
                            alert("Record updated successfully!");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }
        function CmdEditCompany_onclick(Id) {
            if (Id > 0) {
                location.href = '/View/MstCompanyDetail.aspx?Id=' + Id;
            }
        }

        // Select2 controls
        function Select2_DefaultPeriod() {
            var BranchId = $('#DefaultBranchId').val() == "" ? 0 : $('#DefaultBranchId').val();
            $('#DefaultPeriod').select2({
                placeholder: 'Period',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectDefaultPeriod?BranchId=' + BranchId,
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#DefaultPeriodId').val($('#DefaultPeriod').select2('data').id).change();
            });
        }
        function Select2_DefaultBranch() {
            $('#DefaultBranch').select2({
                placeholder: 'Branch',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectDefaultBranch?UserStaffId=' + $Id,
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#DefaultBranchId').val($('#DefaultBranch').select2('data').id).change();
                
                Select2_DefaultPeriod();
                $('#DefaultPeriod').select2('data', { id: 0, text: "" });
            });
        }
        function Select2_TemplateUser() {
            $('#TemplateUser').select2({
                placeholder: 'Template',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectTemplate',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#TemplateUserId').val($('#TemplateUser').select2('data').id).change();
            });
        }
        function select2_FSIncomeStatementAccount() {
            $('#FSIncomeStatementAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#FSIncomeStatementAccountId').val($('#FSIncomeStatementAccount').select2('data').id).change();
            });
        }
        function select2_SupplierAccount() {
            $('#SupplierAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#SupplierAccountId').val($('#SupplierAccount').select2('data').id).change();
            });
        }
        function select2_CustomerAccount() {
            $('#CustomerAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#CustomerAccountId').val($('#CustomerAccount').select2('data').id).change();
            });
        }
        function select2_ItemPurchaseAccount() {
            $('#ItemPurchaseAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ItemPurchaseAccountId').val($('#ItemPurchaseAccount').select2('data').id).change();
            });
        }
        function select2_ItemSalesAccount() {
            $('#ItemSalesAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ItemSalesAccountId').val($('#ItemSalesAccount').select2('data').id).change();
            });
        }
        function select2_ItemCostAccount() {
            $('#ItemCostAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ItemCostAccountId').val($('#ItemCostAccount').select2('data').id).change();
            });
        }
        function select2_ItemAssetAccount() {
            $('#ItemAssetAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ItemAssetAccountId').val($('#ItemAssetAccount').select2('data').id).change();
            });
        }
        function select2_InventoryValuationMethod() {
            $('#InventoryValuationMethod').select2({
                data: [
                    { id: "SPECIFIC", text: "SPECIFIC" },
                    { id: "AVERAGE", text: "AVERAGE" }
                ]
            });
        }

        // On Page Load
        $(document).ready(function () {
            // Select2 controls
            Select2_DefaultPeriod();
            Select2_DefaultBranch();
            Select2_TemplateUser();
            select2_FSIncomeStatementAccount();
            select2_SupplierAccount();
            select2_CustomerAccount();
            select2_ItemPurchaseAccount();
            select2_ItemSalesAccount();
            select2_ItemCostAccount();
            select2_ItemAssetAccount();
            select2_InventoryValuationMethod();

            if ($Id != "") {
                $koNamespace.getUser($Id);
            } else {
                $koNamespace.getUser(null);
            }

            $("#CompanyTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#CompanyTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditCompany") > 0) CmdEditCompany_onclick(Id);
            });
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">

            <h2>Settings</h2>

            <div id="loading-indicator-modal" class="modal hide fade in" style="display: none;">
                <div class="modal-body">
                    <div class="text-center" style="height:20px">
                        Please wait.  Contacting server: <img src="/Images/progress_bar.gif" id="loading-indicator"/>
                    </div>
                </div>
            </div>

            <section id="passwordForm">
            <div class="row-fluid">
                <div class="span6">
                    <asp:PlaceHolder runat="server" ID="successMessage" Visible="false" ViewStateMode="Disabled">
                        <p class="message-success"><%: SuccessMessage %></p>
                    </asp:PlaceHolder>

                    <h4>You're logged in as <strong><%: User.Identity.Name %></strong>.</h4>

                    <div class="control-group">
                        <label class="control-label">Account Number</label>
                        <div class="controls">
                            <input id="UserAccountNumber" type="text" data-bind="value: UserAccountNumber" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Full Name</label>
                        <div class="controls">
                            <input id="FullName" type="text" data-bind="value: FullName" class="input-large" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Address</label>
                        <div class="controls">
                            <textarea id="Address" rows="3" data-bind="value: Address" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Contact Numbers</label>
                        <div class="controls">
                            <input id="ContactNumber" type="text" data-bind="value: ContactNumber" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Email Address</label>
                        <div class="controls">
                            <input id="EmailAddress" type="text" data-bind="value: EmailAddress" class="input-xlarge" />
                        </div>
                    </div>

                    <button type="button" class="btn btn-primary" onclick="CmdSave_onclick()">Save</button>
                </div>

                <div class="span6">
                    <asp:PlaceHolder runat="server" ID="setPassword" Visible="false">
                        <p>
                            You do not have a local password for this site. Add a local
                            password so you can log in without an external login.
                        </p>
                        <fieldset>
                            <legend>Set Password Form</legend>
                            <ol>
                                <li>
                                    <asp:Label ID="Label1" runat="server" AssociatedControlID="password">Password</asp:Label>
                                    <asp:TextBox runat="server" ID="password" TextMode="Password" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="password"
                                        CssClass="field-validation-error" ErrorMessage="The password field is required."
                                        Display="Dynamic" ValidationGroup="SetPassword" />
                        
                                    <asp:ModelErrorMessage ID="ModelErrorMessage1" runat="server" ModelStateKey="NewPassword" AssociatedControlID="password"
                                        CssClass="field-validation-error" SetFocusOnError="true" />
                        
                                </li>
                                <li>
                                    <asp:Label ID="Label2" runat="server" AssociatedControlID="confirmPassword">Confirm password</asp:Label>
                                    <asp:TextBox runat="server" ID="confirmPassword" TextMode="Password" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="confirmPassword"
                                        CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The confirm password field is required."
                                        ValidationGroup="SetPassword" />
                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="Password" ControlToValidate="confirmPassword"
                                        CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The password and confirmation password do not match."
                                        ValidationGroup="SetPassword" />
                                </li>
                            </ol>
                            <asp:Button ID="Button1" runat="server" Text="Set Password" ValidationGroup="SetPassword" OnClick="setPassword_Click" />
                        </fieldset>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder runat="server" ID="changePassword" Visible="false">
                        <h4>Change password</h4>
                        <asp:ChangePassword ID="ChangePassword1" runat="server" CancelDestinationPageUrl="~/" ViewStateMode="Disabled" RenderOuterTable="false" SuccessPageUrl="Manage.aspx?m=ChangePwdSuccess">
                            <ChangePasswordTemplate>
                                <p class="validation-summary-errors">
                                    <asp:Literal runat="server" ID="FailureText" />
                                </p>
                                <fieldset class="changePassword">
                                    <div class="control-group">
                                        <asp:Label runat="server" ID="CurrentPasswordLabel" AssociatedControlID="CurrentPassword">Current password</asp:Label>
                                        <asp:TextBox runat="server" ID="CurrentPassword" CssClass="passwordEntry" TextMode="Password" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="CurrentPassword"
                                            CssClass="field-validation-error" ErrorMessage="The current password field is required."
                                            ValidationGroup="ChangePassword" />
                                    </div>
                                    <div class="control-group">
                                        <asp:Label runat="server" ID="NewPasswordLabel" AssociatedControlID="NewPassword">New password</asp:Label>
                                        <asp:TextBox runat="server" ID="NewPassword" CssClass="passwordEntry" TextMode="Password" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="NewPassword"
                                            CssClass="field-validation-error" ErrorMessage="The new password is required."
                                            ValidationGroup="ChangePassword" />
                                    </div>
                                    <div class="control-group">
                                        <asp:Label runat="server" ID="ConfirmNewPasswordLabel" AssociatedControlID="ConfirmNewPassword">Confirm new password</asp:Label>
                                        <asp:TextBox runat="server" ID="ConfirmNewPassword" CssClass="passwordEntry" TextMode="Password" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ConfirmNewPassword"
                                            CssClass="field-validation-error" Display="Dynamic" ErrorMessage="Confirm new password is required."
                                            ValidationGroup="ChangePassword" />
                                    </div>
                                    <div class="control-group">
                                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword"
                                            CssClass="field-validation-error" Display="Dynamic" ErrorMessage="The new password and confirmation password do not match."
                                            ValidationGroup="ChangePassword" />
                                    </div>
                                    <asp:Button ID="Button2" runat="server" CommandName="ChangePassword" Text="Change password" ValidationGroup="ChangePassword" class="btn btn-primary" />
                                </fieldset>
                            </ChangePasswordTemplate>
                        </asp:ChangePassword>
                        <br />
                        <h4>Change template</h4>
                        <div class="control-group">
                            <label class="control-label">Template</label>
                            <div class="controls">
                                <input id="TemplateUserId" type="hidden" data-bind="value: TemplateUserId" class="input-medium" />
                                <input id="TemplateUser" type="text" data-bind="value: TemplateUser" class="input-xlarge" disabled="disabled" />
                            </div>
                        </div>
                        <button type="button" class="btn btn-primary" onclick="CmdChangeTemplate_onclick()" disabled="disabled">Change template</button>
                    </asp:PlaceHolder>
                </div>
            </div>
            </section>

            <br />

            <div id="tab" class="btn-group" data-toggle="buttons-radio">
              <a href="#tabDefaultValues" class="btn" data-toggle="tab" id="tab1">Default Values</a>
              <a href="#tabCompany" class="btn" data-toggle="tab" id="tab2">Companies / Businesses</a>
            </div>

            <br />

            <br />

            <div class="tab-content">
                <div class="tab-pane active" id="tabDefaultValues">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Default Branch</label>
                                <div class="controls">
                                    <input id="DefaultBranchId" type="hidden" data-bind="value: DefaultBranchId" class="input-medium" />
                                    <input id="DefaultBranch" type="text" data-bind="value: DefaultBranch" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Default Period</label>
                                <div class="controls">
                                    <input id="DefaultPeriodId" type="hidden" data-bind="value: DefaultPeriodId" class="input-medium" />
                                    <input id="DefaultPeriod" type="text" data-bind="value: DefaultPeriod" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Is Template</label>
                                <div class="controls">
                                    <input id="IsTemplate" type="checkbox" data-bind="checked: IsTemplate" class="input-large" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Is Auto Inventory</label>
                                <div class="controls">
                                    <input id="IsAutoInventory" type="checkbox" data-bind="checked: IsAutoInventory" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">FS Income Statement Account</label>
                                <div class="controls">
                                    <input id="FSIncomeStatementAccountId" type="hidden" data-bind="value: FSIncomeStatementAccountId" class="input-medium" />
                                    <input id="FSIncomeStatementAccount" type="text" data-bind="value: FSIncomeStatementAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Supplier Account</label>
                                <div class="controls">
                                    <input id="SupplierAccountId" type="hidden" data-bind="value: SupplierAccountId" class="input-medium" />
                                    <input id="SupplierAccount" type="text" data-bind="value: SupplierAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Customer Account</label>
                                <div class="controls">
                                    <input id="CustomerAccountId" type="hidden" data-bind="value: CustomerAccountId" class="input-medium" />
                                    <input id="CustomerAccount" type="text" data-bind="value: CustomerAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <button type="button" class="btn btn-primary" onclick="CmdSaveDefaultValues_onclick()">Save Default Values</button>
                        </div>
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Particulars</label>
                                <div class="controls">
                                    <textarea id="Particulars" rows="3" data-bind="value: Address" class="input-block-level"></textarea>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Item Upon Purchase Account</label>
                                <div class="controls">
                                    <input id="ItemPurchaseAccountId" type="hidden" data-bind="value: ItemPurchaseAccountId" class="input-medium" />
                                    <input id="ItemPurchaseAccount" type="text" data-bind="value: ItemPurchaseAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Item Upon Sales Account</label>
                                <div class="controls">
                                    <input id="ItemSalesAccountId" type="hidden" data-bind="value: ItemSalesAccountId" class="input-medium" />
                                    <input id="ItemSalesAccount" type="text" data-bind="value: ItemSalesAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Item Upon Sales Account (Cost)</label>
                                <div class="controls">
                                    <input id="ItemCostAccountId" type="hidden" data-bind="value: ItemCostAccountId" class="input-medium" />
                                    <input id="ItemCostAccount" type="text" data-bind="value: ItemCostAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Item Asset Account</label>
                                <div class="controls">
                                    <input id="ItemAssetAccountId" type="hidden" data-bind="value: ItemAssetAccountId" class="input-medium" />
                                    <input id="ItemAssetAccount" type="text" data-bind="value: ItemAssetAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Inventory Valuation Method</label>
                                <div class="controls">
                                    <input id="InventoryValuationMethod" type="text" data-bind="value: InventoryValuationMethod" class="input-xlarge" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane" id="tabCompany">
                    <div class="row-fluid">
                        <table id="CompanyTable" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Code</th>
                                    <th>Company</th>
                                </tr>
                            </thead>
                            <tbody id="CompanyTableBody"></tbody>
                            <tfoot>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
   </div>
</asp:Content>
