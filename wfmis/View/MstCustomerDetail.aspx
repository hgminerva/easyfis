<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstCustomerDetail.aspx.cs" Inherits="wfmis.View.MstCustomerDetail" %>

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
        var $CurrentCustomerAccountId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentCustomerAccountId %>';
        var $CurrentCustomerAccount = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentCustomerAccount %>';
        var $Id = 0;
        var $ArticleId = 0;
        var $koNamespace = {};
        var $pageSize = 20;

        // Bindings
        var $koCustomer;

        $koNamespace.initCustomer = function (Customer) {
            var self = this;

            self.Id = ko.observable(!Customer ? 0 : Customer.Id);
            self.ArticleId = ko.observable(!Customer ? 0 : Customer.ArticleId);
            self.CustomerCode = ko.observable(!Customer ? "" : Customer.CustomerCode);
            self.Customer = ko.observable(!Customer ? "" : Customer.Customer);
            self.Address = ko.observable(!Customer ? "" : Customer.Address);
            self.ContactNumbers = ko.observable(!Customer ? "" : Customer.ContactNumbers);
            self.ContactPerson = ko.observable(!Customer ? "" : Customer.ContactPerson);
            self.EmailAddress = ko.observable(!Customer ? "" : Customer.EmailAddress);
            self.AccountId = ko.observable(!Customer ? $CurrentCustomerAccountId : Customer.AccountId);
            self.Account = ko.observable(!Customer ? $CurrentCustomerAccount : Customer.Account);
            self.TermId = ko.observable(!Customer ? 0 : Customer.TermId);
            self.Term = ko.observable(!Customer ? "" : Customer.Term);
            self.TaxNumber = ko.observable(!Customer ? "" : Customer.TaxNumber);

            $('#Account').select2('data', { id: !Customer ? $CurrentCustomerAccountId : Customer.AccountId, text: !Customer ? $CurrentCustomerAccount : Customer.Account });
            $('#Term').select2('data', { id: !Customer ? 0 : Customer.TermId, text: !Customer ? "" : Customer.Term });

            return self;
        };
        $koNamespace.bindCustomer = function (Customer) {
            var viewModel = $koNamespace.initCustomer(Customer);
            ko.applyBindings(viewModel, $("#CustomerDetail")[0]); //Bind the section #CustomerDetail
            $koCustomer = viewModel;
        };
        $koNamespace.getCustomer = function (Id) {
            if (!Id) {
                $koNamespace.bindCustomer(null);
            } else {
                // Render customer
                $.getJSON("/api/MstArticleCustomer/" + Id + "/Customer", function (data) {
                    $koNamespace.bindCustomer(data);
                    $ArticleId = data.ArticleId;
                    Render_SalesInvoiceTable();
                });
            }
        };

        // Events
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                // Existing record (Update)
                if (confirm('Update customer?')) {
                    $.ajax({
                        url: '/api/MstArticleCustomer/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koCustomer),
                        success: function (data) {
                            location.href = 'MstCustomerDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                // New record (Insert)
                if (confirm('Save customer?')) {
                    $.ajax({
                        url: '/api/MstArticleCustomer',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koCustomer),
                        success: function (data) {
                            location.href = 'MstCustomerDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdClose_onclick() {
            location.href = 'MstCustomerList.aspx';
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
                $koCustomer['AccountId']($('#Account').select2('data').id);
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
                $koCustomer['TermId']($('#Term').select2('data').id);
            });
        }

        // Render tables
        function Render_SalesInvoiceTable() {
            var SalesInvoiceTable = $("#SalesInvoiceTable").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/TrnSalesInvoice/' + $ArticleId + '/CustomerSalesInvoices',
                "sAjaxDataProp": "TrnSalesInvoiceData",
                "bProcessing": true,
                "bLengthChange": false,
                "iDisplayLength": 20,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                        { "mData": "SIDate", "sWidth": "120px" },
                        { "mData": "SINumber", "sWidth": "120px" },
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
                $koNamespace.getCustomer($Id);
            } else {
                $koNamespace.getCustomer(null);
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

            <h2>Customer Detail</h2>

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
                        <input runat="server" id="CmdSave"  type="button" class="btn btn-primary" value="Save" onclick="CmdSave_onclick()"/>
                        <input runat="server" id="CmdClose"  type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()"/>
                    </div>
                </div>
            </div>

            <section id="CustomerDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label for="CustomerCode" class="control-label">Customer Code</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="ArticleId" type="hidden" data-bind="value: ArticleId" disabled="disabled" />
                            <input id="CustomerCode" data-bind="value: CustomerCode" type="text" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Customer" class="control-label">Customer</label>
                        <div class="controls">
                            <input id="Customer" data-bind="value: Customer" type="text" class="input-xxlarge" />
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
              <a href="#TabSalesInvoices" class="btn" data-toggle="Tab" id="Tab1">Sales Invoices</a>
            </div>

            <br />

            <br />

            <div class="tab-content">
                <div class="tab-pane active" id="TabSalesInvoices">
                    <div class="row-fluid">
                        <table id="SalesInvoiceTable" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>SI Date</th>
                                    <th>SI Number</th>
                                    <th>Particulars</th>  
                                    <th>Doc. Ref</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="SalesInvoiceTableBody"></tbody>
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
