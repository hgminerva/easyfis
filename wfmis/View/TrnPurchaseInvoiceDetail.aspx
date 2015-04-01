<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnPurchaseInvoiceDetail.aspx.cs" Inherits="wfmis.View.TrnPurchaseInvoiceDetail" %>

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
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        // Page variables
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';
        
        var $koNamespace = {};
        var $selectPageSize = 20;
        var $Modal01 = false;

        var $Id = 0;
        var $LineUnitId = 0;
        var $LineUnit = "";
        var $LinePurchaseTaxId = 0;
        var $LinePurchaseTax = "";
        var $LinePurchaseTaxRate = 0;
        var $LinePurchaseTaxType = "";

        // Purchase Invoice Model (Detail)
        var $koPurchaseInvoiceModel;
        $koNamespace.initPurchaseInvoice = function (PurchaseInvoice) {
            var self = this;

            self.Id = ko.observable(!PurchaseInvoice ? $Id : PurchaseInvoice.Id),
            self.PeriodId = ko.observable(!PurchaseInvoice ? $CurrentPeriodId : PurchaseInvoice.PeriodId),
            self.Period = ko.observable(!PurchaseInvoice ? $CurrentPeriod : PurchaseInvoice.Period),
            self.BranchId = ko.observable(!PurchaseInvoice ? $CurrentBranchId : PurchaseInvoice.BranchId),
            self.Branch = ko.observable(!PurchaseInvoice ? $CurrentBranch : PurchaseInvoice.Branch),
            self.PINumber = ko.observable(!PurchaseInvoice ? "" : PurchaseInvoice.PINumber),
            self.PIManualNumber = ko.observable(!PurchaseInvoice ? "" : PurchaseInvoice.PIManualNumber),
            self.PIDate = ko.observable(!PurchaseInvoice ? easyFIS.getCurrentDate() : PurchaseInvoice.PIDate),
            self.SupplierId = ko.observable(!PurchaseInvoice ? 0 : PurchaseInvoice.SupplierId),
            self.Supplier = ko.observable(!PurchaseInvoice ? "" : PurchaseInvoice.Supplier),
            self.TermId = ko.observable(!PurchaseInvoice ? 0 : PurchaseInvoice.TermId),
            self.Term = ko.observable(!PurchaseInvoice ? "" : PurchaseInvoice.Term),
            self.DocumentReference = ko.observable(!PurchaseInvoice ? "NA" : PurchaseInvoice.DocumentReference),
            self.Particulars = ko.observable(!PurchaseInvoice ? "NA" : PurchaseInvoice.Particulars),
            self.TotalAmount = ko.observable(easyFIS.formatNumber(!PurchaseInvoice ? 0 : PurchaseInvoice.TotalAmount, 2, ',', '.', '', '', '-', '')),
            self.TotalPaidAmount = ko.observable(!PurchaseInvoice ? 0 : PurchaseInvoice.TotalPaidAmount),
            self.TotalCreditAmount = ko.observable(!PurchaseInvoice ? 0 : PurchaseInvoice.TotalCreditAmount),
            self.TotalDebitAmount = ko.observable(!PurchaseInvoice ? 0 : PurchaseInvoice.TotalDebitAmount),
            self.PreparedById = ko.observable(!PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.PreparedById),
            self.PreparedBy = ko.observable(!PurchaseInvoice ? $CurrentUser : PurchaseInvoice.PreparedBy),
            self.CheckedById = ko.observable(!PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.CheckedById),
            self.CheckedBy = ko.observable(!PurchaseInvoice ? $CurrentUser : PurchaseInvoice.CheckedBy),
            self.ApprovedById = ko.observable(!PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.ApprovedById),
            self.ApprovedBy = ko.observable(!PurchaseInvoice ? $CurrentUser : PurchaseInvoice.ApprovedBy),
            self.IsLocked = ko.observable(!PurchaseInvoice ? false : PurchaseInvoice.IsLocked),
            self.CreatedById = ko.observable(!PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.CreatedById),
            self.CreatedBy = ko.observable(!PurchaseInvoice ? $CurrentUser : PurchaseInvoice.CreatedBy),
            self.CreatedDateTime = ko.observable(!PurchaseInvoice ? "" : PurchaseInvoice.CreatedDateTime),
            self.UpdatedById = ko.observable(!PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.UpdatedById),
            self.UpdatedBy = ko.observable(!PurchaseInvoice ? $CurrentUser : PurchaseInvoice.UpdatedBy),
            self.UpdatedDateTime = ko.observable(!PurchaseInvoice ? "" : PurchaseInvoice.UpdatedDateTime),

            // Select2 defaults
            $('#Supplier').select2('data', { id: !PurchaseInvoice ? 0 : PurchaseInvoice.SupplierId, text: !PurchaseInvoice ? "" : PurchaseInvoice.Supplier });
            $('#Term').select2('data', { id: !PurchaseInvoice ? 0 : PurchaseInvoice.TermId, text: !PurchaseInvoice ? "" : PurchaseInvoice.Term });
            $('#PreparedBy').select2('data', { id: !PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.PreparedById, text: !PurchaseInvoice ? $CurrentUser : PurchaseInvoice.PreparedBy });
            $('#CheckedBy').select2('data', { id: !PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.CheckedById, text: !PurchaseInvoice ? $CurrentUser : PurchaseInvoice.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !PurchaseInvoice ? $CurrentUserId : PurchaseInvoice.ApprovedById, text: !PurchaseInvoice ? $CurrentUser : PurchaseInvoice.ApprovedBy });

            if ((!PurchaseInvoice ? false : PurchaseInvoice.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#PINumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);
                $('#LineTaxRate').prop("disabled", true);
                $('#LineTaxAmount').prop("disabled", true);

                $('#Supplier').select2('disable');
                $('#Term').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');

            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#PINumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);
                $('#LineTaxRate').prop("disabled", true);
                $('#LineTaxAmount').prop("disabled", true);

                $('#Supplier').select2('enable');
                $('#Term').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');
            }

            return self;
        };
        $koNamespace.bindPurchaseInvoice = function (PurchaseInvoice) {
            var viewModel = $koNamespace.initPurchaseInvoice(PurchaseInvoice);
            ko.applyBindings(viewModel, $("#PurchaseInvoiceDetail")[0]); //Bind the section #PurchaseInvoiceDetail
            $koPurchaseInvoiceModel = viewModel;
        }
        $koNamespace.getPurchaseInvoice = function (Id) {
            if (!Id) {
                $koNamespace.bindPurchaseInvoice(null);
            } else {
                // Render Purchase Invoice
                $.ajax({
                    url: '/api/TrnPurchaseInvoice/' + Id + '/PurchaseInvoice',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (PurchaseInvoice) {
                        $koNamespace.bindPurchaseInvoice(PurchaseInvoice);

                        // Render Purchase Invoice Line
                        $("#PurchaseInvoiceLineTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnPurchaseInvoice/' + Id + '/PurchaseInvoiceLines',
                            "sAjaxDataProp": "TrnPurchaseInvoiceLineData",
                            "bProcessing": true,
                            "bLengthChange": false,
                            "iDisplayLength": 20,
                            "sPaginationType": "full_numbers",
                            "aoColumns": [
                                            {
                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdEditLine" type="button" class="btn btn-primary" value="Edit" />'
                                                }
                                            },
                                            {
                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdDeleteLine" type="button" class="btn btn-danger" value="Delete" />'
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
                                            { "mData": "LineTax", "sWidth": "100px" },
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
                                nCells[8].innerHTML = easyFIS.formatNumber(TotalAmount, 2, ',', '.', '', '', '-', '');
                            }
                        });

                        // Render Journal Entries
                        $("#JournalEntryTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnJournal/' + Id + '/PurchaseInvoiceJournals',
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

        // Purchase Invoice Line Model (Lines)
        var $koPurchaseInvoiceLineModel;
        $koNamespace.initPurchaseInvoiceLine = function (PurchaseInvoiceLine) {
            var self = this;

            self.LineId = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineId);
            self.LinePIId = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LinePIId);
            self.LinePOId = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LinePOId);
            self.LinePONumber = ko.observable(!PurchaseInvoiceLine ? "NA" : PurchaseInvoiceLine.LinePONumber);
            self.LineItemId = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineItemId);
            self.LineItem = ko.observable(!PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineItem);
            self.LineParticulars = ko.observable(!PurchaseInvoiceLine ? "NA" : PurchaseInvoiceLine.LineParticulars);
            self.LineUnitId = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineUnitId);
            self.LineUnit = ko.observable(!PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineUnit);
            self.LineCost = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineCost);
            self.LineQuantity = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineQuantity);
            self.LineAmount = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineAmount);
            self.LineTaxId = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxId);
            self.LineTax = ko.observable(!PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineTax);
            self.LineTaxRate = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxRate);
            self.LineTaxAmount = ko.observable(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxAmount);

            return self;
        }
        $koNamespace.bindPurchaseInvoiceLine = function (PurchaseInvoiceLine) {
            try {
                var viewModel = $koNamespace.initPurchaseInvoiceLine(PurchaseInvoiceLine);
                ko.applyBindings(viewModel, $("#PurchaseInvoiceLineDetail")[0]); //Bind the section #PurchaseInvoiceLineDetail (Modal)
                $koPurchaseInvoiceLineModel = viewModel;

                $('#LinePONumber').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LinePOId, text: !PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LinePONumber });
                $('#LineItem').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineItemId, text: !PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineItem });
                $('#LineUnit').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineUnitId, text: !PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineUnit });
                $('#LineTax').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxId, text: !PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineTax });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineId).change();
                $('#LinePIId').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LinePIId).change();

                $('#LinePOId').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LinePOId).change();
                $('#LinePONumber').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LinePOId, text: !PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LinePONumber });

                $('#LineItemId').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineItemId).change();
                $('#LineItem').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineItemId, text: !PurchaseInvoiceLine ? "":  PurchaseInvoiceLine.LineItem } );

                $('#LineParticulars').val(!PurchaseInvoiceLine ? "NA" : PurchaseInvoiceLine.LineParticulars).change();

                $('#LineUnitId').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineUnitId).change();
                $('#LineUnit').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineUnitId, text: !PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineUnit });

                $('#LineCost').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineCost).change();
                $('#LineQuantity').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineQuantity).change();
                $('#LineAmount').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineAmount).change();

                $('#LineTaxId').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxId).change();
                $('#LineTax').select2('data', { id: !PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxId, text: !PurchaseInvoiceLine ? "" : PurchaseInvoiceLine.LineTax });
                $('#LineTaxRate').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxRate).change();
                $('#LineTaxAmount').val(!PurchaseInvoiceLine ? 0 : PurchaseInvoiceLine.LineTaxAmount).change();
            }
        }

        // Click events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnPurchaseInvoice',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koPurchaseInvoiceModel),
                        success: function (data) {
                            location.href = 'TrnPurchaseInvoiceDetail.aspx?Id=' + data.Id;
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
                            url: '/api/TrnPurchaseInvoice/' + $Id + '/Update',
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koPurchaseInvoiceModel),
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
                window.location.href = '/api/SysReport?Report=PurchaseInvoice&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnPurchaseInvoiceList.aspx';
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#PurchaseInvoiceLineModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindPurchaseInvoiceLine(null);
                // FK
                $('#LinePIId').val($Id).change();
            } else {
                alert('Purchase Invoice not yet saved.');
            }
        }
        function CmdCloseLine_onclick() {
            $('#PurchaseInvoiceLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#PurchaseInvoiceLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnPurchaseInvoiceLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koPurchaseInvoiceLineModel),
                    success: function (data) {
                        location.href = 'TrnPurchaseInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnPurchaseInvoiceLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koPurchaseInvoiceLineModel),
                    success: function (data) {
                        location.href = 'TrnPurchaseInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                    url: '/api/TrnPurchaseInvoiceLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'TrnPurchaseInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
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
                    url: '/api/TrnPurchaseInvoiceLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindPurchaseInvoiceLine(data);
                        $('#PurchaseInvoiceLineModal').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdApproval_onclick(Approval) {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                if (confirm('Change approval.  Are you sure?')) {
                    $.ajax({
                        url: '/api/TrnPurchaseInvoice/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnPurchaseInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Purchase Invoice not yet saved.');
            }
        }

        // Select2 Controls
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
                $('#TermId').val($('#Term').select2('data').id).change();
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
        function Select2_LinePONumber() {
            $('#LinePONumber').select2({
                placeholder: 'Purchase Order',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectPurchaseOrder',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            supplierId: $('#Supplier').select2('data').id
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
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
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            POId: $('#LinePONumber').select2('data').id
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
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
                        } catch(err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
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
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            itemId: $('#LineItemId').val()
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            });
        }
        function Select2_LineTax() {
            $('#LineTax').select2({
                placeholder: 'Tax',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectTax',
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
                    return JSONObject["TaxCode"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["TaxCode"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            });
        }

        // On Change Events
        function OnChange_Supplier() {
            $('#Supplier').on('keyup change', function () {
                var SupplierId = $('#Supplier').select2('data').id;
                $('#SupplierId').val(SupplierId).change();

                Select2_LinePONumber();
                OnChange_LinePONumber();

                $.getJSON("/api/MstArticleSupplier/" + SupplierId + "/SupplierByArticleId", function (data) {
                    if (data) {
                        $('#Term').select2('data', { id: data.TermId, text: data.Term });
                        $('#TermId').val(data.TermId).change();
                    }
                });
            });
        }
        function OnChange_LinePONumber() {
            $('#LinePONumber').on('keyup change', function () {
                $('#LinePOId').val($('#LinePONumber').select2('data').id).change();

                Select2_LineItem();
                OnChange_LineItem();
            });
        }
        function OnChange_LineItem() {
            $('#LineItem').on('keyup change', function () {
                var ItemId = $('#LineItem').select2('data').id;
                var JSONObject = JSON.parse($('#LineItem').select2('data').text);

                $LineUnitId = JSONObject["UnitId"];
                $LineUnit = JSONObject["Unit"];
                $LinePurchaseTaxId = JSONObject["PurchaseTaxId"];
                $LinePurchaseTax = JSONObject["PurchaseTax"];
                $LinePurchaseTaxRate = (parseFloat(JSONObject["PurchaseTaxRate"]) / 100);
                $LinePurchaseTaxType = JSONObject["PurchaseTaxType"];

                $('#LineItemId').val(ItemId).change();

                Select2_LineUnit();
                OnChange_LineUnit();

                $('#LineQuantity').val(0).change().trigger('focusout');
                $('#LineCost').val(0).change().trigger('focusout');
                $('#LineAmount').val(0).change().trigger('focusout');
                $('#LineTaxId').val(0).change();
                $('#LineTax').select2('data', { id: 0, text: "" });
                $('#LineTaxAmount').val(0).change().trigger('focusout');
                $('#LineTaxRate').val(0).change().trigger('focusout');

                $('#LineUnitId').val($LineUnitId).change();
                $('#LineUnit').select2('data', { id: $LineUnitId, text: $LineUnit });
                $('#LineTaxId').val($LinePurchaseTaxId).change();
                $('#LineTax').select2('data', { id: $LinePurchaseTaxId, text: $LinePurchaseTax });
                $('#LineTaxRate').val($LinePurchaseTaxRate).change();
            });
        }
        function OnChange_LineUnit() {
            $('#LineUnit').on('keyup change', function () {
                $('#LineUnitId').val($('#LineUnit').select2('data').id).change();
            });
        }
        function OnChange_LineQuantity() {
            $('#LineQuantity').on('keyup change', function () {
                ComputeAmount();
            });  
        }
        function OnChange_LineCost() {
            $('#LineCost').on('keyup change', function () {
                ComputeAmount();
            }); 
        }
        function OnChange_LineTax() {
            $('#LineTax').on('keyup change', function () {
                var TaxId = $('#LineTax').select2('data').id;

                var JSONObject = JSON.parse($('#LineTax').select2('data').text);

                $LinePurchaseTaxRate = (parseFloat(JSONObject["PurchaseTaxRate"]) / 100);
                $LinePurchaseTaxType = JSONObject["PurchaseTaxType"];

                $('#LineTaxId').val(TaxId).change();
                $('#LineTaxRate').val($LinePurchaseTaxRate).change();

                ComputeTaxAmount();
            });
        }

        // Other functions
        function ComputeAmount() {
            var Amount = 0
            var Cost = parseFloat($('#LineCost').val().replace(',', ''));
            var Quantity = parseFloat($('#LineQuantity').val().replace(',', ''));

            Amount = easyFIS.round2Number(Cost * Quantity);

            $('#LineAmount').val(Amount).change().trigger('focusout');

            ComputeTaxAmount();
        }
        function ComputeTaxAmount() {
            var LineAmount = parseFloat($('#LineAmount').val().replace(',', ''));
            var TaxAmount = 0;
            if ($LinePurchaseTaxType == "INCLUSIVE") {
                TaxAmount = easyFIS.round2Number((LineAmount / (1 + $LinePurchaseTaxRate)) * $LinePurchaseTaxRate);
            } else {
                TaxAmount = easyFIS.round2Number(LineAmount * $LinePurchaseTaxRate);

                var Cost = parseFloat($('#LineCost').val().replace(',', ''));
                var Quantity = parseFloat($('#LineQuantity').val().replace(',', ''));

                Amount = TaxAmount + easyFIS.round2Number(Cost * Quantity);

                $('#LineAmount').val(Amount).change().trigger('focusout');
            }
            $('#LineTaxAmount').val(TaxAmount).change().trigger('focusout');
        }

        // On Page Ready 
        $(document).ready(function () {
            // Page Record Id
            $Id = easyFIS.getParameterByName("Id");

            // DatePicker Control
            $('#PIDate').datepicker().on('changeDate', function (ev) {
                $(this).datepicker('hide');
            });

            // Select Control
            Select2_Supplier();
            Select2_Term();
            Select2_PreparedBy();
            Select2_CheckedBy();
            Select2_ApprovedBy();
            Select2_LinePONumber();
            Select2_LineItem();
            Select2_LineUnit();
            Select2_LineTax();

            // Numeric input
            $('#TotalAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineQuantity').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineCost').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineCost').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineTaxRate').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            // On Change Events
            OnChange_Supplier();
            OnChange_LinePONumber();
            OnChange_LineItem();
            OnChange_LineUnit();
            OnChange_LineQuantity();
            OnChange_LineCost();
            OnChange_LineTax();

            // Line Table Event Handler
            $("#PurchaseInvoiceLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#PurchaseInvoiceLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) CmdEditLine_onclick(Id);
                if (ButtonName.search("CmdDeleteLine") > 0) CmdDeleteLine_onclick(Id);
            });

            // Bind the Page: TrnPurchaseInvoice
            if ($Id != "") {
                $koNamespace.getPurchaseInvoice($Id);
            } else {
                $koNamespace.getPurchaseInvoice(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#PurchaseInvoiceLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#PurchaseInvoiceLineModal').modal('show');
                } 
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Purchase Invoice Detail</h2>

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
                        <input runat="server" id="CmdSave" type="button" class="btn btn-primary" value="Save" onclick="CmdSave_onclick()" />
                        <input runat="server" id="CmdApprove" type="button" class="btn btn-primary" value="Approve" onclick="CmdApproval_onclick(true)" />
                        <input runat="server" id="CmdDisapprove" type="button" class="btn btn-primary" value="Disapprove" onclick="CmdApproval_onclick(false)" />                       
                        <input runat="server" id="CmdPrint" type="button" class="btn btn-primary" value="Print" onclick="CmdPrint_onclick()" />
                        <input runat="server" id="CmdClose" type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()" />
                    </div>
                </div>
            </div>

            <section id="PurchaseInvoiceDetail">
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
                        <label class="control-label">PI Number </label>
                        <div class="controls">
                            <input id="PINumber" type="text" data-bind="value: PINumber" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">PI Date </label>
                        <div class="controls">
                            <input id="PIDate" name="PIDate" type="text" data-bind="value: PIDate" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">PI Manual Number </label>
                        <div class="controls">
                            <input id="PIManualNumber" type="text" data-bind="value: PIManualNumber" class="input-medium" />
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
                        <label class="control-label">Term </label>
                        <div class="controls">
                            <input  id="TermId" type="hidden" data-bind="value: TermId" class="input-medium" />
                            <input  id="Term" type="text" data-bind="value: Term" class="input-large" />
                        </div>
                    </div>
                </div>
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Document Reference </label>
                        <div class="controls">
                            <input id="DocumentReference" type="text" data-bind="value: DocumentReference" class="input-large" />
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

            <section id="PurchaseInvoiceLine">
            <div class="row">
                <div class="span12">
                    <table id="PurchaseInvoiceLineTable" class="table table-striped table-condensed" >
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
                                <th>Cost</th>
                                <th>Tax</th>  
                                <th>Amount</th> 
                            </tr>
                        </thead>
                        <tbody id="PurchaseInvoiceLineTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td>Total:</td> 
                                <td></td>
                                <td></td>
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

            <section id="PurchaseInvoiceLineDetail">
            <div id="PurchaseInvoiceLineModal" class="modal hide fade in" style="display: none;">  
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Purchase Invoice Line Detail</h3>  
                </div>  
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <div class="controls">
                                    <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                    <input id="LinePIId" type="hidden" data-bind="value: LinePIId" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePONumber" class="control-label">PO Number</label>
                                <div class="controls">
                                    <input id="LinePOId" type="hidden" data-bind="value: LinePOId" class="input-medium" />
                                    <input id="LinePONumber" type="text" data-bind="value: LinePONumber" class="input-medium" />
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
                                <label for="LineQuantity" class="control-label">Quantity</label>
                                <div class="controls">
                                    <input id="LineQuantity" type="number" data-bind="value: LineQuantity" class="input-medium pagination-right" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineCost" class="control-label">Cost</label>
                                <div class="controls">
                                    <input id="LineCost" type="number" data-bind="value: LineCost" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineAmount" class="control-label">Amount</label>
                                <div class="controls">
                                    <input id="LineAmount" type="number" data-bind="value: LineAmount" disabled="disabled" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineTax" class="control-label">Tax</label>
                                <div class="controls">
                                    <input id="LineTaxId" type="hidden" data-bind="value: LineTaxId" class="input-medium" />
                                    <input id="LineTax" type="text" data-bind="value: LineTax" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineTaxRate" class="control-label">Tax Rate</label>
                                <div class="controls">
                                    <input id="LineTaxRate" type="number" data-bind="value: LineTaxRate" disabled="disabled" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineTaxAmount" class="control-label">Tax Amount</label>
                                <div class="controls">
                                    <input id="LineTaxAmount" type="number" data-bind="value: LineTaxAmount" disabled="disabled" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
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
