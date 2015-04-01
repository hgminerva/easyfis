<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnStockTransferDetail.aspx.cs" Inherits="wfmis.View.TrnStockTransferDetail" %>

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
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';
        var $CurrentCompanyId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentCompanyId %>';
        var $PageSize = 20;

        // Binding
        var $Id = 0;
        var $koNamespace = {};
        var $koStockTransferModel;
        var $koStockTransferLineModel;
        var $Modal01 = false;
        var $LineUnitId = 0;
        var $LineUnit = "";

        $koNamespace.initStockTransfer = function (StockTransfer) {
            var self = this;

            self.PeriodId = ko.observable(!StockTransfer ? $CurrentPeriodId : StockTransfer.PeriodId);
            self.Period = ko.observable(!StockTransfer ? $CurrentPeriod : StockTransfer.Period);
            self.BranchId = ko.observable(!StockTransfer ? $CurrentBranchId : StockTransfer.BranchId);
            self.Branch = ko.observable(!StockTransfer ? $CurrentBranch : StockTransfer.Branch);
            self.STNumber = ko.observable(!StockTransfer ? "" : StockTransfer.STNumber);
            self.STManualNumber = ko.observable(!StockTransfer ? "" : StockTransfer.STManualNumber);
            self.STDate = ko.observable(!StockTransfer ? easyFIS.getCurrentDate() : StockTransfer.STDate);
            self.ToBranchId = ko.observable(!StockTransfer ? 0 : StockTransfer.ToBranchId);
            self.ToBranch = ko.observable(!StockTransfer ? "" : StockTransfer.ToBranch);
            self.AccountId = ko.observable(!StockTransfer ? 0 : StockTransfer.AccountId);
            self.Account = ko.observable(!StockTransfer ? "" : StockTransfer.Account);
            self.ArticleId = ko.observable(!StockTransfer ? 0 : StockTransfer.ArticleId);
            self.Article = ko.observable(!StockTransfer ? "" : StockTransfer.Article);
            self.Particulars = ko.observable(!StockTransfer ? "NA" : StockTransfer.Particulars);
            self.PreparedById = ko.observable(!StockTransfer ? $CurrentUserId : StockTransfer.PreparedById);
            self.PreparedBy = ko.observable(!StockTransfer ? $CurrentUser : StockTransfer.PreparedBy);
            self.CheckedById = ko.observable(!StockTransfer ? $CurrentUserId : StockTransfer.CheckedById);
            self.CheckedBy = ko.observable(!StockTransfer ? $CurrentUser : StockTransfer.CheckedBy);
            self.ApprovedById = ko.observable(!StockTransfer ? $CurrentUserId : StockTransfer.ApprovedById);
            self.ApprovedBy = ko.observable(!StockTransfer ? $CurrentUser : StockTransfer.ApprovedBy);
            self.IsLocked = ko.observable(!StockTransfer ? false : StockTransfer.IsLocked);
            self.CreatedById = ko.observable(!StockTransfer ? $CurrentUserId : StockTransfer.CreatedById);
            self.CreatedBy = ko.observable(!StockTransfer ? $CurrentUser : StockTransfer.CreatedBy);
            self.CreatedDateTime = ko.observable(!StockTransfer ? "" : StockTransfer.CreatedDateTime);
            self.UpdatedById = ko.observable(!StockTransfer ? $CurrentUserId : StockTransfer.UpdatedById);
            self.UpdatedBy = ko.observable(!StockTransfer ? $CurrentUser : StockTransfer.UpdatedBy);
            self.UpdatedDateTime = ko.observable(!StockTransfer ? "" : StockTransfer.UpdatedDateTime);

            // Select2 defaults
            $('#ToBranch').select2('data', { id: !StockTransfer ? 0 : StockTransfer.ToBranchId, text: !StockTransfer ? "" : StockTransfer.ToBranch });
            $('#Account').select2('data', { id: !StockTransfer ? 0 : StockTransfer.AccountId, text: !StockTransfer ? "" : StockTransfer.Account });
            $('#Article').select2('data', { id: !StockTransfer ? 0 : StockTransfer.ArticleId, text: !StockTransfer ? "" : StockTransfer.Article });
            $('#PreparedBy').select2('data', { id: !StockTransfer ? $CurrentUserId : StockTransfer.PreparedById, text: !StockTransfer ? $CurrentUser : StockTransfer.PreparedBy });
            $('#CheckedBy').select2('data', { id: !StockTransfer ? $CurrentUserId : StockTransfer.CheckedById, text: !StockTransfer ? $CurrentUser : StockTransfer.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !StockTransfer ? $CurrentUserId : StockTransfer.ApprovedById, text: !StockTransfer ? $CurrentUser : StockTransfer.ApprovedBy });


            if ((!StockTransfer ? false : StockTransfer.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#STNumber').prop("disabled", true);
                $('#LineCost').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#ToBranch').select2('disable');
                $('#Account').select2('disable');
                $('#Article').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');
            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#STNumber').prop("disabled", true);
                $('#LineCost').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#ToBranch').select2('enable');
                $('#Account').select2('enable');
                $('#Article').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');
            }

            return self;
        };
        $koNamespace.bindStockTransfer = function (StockTransfer) {
            var viewModel = $koNamespace.initStockTransfer(StockTransfer);
            ko.applyBindings(viewModel, $("#StockTransferDetail")[0]);
            $koStockTransferModel = viewModel;
        }
        $koNamespace.getStockTransfer = function (Id) {
            if (!Id) {
                $koNamespace.bindStockTransfer(null);
            } else {
                // Render Stock Transfer
                $.ajax({
                    url: '/api/TrnStockTransfer/' + Id + '/StockTransfer',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (StockTransfer) {
                        $koNamespace.bindStockTransfer(StockTransfer);

                        // Render Stock In Transfer
                        $("#StockTransferLineTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnStockTransfer/' + Id + '/StockTransferLines',
                            "sAjaxDataProp": "TrnStockTransferLineData",
                            "bProcessing": true,
                            "bLengthChange": false,
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
                                            { "mData": "LineQuantity", "sWidth": "100px" },
                                            { "mData": "LineUnit", "sWidth": "100px" },
                                            { "mData": "LineItem", "sWidth": "300px" },
                                            { "mData": "LineParticulars" },
                                            {
                                                "mData": "LineCost", "sWidth": "100px", "sClass": "alignRight",
                                                "mRender": function (data) {
                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                }
                                            },
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
                                nCells[7].innerHTML = easyFIS.formatNumber(TotalAmount, 2, ',', '.', '', '', '-', '');
                            }
                        });

                        // Render Journal Entries
                        $("#JournalEntryTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnJournal/' + Id + '/StockTransferJournals',
                            "sAjaxDataProp": "TrnJournalData",
                            "bProcessing": true,
                            "bLengthChange": false,
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

        $koNamespace.initStockTransferLine = function (StockTransferLine) {
            var self = this;

            self.LineId = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineId);
            self.LineSTId = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineSTId);
            self.LineItemId = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineItemId);
            self.LineItem = ko.observable(!StockTransferLine ? "" : StockTransferLine.LineItem);
            self.LineItemInventoryId = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineItemInventoryId);
            self.LineItemInventoryNumber = ko.observable(!StockTransferLine ? "" : StockTransferLine.LineItemInventoryNumber);
            self.LineParticulars = ko.observable(!StockTransferLine ? "NA" : StockTransferLine.LineParticulars);
            self.LineUnitId = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineUnitId);
            self.LineUnit = ko.observable(!StockTransferLine ? "" : StockTransferLine.LineUnit);
            self.LineCost = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineCost);
            self.LineQuantity = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineQuantity);
            self.LineAmount = ko.observable(!StockTransferLine ? 0 : StockTransferLine.LineAmount);

            return self;
        }
        $koNamespace.bindStockTransferLine = function (StockTransferLine) {
            try {
                var viewModel = $koNamespace.initStockTransferLine(StockTransferLine);
                ko.applyBindings(viewModel, $("#StockTransferLineDetail")[0]);
                $koStockTransferLineModel = viewModel;

                $('#LineItem').select2('data', { id: !StockTransferLine ? 0 : StockTransferLine.LineItemId, text: !StockTransferLine ? "" : StockTransferLine.LineItem });
                $('#LineItemInventoryNumber').select2('data', { id: !StockTransferLine ? 0 : StockTransferLine.LineItemInventoryId, text: !StockTransferLine ? "" : StockTransferLine.LineItemInventoryNumber });
                $('#LineUnit').select2('data', { id: !StockTransferLine ? 0 : StockTransferLine.LineUnitId, text: !StockTransferLine ? "" : StockTransferLine.LineUnit });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!StockTransferLine ? 0 : StockTransferLine.LineId).change();
                $('#LineSTId').val(!StockTransferLine ? 0 : StockTransferLine.LineSTId).change();
                $('#LineItemId').val(!StockTransferLine ? 0 : StockTransferLine.LineItemId).change();
                $('#LineItem').select2('data', { id: !StockTransferLine ? 0 : StockTransferLine.LineItemId, text: !StockTransferLine ? "" : StockTransferLine.LineItem });
                $('#LineItemInventoryId').val(!StockTransferLine ? 0 : StockTransferLine.LineItemInventoryId).change();
                $('#LineItemInventoryNumber').select2('data', { id: !StockTransferLine ? 0 : StockTransferLine.LineItemInventoryId, text: !StockTransferLine ? "" : StockTransferLine.LineItemInventoryNumber });
                $('#LineParticulars').val(!StockTransferLine ? "NA" : StockTransferLine.LineParticulars).change();
                $('#LineUnitId').val(!StockTransferLine ? 0 : StockTransferLine.LineUnitId).change();
                $('#LineUnit').select2('data', { id: !StockTransferLine ? 0 : StockTransferLine.LineUnitId, text: !StockTransferLine ? "" : StockTransferLine.LineUnit });
                $('#LineCost').val(!StockTransferLine ? 0 : StockTransferLine.LineCost).change();
                $('#LineQuantity').val(!StockTransferLine ? 0 : StockTransferLine.LineQuantity).change();
                $('#LineAmount').val(!StockTransferLine ? 0 : StockTransferLine.LineAmount).change();
            }
        }

        // Click events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnStockTransfer',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koStockTransferModel),
                        success: function (data) {
                            location.href = 'TrnStockTransferDetail.aspx?Id=' + data.Id;
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
                            url: '/api/TrnStockTransfer/' + $Id + '/Update',
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koStockTransferModel),
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
                window.location.href = '/api/SysReport?Report=StockTransfer&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnStockTransferList.aspx';
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#StockTransferLineModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindStockTransferLine(null);
                // FK
                $('#LineSTId').val($Id).change();
            }
        }
        function CmdEditLine_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/TrnStockTransferLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindStockTransferLine(data);
                        $('#StockTransferLineModal').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdCloseLine_onclick() {
            $('#StockTransferLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#StockTransferLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnStockTransferLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koStockTransferLineModel),
                    success: function (data) {
                        location.href = 'TrnStockTransferDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnStockTransferLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koStockTransferLineModel),
                    success: function (data) {
                        location.href = 'TrnStockTransferDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteLine_onclick(Id) {
            if (confirm('Are you sure?')) {
                $.ajax({
                    url: '/api/TrnStockTransferLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'TrnStockTransferDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                        url: '/api/TrnStockTransfer/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnStockTransferDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Stock Transfer not yet saved.');
            }
        }

        // Select Control
        function Select2_ToBranch() {
            $('#ToBranch').select2({
                placeholder: 'Sales Invoice',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectBranch',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term,
                            fromBranchId: $CurrentBranchId,
                            companyId: $CurrentCompanyId
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ToBranchId').val($('#ToBranch').select2('data').id).change();
            });
        }
        function Select2_Account() {
            $('#Account').select2({
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
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#AccountId').val($('#Account').select2('data').id).change();
            });
        }
        function Select2_Article() {
            $('#Article').select2({
                placeholder: 'Article',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectArticle',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ArticleId').val($('#Article').select2('data').id).change();
            });
        }
        function Select2_PreparedBy() {
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
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#PreparedById').val($('#PreparedBy').select2('data').id).change();
            });
        }
        function Select2_CheckedBy() {
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
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#CheckedById').val($('#CheckedBy').select2('data').id).change();
            });
        }
        function Select2_ApprovedBy() {
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
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#ApprovedById').val($('#ApprovedBy').select2('data').id).change();
            });
        }
        function Select2_LineItem() {
            $('#LineItem').select2({
                placeholder: 'Item',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectItem',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term,
                            IsInventory: true
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                },
                formatResult: function (data) {
                    var JSONObject = JSON.parse(data.text);
                    return JSONObject["Item"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["Item"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            }).change(function () {
                $('#LineItemId').val($('#LineItem').select2('data').id).change();

                Select2_LineItemInventoryNumber();
                Select2_LineUnit();

                OnChange_LineItemInventoryNumber();
            });
        }
        function Select2_LineItemInventoryNumber() {
            $('#LineItemInventoryNumber').select2({
                placeholder: 'Item Inventory',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectItemInventory',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term,
                            ItemId: $('#LineItemId').val(),
                            BranchId: $CurrentBranchId
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LineItemInventoryId').val($('#LineItemInventoryNumber').select2('data').id).change();
            });
        }
        function Select2_LineUnit() {
            $('#LineUnit').select2({
                placeholder: 'Unit',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectItemUnit',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term,
                            itemId: $('#LineItemId').val()
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LineUnitId').val($('#LineUnit').select2('data').id).change();
            });
        }

        // Other functions
        function KeyUp_LineCost() {
            $('#LineCost').on('keyup change', function () {
                $('#LineAmount').val($(this).val() * $('#LineQuantity').val()).change();
            });
        }
        function KeyUp_LineQuantity() {
            $('#LineQuantity').on('keyup change', function () {
                $('#LineAmount').val($(this).val() * $('#LineCost').val()).change();
            });
        }

        // On Change Event
        function OnChange_LineItem() {
            $('#LineItem').on('keyup change', function () {
                var ItemId = $('#LineItem').select2('data').id;
                var JSONObject = JSON.parse($('#LineItem').select2('data').text);

                $LineUnitId = JSONObject["UnitId"];
                $LineUnit = JSONObject["Unit"];

                $('#LineItemId').val(ItemId).change();

                Select2_LineItemInventoryNumber();
                Select2_LineUnit();

                OnChange_LineItemInventoryNumber();

                $('#LineItemInventoryId').val(0).change();
                $('#LineItemInventoryNumber').select2('data', { id: 0, text: "" });
                $('#LineUnitId').val($LineUnitId).change();
                $('#LineUnit').select2('data', { id: $LineUnitId, text: $LineUnit });
                $('#LineQuantity').val(0).change().trigger('focusout');
                $('#LineAmount').val(0).change().trigger('focusout');
            });
        }
        function OnChange_LineItemInventoryNumber() {
            $('#LineItemInventoryNumber').on('keyup change', function () {
                var ItemInventoryId = $('#LineItemInventoryNumber').select2('data').id;
                var ItemInventoryNumber = $('#LineItemInventoryNumber').select2('data').text;

                $('#LineItemInventoryId').val(ItemInventoryId).change();
                $('#LineCost').val(parseFloat(ItemInventoryNumber.substr(ItemInventoryNumber.indexOf('@') + 2, 10))).change().trigger('focusout');
                $('#LineQuantity').val(0).change().trigger('focusout');
                $('#LineAmount').val(0).change().trigger('focusout');
            });
        }

        // On Page Ready 
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // DatePicker Controls
            $('#STDate').datepicker().on('changeDate', function (ev) {
                $koStockTransferModel['STDate']($(this).val());
                $(this).datepicker('hide');
            });

            // Select Control
            Select2_ToBranch();
            Select2_Account();
            Select2_Article();
            Select2_PreparedBy();
            Select2_CheckedBy();
            Select2_ApprovedBy();
            Select2_LineItem();
            Select2_LineItemInventoryNumber();
            Select2_LineUnit();

            OnChange_LineItem();
            OnChange_LineItemInventoryNumber();

            KeyUp_LineCost();
            KeyUp_LineQuantity();

            // Event Handler Line Table
            $("#StockTransferLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#StockTransferLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) CmdEditLine_onclick(Id);
                if (ButtonName.search("CmdDeleteLine") > 0) CmdDeleteLine_onclick(Id);
            });

            // Bind the Page
            if ($Id != "") {
                $koNamespace.getStockTransfer($Id);
            } else {
                $koNamespace.getStockTransfer(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#StockTransferLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#StockTransferLineModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Stock Transfer Detail</h2>

            <input runat="server" id="PageName" type="hidden" value="" class="text" />
            <input runat="server" id="PageCompanyId" type="hidden" value="0" class="text" />
            <input runat="server" id="PageId" type="hidden" value="0" class="text" />

            <p>
                <asp:SiteMapPath ID="SiteMapPath1" runat="server"></asp:SiteMapPath>
            </p>

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

            <section id="StockTransferDetail">
                <div class="row">
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label">Period </label>
                            <div class="controls">
                                <input id="Period" type="text" data-bind="value: Period" class="input-large" disabled="disabled" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Branch </label>
                            <div class="controls">
                                <input id="Branch" type="text" data-bind="value: Branch" class="input-large" disabled="disabled" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Transfer Number</label>
                            <div class="controls">
                                <input id="STNumber" type="text" data-bind="value: STNumber" class="input-medium" disabled="disabled" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Transfer Manual Number</label>
                            <div class="controls">
                                <input id="STManualNumber" type="text" data-bind="value: STManualNumber" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Transfer Date </label>
                            <div class="controls">
                                <input id="STDate" type="text" data-bind="value: STDate" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">To Branch </label>
                            <div class="controls">
                                <input id="ToBranchId" type="hidden" data-bind="value: ToBranchId" class="input-medium" />
                                <input id="ToBranch" type="text" data-bind="value: ToBranch" class="input-medium" />
                            </div>
                        </div>
                    </div>
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label">Account </label>
                            <div class="controls">
                                <input id="AccountId" type="hidden" data-bind="value: AccountId" class="input-medium" />
                                <input id="Account" type="text" data-bind="value: Account" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Article </label>
                            <div class="controls">
                                <input id="ArticleId" type="hidden" data-bind="value: ArticleId" class="input-medium" />
                                <input id="Article" type="text" data-bind="value: Article" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Particulars </label>
                            <div class="controls">
                                <textarea id="Particulars" rows="3" data-bind="value: Particulars" class="input-block-level"></textarea>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Prepared By </label>
                            <div class="controls">
                                <input id="PreparedById" type="hidden" data-bind="value: PreparedById" class="input-medium" />
                                <input id="PreparedBy" type="text" data-bind="value: PreparedBy" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Checked By </label>
                            <div class="controls">
                                <input id="CheckedById" type="hidden" data-bind="value: CheckedById" class="input-medium" />
                                <input id="CheckedBy" type="text" data-bind="value: CheckedBy" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Approved By </label>
                            <div class="controls">
                                <input id="ApprovedById" type="hidden" data-bind="value: ApprovedById" class="input-medium" />
                                <input id="ApprovedBy" type="text" data-bind="value: ApprovedBy" class="input-xlarge" />
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section id="StockTransferLine">
                <div class="row">
                    <div class="span12">
                        <table id="StockTransferLineTable" class="table table-striped table-condensed">
                            <thead>
                                <tr>
                                    <th colspan="9">
                                        <input runat="server" id="CmdAddLine" type="button" class="btn btn-primary" value="Add" onclick="CmdAddLine_onclick()"/>
                                    </th>
                                </tr>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th>Quantity</th>
                                    <th>Unit</th>
                                    <th>Item</th>
                                    <th>Particulars</th>
                                    <th>Price</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="StockTransferLineTableBody"></tbody>
                            <tfoot>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td style="text-align: right"></td>
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

            <section id="StockTransferLineDetail">
                <div id="StockTransferLineModal" class="modal hide fade in" style="display: none;">
                    <div class="modal-header">
                        <a class="close" data-dismiss="modal">×</a>
                        <h3>Stock In Line Detail</h3>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="form-horizontal">
                                <div class="control-group">
                                    <div class="controls">
                                        <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                        <input id="LineSTId" type="hidden" data-bind="value: LineSTId" class="input-medium" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LineItem" class="control-label">Item</label>
                                    <div class="controls">
                                        <input id="LineItemId" type="hidden" data-bind="value: LineItemId" class="input-medium" />
                                        <input id="LineItem" type="text" data-bind="value: LineItem" class="input-block-level" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LineParticulars" class="control-label">Particulars </label>
                                    <div class="controls">
                                        <textarea id="LineParticulars" rows="3" data-bind="value: LineParticulars" class="input-block-level"></textarea>
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LineItem" class="control-label">Item Inventory No </label>
                                    <div class="controls">
                                        <input id="LineItemInventoryId" type="hidden" data-bind="value: LineItemInventoryId" class="input-medium" />
                                        <input id="LineItemInventoryNumber" type="text" data-bind="value: LineItemInventoryNumber" class="input-block-level" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LineUnit" class="control-label">Unit</label>
                                    <div class="controls">
                                        <input id="LineUnitId" type="hidden" data-bind="value: LineUnitId" class="input-medium" />
                                        <input id="LineUnit" type="text" data-bind="value: LineUnit" class="input-medium" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LinePrice" class="control-label">Cost</label>
                                    <div class="controls">
                                        <input id="LineCost" type="number" data-bind="value: LineCost" class="input-medium pagination-right" data-validation-number-message="Numbers only please" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LineQuantity" class="control-label">Quantity</label>
                                    <div class="controls">
                                        <input id="LineQuantity" type="number" data-bind="value: LineQuantity" class="input-medium pagination-right" data-validation-number-message="Numbers only please" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LineAmount" class="control-label">Amount</label>
                                    <div class="controls">
                                        <input id="LineAmount" type="number" data-bind="value: LineAmount" disabled="disabled" class="input-medium pagination-right" data-validation-number-message="Numbers only please" />
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
