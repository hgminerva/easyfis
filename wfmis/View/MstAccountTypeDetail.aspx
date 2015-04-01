<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstAccountTypeDetail.aspx.cs" Inherits="wfmis.View.MstAccountTypeDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v3.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        // Page variables
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';
        var $Id = 0;
        var $koNamespace = {};
        var $selectPageSize = 20;
        // Account Type Model
        var $koAccountTypeModel;
        $koNamespace.initAccountType = function (AccountType) {
            var self = this;

            self.Id = ko.observable(!AccountType ? $Id : AccountType.Id),
            self.AccountTypeCode = ko.observable(!AccountType ? "" : AccountType.AccountTypeCode),
            self.AccountType = ko.observable(!AccountType ? "" : AccountType.AccountType),
            self.AccountCategoryId = ko.observable(!AccountType ? 0 : AccountType.AccountCategoryId),
            self.AccountCategory = ko.observable(!AccountType ? "" : AccountType.AccountCategory),
            self.IsLocked = ko.observable(!AccountType ? false : AccountType.IsLocked),
            self.CreatedById = ko.observable(!AccountType ? $CurrentUserId : AccountType.CreatedById),
            self.CreatedBy = ko.observable(!AccountType ? $CurrentUser : AccountType.CreatedBy),
            self.CreatedDateTime = ko.observable(!AccountType ? "" : AccountType.CreatedDateTime),
            self.UpdatedById = ko.observable(!AccountType ? $CurrentUserId : AccountType.UpdatedById),
            self.UpdatedBy = ko.observable(!AccountType ? $CurrentUser : AccountType.UpdatedBy),
            self.UpdatedDateTime = ko.observable(!AccountType ? "" : AccountType.UpdatedDateTime),

            // Select2 defaults
            $('#AccountCategory').select2('data', { id: !AccountType ? 0 : AccountType.AccountCategoryId, text: !AccountType ? "" : AccountType.AccountCategory });

            return self;
        };
        $koNamespace.bindAccountType = function (AccountType) {
            var viewModel = $koNamespace.initAccountType(AccountType);
            ko.applyBindings(viewModel, $("#AccountTypeDetail")[0]); //Bind the section #AccountTypeDetail
            $koAccountTypeModel = viewModel;
        }
        $koNamespace.getAccountType = function (Id) {
            if (!Id) {
                $koNamespace.bindAccountType(null);
            } else {
                // Render Account Type
                $.getJSON("/api/MstAccountType/" + Id + "/AccountType", function (data) {
                    $koNamespace.bindAccountType(data);
                });
            }
        }
        // Select2 controls
        function select2_AccountCategory() {
            $('#AccountCategory').select2({
                placeholder: 'Account Category',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccountCategory',
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
                $('#AccountCategoryId').val($('#AccountCategory').select2('data').id).change();
            });
        }
        // Events
        function cmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/MstAccountType',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koAccountTypeModel),
                        success: function (data) {
                            location.href = 'MstAccountTypeDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                if (confirm('Update record?')) {
                    $Id = easyFIS.getParameterByName("Id");
                    if ($Id != "") {
                        $.ajax({
                            url: '/api/MstAccountType/' + $Id,
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koAccountTypeModel),
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
        }
        function cmdClose_onclick() {
            location.href = 'MstAccountList.aspx';
        }
        // On Page Load
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Select2 Controls
            select2_AccountCategory();

            // Bind the Page: MstAccount
            if ($Id != "") {
                $koNamespace.getAccountType($Id);
            } else {
                $koNamespace.getAccountType(null);
            }
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
            <h2>Account Type Detail</h2>

            <input runat="server" id="PageName" type="hidden" value="" class="text" />
            <input runat="server" id="PageCompanyId" type="hidden" value="0" class="text" />
            <input runat="server" id="PageId" type="hidden" value="0" class="text" />

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div id="loading-indicator-modal" class="modal hide fade in" style="display: none;">
                <div class="modal-body">
                    <div class="text-center" style="height:20px">
                        Please wait.  Contacting server: <img src="../Images/progress_bar.gif" id="loading-indicator"/>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="span12 text-right">
                    <div class="control-group">
                        <input runat="server" id="CmdSave" type="button" value="Save" class="btn btn-primary" onclick="cmdSave_onclick()" />
                        <input runat="server" id="CmdClose" type="button" value="Close" class="btn btn-danger" onclick="cmdClose_onclick()" />
                    </div>
                </div>
            </div>

            <section id="AccountTypeDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Account Type Code </label>
                        <div class="controls">
                            <input id="AccountTypeCode" type="text" data-bind="value: AccountTypeCode" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Account Type </label>
                        <div class="controls">
                            <input id="AccountType" type="text" data-bind="value: AccountType" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Account Category </label>
                        <div class="controls">
                            <input  id="AccountCategoryId" type="hidden" data-bind="value: AccountCategoryId" class="input-medium" />
                            <input  id="AccountCategory" type="text" data-bind="value: AccountCategory" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

        </div>
    </div>
</asp:Content>
