<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnJournalVoucherDetail.aspx.cs" Inherits="wfmis.View.TrnJournalVoucherDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/bootstrap-datepicker/datepicker.css" rel="stylesheet" />
    <link href="../Content/bootstrap-select2/select2.css" rel="stylesheet" />

    <script type='text/javascript' src="../Scripts/easyfis/easyfis.utils.js"></script>

    <script type='text/javascript' src="../Scripts/knockout/knockout-2.3.0.js"></script>
    <script type='text/javascript' src="../Scripts/knockout/json2.js"></script>

    <script type='text/javascript' src="../Scripts/bootstrap-datepicker/bootstrap-datepicker.js"></script>
    <script type='text/javascript' src="../Scripts/bootstrap-select2/select2.js"></script>

    <style type="text/css" title="currentStyle">
			@import "../Content/datatable/datatable.page.css";
            @import "../Content/datatable/datatable.tools.css";
            @import "../Content/datatable/datatable.css";
	</style>

	<script type="text/javascript" src="../Scripts/datatable/jquery.dataTables.js"></script>
    <script type="text/javascript" src="../Scripts/datatable/TableTools.js"></script>
    <script type="text/javascript" src="../Scripts/datatable/ZeroClipboard.js"></script>

    <script type='text/javascript'>
        // Knockout Recordsource binding
        var koNamespace = {};
        var koTrnJournalVoucherModel;

        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';

        koNamespace.initViewModel = function (JournalVoucher) {
            var JournalVoucherViewModel;

            if (!JournalVoucher) {
                // New record
                JournalVoucherViewModel = {
                    Period: ko.observable('<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>'),
                    Branch: ko.observable('<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>'),
                    JVNumber: ko.observable(),
                    JVManualNumber: ko.observable(),
                    JVDate: ko.observable(),
                    Particulars: ko.observable("NA"),
                    PreparedById: ko.observable($CurrentUserId),
                    CheckedById: ko.observable($CurrentUserId),
                    ApprovedById: ko.observable($CurrentUserId),
                    PreparedBy: ko.observable(),
                    CheckedBy: ko.observable(),
                    ApprovedBy: ko.observable(),
                };

                // Select default values for new record
                $('#PreparedBy').select2('data', { id: $CurrentUserId, text: $CurrentUser });
                $('#CheckedBy').select2('data', { id: $CurrentUserId, text: $CurrentUser });
                $('#ApprovedBy').select2('data', { id: $CurrentUserId, text: $CurrentUser });

            } else {
                // Existing record
                JournalVoucherViewModel = {
                    Period: ko.observable(JournalVoucher.Period),
                    Branch: ko.observable(JournalVoucher.Branch),
                    JVNumber: ko.observable(JournalVoucher.JVNumber),
                    JVManualNumber: ko.observable(JournalVoucher.JVManualNumber),
                    JVDate: ko.observable(JournalVoucher.JVDate),
                    Particulars: ko.observable(JournalVoucher.Particulars),
                    PreparedById: ko.observable(JournalVoucher.PreparedById),
                    CheckedById: ko.observable(JournalVoucher.CheckedById),
                    ApprovedById: ko.observable(JournalVoucher.ApprovedById),
                    PreparedBy: ko.observable(),
                    CheckedBy: ko.observable(),
                    ApprovedBy: ko.observable(),
                };

                // Select default values for existing record
                $('#PreparedBy').select2('data', { id: JournalVoucher.PreparedById, text: JournalVoucher.PreparedBy });
                $('#CheckedBy').select2('data', { id: JournalVoucher.CheckedById, text: JournalVoucher.CheckedBy });
                $('#ApprovedBy').select2('data', { id: JournalVoucher.ApprovedById, text: JournalVoucher.ApprovedBy });
            }

            return JournalVoucherViewModel;
        }

        koNamespace.bindData = function (JournalVoucher) {
            var viewModel = koNamespace.initViewModel(JournalVoucher);
            ko.applyBindings(viewModel);
            koTrnJournalVoucherModel = viewModel;
        }

        koNamespace.getJournalVoucher = function (JournalVoucherId) {
            $.getJSON("/api/TrnJournalVoucher/" + JournalVoucherId, function (data) {
                koNamespace.bindData(data);
            });
        }

        // Onload Page
        $(document).ready(function () {
            // Page Parameter
            var $Id = GetParameterByName("Id");

            // Date Picker: JV Date
            $('#JVDate').datepicker().on('changeDate', function (ev) {
                koTrnJournalVoucherModel['JVDate']($(this).val());
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
                    data: function (registration, page) {
                            return {
                                page: page,
                                pageSize: 100,
                                registration: registration
                            };
                    },
                    results: function (data, page) {
                        var more = (page * 100) < data.total; 
                        return { results: data, more: more }; 
                    }
                }
            }).change(function () {
                koTrnJournalVoucherModel['PreparedById']($('#PreparedBy').select2('data').id);
            });

            // Journal Voucher Line Datatable
            var $JournalVoucherLineTable;
            $(function () {
                $JournalVoucherLineTable = $("#tableJournalVoucherLine").dataTable({
                    "sPaginationType": "full_numbers",
                    "bProcessing": true,
                    "bRetrieve": true,
                    "sAjaxSource": '/api/TrnJournalVoucherLine',
                    "sAjaxDataProp": "",
                    "aLengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
                    "aoColumns": [
                        {
                            "mData":"Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<a data-id=' + data + ' data-toggle="modal" href="#modalJournalVoucherLine" class="open-modalAccount btn btn-primary">Edit</a>'
                            }
                        },
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<button type="button" class="btn btn-danger" onclick="cmdDeleteJournalVoucherLine_onclick(' + data + ')">Delete</button>'
                            }
                        },
                        { "mData": "Branch", "sWidth": "100px" },
                        { "mData": "Account", "sWidth": "200px" },
                        { "mData": "Article", "sWidth": "200px" },
                        { "mData": "Particulars", "sWidth": "200px" },
                        { "mData": "DebitAmount", "sWidth": "70px" },
                        { "mData": "CreditAmount", "sWidth": "70px" }
                    ]
                });
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
                    data: function (registration, page) {
                        return {
                            page: page,
                            pageSize: 100,
                            registration: registration
                        };
                    },
                    results: function (data, page) {
                        var more = (page * 100) < data.total;
                        return { results: data, more: more };
                    }
                }
            }).change(function () {
                koTrnJournalVoucherModel['CheckedById']($('#CheckedBy').select2('data').id);
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
                    data: function (registration, page) {
                        return {
                            page: page,
                            pageSize: 100,
                            registration: registration
                        };
                    },
                    results: function (data, page) {
                        var more = (page * 100) < data.total;
                        return { results: data, more: more };
                    }
                }
            }).change(function () {
                koTrnJournalVoucherModel['ApprovedById']($('#ApprovedBy').select2('data').id);
            });

            // Bind the Page: TrnJournalVoucher
            if ($Id != "") {
                koNamespace.getJournalVoucher($Id);
            } else {
                var viewModel = koNamespace.initViewModel(null);
                ko.applyBindings(viewModel);
                koTrnJournalVoucherModel = viewModel;
            }
        });

        // Onclick: Print
        function cmdPrint_onclick() {
            var $Id = GetParameterByName("Id");
            if ($Id != "") {
                location.href = 'TrnJournalVoucherPreview.aspx?Id=' + $Id;
            }
        }

        // Onclick: Save
        function cmdSave_onclick() {
            var $Id = GetParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnJournalVoucher',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON(koTrnJournalVoucherModel),
                        success: function (data) {
                            location.href = 'TrnJournalVoucherDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }

        // Onclick: Update
        function cmdUpdate_onclick() {
            if (confirm('Update record?')) {
                var $Id = GetParameterByName("Id");
                if ($Id != "") {
                    $.ajax({
                        url: '/api/TrnJournalVoucher/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON(koTrnJournalVoucherModel),
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

        // Onchange: Prepared By
        $('#PreparedBy').change(function () {
           
        });

        // Onchange: Checked By
        $('#CheckedBy').change(function () {
            
        });

        // Onchange: Approved By
        $('#ApprovedBy').change(function () {
            
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
                        <input id="cmdUpdate" type="button" value="Update" class="btn btn-primary" onclick="cmdUpdate_onclick()" />
                        <input id="cmdPrint" type="button" value="Print" class="btn btn-primary" onclick="cmdPrint_onclick()" />
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Period </label>
                        <div class="controls">
                            <input type="text" data-bind="value: Period" class="input-large" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Branch </label>
                        <div class="controls">
                            <input type="text" data-bind="value: Branch" class="input-large" disabled="disabled"/>
                        </div>
                    </div>                    
                    <div class="control-group">
                        <label class="control-label">JV Number </label>
                        <div class="controls">
                            <input type="text" data-bind="value: JVNumber" class="input-medium" disabled="disabled"/>
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
                            <input type="text" data-bind="value: JVManualNumber" class="input-medium" />
                        </div>
                    </div>
                </div>

                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Particulars: </label>
                        <div class="controls">
                            <textarea rows="3" data-bind="value: Particulars" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Prepared By </label>
                        <div class="controls">
                            <input  id="PreparedBy" type="hidden" data-bind="value: PreparedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Checked By </label>
                        <div class="controls">
                            <input  id="CheckedBy" type="hidden" data-bind="value: CheckedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Approved By </label>
                        <div class="controls">
                            <input  id="ApprovedBy" type="hidden" data-bind="value: ApprovedBy" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="span12">
                    <table id="tableJournalVoucherLine" class="table table-striped table-condensed" >
                    <thead>
                        <tr>
                            <th colspan="8" style="text-align:right">
                                <input id="cmdAddLine" type="button" value="Add" class="btn btn-primary" />
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
                    <tbody id="tableBodyJournalVoucherLine"></tbody>
                    </table>
                </div>
            </div>

        </div>
     </div>
</asp:Content>
