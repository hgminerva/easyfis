<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnDisbursementDetail.aspx.cs" Inherits="wfmis.View.TrnDisbursementDetail" %>

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
    <script src="../Scripts/easyfis/easyfis.utils.v2.js"></script>
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';
        var $CurrentCompanyId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentCompanyId %>';

        var $koNamespace = {};
        var $selectPageSize = 20;
        var $Modal01 = false;
        var $Id = 0;

        // Disbursement Model (Detail)
        var $koDisbursementModel;
        $koNamespace.initDisbursement = function (Disbursement) {
            var self = this;

            self.Id = ko.observable(!Disbursement ? $Id : Disbursement.Id),
            self.PeriodId = ko.observable(!Disbursement ? $CurrentPeriodId : Disbursement.PeriodId),
            self.Period = ko.observable(!Disbursement ? $CurrentPeriod : Disbursement.Period),
            self.BranchId = ko.observable(!Disbursement ? $CurrentBranchId : Disbursement.BranchId),
            self.Branch = ko.observable(!Disbursement ? $CurrentBranch : Disbursement.Branch),
            self.CVNumber = ko.observable(!Disbursement ? "" : Disbursement.CVNumber),
            self.CVManualNumber = ko.observable(!Disbursement ? "" : Disbursement.CVManualNumber),
            self.CVDate = ko.observable(!Disbursement ? easyFIS.getCurrentDate() : Disbursement.CVDate),
            self.Particulars = ko.observable(!Disbursement ? "NA" : Disbursement.Particulars),
            self.SupplierId = ko.observable(!Disbursement ? 0 : Disbursement.SupplierId),
            self.Supplier = ko.observable(!Disbursement ? "" : Disbursement.Supplier),
            self.BankId = ko.observable(!Disbursement ? 0 : Disbursement.BankId),
            self.Bank = ko.observable(!Disbursement ? "" : Disbursement.Bank),
            self.PayTypeId = ko.observable(!Disbursement ? 0 : Disbursement.PayTypeId),
            self.PayType = ko.observable(!Disbursement ? "" : Disbursement.PayType),
            self.CheckNumber = ko.observable(!Disbursement ? "NA" : Disbursement.CheckNumber),
            self.CheckDate = ko.observable(!Disbursement ? easyFIS.getCurrentDate() : Disbursement.CheckDate),
            self.CheckPayee = ko.observable(!Disbursement ? "NA" : Disbursement.CheckPayee),
            self.TotalAmount = ko.observable(easyFIS.formatNumber(!Disbursement ? 0 : Disbursement.TotalAmount, 2, ',', '.', '', '', '-', '')),
            self.DateCleared = ko.observable(!Disbursement ? easyFIS.getCurrentDate() : Disbursement.DateCleared),
            self.IsCleared = ko.observable(!Disbursement ? false : Disbursement.IsCleared),
            self.PreparedById = ko.observable(!Disbursement ? $CurrentUserId : Disbursement.PreparedById),
            self.PreparedBy = ko.observable(!Disbursement ? $CurrentUser : Disbursement.PreparedBy),
            self.CheckedById = ko.observable(!Disbursement ? $CurrentUserId : Disbursement.CheckedById),
            self.CheckedBy = ko.observable(!Disbursement ? $CurrentUser : Disbursement.CheckedBy),
            self.ApprovedById = ko.observable(!Disbursement ? $CurrentUserId : Disbursement.ApprovedById),
            self.ApprovedBy = ko.observable(!Disbursement ? $CurrentUser : Disbursement.ApprovedBy),
            self.IsLocked = ko.observable(!Disbursement ? false : Disbursement.IsLocked),
            self.CreatedById = ko.observable(!Disbursement ? $CurrentUserId : Disbursement.CreatedById),
            self.CreatedBy = ko.observable(!Disbursement ? $CurrentUser : Disbursement.CreatedBy),
            self.CreatedDateTime = ko.observable(!Disbursement ? "" : Disbursement.CreatedDateTime),

            self.UpdatedById = ko.observable(!Disbursement ? $CurrentUserId : Disbursement.UpdatedById),
            self.UpdatedBy = ko.observable(!Disbursement ? $CurrentUser : Disbursement.UpdatedBy),
            self.UpdatedDateTime = ko.observable(!Disbursement ? "" : Disbursement.UpdatedDateTime),

            // Select2 defaults
            $('#Supplier').select2('data', { id: !Disbursement ? 0 : Disbursement.SupplierId, text: !Disbursement ? "" : Disbursement.Supplier });
            $('#Bank').select2('data', { id: !Disbursement ? 0 : Disbursement.BankId, text: !Disbursement ? "" : Disbursement.Bank });
            $('#PayType').select2('data', { id: !Disbursement ? 0 : Disbursement.PayTypeId, text: !Disbursement ? "" : Disbursement.PayType });
            $('#PreparedBy').select2('data', { id: !Disbursement ? $CurrentUserId : Disbursement.PreparedById, text: !Disbursement ? $CurrentUser : Disbursement.PreparedBy });
            $('#CheckedBy').select2('data', { id: !Disbursement ? $CurrentUserId : Disbursement.CheckedById, text: !Disbursement ? $CurrentUser : Disbursement.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !Disbursement ? $CurrentUserId : Disbursement.ApprovedById, text: !Disbursement ? $CurrentUser : Disbursement.ApprovedBy });

            if ((!Disbursement ? false : Disbursement.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#CVNumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);

                $('#Supplier').select2('disable');
                $('#Bank').select2('disable');
                $('#PayType').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');
            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#CVNumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);

                $('#Supplier').select2('enable');
                $('#Bank').select2('enable');
                $('#PayType').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');
            }

            return self;
        };
        $koNamespace.bindDisbursement = function (Disbursement) {
            var viewModel = $koNamespace.initDisbursement(Disbursement);
            ko.applyBindings(viewModel, $("#DisbursementDetail")[0]); //Bind the section #DisbursementDetail
            $koDisbursementModel = viewModel;
        }
        $koNamespace.getDisbursement = function (Id) {
            if (!Id) {
                $koNamespace.bindDisbursement(null);
            } else {
                // Render Disbursement
                $.ajax({
                    url: '/api/TrnDisbursement/' + Id + '/Disbursement',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (Disbursement) {
                        $koNamespace.bindDisbursement(Disbursement);

                        // Render Disbursement Line
                        $("#DisbursementLineTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnDisbursement/' + Id + '/DisbursementLines',
                            "sAjaxDataProp": "TrnDisbursementLineData",
                            "bProcessing": true,
                            "bLengthChange": false,
                            "iDisplayLength": 20,
                            "sPaginationType": "full_numbers",
                            "aoColumns": [
                                            {
                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdEditLine" type="button" class="btn btn-primary" value="Edit" />';
                                                }
                                            },
                                            {
                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdDeleteLine" type="button" class="btn btn-danger" value="Delete" />';
                                                }
                                            },
                                            { "mData": "LineAccount", "sWidth": "300px" },
                                            { "mData": "LineBranch", "sWidth": "200px" },
                                            { "mData": "LinePINumber", "sWidth": "150px" },
                                            { "mData": "LineParticulars" },
                                            {
                                                "mData": "LineAmount", "sWidth": "100px", "sClass": "alignRight",
                                                "mRender": function (data) {
                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                }
                                            }],
                            "fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                                var TotalAmount = 0;

                                for (var i = 0 ; i < aaData.length ; i++) {
                                    TotalAmount += aaData[i]['LineAmount'] * 1;
                                }

                                var nCells = nRow.getElementsByTagName('td');
                                nCells[6].innerHTML = easyFIS.formatNumber(TotalAmount, 2, ',', '.', '', '', '-', '');
                            }
                        });

                        // Render Journal Entries
                        $("#JournalEntryTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnJournal/' + Id + '/DisbursementJournals',
                            "sAjaxDataProp": "TrnJournalData",
                            "bProcessing": true,
                            "bLengthChange": false,
                            "iDisplayLength": 20,
                            "sPaginationType": "full_numbers",
                            "aoColumns": [
                                            { "mData": "Period", "sWidth": "200px" },
                                            { "mData": "Branch", "sWidth": "200px" },
                                            { "mData": "Account" },
                                            {
                                                "mData": "DebitAmount", "sWidth": "150px", "sClass": "alignRight",
                                                "mRender": function (data) {
                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                }
                                            },
                                            {
                                                "mData": "CreditAmount", "sWidth": "150px", "sClass": "alignRight",
                                                "mRender": function (data) {
                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                }
                                            }],
                            "fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                                var DebitAmount = 0;
                                var CreditAmount = 0;

                                for (var i = 0 ; i < aaData.length ; i++) {
                                    DebitAmount += aaData[i]['DebitAmount'] * 1;
                                    CreditAmount += aaData[i]['CreditAmount'] * 1;
                                }

                                var nCells = nRow.getElementsByTagName('td');
                                nCells[3].innerHTML = easyFIS.formatNumber(DebitAmount, 2, ',', '.', '', '', '-', '');
                                nCells[4].innerHTML = easyFIS.formatNumber(CreditAmount, 2, ',', '.', '', '', '-', '');
                            }
                        });
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        // Disbursement Line Model
        var $koDisbursementLineModel;
        $koNamespace.initDisbursementLine = function (DisbursementLine) {
            var self = this;

            self.LineId = ko.observable(!DisbursementLine ? 0 : DisbursementLine.LineId);
            self.LineCVId = ko.observable(!DisbursementLine ? 0 : DisbursementLine.LineCVId);
            self.LineAccountId = ko.observable(!DisbursementLine ? 0 : DisbursementLine.LineAccountId);
            self.LineAccount = ko.observable(!DisbursementLine ? "NA" : DisbursementLine.LineAccount);
            self.LinePIId = ko.observable(!DisbursementLine ? 0 : DisbursementLine.LinePIId);
            self.LinePINumber = ko.observable(!DisbursementLine ? "NA" : DisbursementLine.LinePINumber);
            self.LineParticulars = ko.observable(!DisbursementLine ? "NA" : DisbursementLine.LineParticulars);
            self.LineAmount = ko.observable(!DisbursementLine ? 0 : DisbursementLine.LineAmount);
            self.LineBranchId = ko.observable(!DisbursementLine ? $CurrentBranchId : DisbursementLine.LineBranchId);
            self.LineBranch = ko.observable(!DisbursementLine ? $CurrentBranch : DisbursementLine.LineBranch);

            return self;
        }
        $koNamespace.bindDisbursementLine = function (DisbursementLine) {
            try {
                var viewModel = $koNamespace.initDisbursementLine(DisbursementLine);
                ko.applyBindings(viewModel, $("#DisbursementLineDetail")[0]); 
                $koDisbursementLineModel = viewModel;

                $('#LineAccount').select2('data', { id: !DisbursementLine ? 0 : DisbursementLine.LineAccountId, text: !DisbursementLine ? "" : DisbursementLine.LineAccount });
                $('#LinePINumber').select2('data', { id: !DisbursementLine ? 0 : DisbursementLine.LinePIId, text: !DisbursementLine ? "" : DisbursementLine.LinePINumber });
                $('#LineBranch').select2('data', { id: !DisbursementLine ? $CurrentBranchId : DisbursementLine.LineBranchId, text: !DisbursementLine ? $CurrentBranch : DisbursementLine.LineBranch });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!DisbursementLine ? 0 : DisbursementLine.LineId).change();
                $('#LineCVId').val(!DisbursementLine ? 0 : DisbursementLine.LineCVId).change();

                $('#LineAccountId').val(!DisbursementLine ? 0 : DisbursementLine.LineAccountId).change();
                $('#LineAccount').select2('data', { id: !DisbursementLine ? 0 : DisbursementLine.LineAccountId, text: !DisbursementLine ? "" : DisbursementLine.LineAccount });

                $('#LineBranchId').val(!DisbursementLine ? $CurrentBranchId : DisbursementLine.LineBranchId).change();
                $('#LineBranch').select2('data', { id: !DisbursementLine ? $CurrentBranchId : DisbursementLine.LineBranchId, text: !DisbursementLine ? $CurrentBranch : DisbursementLine.LineBranch });

                $('#LinePIId').val(!DisbursementLine ? 0 : DisbursementLine.LinePIId).change();
                $('#LinePINumber').select2('data', { id: !DisbursementLine ? 0 : DisbursementLine.LinePIId, text: !DisbursementLine ? "" : DisbursementLine.LinePINumber });

                $('#LineParticulars').val(!DisbursementLine ? "NA" : DisbursementLine.LineParticulars).change();

                $('#LineAmount').val(!DisbursementLine ? 0 : DisbursementLine.LineAmount).change();
            }
        }

        // Events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnDisbursement',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koDisbursementModel),
                        success: function (data) {
                            location.href = 'TrnDisbursementDetail.aspx?Id=' + data.Id;
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
                            url: '/api/TrnDisbursement/' + $Id + '/Update',
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koDisbursementModel),
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
        function CmdPrint_onclick() {
            if ($Id > 0) {
                window.location.href = '/api/SysReport?Report=Disbursement&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnDisbursementList.aspx';
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#DisbursementLineModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindDisbursementLine(null);
                // FK
                $('#LineCVId').val($Id).change();
            } else {
                alert('Disbursement not yet saved.');
            }
        }
        function CmdCloseLine_onclick() {
            $('#DisbursementLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#DisbursementLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnDisbursementLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koDisbursementLineModel),
                    success: function (data) {
                        location.href = 'TrnDisbursementDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnDisbursementLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koDisbursementLineModel),
                    success: function (data) {
                        location.href = 'TrnDisbursementDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdEditLine_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/TrnDisbursementLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindDisbursementLine(data);
                        $('#DisbursementLineModal').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteLine_onclick(Id) {
            if (confirm('Are you sure?')) {
                $.ajax({
                    url: '/api/TrnDisbursementLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'TrnDisbursementDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdApproval_onclick(Approval) {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                if (confirm('Change approval.  Are you sure?')) {
                    $.ajax({
                        url: '/api/TrnDisbursement/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnDisbursementDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Disbursement not yet saved.');
            }
        }

        // Select2 Controls
        function select2_Supplier() {
            $('#Supplier').select2({
                placeholder: 'Supplier',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectSupplier',
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
                $('#SupplierId').val($('#Supplier').select2('data').id).change();
                select2_LinePINumber();
            });
        }
        function select2_Bank() {
            $('#Bank').select2({
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
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
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
                $('#BankId').val($('#Bank').select2('data').id).change();
            });
        }
        function select2_PayType() {
            $('#PayType').select2({
                placeholder: 'PayType',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectPayType',
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
                $('#PayTypeId').val($('#PayType').select2('data').id).change();
            });
        }
        function select2_PreparedBy() {
            $('#PreparedBy').select2({
                placeholder: 'Prepared By',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectStaff',
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
                $('#PreparedById').val($('#PreparedBy').select2('data').id).change();
            });
        }
        function select2_CheckedBy() {
            $('#CheckedBy').select2({
                placeholder: 'Checked By',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectStaff',
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
                $('#CheckedById').val($('#CheckedBy').select2('data').id).change();
            });
        }
        function select2_ApprovedBy() {
            $('#ApprovedBy').select2({
                placeholder: 'Approved By',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectStaff',
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
                $('#ApprovedById').val($('#ApprovedBy').select2('data').id).change();
            });
        }
        function select2_LinePINumber() {
            $('#LinePINumber').select2({
                placeholder: 'Purchase Invoice',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectPurchaseInvoice',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            supplierId: $('#SupplierId').val()
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LinePIId').val($('#LinePINumber').select2('data').id).change();
            });
        }
        function select2_LineAccount() {
            $('#LineAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
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
                $('#LineAccountId').val($('#LineAccount').select2('data').id).change();
            });
        }
        function Select2_LineBranch() {
            $('#LineBranch').select2({
                placeholder: 'Branch',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectBranch',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            fromBranchId: 0,
                            companyId: $CurrentCompanyId
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LineBranchId').val($('#LineBranch').select2('data').id).change();
            });
        }

        // On Page Load
        $(document).ready(function () {
            // Page Id
            $Id = easyFIS.getParameterByName("Id");

            // DatePicker Controls
            $('#CVDate').datepicker().on('changeDate', function (ev) {
                $(this).datepicker('hide');
            });
            $('#CheckDate').datepicker().on('changeDate', function (ev) {
                $(this).datepicker('hide');
            });

            // Select Controls
            select2_Supplier();
            select2_Bank();
            select2_PayType();
            select2_PreparedBy();
            select2_CheckedBy();
            select2_ApprovedBy();
            select2_LinePINumber();
            select2_LineAccount();
            Select2_LineBranch();

            $("#DisbursementLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#DisbursementLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) CmdEditLine_onclick(Id);
                if (ButtonName.search("CmdDeleteLine") > 0) CmdDeleteLine_onclick(Id);
            });

            // Bind Page 
            if ($Id != "") {
                $koNamespace.getDisbursement($Id);
            } else {
                $koNamespace.getDisbursement(null);
            }

            // Numeric
            $('#LineAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#DisbursementLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#DisbursementLineModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Disbursement Detail</h2>

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
                        <input runat="server" id="CmdSave" type="button" class="btn btn-primary" value="Save" onclick="CmdSave_onclick()"/>
                        <input runat="server" id="CmdApprove" type="button" class="btn btn-primary" value="Approve" onclick="CmdApproval_onclick(true)"/>
                        <input runat="server" id="CmdDisapprove" type="button" class="btn btn-primary" value="Disapprove" onclick="CmdApproval_onclick(false)"/>
                        <input runat="server" id="CmdPrint" type="button" class="btn btn-primary" value="Print" onclick="CmdPrint_onclick()"/>
                        <input runat="server" id="CmdClose" type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()"/>
                    </div>
                </div>
            </div>

            <section id="DisbursementDetail">
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
                        <label class="control-label">CV Number </label>
                        <div class="controls">
                            <input id="CVNumber" type="text" data-bind="value: CVNumber" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">CV Date </label>
                        <div class="controls">
                            <input id="CVDate" name="CVDate" type="text" data-bind="value: CVDate" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">CV Manual Number </label>
                        <div class="controls">
                            <input id="CVManualNumber" type="text" data-bind="value: CVManualNumber" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Supplier </label>
                        <div class="controls">
                            <input  id="SupplierId" type="hidden" data-bind="value: SupplierId" class="input-medium" />
                            <input  id="Supplier" type="text" data-bind="value: Supplier" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Bank </label>
                        <div class="controls">
                            <input  id="BankId" type="hidden" data-bind="value: BankId" class="input-medium" />
                            <input  id="Bank" type="text" data-bind="value: Bank" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Pay Type </label>
                        <div class="controls">
                            <input  id="PayTypeId" type="hidden" data-bind="value: PayTypeId" class="input-medium" />
                            <input  id="PayType" type="text" data-bind="value: PayType" class="input-xlarge" />
                        </div>
                    </div>
                </div>
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Check Number </label>
                        <div class="controls">
                            <input id="CheckNumber" type="text" data-bind="value: CheckNumber" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Check Date </label>
                        <div class="controls">
                            <input id="CheckDate" type="text" data-bind="value: CheckDate" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Check Payee </label>
                        <div class="controls">
                            <input id="CheckPayee" type="text" data-bind="value: CheckPayee" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Prepared By </label>
                        <div class="controls">
                            <input  id="PreparedById" type="hidden" data-bind="value: PreparedById" class="input-medium" />
                            <input  id="PreparedBy" type="text" data-bind="value: PreparedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Checked By </label>
                        <div class="controls">
                            <input  id="CheckedById" type="hidden" data-bind="value: CheckedById" class="input-medium" />
                            <input  id="CheckedBy" type="text" data-bind="value: CheckedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Approved By </label>
                        <div class="controls">
                            <input  id="ApprovedById" type="hidden" data-bind="value: ApprovedById" class="input-medium" />
                            <input  id="ApprovedBy" type="text" data-bind="value: ApprovedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Total Amount </label>
                        <div class="controls">
                            <input id="TotalAmount" type="text" data-bind="value: TotalAmount" class="text-right input-medium" disabled="disabled"/>
                        </div>
                    </div>
                </div>
            </div>
            </section>

            <section id="DisbusementLine">
            <div class="row">
                <div class="span12">
                    <table id="DisbursementLineTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="7">
                                    <input runat="server" id="CmdAddLine" type="button" class="btn btn-primary" value="Add" onclick="CmdAddLine_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Account</th>
                                <th>Branch</th>
                                <th>PI Number</th>
                                <th>Particulars</th>
                                <th>Amount</th> 
                            </tr>
                        </thead>
                        <tbody id="DisbursementLineTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td>Total:</td> 
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td style="text-align:right"></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
            </section>

            <br />

            <section id="JournalEntries">
            <div class="row">
                <div class="span12">
                    <table id="JournalEntryTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="5">
                                    Journal Entries
                                </th>
                            </tr>
                            <tr>
                                <th>Period</th>
                                <th>Banch</th>
                                <th>Account</th>
                                <th>Debit Amount</th>
                                <th>Credit Amount</th>
                            </tr>
                        </thead>
                        <tbody id="JournalEntryTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td>Total:</td> 
                                <td></td>
                                <td></td>
                                <td style="text-align:right"></td>
                                <td style="text-align:right"></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
            </section>

            <section id="DisbursementLineDetail">
            <div id="DisbursementLineModal" class="modal hide fade in" style="display: none;">
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Disbursement Line Detail</h3>  
                </div> 
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <div class="controls">
                                    <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                    <input id="LineCVId" type="hidden" data-bind="value: LineCVId" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineAccount" class="control-label">Account </label>
                                <div class="controls">
                                    <input id="LineAccountId" type="hidden" data-bind="value: LineAccountId" class="input-medium" />
                                    <input id="LineAccount" type="text" data-bind="value: LineAccount" class="input-block-level" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineBranch" class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="LineBranchId" type="hidden" data-bind="value: LineBranchId" class="input-medium" />
                                    <input id="LineBranch" type="text" data-bind="value: LineBranch" class="input-block-level" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePINumber" class="control-label">PI Number </label>
                                <div class="controls">
                                    <input id="LinePIId" type="hidden" data-bind="value: LinePIId" class="input-medium" />
                                    <input id="LinePINumber" type="text" data-bind="value: LinePINumber" class="input-medium" />
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
                    <a href="#" class="btn btn-primary" onclick="CmdSaveLine_onclick()">Save</a>  
                    <a href="#" class="btn btn-danger" onclick="CmdCloseLine_onclick()">Close</a>  
                </div>  
            </div>
            </section>

        </div>
    </div>
</asp:Content>
