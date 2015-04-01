<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnStockInDetail.aspx.cs" Inherits="wfmis.View.TrnStockInDetail" %>

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
        var $PageSize = 20;
        var $DefaultPage = "0";

        var $koNamespace = {};
        var $koStockInModel;
        var $koStockInLineModel;

        var $Modal01 = false;

        var $Id = 0;

        $koNamespace.initStockIn = function (StockIn) {
            var self = this;

            self.PeriodId = ko.observable(!StockIn ? $CurrentPeriodId : StockIn.PeriodId);
            self.Period = ko.observable(!StockIn ? $CurrentPeriod : StockIn.Period);
            self.BranchId = ko.observable(!StockIn ? $CurrentBranchId : StockIn.BranchId);
            self.Branch = ko.observable(!StockIn ? $CurrentBranch : StockIn.Branch);
            self.INNumber = ko.observable(!StockIn ? "" : StockIn.INNumber);
            self.INManualNumber = ko.observable(!StockIn ? "" : StockIn.INManualNumber);
            self.INDate = ko.observable(!StockIn ? easyFIS.getCurrentDate() : StockIn.INDate);
            self.PIId = ko.observable(!StockIn ? 0 : StockIn.PIId);
            self.PINumber = ko.observable(!StockIn ? "" : StockIn.PINumber);
            self.AccountId = ko.observable(!StockIn ? 0 : StockIn.AccountId);
            self.Account = ko.observable(!StockIn ? "" : StockIn.Account);
            self.ArticleId = ko.observable(!StockIn ? 0 : StockIn.ArticleId);
            self.Article = ko.observable(!StockIn ? "" : StockIn.Article);
            self.Particulars = ko.observable(!StockIn ? "NA" : StockIn.Particulars);
            self.PreparedById = ko.observable(!StockIn ? $CurrentUserId : StockIn.PreparedById);
            self.PreparedBy = ko.observable(!StockIn ? $CurrentUser : StockIn.PreparedBy);
            self.CheckedById = ko.observable(!StockIn ? $CurrentUserId : StockIn.CheckedById);
            self.CheckedBy = ko.observable(!StockIn ? $CurrentUser : StockIn.CheckedBy);
            self.ApprovedById = ko.observable(!StockIn ? $CurrentUserId : StockIn.ApprovedById);
            self.ApprovedBy = ko.observable(!StockIn ? $CurrentUser : StockIn.ApprovedBy);
            self.IsLocked = ko.observable(!StockIn ? false : StockIn.IsLocked);
            self.IsProduced = ko.observable(!StockIn ? false : StockIn.IsProduced);
            self.CreatedById = ko.observable(!StockIn ? $CurrentUserId : StockIn.CreatedById);
            self.CreatedBy = ko.observable(!StockIn ? $CurrentUser : StockIn.CreatedBy);
            self.CreatedDateTime = ko.observable(!StockIn ? "" : StockIn.CreatedDateTime);
            self.UpdatedById = ko.observable(!StockIn ? $CurrentUserId : StockIn.UpdatedById);
            self.UpdatedBy = ko.observable(!StockIn ? $CurrentUser : StockIn.UpdatedBy);
            self.UpdatedDateTime = ko.observable(!StockIn ? "" : StockIn.UpdatedDateTime);

            // Select2 defaults
            $('#PINumber').select2('data', { id: !StockIn ? 0 : StockIn.PIId, text: !StockIn ? "" : StockIn.PINumber });
            $('#Account').select2('data', { id: !StockIn ? 0 : StockIn.AccountId, text: !StockIn ? "" : StockIn.Account });
            $('#Article').select2('data', { id: !StockIn ? 0 : StockIn.ArticleId, text: !StockIn ? "" : StockIn.Article });
            $('#PreparedBy').select2('data', { id: !StockIn ? $CurrentUserId : StockIn.PreparedById, text: !StockIn ? $CurrentUser : StockIn.PreparedBy });
            $('#CheckedBy').select2('data', { id: !StockIn ? $CurrentUserId : StockIn.CheckedById, text: !StockIn ? $CurrentUser : StockIn.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !StockIn ? $CurrentUserId : StockIn.ApprovedById, text: !StockIn ? $CurrentUser : StockIn.ApprovedBy });
            // checkbox defaults
            $("#IsProduced").prop("checked", !StockIn ? false : StockIn.IsProduced);

            if ((!StockIn ? false : StockIn.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#INNumber').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#PINumber').select2('disable');
                $('#Account').select2('disable');
                $('#Article').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');
            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#INNumber').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#PINumber').select2('enable');
                $('#Account').select2('enable');
                $('#Article').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');
            }

            return self;
        };
        $koNamespace.bindStockIn = function (StockIn) {
            var viewModel = $koNamespace.initStockIn(StockIn);
            ko.applyBindings(viewModel, $("#StockInDetail")[0]); 
            $koStockInModel = viewModel;
        }
        $koNamespace.getStockIn = function (Id) {
            if (!Id) {
                $koNamespace.bindStockIn(null);
            } else {
                // Render Stock In
                $.ajax({
                    url: '/api/TrnStockIn/' + Id + '/StockIn',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (StockIn) {
                        $koNamespace.bindStockIn(StockIn);

                        // Render Stock In Line
                        $("#StockInLineTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnStockIn/' + Id + '/StockInLines',
                            "sAjaxDataProp": "TrnStockInLineData",
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
                            "sAjaxSource": '/api/TrnJournal/' + Id + '/StockInJournals',
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

        $koNamespace.initStockInLine = function (StockInLine) {
            var self = this;

            self.LineId = ko.observable(!StockInLine ? 0 : StockInLine.LineId);
            self.LineINId = ko.observable(!StockInLine ? 0 : StockInLine.LineINId);
            self.LineItemId = ko.observable(!StockInLine ? 0 : StockInLine.LineItemId);
            self.LineItem = ko.observable(!StockInLine ? "" : StockInLine.LineItem);
            self.LineItemInventoryId = ko.observable(!StockInLine ? 0 : StockInLine.LineItemInventoryId);
            self.LineItemInventoryNumber = ko.observable(!StockInLine ? "" : StockInLine.LineItemInventoryNumber);
            self.LineParticulars = ko.observable(!StockInLine ? "NA" : StockInLine.LineParticulars);
            self.LineUnitId = ko.observable(!StockInLine ? 0 : StockInLine.LineUnitId);
            self.LineUnit = ko.observable(!StockInLine ? "" : StockInLine.LineUnit);
            self.LineCost = ko.observable(!StockInLine ? 0 : StockInLine.LineCost);
            self.LineQuantity = ko.observable(!StockInLine ? 0 : StockInLine.LineQuantity);
            self.LineAmount = ko.observable(!StockInLine ? 0 : StockInLine.LineAmount);

            return self;
        }
        $koNamespace.bindStockInLine = function (StockInLine) {
            try {
                var viewModel = $koNamespace.initStockInLine(StockInLine);
                ko.applyBindings(viewModel, $("#StockInLineDetail")[0]);
                $koStockInLineModel = viewModel;

                $('#LineItem').select2('data', { id: !StockInLine ? 0 : StockInLine.LineItemId, text: !StockInLine ? "" : StockInLine.LineItem });
                $('#LineItemInventoryNumber').select2('data', { id: !StockInLine ? 0 : StockInLine.LineItemInventoryId, text: !StockInLine ? "" : StockInLine.LineItemInventoryNumber });
                $('#LineUnit').select2('data', { id: !StockInLine ? 0 : StockInLine.LineUnitId, text: !StockInLine ? "" : StockInLine.LineUnit });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!StockInLine ? 0 : StockInLine.LineId).change();
                $('#LineINId').val(!StockInLine ? 0 : StockInLine.LineINId).change();
                $('#LineItemId').val(!StockInLine ? 0 : StockInLine.LineItemId).change();
                $('#LineItem').select2('data', { id: !StockInLine ? 0 : StockInLine.LineItemId, text: !StockInLine ? "" : StockInLine.LineItem });
                $('#LineItemInventoryId').val(!StockInLine ? 0 : StockInLine.LineItemInventoryId).change();
                $('#LineItemInventoryNumber').select2('data', { id: !StockInLine ? 0 : StockInLine.LineItemInventoryId, text: !StockInLine ? "" : StockInLine.LineItemInventoryNumber });
                $('#LineParticulars').val(!StockInLine ? "NA" : StockInLine.LineParticulars).change();
                $('#LineUnitId').val(!StockInLine ? 0 : StockInLine.LineUnitId).change();
                $('#LineUnit').select2('data', { id: !StockInLine ? 0 : StockInLine.LineUnitId, text: !StockInLine ? "" : StockInLine.LineUnit });
                $('#LineCost').val(!StockInLine ? 0 : StockInLine.LineCost).change();
                $('#LineQuantity').val(!StockInLine ? 0 : StockInLine.LineQuantity).change();
                $('#LineAmount').val(!StockInLine ? 0 : StockInLine.LineAmount).change();
            }
        }

        // Click events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnStockIn',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koStockInModel),
                        success: function (data) {
                            location.href = 'TrnStockInDetail.aspx?Id=' + data.Id;
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
                            url: '/api/TrnStockIn/' + $Id + '/Update',
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koStockInModel),
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
                window.location.href = '/api/SysReport?Report=StockIn&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnStockInList.aspx?DefaultPage=' + $DefaultPage;
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#StockInLineModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindStockInLine(null);
                // FK
                $('#LineINId').val($Id).change();
            } else {
                alert('Stock In not yet saved.');
            }
        }
        function CmdEditLine_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/TrnStockInLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindStockInLine(data);
                        $('#StockInLineModal').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdCloseLine_onclick() {
            $('#StockInLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#StockInLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnStockInLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koStockInLineModel),
                    success: function (data) {
                        location.href = 'TrnStockInDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnStockInLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koStockInLineModel),
                    success: function (data) {
                        location.href = 'TrnStockInDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                    url: '/api/TrnStockInLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'TrnStockInDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                        url: '/api/TrnStockIn/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnStockInDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Stock In not yet saved.');
            }
        }

        // Select Control
        function Select2_PINumber() {
            $('#PINumber').select2({
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
                            pageSize: $PageSize,
                            pageNum: page,
                            searchTerm: term,
                            supplierId: 0
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $PageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#PIId').val($('#PINumber').select2('data').id).change();
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

        // Event
        function OnChange_LineItem() {
            $('#LineItem').on('keyup change', function () {
                var ItemId = $('#LineItem').select2('data').id;
                var JSONObject = JSON.parse($('#LineItem').select2('data').text);
                var Cost = JSONObject["DefaultCost"];

                $('#LineItemId').val(ItemId).change();
                $('#LineCost').val(Cost).change().trigger('focusout');

                Select2_LineItemInventoryNumber();
                Select2_LineUnit();
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

        // On Page Ready 
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            if (easyFIS.getParameterByName("DefaultPage") != "") {
                $DefaultPage = easyFIS.getParameterByName("DefaultPage");
            } else {
                $DefaultPage = "1";
            }

            // DatePicker Controls
            $('#INDate').datepicker().on('changeDate', function (ev) {
                $koStockInModel['INDate']($(this).val());
                $(this).datepicker('hide');
            });

            // Select Control
            Select2_PINumber();
            Select2_Account();
            Select2_Article();
            Select2_PreparedBy();
            Select2_CheckedBy();
            Select2_ApprovedBy();
            Select2_LineItem();
            Select2_LineItemInventoryNumber();
            Select2_LineUnit();

            OnChange_LineItem();

            KeyUp_LineCost();
            KeyUp_LineQuantity();

            // Event Handler Line Table
            $("#StockInLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#StockInLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) CmdEditLine_onclick(Id);
                if (ButtonName.search("CmdDeleteLine") > 0) CmdDeleteLine_onclick(Id);
            });

            // Bind the Page
            if ($Id != "") {
                $koNamespace.getStockIn($Id);
            } else {
                $koNamespace.getStockIn(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#StockInLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#StockInLineModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Stock In Detail</h2>

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

            <section id="StockInDetail">
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
                            <label class="control-label">IN Number</label>
                            <div class="controls">
                                <input id="INNumber" type="text" data-bind="value: INNumber" class="input-medium" disabled="disabled" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">IN Manual Number</label>
                            <div class="controls">
                                <input id="INManualNumber" type="text" data-bind="value: INManualNumber" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">IN Date </label>
                            <div class="controls">
                                <input id="INDate" type="text" data-bind="value: INDate" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Purchase Invoice </label>
                            <div class="controls">
                                <input id="PIId" type="hidden" data-bind="value: PIId" class="input-medium" />
                                <input id="PINumber" type="text" data-bind="value: PINumber" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Produced Internally </label>
                            <div class="controls">
                                <input id="IsProduced" type="checkbox" data-bind="checked: IsProduced" class="input-large" />
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

            <section id="StockInLine">
                <div class="row">
                    <div class="span12">
                        <table id="StockInLineTable" class="table table-striped table-condensed">
                            <thead>
                                <tr>
                                    <th colspan="8">
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
                                    <th>Cost</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="StockInLineTableBody"></tbody>
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

            <section id="StockInLineDetail">
                <div id="StockInLineModal" class="modal hide fade in" style="display: none;">
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
                                        <input id="LineINId" type="hidden" data-bind="value: LineINId" class="input-medium" />
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
