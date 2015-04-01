<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnBank.aspx.cs" Inherits="wfmis.View.TrnBank" %>
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
    <link href="../Content/datatable/report_datatable.css" rel="stylesheet" />
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <script type="text/javascript" charset="utf-8">
        // Page variables
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';

        var $Id = 0;
        var $pageSize = 20;
        var $Modal01 = false;

        var $tab1BankId = 0;
        var $tab1Bank = "";
        var $tab1Account = "";
        var $tab1DateStart = easyFIS.getCurrentDate();
        var $tab1DateEnd = easyFIS.getCurrentDate();

        var $koNamespace = {};

        var $koBankModel;
        $koNamespace.initBank = function (Bank) {
            var self = this;

            self.Id = ko.observable(!Bank ? 0 : Bank.Id);
            self.CVId = ko.observable(!Bank ? 0 : Bank.CVId);
            self.ORId = ko.observable(!Bank ? 0 : Bank.ORId);
            self.JVId = ko.observable(!Bank ? 0 : Bank.JVId);
            self.DocumentNumber = ko.observable(!Bank ? "NA" : Bank.DocumentNumber.substring(Bank.DocumentNumber.indexOf(")") + 1, Bank.DocumentNumber.length));
            self.BankDate = ko.observable(!Bank ? easyFIS.getCurrentDate() : Bank.BankDate);
            self.BankId = ko.observable(!Bank ? 0 : Bank.BankId);
            self.Bank = ko.observable(!Bank ? "NA" : Bank.Bank);
            self.DebitAmount = ko.observable(easyFIS.formatNumber(!Bank ? 0 : Bank.DebitAmount, 2, ',', '.', '', '', '-', ''));
            self.CreditAmount = ko.observable(easyFIS.formatNumber(!Bank ? 0 : Bank.CreditAmount, 2, ',', '.', '', '', '-', ''));
            self.CheckNumber = ko.observable(!Bank ? "NA" : Bank.CheckNumber);
            self.CheckDate = ko.observable(!Bank ? easyFIS.getCurrentDate() : Bank.CheckDate);
            self.CheckBank = ko.observable(!Bank ? "NA" : Bank.CheckBank);
            self.IsCleared = ko.observable(!Bank ? false : Bank.IsCleared);
            self.DateCleared = ko.observable(!Bank ? easyFIS.getCurrentDate() : Bank.DateCleared);
            self.Particulars = ko.observable(!Bank ? "NA" : Bank.Particulars);
            self.CreatedById = ko.observable(!Bank ? $CurrentUserId : Bank.CreatedById);
            self.CreatedBy = ko.observable(!Bank ? $CurrentUser : Bank.CreatedBy);
            self.CreatedDateTime = ko.observable(!Bank ? "" : Bank.CreatedDateTime);
            self.UpdatedById = ko.observable(!Bank ? $CurrentUserId : Bank.UpdatedById);
            self.UpdatedBy = ko.observable(!Bank ? $CurrentUser : Bank.UpdatedBy);
            self.UpdatedDateTime = ko.observable(!Bank ? "" : Bank.UpdatedDateTime);

            return self;
        };
        $koNamespace.bindBank = function (Bank) {
            var viewModel = $koNamespace.initBank(Bank);
            if (!!ko.dataFor(document.getElementById("Id")) == false) {
                ko.applyBindings(viewModel, $("#BankRecordDetail")[0]);
                $koBankModel = viewModel;
            } else {
                $('#Id').val(!Bank ? 0 : Bank.Id).change();
                $('#CVId').val(!Bank ? 0 : Bank.CVId).change();
                $('#ORId').val(!Bank ? 0 : Bank.ORId).change();
                $('#JVId').val(!Bank ? 0 : Bank.JVId).change();
                $('#DocumentNumber').val(!Bank ? "NA" : Bank.DocumentNumber.substring(Bank.DocumentNumber.indexOf(")") + 1, Bank.DocumentNumber.length)).change();
                $('#BankDate').val(!Bank ? easyFIS.getCurrentDate() : Bank.BankDate).change();
                $('#BankId').val(!Bank ? 0 : Bank.BankId).change();
                $('#Bank').val(!Bank ? "NA" : Bank.Bank).change();
                $('#DebitAmount').val(easyFIS.formatNumber(!Bank ? 0 : Bank.DebitAmount, 2, ',', '.', '', '', '-', '')).change();
                $('#CreditAmount').val(easyFIS.formatNumber(!Bank ? 0 : Bank.CreditAmount, 2, ',', '.', '', '', '-', '')).change();
                $('#CheckNumber').val(!Bank ? "NA" : Bank.CheckNumber).change();
                $('#CheckDate').val(!Bank ? easyFIS.getCurrentDate() : Bank.CheckDate).change();
                $('#CheckBank').val(!Bank ? "NA" : Bank.CheckBank).change();
                $('#IsCleared').val(!Bank ? false : Bank.IsCleared).change();
                $('#DateCleared').val(!Bank ? easyFIS.getCurrentDate() : Bank.DateCleared).change();
                $('#Particulars').val(!Bank ? "NA" : Bank.Particulars).change();
                $('#CreatedById').val(!Bank ? $CurrentUserId : Bank.CreatedById).change();
                $('#CreatedBy').val(!Bank ? $CurrentUser : Bank.CreatedBy).change();
                $('#CreatedDateTime').val(!Bank ? "" : Bank.CreatedDateTime).change();
                $('#UpdatedById').val(!Bank ? $CurrentUserId : Bank.UpdatedById).change();
                $('#UpdatedBy').val(!Bank ? $CurrentUser : Bank.UpdatedBy).change();
                $('#UpdatedDateTime').val(!Bank ? "" : Bank.UpdatedDateTime).change();
            }
        }
        $koNamespace.getBank = function (Id) {
            if (!Id) {
                $koNamespace.bindBank(null);
            } else {
                $.ajax({
                    url: '/api/TrnBank/' + Id + '/Bank',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (Bank) {
                        $koNamespace.bindBank(Bank);
                    }
                });
            }
        }

        function Select2_tab1Bank() {
            $('#tab1Bank').select2({
                placeholder: 'Bank',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectBank',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
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
                },
                formatResult: function (data) {
                    var JSONObject = JSON.parse(data.text);
                    return JSONObject["Bank"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["Bank"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            }).change(function () {
                var JSONObject = JSON.parse($('#tab1Bank').select2('data').text);

                $tab1BankId = $('#tab1Bank').select2('data').id;
                $tab1Bank = $('#tab1Bank').select2('data').text;

                $('#tab1Account').val(JSONObject["Account"]);

                $tab1BankId = $('#tab1Bank').select2('data').id;
            });
        }

        function CmdViewBankReconciliation_onclick() {
            $("#tableBankReconciliation").dataTable().fnDestroy();
            RenderTableBankReconciliation();
            UpdateTotals();
        }
        function CmdEditBankRecordDetail_onclick(Id) {
            $('#BankRecordModal').modal('show');
            $Modal01 = true;

            $koNamespace.getBank(Id);
            $Id = Id;
        }
        function CmdSaveBankRecordDetail_onclick() {
            if ($Id > 0) {
                $('#BankRecordModal').modal('hide');
                $Modal01 = false;

                $.ajax({
                    url: '/api/TrnBank/' + $Id + '/Update',
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koBankModel),
                    success: function (data) {
                        $("#tableBankReconciliation").dataTable().fnDestroy();
                        RenderTableBankReconciliation();
                        UpdateTotals();
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                alert('Save not allowed.');
            }
        }
        function CmdCloseBankRecordDetail_onclick() {
            $('#BankRecordModal').modal('hide');
            $Modal01 = false;
        }

        function RenderTableBankReconciliation() {
            var ds = new Date($tab1DateStart);
            var de = new Date($tab1DateEnd);
            var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
            var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

            var tableBankReconciliation = $("#tableBankReconciliation").dataTable({
                "sAjaxSource": '/api/TrnBank?tab1DateStart=' + DateStart + '&tab1DateEnd=' + DateEnd + '&tab1BankId=' + $tab1BankId,
                "bPaginate": false,
                "sAjaxDataProp": "TrnBankData",
                "bLengthChange": false,
                "aoColumns": [
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdEditBankRecon" type="button" class="btn btn-primary" value="Edit"/>'
                                    }
                                },
                                { "mData": "BankDate", "sWidth": "100px" },
                                {
                                    "mData": "DocumentNumber", "sWidth": "150px",
                                    "mRender": function (data) {
                                        return easyFIS.returnLink(data);
                                    }
                                },
                                { "mData": "Particulars", "bSortable": false, },
                                {
                                    "mData": "DebitAmount", "sWidth": "100px", "sClass": "alignRight",
                                    "mRender": function (data) {
                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                    }
                                },
                                {
                                    "mData": "CreditAmount", "sWidth": "100px", "sClass": "alignRight",
                                    "mRender": function (data) {
                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                    }
                                },
                                {
                                    "mData": "IsCleared", "sWidth": "100px",
                                    "mRender": function (data) {
                                        return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                    }
                                }
                            ]
            });
        }
        function UpdateTotals() {
            var BankId = $tab1BankId;
            var BankBalance = $('#tab1BankBalance').val() == "" ? 0 : $('#tab1BankBalance').val();
            var ds = new Date($tab1DateStart);
            var de = new Date($tab1DateEnd);
            var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
            var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

            $.ajax({
                url: '/api/TrnBankSummary?tab1BankId=' + BankId + '&' +
                                         'tab1DateStart=' + DateStart + '&' +
                                         'tab1DateEnd=' + DateEnd + '&' +
                                         'tab1BankBalance=' + BankBalance,
                cache: false,
                type: 'GET',
                contentType: 'application/json; charset=utf-8',
                data: {},
                success: function (data) {
                    $('#tab1DepositInTransit').val(easyFIS.formatNumber(data.TotalDepositInTransit, 2, ',', '.', '', '', '-', ''));
                    $('#tab1OutstandingWithdrawal').val(easyFIS.formatNumber(data.TotalOutstandingWithdrawal, 2, ',', '.', '', '', '-', ''));
                    $('#tab1AdjustedBankBalance').val(easyFIS.formatNumber(data.AdjustedEndingBankBalance, 2, ',', '.', '', '', '-', ''));
                    $('#tab1BookBalance').val(easyFIS.formatNumber(data.EndingBookBalance, 2, ',', '.', '', '', '-', ''));
                    $('#tab1VoucherDebit').val(easyFIS.formatNumber(data.TotalVoucherDebit, 2, ',', '.', '', '', '-', ''));
                    $('#tab1VoucherCredit').val(easyFIS.formatNumber(data.TotalVoucherCredit, 2, ',', '.', '', '', '-', ''));
                    $('#tab1AdjustedBookBalance').val(easyFIS.formatNumber(data.AdjustedEndingBookBalance, 2, ',', '.', '', '', '-', ''));
                }
            }).fail(function (xhr, textStatus, err) {
                alert(err);
            });
        }

        $(document).ready(function () {
            $('#tab1DateStart').datepicker().on('changeDate', function (ev) {
                $tab1DateStart = $(this).val();
                $(this).datepicker('hide');
            }).val(easyFIS.getCurrentDate());
            $('#tab1DateEnd').datepicker().on('changeDate', function (ev) {
                $tab1DateEnd = $(this).val();
                $(this).datepicker('hide');
            }).val(easyFIS.getCurrentDate());

            Select2_tab1Bank();

            $("#tableBankReconciliation").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#tableBankReconciliation").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditBankRecon") > 0) CmdEditBankRecordDetail_onclick(Id);
            });
        });

        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#BankRecordModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#BankRecordModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Bank Reconciliation</h2>

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

            <div id="tab" class="btn-group" data-toggle="buttons-radio">
              <a href="#tabBankReconciliation" class="btn" data-toggle="tab" id="tab1">Bank Reconciliation</a>
            </div>

            <br />

            <br />

            <div class="tab-content">

                <div class="tab-pane active" id="tabBankReconciliation">
                    <div class="row-fluid">
                        <div class="span5">
                            <div class="control-group">
                                <label class="control-label">Bank </label>
                                <div class="controls">
                                    <input id="tab1Bank" type="text" class="input-block-level"/>
                                </div>
                            </div>  
                            <div class="control-group">
                                <label class="control-label">Account </label>
                                <div class="controls">
                                    <input id="tab1Account" type="text" class="input-block-level" disabled="disabled"/>
                                </div>
                            </div>  
                            <div class="control-group">
                                <label class="control-label">Date Start </label>
                                <div class="controls">
                                    <input id="tab1DateStart" name="tab1DateStart" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date End </label>
                                <div class="controls">
                                    <input id="tab1DateEnd" name="tab1DateEnd" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span3"> 
                            <div class="control-group">
                                <label class="control-label">Ending Balance as per Bank</label>
                                <div class="controls">
                                    <input id="tab1BankBalance" name="tab1BankBalance" type="text" class="text-right input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Total Deposit in Transit (OR)</label>
                                <div class="controls">
                                    <input id="tab1DepositInTransit" name="tab1DepositInTransit" type="text" class="text-right input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Total Outstanding Withdrawals (CV)</label>
                                <div class="controls">
                                    <input id="tab1OutstandingWithdrawal" name="tab1OutstandingWithdrawal" type="text" class="text-right input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Adjusted Ending Balance as per Bank</label>
                                <div class="controls">
                                    <input id="tab1AdjustedBankBalance" name="tab1AdjustedBankBalance" type="text" class="text-right input-medium" disabled="disabled"/>
                                </div>
                            </div>
                        </div>
                        <div class="span3">
                            <div class="control-group">
                                <label class="control-label">Ending Balance as per Book</label>
                                <div class="controls">
                                    <input id="tab1BookBalance" name="tab1BookBalance" type="text" class="text-right input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Total Voucher Debit (JV)</label>
                                <div class="controls">
                                    <input id="tab1VoucherDebit" name="tab1VoucherDebit" type="text" class="text-right input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Total Voucher Credit (JV)</label>
                                <div class="controls">
                                    <input id="tab1VoucherCredit" name="tab1VoucherCredit" type="text" class="text-right input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Adjusted Ending Balance as per Book</label>
                                <div class="controls">
                                    <input id="tab1AdjustedBookBalance" name="tab1AdjustedBookBalance" type="text" class="text-right input-medium" disabled="disabled"/>
                                </div>
                            </div>
                        </div>
                        <div class="span1 text-right">
                            <input runat="server" id="CmdViewBankRecon" type="button" class="btn btn-primary" value="View" onclick="CmdViewBankReconciliation_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Bank Reconciliation</h3>
                        <table id="tableBankReconciliation" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Date</th>
                                    <th>Document No.</th>
                                    <th>Particulars</th>
                                    <th>Debit Amount</th>
                                    <th>Credit Amount</th>
                                    <th>Is Cleared</th>
                                </tr>
                            </thead>
                            <tbody id="tableBodyBankReconciliation"></tbody>
                            <tfoot id="tableFootBankReconciliation"></tfoot>
                        </table>
                    </div>
                </div>

            </div>

            <section id="BankRecordDetail">
            <div id="BankRecordModal" class="modal hide fade in" style="display: none;">
                <div class="modal-header">
                    <a class="close" data-dismiss="modal">×</a>
                    <h3>Bank Record Detail</h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <div class="controls">
                                    <input id="Id" type="hidden" data-bind="value: Id" class="input-medium" />
                                    <input id="CVId" type="hidden" data-bind="value: CVId" class="input-medium" />
                                    <input id="ORId" type="hidden" data-bind="value: ORId" class="input-medium" />
                                    <input id="JVId" type="hidden" data-bind="value: JVId" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineItem" class="control-label">Bank Record Date</label>
                                <div class="controls">
                                    <input id="BankDate" type="text" data-bind="value: BankDate" class="input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineItem" class="control-label">Bank </label>
                                <div class="controls">
                                    <input id="BankId" type="hidden" data-bind="value: BankId" class="input-medium" />
                                    <input id="Bank" type="text" data-bind="value: Bank" class="input-block-level" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineItem" class="control-label">Document Number</label>
                                <div class="controls">
                                    <input id="DocumentNumber" type="text" data-bind="value: DocumentNumber" class="input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="Particulars" class="control-label">Particulars </label>
                                <div class="controls">
                                    <textarea id="Particulars" rows="3" data-bind="value: Particulars" class="input-block-level"></textarea>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="DebitAmount" class="control-label">Debit Amount</label>
                                <div class="controls">
                                    <input id="DebitAmount" type="number" data-bind="value: DebitAmount" class="input-medium pagination-right" data-validation-number-message="Numbers only please" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="CreditAmount" class="control-label">Credit Amount</label>
                                <div class="controls">
                                    <input id="CreditAmount" type="number" data-bind="value: CreditAmount" class="input-medium pagination-right" data-validation-number-message="Numbers only please" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Is Cleared</label>
                                <div class="controls">
                                    <input id="IsCleared" type="checkbox" data-bind="checked: IsCleared" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="CheckNumber" class="control-label">Check Number </label>
                                <div class="controls">
                                    <input id="CheckNumber" type="text" data-bind="value: CheckNumber" class="input-large" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="CheckDate" class="control-label">Check Date </label>
                                <div class="controls">
                                    <input id="CheckDate" type="text" data-bind="value: CheckDate" class="input-medium" disabled="disabled"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="CheckBank" class="control-label">Check Bank </label>
                                <div class="controls">
                                    <input id="CheckBank" type="text" data-bind="value: CheckBank" class="input-xlarge" disabled="disabled"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <a href="#" class="btn btn-primary" onclick="CmdSaveBankRecordDetail_onclick()">Save</a>
                    <a href="#" class="btn btn-danger" onclick="CmdCloseBankRecordDetail_onclick()">Close</a>
                </div>
            </div>
            </section>

        </div>
    </div>
</asp:Content>
