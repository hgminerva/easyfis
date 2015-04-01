<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstArticleBankDetail.aspx.cs" Inherits="wfmis.View.MstArticleBank" %>

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
        var $ArticleId = 0;
        var $koNamespace = {};
        var $pageSize = 20;

        // Bindings
        var $koBank;
        $koNamespace.initBank = function (Bank) {
            var self = this;

            self.Id = ko.observable(!Bank ? 0 : Bank.Id);
            self.ArticleId = ko.observable(!Bank ? 0 : Bank.ArticleId);
            self.BankCode = ko.observable(!Bank ? "" : Bank.BankCode);
            self.Bank = ko.observable(!Bank ? "" : Bank.Bank);
            self.BankAccountNumber = ko.observable(!Bank ? "" : Bank.BankAccountNumber);
            self.Particulars = ko.observable(!Bank ? "" : Bank.Particulars);
            self.Address = ko.observable(!Bank ? "" : Bank.Address);
            self.ContactPerson = ko.observable(!Bank ? "" : Bank.ContactPerson);
            self.ContactNumbers = ko.observable(!Bank ? "" : Bank.ContactNumbers);
            self.AccountId = ko.observable(!Bank ? 0 : Bank.AccountId);
            self.Account = ko.observable(!Bank ? "" : Bank.Account);

            $('#Account').select2('data', { id: !Bank ? 0 : Bank.AccountId, text: !Bank ? "" : Bank.Account });

            return self;
        };
        $koNamespace.bindBank = function (Bank) {
            var viewModel = $koNamespace.initBank(Bank);
            ko.applyBindings(viewModel, $("#BankDetail")[0]);
            $koBank = viewModel;
        };
        $koNamespace.getBank = function (Id) {
            if (!Id) {
                $koNamespace.bindBank(null);
            } else {
                // Render Bank
                $.getJSON("/api/MstArticleBank/" + Id + "/Bank", function (data) {
                    $koNamespace.bindBank(data);
                    $ArticleId = data.ArticleId;
                });
            }
        };

        // Events
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                // Existing record (Update)
                if (confirm('Update Bank?')) {
                    $.ajax({
                        url: '/api/MstArticleBank/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koBank),
                        success: function (data) {
                            location.href = 'MstArticleBankDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                // New record (Insert)
                if (confirm('Save Bank?')) {
                    $.ajax({
                        url: '/api/MstArticleBank',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koBank),
                        success: function (data) {
                            location.href = 'MstArticleBankDetail.aspx?Id=' + data.Id;
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
                $koBank['AccountId']($('#Account').select2('data').id);
            });
        }

        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Select2
            Select2_Account();

            // Fill the page with data
            if ($Id != "") {
                $koNamespace.getBank($Id);
            } else {
                $koNamespace.getBank(null);
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

            <h2>Bank Detail</h2>

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

            <section id="BankDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label for="BankCode" class="control-label">Bank Code</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="ArticleId" type="hidden" data-bind="value: ArticleId" disabled="disabled" />
                            <input id="BankCode" data-bind="value: BankCode" type="text" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Bank" class="control-label">Bank</label>
                        <div class="controls">
                            <input id="Bank" data-bind="value: Bank" type="text" class="input-xxlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Bank Account Number" class="control-label">Account Number</label>
                        <div class="controls">
                            <input  id="BankAccountNumber" data-bind="value: BankAccountNumber" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Particulars" class="control-label">Particulars</label>
                        <div class="controls">
                            <textarea rows="3" id="Particulars" data-bind="value: Particulars" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Address" class="control-label">Address</label>
                        <div class="controls">
                            <textarea rows="3" id="Textarea1" data-bind="value: Address" class="input-block-level"></textarea>
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
                </div>
                <div class="span6">
                    <div class="control-group">
                        <label for="Account" class="control-label">Account</label>
                        <div class="controls">
                            <input id="AccountId" type="hidden" data-bind="value: AccountId" disabled="disabled" />
                            <input id="Account" type="text" data-bind="value: Account" class="input-xxlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

        </div>
    </div>
</asp:Content>
