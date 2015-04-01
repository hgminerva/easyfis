<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstTaxDetail.aspx.cs" Inherits="wfmis.View.MstTaxDetail" %>

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
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8">
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $Id = 0;
        var $koNamespace = {};
        var $pageSize = 20;

        // Bindings
        var $koTax;
        $koNamespace.initTax = function (Tax) {
            var self = this;

            self.Id = ko.observable(!Tax ? 0 : Tax.Id);
            self.UserId = ko.observable(!Tax ? $CurrentUserId : Tax.UserId);
            self.TaxCode = ko.observable(!Tax ? "" : Tax.TaxCode);
            self.TaxTypeId = ko.observable(!Tax ? 0 : Tax.TaxTypeId);
            self.TaxType = ko.observable(!Tax ? "" : Tax.TaxType);
            self.TaxRate = ko.observable(!Tax ? 0 : Tax.TaxRate);
            self.AccountId = ko.observable(!Tax ? 0 : Tax.AccountId);
            self.Account = ko.observable(!Tax ? "" : Tax.Account);

            $('#TaxType').select2('data', { id: !Tax ? 0 : Tax.TaxTypeId, text: !Tax ? "" : Tax.TaxType });
            $('#Account').select2('data', { id: !Tax ? 0 : Tax.AccountId, text: !Tax ? "" : Tax.Account });

            return self;
        };
        $koNamespace.bindTax = function (Tax) {
            var viewModel = $koNamespace.initTax(Tax);
            ko.applyBindings(viewModel, $("#TaxDetail")[0]);
            $koTax = viewModel;
        };
        $koNamespace.getTax = function (Id) {
            if (!Id) {
                $koNamespace.bindTax(null);
            } else {
                // Render Tax
                $.getJSON("/api/MstTax/" + Id + "/Tax", function (data) {
                    $koNamespace.bindTax(data);
                });
            }
        };

        // Events
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                if (confirm('Update Tax?')) {
                    $.ajax({
                        url: '/api/MstTax/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koTax),
                        success: function (data) {
                            location.href = 'MstTaxDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                if (confirm('Save Tax?')) {
                    $.ajax({
                        url: '/api/MstTax',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koTax),
                        success: function (data) {
                            location.href = 'MstTaxDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdClose_onclick() {
            location.href = 'SysFolders.aspx';
        }

        // Select2
        function Select2_TaxType() {
            $('#TaxType').select2({
                placeholder: 'Tax Type',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectTaxType',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $koTax['TaxTypeId']($('#TaxType').select2('data').id);
            });
        }
        function Select2_Account() {
            $('#Account').select2({
                placeholder: 'Account',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectAccount',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $koTax['AccountId']($('#Account').select2('data').id);
            });
        }

        // Page Load
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            Select2_TaxType();
            Select2_Account();

            // Numbers
            $('#TaxRate').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            // Fill the page with data
            if ($Id != "") {
                $koNamespace.getTax($Id);
            } else {
                $koNamespace.getTax(null);
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

            <h2>Tax Detail</h2>

            <input runat="server" id="PageName" type="hidden" value="" class="text" />
            <input runat="server" id="PageCompanyId" type="hidden" value="0" class="text" />
            <input runat="server" id="PageId" type="hidden" value="0" class="text" />

            <p><asp:SiteMapPath ID="SiteMapPath1" runat="server"></asp:SiteMapPath></p>

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
                        <input runat="server" id="CmdSave" type="button" class="btn btn-primary" value="Save" onclick="CmdSave_onclick()"/>
                        <input runat="server" id="CmdClose" type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()"/>
                    </div>
                </div>
            </div>

            <section id="TaxDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label for="Unit" class="control-label">Tax Code</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="TaxCode" data-bind="value: TaxCode" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Unit" class="control-label">Tax Type</label>
                        <div class="controls">
                            <input id="TaxTypeId" type="hidden" data-bind="value: TaxTypeId" disabled="disabled" />
                            <input id="TaxType" data-bind="value: TaxType" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="TaxRate" class="control-label">Rate (%)</label>
                        <div class="controls">
                            <input id="TaxRate" data-bind="value: TaxRate" type="text" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Account" class="control-label">Account</label>
                        <div class="controls">
                            <input id="AccountId" type="hidden" data-bind="value: AccountId" disabled="disabled" />
                            <input id="Account" data-bind="value: Account" type="text" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

        </div>
    </div>
</asp:Content>
