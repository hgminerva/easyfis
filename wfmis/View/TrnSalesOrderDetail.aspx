<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnSalesOrderDetail.aspx.cs" Inherits="wfmis.View.TrnSalesOrderDetail" %>

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

        var $koNamespace = {};
        var $koSalesOrderModel;
        var $koSalesOrderLineModel;

        var $Id = 0;
        var $Modal01 = false;

        $koNamespace.initSalesOrder = function (SalesOrder) {
            var self = this;

            self.PeriodId = ko.observable(!SalesOrder ? $CurrentPeriodId : SalesOrder.PeriodId),
            self.Period = ko.observable(!SalesOrder ? $CurrentPeriod : SalesOrder.Period),
            self.BranchId = ko.observable(!SalesOrder ? $CurrentBranchId : SalesOrder.BranchId),
            self.Branch = ko.observable(!SalesOrder ? $CurrentBranch : SalesOrder.Branch),
            self.SONumber = ko.observable(!SalesOrder ? "" : SalesOrder.SONumber),
            self.SOManualNumber = ko.observable(!SalesOrder ? "" : SalesOrder.SOManualNumber),
            self.SODate = ko.observable(!SalesOrder ? easyFIS.getCurrentDate() : SalesOrder.SODate),
            self.CustomerId = ko.observable(!SalesOrder ? 0 : SalesOrder.CustomerId),
            self.Customer = ko.observable(!SalesOrder ? "" : SalesOrder.Customer),
            self.TermId = ko.observable(!SalesOrder ? 0 : SalesOrder.TermId),
            self.Term = ko.observable(!SalesOrder ? "" : SalesOrder.Term),
            self.OrderNumber = ko.observable(!SalesOrder ? "" : SalesOrder.OrderNumber),
            self.DateNeeded = ko.observable(!SalesOrder ? easyFIS.getCurrentDate() : SalesOrder.DateNeeded),
            self.Particulars = ko.observable(!SalesOrder ? "NA" : SalesOrder.Particulars),
            self.OrderedById = ko.observable(!SalesOrder ? $CurrentUserId : SalesOrder.OrderedById),
            self.OrderedBy = ko.observable(!SalesOrder ? $CurrentUser : SalesOrder.OrderedBy),
            self.IsClosed = ko.observable(!SalesOrder ? false : SalesOrder.IsClosed),
            self.PreparedById = ko.observable(!SalesOrder ? $CurrentUserId : SalesOrder.PreparedById),
            self.PreparedBy = ko.observable(!SalesOrder ? $CurrentUser : SalesOrder.PreparedBy),
            self.CheckedById = ko.observable(!SalesOrder ? $CurrentUserId : SalesOrder.CheckedById),
            self.CheckedBy = ko.observable(!SalesOrder ? $CurrentUser : SalesOrder.CheckedBy),
            self.ApprovedById = ko.observable(!SalesOrder ? $CurrentUserId : SalesOrder.ApprovedById),
            self.ApprovedBy = ko.observable(!SalesOrder ? $CurrentUser : SalesOrder.ApprovedBy),
            self.IsLocked = ko.observable(!SalesOrder ? false : SalesOrder.IsLocked),
            self.CreatedById = ko.observable(!SalesOrder ? $CurrentUserId : SalesOrder.CreatedById),
            self.CreatedBy = ko.observable(!SalesOrder ? $CurrentUser : SalesOrder.CreatedBy),
            self.CreatedDateTime = ko.observable(!SalesOrder ? "" : SalesOrder.CreatedDateTime),
            self.UpdatedById = ko.observable(!SalesOrder ? $CurrentUserId : SalesOrder.UpdatedById),
            self.UpdatedBy = ko.observable(!SalesOrder ? $CurrentUser : SalesOrder.UpdatedBy),
            self.UpdatedDateTime = ko.observable(!SalesOrder ? "" : SalesOrder.UpdatedDateTime),

            // Select2 defaults
            $('#Customer').select2('data', { id: !SalesOrder ? 0 : SalesOrder.CustomerId, text: !SalesOrder ? "" : SalesOrder.Customer });
            $('#Term').select2('data', { id: !SalesOrder ? 0 : SalesOrder.TermId, text: !SalesOrder ? "" : SalesOrder.Term });
            $('#OrderedBy').select2('data', { id: !SalesOrder ? $CurrentUserId : SalesOrder.OrderedBy, text: !SalesOrder ? $CurrentUser : SalesOrder.OrderedBy });
            $('#PreparedBy').select2('data', { id: !SalesOrder ? $CurrentUserId : SalesOrder.PreparedById, text: !SalesOrder ? $CurrentUser : SalesOrder.PreparedBy });
            $('#CheckedBy').select2('data', { id: !SalesOrder ? $CurrentUserId : SalesOrder.CheckedById, text: !SalesOrder ? $CurrentUser : SalesOrder.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !SalesOrder ? $CurrentUserId : SalesOrder.ApprovedById, text: !SalesOrder ? $CurrentUser : SalesOrder.ApprovedBy });

            if ((!SalesOrder ? false : SalesOrder.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#SONumber').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#Customer').select2('disable');
                $('#Term').select2('disable');
                $('#OrderedBy').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');

            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#SONumber').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#Customer').select2('enable');
                $('#Term').select2('enable');
                $('#OrderedBy').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');
            }

            return self;
        };
        $koNamespace.bindSalesOrder = function (SalesOrder) {
            var viewModel = $koNamespace.initSalesOrder(SalesOrder);
            ko.applyBindings(viewModel, $("#SalesOrderDetail")[0]); //Bind the section #SalesOrderDetail
            $koSalesOrderModel = viewModel;
        }
        $koNamespace.getSalesOrder = function (Id) {
            if (!Id) {
                $koNamespace.bindSalesOrder(null);
            } else {
                // Render Sales Order
                $.ajax({
                    url: '/api/TrnSalesOrder/' + Id + '/SalesOrder',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (SalesOrder) {
                        $koNamespace.bindSalesOrder(SalesOrder);

                        // Render Sales Order Line
                        $("#SalesOrderLineTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnSalesOrder/' + Id + '/SalesOrderLines',
                            "sAjaxDataProp": "TrnSalesOrderLineData",
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
                                                "mData": "LinePrice", "sWidth": "100px", "sClass": "alignRight",
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
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        $koNamespace.initSalesOrderLine = function (SalesOrderLine) {
            var self = this;

            self.LineId = ko.observable(!SalesOrderLine ? 0 : SalesOrderLine.LineId);
            self.LineSOId = ko.observable(!SalesOrderLine ? 0 : SalesOrderLine.LineSOId);
            self.LineItemId = ko.observable(!SalesOrderLine ? 0 : SalesOrderLine.LineItemId);
            self.LineItem = ko.observable(!SalesOrderLine ? "" : SalesOrderLine.LineItem);
            self.LineParticulars = ko.observable(!SalesOrderLine ? "NA" : SalesOrderLine.LineParticulars);
            self.LineUnitId = ko.observable(!SalesOrderLine ? 0 : SalesOrderLine.LineUnitId);
            self.LineUnit = ko.observable(!SalesOrderLine ? "" : SalesOrderLine.LineUnit);
            self.LinePrice = ko.observable(!SalesOrderLine ? 0 : SalesOrderLine.LinePrice);
            self.LineQuantity = ko.observable(!SalesOrderLine ? 0 : SalesOrderLine.LineQuantity);
            self.LineAmount = ko.observable(!SalesOrderLine ? 0 : SalesOrderLine.LineAmount);

            return self;
        }
        $koNamespace.bindSalesOrderLine = function (SalesOrderLine) {
            try {
                var viewModel = $koNamespace.initSalesOrderLine(SalesOrderLine);
                ko.applyBindings(viewModel, $("#SalesOrderLineDetail")[0]); //Bind the section #SalesOrderLineDetail (Modal)
                $koSalesOrderLineModel = viewModel;

                $('#LineItem').select2('data', { id: !SalesOrderLine ? 0 : SalesOrderLine.LineItemId, text: !SalesOrderLine ? "" : SalesOrderLine.LineItem });
                $('#LineUnit').select2('data', { id: !SalesOrderLine ? 0 : SalesOrderLine.LineUnitId, text: !SalesOrderLine ? "" : SalesOrderLine.LineUnit });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!SalesOrderLine ? 0 : SalesOrderLine.LineId).change();
                $('#LineSOId').val(!SalesOrderLine ? 0 : SalesOrderLine.LineSOId).change();
                $('#LineItemId').val(!SalesOrderLine ? 0 : SalesOrderLine.LineItemId).change();
                $('#LineItem').select2('data', { id: !SalesOrderLine ? 0 : SalesOrderLine.LineItemId, text: !SalesOrderLine ? "" : SalesOrderLine.LineItem });
                $('#LineParticulars').val(!SalesOrderLine ? "NA" : SalesOrderLine.LineParticulars).change();
                $('#LineUnitId').val(!SalesOrderLine ? 0 : SalesOrderLine.LineUnitId).change();
                $('#LineUnit').select2('data', { id: !SalesOrderLine ? 0 : SalesOrderLine.LineUnitId, text: !SalesOrderLine ? "" : SalesOrderLine.LineUnit });
                $('#LinePrice').val(!SalesOrderLine ? 0 : SalesOrderLine.LinePrice).change();
                $('#LineQuantity').val(!SalesOrderLine ? 0 : SalesOrderLine.LineQuantity).change();
                $('#LineAmount').val(!SalesOrderLine ? 0 : SalesOrderLine.LineAmount).change();
            }
        }

        // Click events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnSalesOrder',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koSalesOrderModel),
                        success: function (data) {
                            location.href = 'TrnSalesOrderDetail.aspx?Id=' + data.Id;
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
                            url: '/api/TrnSalesOrder/' + $Id,
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koSalesOrderModel),
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
                window.location.href = '/api/SysReport?Report=SalesOrder&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnSalesOrderList.aspx';
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#SalesOrderLineModal').modal('show');
                $koNamespace.bindSalesOrderLine(null);
                // FK
                $('#LineSOId').val($Id).change();
            } else {
                alert('Sales Order not yet saved.');
            }
        }
        function CmdEditLine_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/TrnSalesOrderLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindSalesOrderLine(data);
                        $('#SalesOrderLineModal').modal('show');
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdCloseLine_onclick() {
            $('#SalesOrderLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#SalesOrderLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnSalesOrderLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koSalesOrderLineModel),
                    success: function (data) {
                        location.href = 'TrnSalesOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnSalesOrderLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koSalesOrderLineModel),
                    success: function (data) {
                        location.href = 'TrnSalesOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                    url: '/api/TrnSalesOrderLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'TrnSalesOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                        url: '/api/TrnSalesOrder/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnSalesOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Sales Order not yet saved.');
            }
        }

        // Select Control
        function Select2_Customer() {
            $('#Customer').select2({
                placeholder: 'Customer',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectCustomer',
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
                $('#CustomerId').val($('#Customer').select2('data').id).change();
            });
        }
        function Select2_Term() {
            $('#Term').select2({
                placeholder: 'Term',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectTerm',
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
                $('#TermId').val($('#Term').select2('data').id).change();
            });
        }
        function Select2_OrderedBy() {
            $('#OrderedBy').select2({
                placeholder: 'Requested By',
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
                $('#OrderedBy').val($('#OrderedBy').select2('data').id).change();
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
                            searchTerm: term
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
                Select2_LineUnit();
            });
        }
        function Select2_LineUnit() {
            // Select Control: Line Unit
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
        // Private Functions
        function KeyUp_LinePrice() {
            $('#LinePrice').on('keyup change', function () {
                $('#LineAmount').val($(this).val() * $('#LineQuantity').val()).change();
            });
        }
        function KeyUp_LineQuantity() {
            $('#LineQuantity').on('keyup change', function () {
                $('#LineAmount').val($(this).val() * $('#LinePrice').val()).change();
            });
        }

        // On Page Ready 
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // DatePicker Controls
            $('#SODate').datepicker().on('changeDate', function (ev) {
                $koSalesOrderModel['SODate']($(this).val());
                $(this).datepicker('hide');
            });
            $('#DateNeeded').datepicker().on('changeDate', function (ev) {
                $koSalesOrderModel['DateNeeded']($(this).val());
                $(this).datepicker('hide');
            });

            // Select Control
            Select2_Customer();
            Select2_Term();
            Select2_OrderedBy();
            Select2_PreparedBy();
            Select2_CheckedBy();
            Select2_ApprovedBy();
            Select2_LineItem();
            Select2_LineUnit();

            // Other events
            KeyUp_LinePrice();
            KeyUp_LineQuantity();

            // Event Handler Line Table
            $("#SalesOrderLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#SalesOrderLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) CmdEditLine_onclick(Id);
                if (ButtonName.search("CmdDeleteLine") > 0) CmdDeleteLine_onclick(Id);
            });

            // Bind the Page
            if ($Id != "") {
                $koNamespace.getSalesOrder($Id);
            } else {
                $koNamespace.getSalesOrder(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#SalesOrderLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#SalesOrderLineModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Sales Order Detail</h2>

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

            <section id="SalesOrderDetail">
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
                            <label class="control-label">SO Number</label>
                            <div class="controls">
                                <input id="SONumber" type="text" data-bind="value: SONumber" class="input-medium" disabled="disabled" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">SO Manual Number</label>
                            <div class="controls">
                                <input id="SOManualNumber" type="text" data-bind="value: SOManualNumber" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">SO Date </label>
                            <div class="controls">
                                <input id="SODate" type="text" data-bind="value: SODate" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Customer </label>
                            <div class="controls">
                                <input id="CustomerId" type="hidden" data-bind="value: CustomerId" class="input-medium" />
                                <input id="Customer" type="text" data-bind="value: Customer" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Term </label>
                            <div class="controls">
                                <input id="TermId" type="hidden" data-bind="value: TermId" class="input-medium" />
                                <input id="Term" type="text" data-bind="value: Term" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Order Number </label>
                            <div class="controls">
                                <input id="OrderNumber" type="text" data-bind="value: OrderNumber" class="input-medium" />
                            </div>
                        </div>
                    </div>
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label">Date Needed </label>
                            <div class="controls">
                                <input id="DateNeeded" type="text" data-bind="value: DateNeeded" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Particulars </label>
                            <div class="controls">
                                <textarea id="Particulars" rows="3" data-bind="value: Particulars" class="input-block-level"></textarea>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Ordered By </label>
                            <div class="controls">
                                <input id="OrderedById" type="hidden" data-bind="value: OrderedById" class="input-medium" />
                                <input id="OrderedBy" type="text" data-bind="value: OrderedBy" class="input-xlarge" />
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

            <section id="SalesOrderLine">
                <div class="row">
                    <div class="span12">
                        <table id="SalesOrderLineTable" class="table table-striped table-condensed">
                            <thead>
                                <tr>
                                    <th colspan="9">
                                        <input runat="server" id="CmdAddLine" type="button" class="btn btn-primary" value="Add" onclick="CmdAddLine_onclick()" />
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
                            <tbody id="SalesOrderLineTableBody"></tbody>
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

            <section id="SalesOrderLineDetail">
                <div id="SalesOrderLineModal" class="modal hide fade in" style="display: none;">
                    <div class="modal-header">
                        <a class="close" data-dismiss="modal">×</a>
                        <h3>Sales Order Line Detail</h3>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="form-horizontal">
                                <div class="control-group">
                                    <div class="controls">
                                        <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                        <input id="LineSOId" type="hidden" data-bind="value: LineSOId" class="input-medium" />
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
                                    <label for="LineUnit" class="control-label">Unit</label>
                                    <div class="controls">
                                        <input id="LineUnitId" type="hidden" data-bind="value: LineUnitId" class="input-medium" />
                                        <input id="LineUnit" type="text" data-bind="value: LineUnit" class="input-medium" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label for="LinePrice" class="control-label">Price</label>
                                    <div class="controls">
                                        <input id="LinePrice" type="number" data-bind="value: LinePrice" class="input-medium pagination-right" data-validation-number-message="Numbers only please" />
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
