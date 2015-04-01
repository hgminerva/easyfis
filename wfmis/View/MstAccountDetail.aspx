<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstAccountDetail.aspx.cs" Inherits="wfmis.View.MstAccountDetail" %>
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
        var $Modal01 = false;

        // Account Model
        var $koAccountModel;
        $koNamespace.initAccount = function (Account) {
            var self = this;

            self.Id = ko.observable(!Account ? $Id : Account.Id);
            self.AccountCode = ko.observable(!Account ? "" : Account.AccountCode);
            self.Account = ko.observable(!Account ? "" : Account.Account);
            self.AccountTypeId = ko.observable(!Account ? 0 : Account.AccountTypeId);
            self.AccountType = ko.observable(!Account ? "" : Account.AccountType);
            self.AccountCashFlowId = ko.observable(!Account ? 0 : Account.AccountCashFlowId);
            self.AccountCashFlow = ko.observable(!Account ? "" : Account.AccountCashFlow);
            self.IsLocked = ko.observable(!Account ? false : Account.IsLocked);
            self.CreatedById = ko.observable(!Account ? $CurrentUserId : Account.CreatedById);
            self.CreatedBy = ko.observable(!Account ? $CurrentUser : Account.CreatedBy);
            self.CreatedDateTime = ko.observable(!Account ? "" : Account.CreatedDateTime);
            self.UpdatedById = ko.observable(!Account ? $CurrentUserId : Account.UpdatedById);
            self.UpdatedBy = ko.observable(!Account ? $CurrentUser : Account.UpdatedBy);
            self.UpdatedDateTime = ko.observable(!Account ? "" : Account.UpdatedDateTime);

            // Select2 defaults
            $('#AccountType').select2('data', { id: !Account ? 0 : Account.AccountTypeId, text: !Account ? "" : Account.AccountType });
            $('#AccountCashFlow').select2('data', { id: !Account ? 0 : Account.AccountCashFlowId, text: !Account ? "" : Account.AccountCashFlow });

            return self;
        };
        $koNamespace.bindAccount = function (Account) {
            var viewModel = $koNamespace.initAccount(Account);
            ko.applyBindings(viewModel, $("#AccountDetail")[0]); //Bind the section #AccountDetail
            $koAccountModel = viewModel;
        }
        $koNamespace.getAccount = function (Id) {
            if (!Id) {
                $koNamespace.bindAccount(null);
            } else {
                // Render Account
                $.getJSON("/api/MstAccount/" + Id + "/Account", function (data) {
                    $koNamespace.bindAccount(data);
                });

                // Render Account Budget Line
                $("#AccountBudgetLineTable").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/MstAccount/' + Id + '/AccountBudgetLines',
                    "sAjaxDataProp": "MstAccountBudgetLineData",
                    "bProcessing": true,
                    "bLengthChange": false,
                    "sPaginationType": "full_numbers",
                    "aoColumns": [
                                    {
                                        "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                        "mRender": function (data) {
                                            return '<input runat="server" id="CmdEditBudgetLine" type="button" class="btn btn-primary" value="Edit"/>'
                                        }
                                    },
                                    {
                                        "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                        "mRender": function (data) {
                                            return '<input runat="server" id="CmdDeleteBudgetLine" type="button" class="btn btn-danger" value="Delete"/>'
                                        }
                                    },
                                    { "mData": "LinePeriod", "sWidth": "300px" },
                                    { "mData": "LineCompany", "sWidth": "300px" },
                                    { "mData": "LineParticulars"},
                                    {
                                        "mData": "LineAmount", "sWidth": "100px", "sClass": "alignRight",
                                        "mRender": function (data) {
                                            return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                        }
                                    }]
                });
            }
        }

        // Account Budget Line Model
        var $koBudgetLineModel;
        $koNamespace.initBudgetLine = function (BudgetLine) {
            var self = this;

            self.LineId = ko.observable(!BudgetLine ? 0 : BudgetLine.LineId);
            self.LineAccountId = ko.observable(!BudgetLine ? 0 : BudgetLine.LineAccountId);
            self.LinePeriodId = ko.observable(!BudgetLine ? 0 : BudgetLine.LinePeriodId);
            self.LinePeriod = ko.observable(!BudgetLine ? "" : BudgetLine.LinePeriod);
            self.LineCompanyId = ko.observable(!BudgetLine ? 0 : BudgetLine.LineCompanyId);
            self.LineCompany = ko.observable(!BudgetLine ? "" : BudgetLine.LineCompany);
            self.LineParticulars = ko.observable(!BudgetLine ? "" : BudgetLine.LineParticulars);
            self.LineAmount = ko.observable(!BudgetLine ? 0 : BudgetLine.LineAmount);

            return self;
        }
        $koNamespace.bindBudgetLine = function (BudgetLine) {
            try {
                var viewModel = $koNamespace.initBudgetLine(BudgetLine);
                ko.applyBindings(viewModel, $("#AccountBudgetLineDetail")[0]);
                $koBudgetLineModel = viewModel;

                $('#LinePeriod').select2('data', { id: !BudgetLine ? 0 : BudgetLine.LinePeriodId, text: !BudgetLine ? "" : BudgetLine.LinePeriod });
                $('#LineCompany').select2('data', { id: !BudgetLine ? 0 : BudgetLine.LineCompanyId, text: !BudgetLine ? "" : BudgetLine.LineCompany });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!BudgetLine ? 0 : BudgetLine.LineId).change();
                $('#LineAccountId').val(!BudgetLine ? 0 : BudgetLine.LineAccountId).change();

                $('#LinePeriodId').val(!BudgetLine ? 0 : BudgetLine.LinePeriodId).change();
                $('#LinePeriod').select2('data', { id: !BudgetLine ? 0 : BudgetLine.LinePeriodId, text: !BudgetLine ? "" : BudgetLine.LinePeriod });

                $('#LineCompanyId').val(!BudgetLine ? 0 : BudgetLine.LineCompanyId).change();
                $('#LineCompany').select2('data', { id: !BudgetLine ? 0 : BudgetLine.LineCompanyId, text: !BudgetLine ? "" : BudgetLine.LineCompany });

                $('#LineParticulars').val(!BudgetLine ? "" : BudgetLine.LineParticulars).change();

                $('#LineAmount').val(!BudgetLine ? 0 : BudgetLine.LineAmount).change();
            }
        }

        // Select2  control
        function select2_AccountType() {
            $('#AccountType').select2({
                placeholder: 'Account Type',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccountType',
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
                $('#AccountTypeId').val($('#AccountType').select2('data').id).change();
            });
        }
        function select2_AccountCashFlow() {
            $('#AccountCashFlow').select2({
                placeholder: 'Account Cash Flow',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccountCashFlow',
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
                $('#AccountCashFlowId').val($('#AccountCashFlow').select2('data').id).change();
            });
        }
        function select2_LinePeriod() {
            $('#LinePeriod').select2({
                placeholder: 'Period',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectPeriod',
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
                $('#LinePeriodId').val($('#LinePeriod').select2('data').id).change();
            });
        }
        function select2_LineCompany() {
            $('#LineCompany').select2({
                placeholder: 'Company',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectCompany',
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
                $('#LineCompanyId').val($('#LineCompany').select2('data').id).change();
            });
        }

        // Events
        function cmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/MstAccount',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koAccountModel),
                        success: function (data) {
                            location.href = 'MstAccountDetail.aspx?Id=' + data.Id;
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
                            url: '/api/MstAccount/' + $Id,
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koAccountModel),
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
        function cmdAddBudgetLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#AccountBudgetLineModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindBudgetLine(null);
                // FK
                $('#LineAccountId').val($Id).change();
            }
        }
        function cmdEditBudgetLine_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/MstAccountBudgetLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindBudgetLine(data);
                        $('#AccountBudgetLineModal').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function cmdDeleteBudgetLine_onclick(LineId) {
            if (confirm('Are you sure?')) {
                $.ajax({
                    url: '/api/MstAccountBudgetLine/' + LineId,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstAccountDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function cmdSaveBudgetLine_onclick() {
            var LineId = $('#LineId').val();

            $('#AccountBudgetLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/MstAccountBudgetLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koBudgetLineModel),
                    success: function (data) {
                        location.href = 'MstAccountDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/MstAccountBudgetLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koBudgetLineModel),
                    success: function (data) {
                        location.href = 'MstAccountDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function cmdCloseBudgetLine_onclick() {
            $('#AccountBudgetLineModal').modal('hide');
            $Modal01 = false;
        }

        // On Page Load
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Select2 Controls
            select2_AccountType();
            select2_AccountCashFlow();
            select2_LinePeriod();
            select2_LineCompany();

            $('#LineAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            $("#AccountBudgetLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#AccountBudgetLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditBudgetLine") > 0) cmdEditBudgetLine_onclick(Id);
                if (ButtonName.search("CmdDeleteBudgetLine") > 0) cmdDeleteBudgetLine_onclick(Id);
            });

            // Bind the Page: MstAccount
            if ($Id != "") {
                $koNamespace.getAccount($Id);
            } else {
                $koNamespace.getAccount(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#AccountBudgetLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#AccountBudgetLineModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Account Detail</h2>

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

            <section id="AccountDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Account Code </label>
                        <div class="controls">
                            <input id="AccountCode" type="text" data-bind="value: AccountCode" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Account </label>
                        <div class="controls">
                            <input id="Account" type="text" data-bind="value: Account" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Account Type </label>
                        <div class="controls">
                            <input  id="AccountTypeId" type="hidden" data-bind="value: AccountTypeId" class="input-medium" />
                            <input  id="AccountType" type="text" data-bind="value: AccountType" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Account Cash Flow </label>
                        <div class="controls">
                            <input  id="AccountCashFlowId" type="hidden" data-bind="value: AccountCashFlowId" class="input-medium" />
                            <input  id="AccountCashFlow" type="text" data-bind="value: AccountCashFlow" class="input-xxlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

            <section id="AccountBudgetLine">
            <div class="row">
                <div class="span12">
                    <table id="AccountBudgetLineTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="6">
                                    <input runat="server" id="CmdAddBudgetLine" type="button" value="Add" class="btn btn-primary" onclick="cmdAddBudgetLine_onclick()" />  
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Period</th>
                                <th>Company</th>
                                <th>Particulars</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody id="AccountBudgetLineTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td></td> 
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
            </section>

            <section id="AccountBudgetLineDetail">
            <div id="AccountBudgetLineModal" class="modal hide fade in" style="display: none;">
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Account Budget Line Detail</h3>  
                </div> 
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <div class="controls">
                                    <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                    <input id="LineAccountId" type="hidden" data-bind="value: LineAccountId" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePeriod" class="control-label">Period </label>
                                <div class="controls">
                                    <input id="LinePeriodId" type="hidden" data-bind="value: LinePeriodId" class="input-medium" />
                                    <input id="LinePeriod" type="text" data-bind="value: LinePeriod" class="input-xlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineCompany" class="control-label">Company </label>
                                <div class="controls">
                                    <input id="LineCompanyId" type="hidden" data-bind="value: LineCompanyId" class="input-medium" />
                                    <input id="LineCompany" type="text" data-bind="value: LineCompany" class="input-xlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineParticulars" class="control-label">Particulars </label>
                                <div class="controls">
                                    <textarea id="LineParticulars" rows="3" data-bind="value: LineParticulars" class="input-block-level"></textarea>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineAmount" class="control-label">Amount </label>
                                <div class="controls">
                                    <input id="LineAmount" type="number" data-bind="value: LineAmount" class="input-medium" />
                                </div>
                            </div>
                        </div>
                    </div>             
                </div> 
                <div class="modal-footer">
                    <input runat="server" id="CmdSaveBudgetLine" type="button" value="Save" class="btn btn-primary" onclick="cmdSaveBudgetLine_onclick()" />
                    <input runat="server" id="CmdCloseBudgetLine" type="button" value="Close" class="btn btn-danger" onclick="cmdCloseBudgetLine_onclick()" />  
                </div>  
            </div>
            </section>


        </div>
    </div>
</asp:Content>
