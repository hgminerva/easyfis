<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstAccountCashFlowDetail.aspx.cs" Inherits="wfmis.View.MstAccountCashFlowDetail" %>

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
        // Account Cash Flow Model
        var $koAccountCashFlowModel;
        $koNamespace.initAccountCashFlow = function (AccountCashFlow) {
            var self = this;

            self.Id = ko.observable(!AccountCashFlow ? $Id : AccountCashFlow.Id);
            self.AccountCashFlowCode = ko.observable(!AccountCashFlow ? "" : AccountCashFlow.AccountCashFlowCode);
            self.AccountCashFlow = ko.observable(!AccountCashFlow ? "" : AccountCashFlow.AccountCashFlow);
            self.IsLocked = ko.observable(!AccountCashFlow ? false : AccountCashFlow.IsLocked);
            self.CreatedById = ko.observable(!AccountCashFlow ? $CurrentUserId : AccountCashFlow.CreatedById);
            self.CreatedBy = ko.observable(!AccountCashFlow ? $CurrentUser : AccountCashFlow.CreatedBy);
            self.CreatedDateTime = ko.observable(!AccountCashFlow ? "" : AccountCashFlow.CreatedDateTime);
            self.UpdatedById = ko.observable(!AccountCashFlow ? $CurrentUserId : AccountCashFlow.UpdatedById);
            self.UpdatedBy = ko.observable(!AccountCashFlow ? $CurrentUser : AccountCashFlow.UpdatedBy);
            self.UpdatedDateTime = ko.observable(!AccountCashFlow ? "" : AccountCashFlow.UpdatedDateTime);

            return self;
        };
        $koNamespace.bindAccountCashFlow = function (AccountCashFlow) {
            var viewModel = $koNamespace.initAccountCashFlow(AccountCashFlow);
            ko.applyBindings(viewModel, $("#AccountCashFlowDetail")[0]); 
            $koAccountCashFlowModel = viewModel;
        }
        $koNamespace.getAccountCashFlow = function (Id) {
            if (!Id) {
                $koNamespace.bindAccountCashFlow(null);
            } else {
                $.getJSON("/api/MstAccountCashFlow/" + Id + "/AccountCashFlow", function (data) {
                    $koNamespace.bindAccountCashFlow(data);
                });
            }
        }
        // Events
        function cmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/MstAccountCashFlow',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koAccountCashFlowModel),
                        success: function (data) {
                            location.href = 'MstAccountCashFlowDetail.aspx?Id=' + data.Id;
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
                            url: '/api/MstAccountCashFlow/' + $Id,
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koAccountCashFlowModel),
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
            if ($Id != "") {
                $koNamespace.getAccountCashFlow($Id);
            } else {
                $koNamespace.getAccountCashFlow(null);
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
            <h2>Account Cash Flow Detail</h2>

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

            <section id="AccountCashFlowDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Account Cash Flow Code </label>
                        <div class="controls">
                            <input id="AccountCashFlowCode" type="text" data-bind="value: AccountCashFlowCode" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Account Cash Flow </label>
                        <div class="controls">
                            <input id="AccountCashFlow" type="text" data-bind="value: AccountCashFlow" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

        </div>
    </div>
</asp:Content>
