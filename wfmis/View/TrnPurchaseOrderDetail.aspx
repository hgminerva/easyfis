<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnPurchaseOrderDetail.aspx.cs" Inherits="wfmis.View.TrnPurchaseOrderDetail" %>

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

        // Global Application Variables
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';

        // Global Variable
        var $Id = 0;
        var $koNamespace = {};
        var $PageSize = 20;
        var $Modal01 = false;

        var $PurchaseOrderLineTable;

        // Binding
        var $koPurchaseOrderModel;
        var $koPurchaseOrderLineModel;
        $koNamespace.initPurchaseOrder = function (PurchaseOrder) {
            var self = this;

            self.PeriodId = ko.observable(!PurchaseOrder ? $CurrentPeriodId : PurchaseOrder.PeriodId),
            self.Period = ko.observable(!PurchaseOrder ? $CurrentPeriod : PurchaseOrder.Period),
            self.BranchId = ko.observable(!PurchaseOrder ? $CurrentBranchId : PurchaseOrder.BranchId),
            self.Branch = ko.observable(!PurchaseOrder ? $CurrentBranch : PurchaseOrder.Branch),
            self.PONumber = ko.observable(!PurchaseOrder ? "" : PurchaseOrder.PONumber),
            self.POManualNumber = ko.observable(!PurchaseOrder ? "" : PurchaseOrder.POManualNumber),
            self.PODate = ko.observable(!PurchaseOrder ? easyFIS.getCurrentDate() : PurchaseOrder.PODate),
            self.SupplierId = ko.observable(!PurchaseOrder ? 0 : PurchaseOrder.SupplierId),
            self.Supplier = ko.observable(!PurchaseOrder ? "" : PurchaseOrder.Supplier),
            self.TermId = ko.observable(!PurchaseOrder ? 0 : PurchaseOrder.TermId),
            self.Term = ko.observable(!PurchaseOrder ? "" : PurchaseOrder.Term),
            self.RequestNumber = ko.observable(!PurchaseOrder ? "" : PurchaseOrder.RequestNumber),
            self.DateNeeded = ko.observable(!PurchaseOrder ? easyFIS.getCurrentDate() : PurchaseOrder.DateNeeded),
            self.Particulars = ko.observable(!PurchaseOrder ? "NA" : PurchaseOrder.Particulars),
            self.RequestedById = ko.observable(!PurchaseOrder ? $CurrentUserId : PurchaseOrder.RequestedById),
            self.RequestedBy = ko.observable(!PurchaseOrder ? $CurrentUser : PurchaseOrder.RequestedBy),
            self.IsClosed = ko.observable(!PurchaseOrder ? false : PurchaseOrder.IsClosed),
            self.PreparedById = ko.observable(!PurchaseOrder ? $CurrentUserId : PurchaseOrder.PreparedById),
            self.PreparedBy = ko.observable(!PurchaseOrder ? $CurrentUser : PurchaseOrder.PreparedBy),
            self.CheckedById = ko.observable(!PurchaseOrder ? $CurrentUserId : PurchaseOrder.CheckedById),
            self.CheckedBy = ko.observable(!PurchaseOrder ? $CurrentUser : PurchaseOrder.CheckedBy),
            self.ApprovedById = ko.observable(!PurchaseOrder ? $CurrentUserId : PurchaseOrder.ApprovedById),
            self.ApprovedBy = ko.observable(!PurchaseOrder ? $CurrentUser : PurchaseOrder.ApprovedBy),
            self.IsLocked = ko.observable(!PurchaseOrder ? false : PurchaseOrder.IsLocked),
            self.CreatedById = ko.observable(!PurchaseOrder ? $CurrentUserId : PurchaseOrder.CreatedById),
            self.CreatedBy = ko.observable(!PurchaseOrder ? $CurrentUser : PurchaseOrder.CreatedBy),
            self.CreatedDateTime = ko.observable(!PurchaseOrder ? "" : PurchaseOrder.CreatedDateTime),
            self.UpdatedById = ko.observable(!PurchaseOrder ? $CurrentUserId : PurchaseOrder.UpdatedById),
            self.UpdatedBy = ko.observable(!PurchaseOrder ? $CurrentUser : PurchaseOrder.UpdatedBy),
            self.UpdatedDateTime = ko.observable(!PurchaseOrder ? "" : PurchaseOrder.UpdatedDateTime),

            // Select2 defaults
            $('#Supplier').select2('data', { id: !PurchaseOrder ? 0 : PurchaseOrder.SupplierId, text: !PurchaseOrder ? "" : PurchaseOrder.Supplier });
            $('#Term').select2('data', { id: !PurchaseOrder ? 0 : PurchaseOrder.TermId, text: !PurchaseOrder ? "" : PurchaseOrder.Term });
            $('#RequestedBy').select2('data', { id: !PurchaseOrder ? $CurrentUserId : PurchaseOrder.RequestedBy, text: !PurchaseOrder ? $CurrentUser : PurchaseOrder.RequestedBy });
            $('#PreparedBy').select2('data', { id: !PurchaseOrder ? $CurrentUserId : PurchaseOrder.PreparedById, text: !PurchaseOrder ? $CurrentUser : PurchaseOrder.PreparedBy });
            $('#CheckedBy').select2('data', { id: !PurchaseOrder ? $CurrentUserId : PurchaseOrder.CheckedById, text: !PurchaseOrder ? $CurrentUser : PurchaseOrder.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !PurchaseOrder ? $CurrentUserId : PurchaseOrder.ApprovedById, text: !PurchaseOrder ? $CurrentUser : PurchaseOrder.ApprovedBy });

            if ((!PurchaseOrder ? false : PurchaseOrder.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#PONumber').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#Supplier').select2('disable');
                $('#Term').select2('disable');
                $('#RequestedBy').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');

            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#PONumber').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);

                $('#Supplier').select2('enable');
                $('#Term').select2('enable');
                $('#RequestedBy').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');

            }

            return self;
        };
        $koNamespace.bindPurchaseOrder = function (PurchaseOrder) {
            var viewModel = $koNamespace.initPurchaseOrder(PurchaseOrder);
            ko.applyBindings(viewModel, $("#PurchaseOrderDetail")[0]); 
            $koPurchaseOrderModel = viewModel;
        }
        $koNamespace.getPurchaseOrder = function (Id) {
            if (!Id) {
                $koNamespace.bindPurchaseOrder(null);
            } else {
                $.ajax({
                    url: '/api/TrnPurchaseOrder/' + Id + '/PurchaseOrder',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (PurchaseOrder) {
                        $koNamespace.bindPurchaseOrder(PurchaseOrder);
                        RenderPurchaseOrderLine(Id);
                    }
                }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                });  
            }
        }
        $koNamespace.initPurchaseOrderLine = function (PurchaseOrderLine) {
            var self = this;

            self.LineId = ko.observable(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineId);
            self.LinePOId = ko.observable(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LinePOId);
            self.LineItemId = ko.observable(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineItemId);
            self.LineItem = ko.observable(!PurchaseOrderLine ? "" : PurchaseOrderLine.LineItem);
            self.LineParticulars = ko.observable(!PurchaseOrderLine ? "NA" : PurchaseOrderLine.LineParticulars);
            self.LineUnitId = ko.observable(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineUnitId);
            self.LineUnit = ko.observable(!PurchaseOrderLine ? "" : PurchaseOrderLine.LineUnit);
            self.LineCost = ko.observable(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineCost);
            self.LineQuantity = ko.observable(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineQuantity);
            self.LineAmount = ko.observable(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineAmount);

            return self;
        }
        $koNamespace.bindPurchaseOrderLine = function (PurchaseOrderLine) {
            try {
                var viewModel = $koNamespace.initPurchaseOrderLine(PurchaseOrderLine);
                ko.applyBindings(viewModel, $("#PurchaseOrderLineDetail")[0]); //Bind the section #PurchaseOrderLineDetail (Modal)
                $koPurchaseOrderLineModel = viewModel;

                $('#LineItem').select2('data', { id: !PurchaseOrderLine ? 0 : PurchaseOrderLine.LineItemId, text: !PurchaseOrderLine ? "" : PurchaseOrderLine.LineItem });
                $('#LineUnit').select2('data', { id: !PurchaseOrderLine ? 0 : PurchaseOrderLine.LineUnitId, text: !PurchaseOrderLine ? "" : PurchaseOrderLine.LineUnit });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineId).change();
                $('#LinePOId').val(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LinePOId).change();
                $('#LineItemId').val(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineItemId).change();
                $('#LineItem').select2('data', { id: !PurchaseOrderLine ? 0 : PurchaseOrderLine.LineItemId, text: !PurchaseOrderLine ? "" : PurchaseOrderLine.LineItem });
                $('#LineParticulars').val(!PurchaseOrderLine ? "NA" : PurchaseOrderLine.LineParticulars).change();
                $('#LineUnitId').val(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineUnitId).change();
                $('#LineUnit').select2('data', { id: !PurchaseOrderLine ? 0 : PurchaseOrderLine.LineUnitId, text: !PurchaseOrderLine ? "" : PurchaseOrderLine.LineUnit });
                $('#LineCost').val(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineCost).change();
                $('#LineQuantity').val(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineQuantity).change();
                $('#LineAmount').val(!PurchaseOrderLine ? 0 : PurchaseOrderLine.LineAmount).change();
            }
        }

        // Click events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnPurchaseOrder',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koPurchaseOrderModel),
                        success: function (data) {
                            location.href = 'TrnPurchaseOrderDetail.aspx?Id=' + data.Id;
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
                            url: '/api/TrnPurchaseOrder/' + $Id + '/Update',
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koPurchaseOrderModel),
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
                window.location.href = '/api/SysReport?Report=PurchaseOrder&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnPurchaseOrderList.aspx';
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#PurchaseOrderLineModal').modal('show');
                $koNamespace.bindPurchaseOrderLine(null);
                // FK
                $('#LinePOId').val($Id).change();
            } else {
                if (confirm('Save record?')) {
                    CmdSave_onclick();
                }
                // alert('Purchase Order not yet saved.');
            }
        }
        function CmdEditLine_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/TrnPurchaseOrderLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindPurchaseOrderLine(data);
                        $('#PurchaseOrderLineModal').modal('show');
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdCloseLine_onclick() {
            $('#PurchaseOrderLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#PurchaseOrderLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnPurchaseOrderLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koPurchaseOrderLineModel),
                    success: function (data) {
                        RenderPurchaseOrderLine(easyFIS.getParameterByName("Id"));
                        // location.href = 'TrnPurchaseOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnPurchaseOrderLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koPurchaseOrderLineModel),
                    success: function (data) {
                        RenderPurchaseOrderLine(easyFIS.getParameterByName("Id"));
                        // location.href = 'TrnPurchaseOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                    url: '/api/TrnPurchaseOrderLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        RenderPurchaseOrderLine(easyFIS.getParameterByName("Id"));
                        // location.href = 'TrnPurchaseOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                        url: '/api/TrnPurchaseOrder/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnPurchaseOrderDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Purchase Order not yet saved.');
            }
        }

        // Render Datatable
        function RenderPurchaseOrderLine(Id) {
            $PurchaseOrderLineTable = $("#PurchaseOrderLineTable").dataTable({
                                            "bServerSide": true,
                                            "sAjaxSource": '/api/TrnPurchaseOrder/' + Id + '/PurchaseOrderLines',
                                            "sAjaxDataProp": "TrnPurchaseOrderLineData",
                                            "bProcessing": true,
                                            "bLengthChange": false,
                                            "iDisplayLength": 20,
                                            "bDestroy": true,
                                            "sPaginationType": "full_numbers",
                                            "aoColumns": [
                                                            {
                                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                                "mRender": function (data) {
                                                                    return '<input runat="server" id="CmdEditLine" type="button" class="btn btn-primary" value="&#xf044;" style="font-family:Arial, FontAwesome"/>'
                                                                }
                                                            },
                                                            {
                                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                                "mRender": function (data) {
                                                                    return '<input runat="server" id="CmdDeleteLine" type="button" class="btn btn-danger" value="&#xf068;" style="font-family:Arial, FontAwesome"/>'
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
        }

        // Select2 Control
        function Select2_Supplier() {
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
                $('#SupplierId').val($('#Supplier').select2('data').id).change();
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
        function Select2_RequestedBy() {
            $('#RequestedBy').select2({
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
                $('#RequestedBy').val($('#RequestedBy').select2('data').id).change();
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

        // Private Functions
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
            // Page Id
            $Id = easyFIS.getParameterByName("Id");

            // DatePicker Controls
            $('#PODate').datepicker().on('changeDate', function (ev) {
                $koPurchaseOrderModel['PODate']($(this).val());
                $(this).datepicker('hide');
            });
            $('#DateNeeded').datepicker().on('changeDate', function (ev) {
                $koPurchaseOrderModel['DateNeeded']($(this).val());
                $(this).datepicker('hide');
            });

            // Select Control
            Select2_Supplier();
            Select2_Term();
            Select2_RequestedBy();
            Select2_PreparedBy();
            Select2_CheckedBy();
            Select2_ApprovedBy();
            Select2_LineItem();
            Select2_LineUnit();

            KeyUp_LineCost();
            KeyUp_LineQuantity();

            // Event Handler Line Table
            $("#PurchaseOrderLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#PurchaseOrderLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) {
                    CmdEditLine_onclick(Id);
                }
                if (ButtonName.search("CmdDeleteLine") > 0) {
                    CmdDeleteLine_onclick(Id);
                }
            });

            // Bind Page
            if ($Id != "") {
                $koNamespace.getPurchaseOrder($Id);
            } else {
                $koNamespace.getPurchaseOrder(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) == "/api/Select") {
                // Do nothing
            } else if (settings.url.substr(0, 25) == "/api/TrnPurchaseOrderLine") {
                if (settings.type.substr(0, 3) == "GET") {
                    if ($Modal01 == true) $('#PurchaseOrderLineModal').modal('hide');
                    $('#loading-indicator-modal').modal('show');
                }
            } else {
                if ($Modal01 == true) $('#PurchaseOrderLineModal').modal('hide');
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            $('#loading-indicator-modal').modal('hide');
            if ($Modal01 == true) $('#PurchaseOrderLineModal').modal('show');
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Purchase Order Detail</h2>

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
                        <input runat="server" id="CmdSave" type="button" class="btn btn-primary" value="Save" onclick="CmdSave_onclick()" />
                        <input runat="server" id="CmdApprove" type="button" class="btn btn-primary" value="Approve" onclick="CmdApproval_onclick(true)" />
                        <input runat="server" id="CmdDisapprove" type="button" class="btn btn-primary" value="Disapprove" onclick="CmdApproval_onclick(false)" />
                        <input runat="server" id="CmdPrint" type="button" class="btn btn-primary" value="Print" onclick="CmdPrint_onclick()" />
                        <input runat="server" id="CmdClose" type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()" />
                    </div>
                </div>
            </div>

            <section id="PurchaseOrderDetail">
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
                            <label class="control-label">PO Number</label>
                            <div class="controls">
                                <input id="PONumber" type="text" data-bind="value: PONumber" class="input-medium" disabled="disabled" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">PO Manual Number</label>
                            <div class="controls">
                                <input id="POManualNumber" type="text" data-bind="value: POManualNumber" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">PO Date </label>
                            <div class="controls">
                                <input id="PODate" type="text" data-bind="value: PODate" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Supplier </label>
                            <div class="controls">
                                <input id="SupplierId" type="hidden" data-bind="value: SupplierId" class="input-medium" />
                                <input id="Supplier" type="text" data-bind="value: Supplier" class="input-xlarge" />
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
                            <label class="control-label">Request Number </label>
                            <div class="controls">
                                <input id="RequestNumber" type="text" data-bind="value: RequestNumber" class="input-medium" />
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
                            <label class="control-label">Requested By </label>
                            <div class="controls">
                                <input id="RequestedById" type="hidden" data-bind="value: RequestedById" class="input-medium" />
                                <input id="RequestedBy" type="text" data-bind="value: RequestedBy" class="input-xlarge" />
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

            <section id="PurchaseOrderLine">
                <div class="row">
                    <div class="span12">
                        <table id="PurchaseOrderLineTable" class="table table-striped table-condensed">
                            <thead>
                                <tr>
                                    <th colspan="9">
                                        <input runat="server" id="CmdAddLine" type="button" class="btn btn-primary" value="&#xf067;" style="font-family:Arial, FontAwesome" onclick="CmdAddLine_onclick()" />
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
                            <tbody id="PurchaseOrderLineTableBody">
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tbody>
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

            <section id="PurchaseOrderLineDetail">
                <div id="PurchaseOrderLineModal" class="modal hide fade in" style="display: none;">
                    <div class="modal-header">
                        <a class="close" data-dismiss="modal">×</a>
                        <h3>Purchase Order Line Detail</h3>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="form-horizontal">
                                <div class="control-group">
                                    <div class="controls">
                                        <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                        <input id="LinePOId" type="hidden" data-bind="value: LinePOId" class="input-medium" />
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
                                    <label for="LineCost" class="control-label">Cost</label>
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
