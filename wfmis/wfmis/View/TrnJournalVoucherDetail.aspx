<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnJournalVoucherDetail.aspx.cs" Inherits="wfmis.View.TrnJournalVoucherDetail" %>

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
    <script src="../Scripts/easyfis/easyfis.utils.v1.js"></script>
    <%--Validation--%>
    <script type="text/javascript" src="../Scripts/bootstrap-validation/jqBootstrapValidation.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        // ============================
        // Global Application Variables
        // ============================
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';
        // =======
        // Binding
        // =======
        var $Id = 0;             
        var $koNamespace = {};
        // Journal Voucher Model (Detail)
        var $koJournalVoucherModel;
        $koNamespace.initJournalVoucher = function (JournalVoucher) {
            var self = this;

            self.Period = ko.observable(!JournalVoucher? $CurrentPeriod : JournalVoucher.Period),
            self.Branch = ko.observable(!JournalVoucher ? $CurrentBranch : JournalVoucher.Branch),
            self.JVNumber = ko.observable(!JournalVoucher ? "" : JournalVoucher.JVNumber),
            self.JVManualNumber = ko.observable(!JournalVoucher ? "" : JournalVoucher.JVManualNumber),
            self.JVDate = ko.observable(!JournalVoucher ? "" : JournalVoucher.JVDate),
            self.Particulars = ko.observable(!JournalVoucher ? "NA" : JournalVoucher.Particulars),
            self.PreparedById = ko.observable(!JournalVoucher ? $CurrentUserId : JournalVoucher.PreparedById),
            self.CheckedById = ko.observable(!JournalVoucher ? $CurrentUserId : JournalVoucher.CheckedById),
            self.ApprovedById = ko.observable(!JournalVoucher ? $CurrentUserId : JournalVoucher.ApprovedById),
            self.PreparedBy = ko.observable(!JournalVoucher ? $CurrentUser : JournalVoucher.PreparedBy),
            self.CheckedBy = ko.observable(!JournalVoucher ? $CurrentUser : JournalVoucher.CheckedBy),
            self.ApprovedBy = ko.observable(!JournalVoucher ? $CurrentUser : JournalVoucher.ApprovedBy)

            $('#PreparedBy').select2('data', { id: !JournalVoucher ? 0 : JournalVoucher.PreparedById, text: !JournalVoucher ? "" : JournalVoucher.PreparedBy });
            $('#CheckedBy').select2('data', { id: !JournalVoucher ? 0 : JournalVoucher.CheckedById, text: !JournalVoucher ? "" : JournalVoucher.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !JournalVoucher ? 0 : JournalVoucher.ApprovedById, text: !JournalVoucher ? "" : JournalVoucher.ApprovedBy });

            return self;
        };
        $koNamespace.bindJournalVoucher = function (JournalVoucher) {
            var viewModel = $koNamespace.initJournalVoucher(JournalVoucher);
            ko.applyBindings(viewModel, $("#JournalVoucherDetail")[0]); //Bind the section #JournalVoucherDetail
            $koJournalVoucherModel = viewModel;
        }
        $koNamespace.getJournalVoucher = function (Id) {
            if (!Id) {
                $koNamespace.bindJournalVoucher(null);
            } else {
                // Render Journal Voucher
                $.getJSON("/api/TrnJournalVoucher/" + Id + "/JournalVoucher", function (data) {
                    $koNamespace.bindJournalVoucher(data);
                });
                // Render Journal Voucher Lines
                $("#JournalVoucherLineTable").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/TrnJournalVoucher/' + Id + '/JournalVoucherLines',
                    "sAjaxDataProp": "TrnJournalVoucherLineData",
                    "bProcessing": true,
                    "bLengthChange": false,
                    "sPaginationType": "full_numbers",
                    "aoColumns": [
                                    {
                                        "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                        "mRender": function (data) {
                                            return '<button type="button" class="btn btn-primary" onclick="cmdEditLine_onclick(' + data + ')">Edit</button>'
                                        }
                                    },
                                    {
                                        "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                        "mRender": function (data) {
                                            return '<button type="button" class="btn btn-danger" onclick="cmdDeleteLine_onclick(' + data + ')">Delete</button>'
                                        }
                                    },
                                    { "mData": "LineBranch", "sWidth": "100px" },
                                    { "mData": "LineAccount", "sWidth": "200px" },
                                    { "mData": "LineArticle", "sWidth": "200px" },
                                    { "mData": "LineParticulars", "sWidth": "200px" },
                                    {
                                        "mData": "LineDebitAmount", "sWidth": "100px", "sClass": "alignRight",
                                        "mRender": function (data) {
                                            return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                        }
                                    },
                                    {
                                        "mData": "LineCreditAmount", "sWidth": "100px", "sClass": "alignRight",
                                        "mRender": function (data) {
                                            return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                        }
                                    }],
                    "fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                        var TotalDebit = 0;
                        var TotalCredit = 0;

                        for (var i = 0 ; i < aaData.length ; i++) {
                            TotalDebit += aaData[i]['LineDebitAmount'] * 1;
                            TotalCredit += aaData[i]['LineCreditAmount'] * 1;
                        }

                        var nCells = nRow.getElementsByTagName('th');
                        nCells[6].innerHTML = easyFIS.formatNumber(TotalDebit, 2, ',', '.', '', '', '-', '');
                        nCells[7].innerHTML = easyFIS.formatNumber(TotalCredit, 2, ',', '.', '', '', '-', '');
                    }
                });
            }
        }
        // Journal Voucher Line Model
        var $koJournalVoucherLineModel;
        $koNamespace.initJournalVoucherLine = function (JournalVoucherLine) {
            var self = this;

            self.LineId = ko.observable(!JournalVoucherLine ? 0 : JournalVoucherLine.LineId);
            self.LineJVId = ko.observable(!JournalVoucherLine ? 0 : JournalVoucherLine.LineJVId);
            self.LineBranchId = ko.observable(!JournalVoucherLine ? 0 : JournalVoucherLine.LineBranchId);
            self.LineBranch = ko.observable(!JournalVoucherLine ? "" : JournalVoucherLine.LineBranch);
            self.LineAccountId = ko.observable(!JournalVoucherLine ? 0 : JournalVoucherLine.LineAccountId);
            self.LineAccount = ko.observable(!JournalVoucherLine ? "" : JournalVoucherLine.LineAccount);
            self.LineArticleId = ko.observable(!JournalVoucherLine ? 0 : JournalVoucherLine.LineArticleId);
            self.LineArticle = ko.observable(!JournalVoucherLine ? "" : JournalVoucherLine.LineArticle);
            self.LineDebitAmount = ko.observable(!JournalVoucherLine ? 0 : JournalVoucherLineLine.DebitAmount);
            self.LineCreditAmount = ko.observable(!JournalVoucherLine ? 0 : JournalVoucherLine.LineCreditAmount);
            self.LineParticulars = ko.observable(!JournalVoucherLine ? "NA" : JournalVoucherLine.LineParticulars);

            return self;
        }
        $koNamespace.bindJournalVoucherLine = function (JournalVoucherLine) {
            try {
                var viewModel = $koNamespace.initJournalVoucherLine(JournalVoucherLine);
                ko.applyBindings(viewModel, $("#JournalVoucherLineDetail")[0]); //Bind the section #JournalVoucherLineDetail (Modal)
                $koJournalVoucherLineModel = viewModel;

                $('#LineBranch').select2('data', { id: !JournalVoucherLine ? 0 : JournalVoucherLine.LineBranchId, text: !JournalVoucherLine ? "" : JournalVoucherLine.LineBranch });
                $('#LineAccount').select2('data', { id: !JournalVoucherLine ? 0 : JournalVoucherLine.LineAccountId, text: !JournalVoucherLine ? "" : JournalVoucherLine.LineAccount });
                $('#LineArticle').select2('data', { id: !JournalVoucherLine ? 0 : JournalVoucherLine.LineArticleId, text: !JournalVoucherLine ? "" : JournalVoucherLine.LineArticle });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!JournalVoucherLine ? 0 : JournalVoucherLine.LineId).change();
                $('#LineJVId').val(!JournalVoucherLine ? 0 : JournalVoucherLine.LineJVId).change();

                $('#LineBranchId').val(!JournalVoucherLine ? 0 : JournalVoucherLine.LineBranchId).change();
                $('#LineBranch').select2('data', { id: !JournalVoucherLine ? 0 : JournalVoucherLine.LineBranchId, text: !JournalVoucherLine ? "" : JournalVoucherLine.LineBranch });

                $('#LineAccountId').val(!JournalVoucherLine ? 0 : JournalVoucherLine.LineAccountId).change();
                $('#LineAccount').select2('data', { id: !JournalVoucherLine ? 0 : JournalVoucherLine.LineAccountId, text: !JournalVoucherLine ? "" : JournalVoucherLine.LineAccount });

                $('#LineArticleId').val(!JournalVoucherLine ? 0 : JournalVoucherLine.LineArticleId).change();
                $('#LineArticle').select2('data', { id: !JournalVoucherLine ? 0 : JournalVoucherLine.LineArticleId, text: !JournalVoucherLine ? "" : JournalVoucherLine.LineArticle });

                $('#LineDebitAmount').val(!JournalVoucherLine ? 0 : JournalVoucherLine.LineDebitAmount).change();
                $('#LineCreditAmount').val(!JournalVoucherLine ? 0 : JournalVoucherLine.LineCreditAmount).change();

                $('#LineParticulars').val(!JournalVoucherLine ? "NA" : JournalVoucherLine.LineParticulars).change();
            }
        }
        // =============
        // Button Events
        // =============
        // Detail
        function cmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnJournalVoucher',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koJournalVoucherModel),
                        success: function (data) {
                            location.href = 'TrnJournalVoucherDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                if (confirm('Update record?')) {
                    var $Id = easyFIS.getParameterByName("Id");
                    if ($Id != "") {
                        $.ajax({
                            url: '/api/TrnJournalVoucher/' + $Id,
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koJournalVoucherModel),
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
        function cmdPrint_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                location.href = 'TrnJournalVoucherPreview.aspx?Id=' + $Id;
            }
        }
        function cmdClose_onclick() {
            location.href = 'TrnJournalVoucherList.aspx';
        }
        // Lines
        function cmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#JournalVoucherLineModal').modal('show');
                $koNamespace.bindJournalVoucherLine(null);
                // FK
                $('#LineJVId').val($Id).change();
            }
        }
        function cmdEditLine_onclick(LineId) {
            if (LineId > 0) {
                // Open the modal
                $('#JournalVoucherLineModal').modal('show');
                // Get and bind the data
                $.getJSON("/api/TrnJournalVoucherLine/" + LineId, function (data) {
                    $koNamespace.bindJournalVoucherLine(data);
                });
            }
        }
        function cmdSaveLine_onclick() {
            if (confirm('Save record?')) {
                var LineId = $('#LineId').val();
                if (LineId != 0) {
                    // Update Existing Record
                    $.ajax({
                        url: '/api/TrnJournalVoucherLine/' + LineId,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koJournalVoucherLineModel),
                        success: function (data) {
                            location.href = 'TrnJournalVoucherDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                } else {
                    // Add Record
                    $.ajax({
                        url: '/api/TrnJournalVoucherLine',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koJournalVoucherLineModel),
                        success: function (data) {
                            location.href = 'TrnJournalVoucherDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }
        function cmdDeleteLine_onclick(Id) {
            if (confirm('Are you sure?')) {
                $.ajax({
                    url: '/api/TrnJournalVoucherLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'TrnJournalVoucherDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function cmdCloseLine_onclick() {
            $('#JournalVoucherLineModal').modal('hide');
        }
        // ===========
        // Page Events
        // ===========
        // Main Page
        $(document).ready(function () {
            var pageSize = 20;
            // Page Parameter
            $Id = easyFIS.getParameterByName("Id");

            // Date Picker: JV Date
            $('#JVDate').datepicker().on('changeDate', function (ev) {
                $koJournalVoucherModel['JVDate']($(this).val());
                $(this).datepicker('hide');
            });

            // Select Control: Prepared By
            $('#PreparedBy').select2({
                placeholder: 'Prepared By',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectStaff',
                    data: function (term, page) {
                            return {
                                pageSize: pageSize,
                                pageNum: page,
                                searchTerm: term
                            };
                    },
                    results: function (data, page) {
                        var more = (page * pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#PreparedById').val($('#PreparedBy').select2('data').id).change();
            });

            // Select Control: Checked By
            $('#CheckedBy').select2({
                placeholder: 'Checked By',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectStaff',
                    data: function (term, page) {
                        return {
                            pageSize: pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#CheckedById').val($('#CheckedBy').select2('data').id).change();
            });

            // Select Control: Approved By
            $('#ApprovedBy').select2({
                placeholder: 'Approved By',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectStaff',
                    data: function (term, page) {
                        return {
                            pageSize: pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ApprovedById').val($('#ApprovedBy').select2('data').id).change();
            });

            // Select Control: Line Branch
            $('#LineBranch').select2({
                placeholder: 'Branch',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectBranch',
                    data: function (term, page) {
                        return {
                            pageSize: pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LineBranchId').val($('#LineBranch').select2('data').id).change();
            });

            // Select Control: Line Account
            
            $('#LineAccount').select2({
                placeholder: 'Account',
                allowClear: true,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LineAccountId').val($('#LineAccount').select2('data').id).change();
            });

            // Select Control: Line Subsidiary
            $('#LineArticle').select2({
                placeholder: 'Subsidiary Account',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectArticle',
                    data: function (term, page) {
                        return {
                            pageSize: pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LineArticleId').val($('#LineArticle').select2('data').id).change();
            });

            // Bind the Page: TrnJournalVoucher
            if ($Id != "") {
                $koNamespace.getJournalVoucher($Id);
            } else {
                $koNamespace.getJournalVoucher(null);
            }
        });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Journal Voucher Detail</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <br />

            <div class="row">
                <div class="span12 text-right">
                    <div class="control-group">
                        <input id="cmdSave" type="button" value="Save" class="btn btn-primary" onclick="cmdSave_onclick()" />
                        <input id="cmdPrint" type="button" value="Print" class="btn btn-primary" onclick="cmdPrint_onclick()" />
                        <input id="cmdClose" type="button" value="Close" class="btn btn-danger" onclick="cmdClose_onclick()" />
                    </div>
                </div>
            </div>

            <section id="JournalVoucherDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Period </label>
                        <div class="controls">
                            <input id="Period" type="text" data-bind="value: Period" class="input-large" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Branch </label>
                        <div class="controls">
                            <input id="Branch" type="text" data-bind="value: Branch" class="input-large" disabled="disabled"/>
                        </div>
                    </div>                    
                    <div class="control-group">
                        <label class="control-label">JV Number </label>
                        <div class="controls">
                            <input id="JVNumber" type="text" data-bind="value: JVNumber" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">JV Date </label>
                        <div class="controls">
                            <input id="JVDate" name="JVDate" type="text" data-bind="value: JVDate" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">JV Manual Number </label>
                        <div class="controls">
                            <input id="JVManualNumber" type="text" data-bind="value: JVManualNumber" class="input-medium" />
                        </div>
                    </div>
                </div>
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Particulars: </label>
                        <div class="controls">
                            <textarea id="Particulars" rows="3" data-bind="value: Particulars" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Prepared By </label>
                        <div class="controls">
                            <input  id="PreparedById" type="hidden" data-bind="value: PreparedById" class="input-medium" />
                            <input  id="PreparedBy" type="hidden" data-bind="value: PreparedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Checked By </label>
                        <div class="controls">
                            <input  id="CheckedById" type="hidden" data-bind="value: CheckedById" class="input-medium" />
                            <input  id="CheckedBy" type="hidden" data-bind="value: CheckedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Approved By </label>
                        <div class="controls">
                            <input  id="ApprovedById" type="hidden" data-bind="value: ApprovedById" class="input-medium" />
                            <input  id="ApprovedBy" type="hidden" data-bind="value: ApprovedBy" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

            <div class="row">
                <div class="span12">
                    <table id="JournalVoucherLineTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="8">
                                    <button type="button" class="btn btn-primary" onclick="cmdAddLine_onclick()">Add</button>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Branch</th>
                                <th>Account</th>
                                <th>Subsidiary</th>
                                <th>Particulars</th>
                                <th>Debit </th>
                                <th>Credit </th>  
                            </tr>
                        </thead>
                        <tbody id="JournalVoucherLineTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <th>Total:</th> 
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th style="text-align:right"></th>
                                <th style="text-align:right"></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

        </div>
     </div>

    <section id="JournalVoucherLineDetail">
    <div id="JournalVoucherLineModal" class="modal hide fade in" style="display: none;">  
        <div class="modal-header">  
            <a class="close" data-dismiss="modal">×</a>  
            <h3>Journal Voucher Line Detail</h3>  
        </div>  
        <div class="modal-body">
            <div class="row">
                <div class="form-horizontal">
                    <div class="control-group">
                        <div class="controls">
                            <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                            <input id="LineJVId" type="hidden" data-bind="value: LineJVId" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="LineBranch" class="control-label">Branch</label>
                        <div class="controls">
                            <input id="LineBranchId" type="hidden" data-bind="value: LineBranchId" class="input-medium" />
                            <input id="LineBranch" type="hidden" data-bind="value: LineBranch" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="LineAccount" class="control-label">Account</label>
                        <div class="controls">
                            <input id="LineAccountId" type="hidden" data-bind="value: LineAccountId" class="input-medium" />
                            <input id="LineAccount" type="hidden" data-bind="value: LineAccount" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="LineArticle" class="control-label">Subsidiary</label>
                        <div class="controls">
                            <input id="LineArticleId" type="hidden" data-bind="value: LineArticleId" class="input-medium" />
                            <input id="LineArticle" type="hidden" data-bind="value: LineArticle" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="LineDebitAmount" class="control-label">Debit</label>
                        <div class="controls">
                            <input id="LineDebitAmount" type="number" data-bind="value: LineDebitAmount" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="LineCreditAmount" class="control-label">Credit</label>
                        <div class="controls">
                            <input id="LineCreditAmount" type="number" data-bind="value: LineCreditAmount" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="LineParticulars" class="control-label">Particulars </label>
                        <div class="controls">
                            <textarea id="LineParticulars" rows="3" data-bind="value: LineParticulars" class="input-block-level"></textarea>
                        </div>
                    </div>
                </div>
            </div>             
        </div>  
        <div class="modal-footer">  
            <a href="#" class="btn btn-primary" onclick="cmdSaveLine_onclick()">Save</a>  
            <a href="#" class="btn btn-danger" onclick="cmdCloseLine_onclick()">Close</a>  
        </div>  
    </div>
    </section>

</asp:Content>
