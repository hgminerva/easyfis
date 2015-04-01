<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstSupplierDetail.aspx.cs" Inherits="wfmis.View.MstSupplierDetail" %>

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
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';
        var $CurrentSupplierAccountId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentSupplierAccountId %>';
        var $CurrentSupplierAccount = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentSupplierAccount %>';
        var $Id = 0;
        var $ArticleId = 0;
        var $koNamespace = {};
        var $pageSize = 20;

        // Bindings
        var $koSupplier;

        $koNamespace.initSupplier = function (Supplier) {
            var self = this;

            self.Id = ko.observable(!Supplier ? 0 : Supplier.Id);
            self.ArticleId = ko.observable(!Supplier ? 0 : Supplier.ArticleId);
            self.SupplierCode = ko.observable(!Supplier ? "" : Supplier.SupplierCode);
            self.Supplier = ko.observable(!Supplier ? "" : Supplier.Supplier);
            self.Address = ko.observable(!Supplier ? "" : Supplier.Address);
            self.ContactNumbers = ko.observable(!Supplier ? "" : Supplier.ContactNumbers);
            self.ContactPerson = ko.observable(!Supplier ? "" : Supplier.ContactPerson);
            self.EmailAddress = ko.observable(!Supplier ? "" : Supplier.EmailAddress);
            self.AccountId = ko.observable(!Supplier ? $CurrentSupplierAccountId : Supplier.AccountId);
            self.Account = ko.observable(!Supplier ? $CurrentSupplierAccount : Supplier.Account);
            self.TermId = ko.observable(!Supplier ? 0 : Supplier.TermId);
            self.Term = ko.observable(!Supplier ? "" : Supplier.Term);
            self.TaxNumber = ko.observable(!Supplier ? "" : Supplier.TaxNumber);

            $('#Account').select2('data', { id: !Supplier ? $CurrentSupplierAccountId : Supplier.AccountId, text: !Supplier ? $CurrentSupplierAccount : Supplier.Account });
            $('#Term').select2('data', { id: !Supplier ? 0 : Supplier.TermId, text: !Supplier ? "" : Supplier.Term });

            return self;
        };
        $koNamespace.bindSupplier = function (Supplier) {
            var viewModel = $koNamespace.initSupplier(Supplier);
            ko.applyBindings(viewModel, $("#SupplierDetail")[0]); //Bind the section #SupplierDetail
            $koSupplier = viewModel;
        };
        $koNamespace.getSupplier = function (Id) {
            if (!Id) {
                $koNamespace.bindSupplier(null);
            } else {
                // Render Supplier
                $.getJSON("/api/MstArticleSupplier/" + Id + "/Supplier", function (data) {
                    $koNamespace.bindSupplier(data);
                    $ArticleId = data.ArticleId;

                    Render_PurchaseInvoiceTable();
                });
            }
        };

        // Events
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                // Existing record (Update)
                if (confirm('Update supplier?')) {
                    $.ajax({
                        url: '/api/MstArticleSupplier/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koSupplier),
                        success: function (data) {
                            location.href = 'MstSupplierDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                // New record (Insert)
                if (confirm('Save supplier?')) {
                    $.ajax({
                        url: '/api/MstArticleSupplier',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koSupplier),
                        success: function (data) {
                            location.href = 'MstSupplierDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdClose_onclick() {
            location.href = 'MstSupplierList.aspx';
        }

        // Select2 controls
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
                $koSupplier['AccountId']($('#Account').select2('data').id);
            });
        }
        function Select2_Term() {
            $('#Term').select2({
                placeholder: 'Term',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectTerm',
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
                $koSupplier['TermId']($('#Term').select2('data').id);
            });
        }

        // Render tables
        function Render_PurchaseInvoiceTable() {
            var PurchaseInvoiceTable = $("#PurchaseInvoiceTable").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/TrnPurchaseInvoice/' + $ArticleId + '/SupplierPurchaseInvoices',
                "sAjaxDataProp": "TrnPurchaseInvoiceData",
                "bProcessing": true,
                "bLengthChange": false,
                "iDisplayLength": 20,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                        { "mData": "PIDate", "sWidth": "120px" },
                        { "mData": "PINumber", "sWidth": "120px" },
                        { "mData": "Particulars" },
                        { "mData": "DocumentReference", "sWidth": "120px" },
                        {
                            "mData": "TotalAmount", "sWidth": "120px", "sClass": "alignRight",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }]
            }).fnSort([[0, 'asc']]);
        }

        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Select2
            Select2_Account();
            Select2_Term();

            // Fill the page with data
            if ($Id != "") {
                $koNamespace.getSupplier($Id);
            } else {
                $koNamespace.getSupplier(null);
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

            <h2>Supplier Detail</h2>

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
                        <input runat="server" id="CmdClose"  type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()"/>
                    </div>
                </div>
            </div>

            <section id="SupplierDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label for="SupplierCode" class="control-label">Supplier Code</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="ArticleId" type="hidden" data-bind="value: ArticleId" disabled="disabled" />
                            <input id="SupplierCode" data-bind="value: SupplierCode" type="text" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Supplier" class="control-label">Supplier</label>
                        <div class="controls">
                            <input id="Supplier" data-bind="value: Supplier" type="text" class="input-xxlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Address" class="control-label">Address</label>
                        <div class="controls">
                            <textarea rows="3" id="Address" data-bind="value: Address" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="ContactNumbers" class="control-label">Contact Numbers</label>
                        <div class="controls">
                            <input  id="ContactNumbers" data-bind="value: ContactNumbers" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="ContactPerson" class="control-label">Contact Person</label>
                        <div class="controls">
                            <input  id="ContactPerson" data-bind="value: ContactPerson" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="EmailAddress" class="control-label">Email Address</label>
                        <div class="controls">
                            <input  id="EmailAddress" type="email" data-bind="value: EmailAddress"  class="input-xlarge" />
                        </div>
                    </div>
                </div>
                <div class="span6">
                    <div class="control-group">
                        <label for="Account" class="control-label">Account</label>
                        <div class="controls">
                            <input id="AccountId" type="hidden" data-bind="value: AccountId" disabled="disabled" />
                            <input id="Account" type="text" data-bind="value: Account" class="input-xxlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Term" class="control-label">Term</label>
                        <div class="controls">
                            <input id="TermId" type="hidden" data-bind="value: TermId" disabled="disabled" />
                            <input id="Term" type="text" data-bind="value: Term" class="input-large" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="TaxNumber" class="control-label">TIN</label>
                        <div class="controls">
                            <input id="TaxNumber" data-bind="value: TaxNumber" type="text" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

            <br />

            <div id="Tab" class="btn-group" data-toggle="buttons-radio">
              <a href="#TabPurchaseInvoices" class="btn" data-toggle="Tab" id="Tab1">Purchase Invoices</a>
            </div>

            <br />

            <br />

            <div class="tab-content">
                <div class="tab-pane active" id="TabPurchaseInvoices">
                    <div class="row-fluid">
                        <table id="PurchaseInvoiceTable" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>PI Date</th>
                                    <th>PI Number</th>
                                    <th>Particulars</th>  
                                    <th>Doc. Ref</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="PurchaseInvoiceTableBody"></tbody>
                            <tfoot>
                                <tr>
                                    <td></td>
                                    <td></td>
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
