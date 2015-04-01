<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnSalesInvoiceDetail.aspx.cs" Inherits="wfmis.View.TrnSalesInvoiceDetail" %>

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
        var $Modal02 = false;

        var $Id = 0;
        var $LineUnitId = 0;
        var $LineUnit = "";
        var $LineSalesTaxId = 0;
        var $LineSalesTax = "";
        var $LineSalesTaxRate = 0;
        var $LineSalesTaxType = "";
        var $LinePriceId = 0;
        var $LinePriceDescription = "";
        var $LinePrice = 0;
        var $LineDiscountId = 0;
        var $LineDiscount = "";
        var $LineDiscountRate = 0;

        // Sales Invoice Model (Detail)
        var $koSalesInvoiceModel;
        $koNamespace.initSalesInvoice = function (SalesInvoice) {
            var self = this;

            self.Id = ko.observable(!SalesInvoice ? $Id : SalesInvoice.Id),
            self.PeriodId = ko.observable(!SalesInvoice ? $CurrentPeriodId : SalesInvoice.PeriodId),
            self.Period = ko.observable(!SalesInvoice ? $CurrentPeriod : SalesInvoice.Period),
            self.BranchId = ko.observable(!SalesInvoice ? $CurrentBranchId : SalesInvoice.BranchId),
            self.Branch = ko.observable(!SalesInvoice ? $CurrentBranch : SalesInvoice.Branch),
            self.SINumber = ko.observable(!SalesInvoice ? "" : SalesInvoice.SINumber),
            self.SIManualNumber = ko.observable(!SalesInvoice ? "" : SalesInvoice.SIManualNumber),
            self.SIDate = ko.observable(!SalesInvoice ? easyFIS.getCurrentDate() : SalesInvoice.SIDate),
            self.CustomerId = ko.observable(!SalesInvoice ? 0 : SalesInvoice.CustomerId),
            self.Customer = ko.observable(!SalesInvoice ? "" : SalesInvoice.Customer),
            self.TermId = ko.observable(!SalesInvoice ? 0 : SalesInvoice.TermId),
            self.Term = ko.observable(!SalesInvoice ? "" : SalesInvoice.Term),
            self.DocumentReference = ko.observable(!SalesInvoice ? "NA" : SalesInvoice.DocumentReference),
            self.Particulars = ko.observable(!SalesInvoice ? "NA" : SalesInvoice.Particulars),
            self.SoldById = ko.observable(!SalesInvoice ? $CurrentUserId : SalesInvoice.SoldById),
            self.SoldBy = ko.observable(!SalesInvoice ? $CurrentUser : SalesInvoice.SoldBy),
            self.TotalAmount = ko.observable(easyFIS.formatNumber(!SalesInvoice ? 0 : SalesInvoice.TotalAmount, 2, ',', '.', '', '', '-', '')),
            self.TotalCollectedAmount = ko.observable(!SalesInvoice ? 0 : SalesInvoice.TotalCollectedAmount),
            self.TotalCreditAmount = ko.observable(!SalesInvoice ? 0 : SalesInvoice.TotalCreditAmount),
            self.TotalDebitAmount = ko.observable(!SalesInvoice ? 0 : SalesInvoice.TotalDebitAmount),
            self.PreparedById = ko.observable(!SalesInvoice ? $CurrentUserId : SalesInvoice.PreparedById),
            self.PreparedBy = ko.observable(!SalesInvoice ? $CurrentUser : SalesInvoice.PreparedBy),
            self.CheckedById = ko.observable(!SalesInvoice ? $CurrentUserId : SalesInvoice.CheckedById),
            self.CheckedBy = ko.observable(!SalesInvoice ? $CurrentUser : SalesInvoice.CheckedBy),
            self.ApprovedById = ko.observable(!SalesInvoice ? $CurrentUserId : SalesInvoice.ApprovedById),
            self.ApprovedBy = ko.observable(!SalesInvoice ? $CurrentUser : SalesInvoice.ApprovedBy),
            self.IsLocked = ko.observable(!SalesInvoice ? false : SalesInvoice.IsLocked),
            self.CreatedById = ko.observable(!SalesInvoice ? $CurrentUserId : SalesInvoice.CreatedById),
            self.CreatedBy = ko.observable(!SalesInvoice ? $CurrentUser : SalesInvoice.CreatedBy),
            self.CreatedDateTime = ko.observable(!SalesInvoice ? "" : SalesInvoice.CreatedDateTime),
            self.UpdatedById = ko.observable(!SalesInvoice ? $CurrentUserId : SalesInvoice.UpdatedById),
            self.UpdatedBy = ko.observable(!SalesInvoice ? $CurrentUser : SalesInvoice.UpdatedBy),
            self.UpdatedDateTime = ko.observable(!SalesInvoice ? "" : SalesInvoice.UpdatedDateTime),

            // Select2 defaults
            $('#Customer').select2('data', { id: !SalesInvoice ? 0 : SalesInvoice.CustomerId, text: !SalesInvoice ? "" : SalesInvoice.Customer });
            $('#Term').select2('data', { id: !SalesInvoice ? 0 : SalesInvoice.TermId, text: !SalesInvoice ? "" : SalesInvoice.Term });
            $('#SoldBy').select2('data', { id: !SalesInvoice ? $CurrentUserId : SalesInvoice.SoldById, text: !SalesInvoice ? $CurrentUser : SalesInvoice.SoldBy });
            $('#PreparedBy').select2('data', { id: !SalesInvoice ? $CurrentUserId : SalesInvoice.PreparedById, text: !SalesInvoice ? $CurrentUser : SalesInvoice.PreparedBy });
            $('#CheckedBy').select2('data', { id: !SalesInvoice ? $CurrentUserId : SalesInvoice.CheckedById, text: !SalesInvoice ? $CurrentUser : SalesInvoice.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !SalesInvoice ? $CurrentUserId : SalesInvoice.ApprovedById, text: !SalesInvoice ? $CurrentUser : SalesInvoice.ApprovedBy });

            if ((!SalesInvoice ? false : SalesInvoice.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#SINumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);
                $('#LineTaxRate').prop("disabled", true);
                $('#LineTaxAmount').prop("disabled", true);

                $('#Customer').select2('disable');
                $('#Term').select2('disable');
                $('#SoldBy').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');

            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#SINumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);
                $('#LineAmount').prop("disabled", true);
                $('#LineTaxRate').prop("disabled", true);
                $('#LineTaxAmount').prop("disabled", true);

                $('#Customer').select2('enable');
                $('#Term').select2('enable');
                $('#SoldBy').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');

            }

            return self;
        };
        $koNamespace.bindSalesInvoice = function (SalesInvoice) {
            var viewModel = $koNamespace.initSalesInvoice(SalesInvoice);
            ko.applyBindings(viewModel, $("#SalesInvoiceDetail")[0]); //Bind the section #SalesInvoiceDetail
            $koSalesInvoiceModel = viewModel;
        }
        $koNamespace.getSalesInvoice = function (Id) {
            if (!Id) {
                $koNamespace.bindSalesInvoice(null);
            } else {
                // Render Sales Invoice
                $.ajax({
                    url: '/api/TrnSalesInvoice/' + Id + '/SalesInvoice',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (SalesInvoice) {
                        $koNamespace.bindSalesInvoice(SalesInvoice);
                        RenderSalesInvoiceLines(Id);
                        RenderSalesInvoiceJournalEntries(Id);
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        // Sales Invoice Line Model (Lines)
        var $koSalesInvoiceLineModel;
        $koNamespace.initSalesInvoiceLine = function (SalesInvoiceLine) {
            var self = this;

            self.LineId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineId);
            self.LineSIId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineSIId);
            self.LineSOId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineSOId);
            self.LineSONumber = ko.observable(!SalesInvoiceLine ? "NA" : SalesInvoiceLine.LineSONumber);
            self.LineItemId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemId);
            self.LineItem = ko.observable(!SalesInvoiceLine ? "" : SalesInvoiceLine.LineItem);
            self.LineItemInventoryId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemInventoryId);
            self.LineItemInventoryNumber = ko.observable(!SalesInvoiceLine ? "" : SalesInvoiceLine.LineItemInventoryNumber);
            self.LineParticulars = ko.observable(!SalesInvoiceLine ? "NA" : SalesInvoiceLine.LineParticulars);
            self.LineUnitId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineUnitId);
            self.LineUnit = ko.observable(!SalesInvoiceLine ? "" : SalesInvoiceLine.LineUnit);
            self.LinePriceId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LinePriceId);
            self.LinePriceDescription = ko.observable(!SalesInvoiceLine ? "" : SalesInvoiceLine.LinePriceDescription);
            self.LinePrice = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LinePrice);
            self.LineDiscountId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountId);
            self.LineDiscount = ko.observable(!SalesInvoiceLine ? "" : SalesInvoiceLine.LineDiscount);
            self.LineDiscountRate = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountRate);
            self.LineDiscountAmount = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountAmount);
            self.LineNetPrice = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineNetPrice);
            self.LineQuantity = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineQuantity);
            self.LineAmount = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineAmount);
            self.LineTaxId = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxId);
            self.LineTax = ko.observable(!SalesInvoiceLine ? "" : SalesInvoiceLine.LineTax);
            self.LineTaxRate = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxRate);
            self.LineTaxAmount = ko.observable(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxAmount);

            return self;
        }
        $koNamespace.bindSalesInvoiceLine = function (SalesInvoiceLine) {
            try {
                var viewModel = $koNamespace.initSalesInvoiceLine(SalesInvoiceLine);
                ko.applyBindings(viewModel, $("#SalesInvoiceLineDetail")[0]); //Bind the section #SalesInvoiceLineDetail (Modal)
                $koSalesInvoiceLineModel = viewModel;

                $('#LineSONumber').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineSOId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineSONumber });
                $('#LineItem').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineItem });
                $('#LineItemInventoryNumber').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemInventoryId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineItemInventoryNumber });
                $('#LineUnit').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineUnitId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineUnit });
                $('#LinePriceDescription').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LinePriceId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LinePriceDescription });
                $('#LineDiscount').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineDiscount });
                $('#LineTax').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineTax });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineId).change();
                $('#LineSIId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineSIId).change();

                $('#LineSOId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineSOId).change();
                $('#LineSONumber').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineSOId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineSONumber });

                $('#LineItemId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemId).change();
                $('#LineItem').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineItem });

                $('#LineItemInventoryId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemInventoryId).change();
                $('#LineItemInventoryNumber').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineItemInventoryId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineItemInventoryNumber });

                $('#LineParticulars').val(!SalesInvoiceLine ? "NA" : SalesInvoiceLine.LineParticulars).change();

                $('#LineUnitId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineUnitId).change();
                $('#LineUnit').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineUnitId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineUnit });

                $('#LinePriceId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LinePriceId).change();
                $('#LinePriceDescription').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LinePriceId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LinePriceDescription });
                $('#LinePrice').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LinePrice).change();

                $('#LineDiscountId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountId).change();
                $('#LineDiscount').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineDiscount });
                $('#LineDiscountRate').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountRate).change();
                $('#LineDiscountAmount').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineDiscountAmount).change();

                $('#LineNetPrice').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineNetPrice).change();

                $('#LineQuantity').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineQuantity).change();

                $('#LineAmount').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineAmount).change();

                $('#LineTaxId').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxId).change();
                $('#LineTax').select2('data', { id: !SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxId, text: !SalesInvoiceLine ? "" : SalesInvoiceLine.LineTax });
                $('#LineTaxRate').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxRate).change();
                $('#LineTaxAmount').val(!SalesInvoiceLine ? 0 : SalesInvoiceLine.LineTaxAmount).change();
            }
        }

        // Render datatables
        function RenderSalesInvoiceLines(Id) {
            if (!!Id) {
                $("#SalesInvoiceLineTable").dataTable().fnDestroy();

                $("#SalesInvoiceLineTable").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/TrnSalesInvoice/' + Id + '/SalesInvoiceLines',
                    "sAjaxDataProp": "TrnSalesInvoiceLineData",
                    "bProcessing": true,
                    "bLengthChange": false,
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
                                        "mData": "LineNetPrice", "sWidth": "100px", "sClass": "alignRight",
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
            }
        }
        function RenderSalesInvoiceJournalEntries(Id) {
            if (!!Id) {
                $("#JournalEntryTable").dataTable().fnDestroy();

                $("#JournalEntryTable").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/TrnJournal/' + Id + '/SalesInvoiceJournals',
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
        }

        // Click events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnSalesInvoice',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koSalesInvoiceModel),
                        success: function (data) {
                            location.href = 'TrnSalesInvoiceDetail.aspx?Id=' + data.Id;
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
                            url: '/api/TrnSalesInvoice/' + $Id + '/Update',
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koSalesInvoiceModel),
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
                window.location.href = '/api/SysReport?Report=SalesInvoice&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnSalesInvoiceList.aspx';
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#SalesInvoiceLineModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindSalesInvoiceLine(null);
                // FK
                $('#LineSIId').val($Id).change();
            } else {
                alert('Sales Invoice not yet saved.');
            }
        }
        function CmdCloseLine_onclick() {
            $('#SalesInvoiceLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#SalesInvoiceLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnSalesInvoiceLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koSalesInvoiceLineModel),
                    success: function (data) {
                        //location.href = 'TrnSalesInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        RenderSalesInvoiceLines(easyFIS.getParameterByName("Id"));
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnSalesInvoiceLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koSalesInvoiceLineModel),
                    success: function (data) {
                        //location.href = 'TrnSalesInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        RenderSalesInvoiceLines(easyFIS.getParameterByName("Id"));
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
                    url: '/api/TrnSalesInvoiceLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindSalesInvoiceLine(data);
                        $('#SalesInvoiceLineModal').modal('show');
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
                    url: '/api/TrnSalesInvoiceLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        //location.href = 'TrnSalesInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        RenderSalesInvoiceLines(easyFIS.getParameterByName("Id"));
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
                        url: '/api/TrnSalesInvoice/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnSalesInvoiceDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Sales Invoice not yet saved.');
            }
        }
        function CmdOpenSearchItem_onclick() {
            $("#SearchItemTable").dataTable().fnDestroy();

            $('#SearchItemTable').css('width', '')

            var SearchItemTable = $("#SearchItemTable").dataTable({
                                        "bServerSide": true,
                                        "sAjaxSource": '/api/SysItemSearch',
                                        "sAjaxDataProp": "MstArticleItemData",
                                        "bProcessing": true,
                                        "bLengthChange": false,
                                        "oLanguage": { "sSearch": "" },
                                        "iDisplayLength": 6,
                                        "sPaginationType": "full_numbers",
                                        "bAutoWidth": false,
                                        "aoColumns": [
                                                {
                                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "10%",
                                                    "mRender": function (data) {
                                                        return '<input runat="server" id="CmdPick" type="button" class="btn btn-primary" value="Pick"/>'
                                                    }
                                                },
                                                { "mData": "Remarks", "sWidth": "90%" },
                                                { "mData": "Item", "bVisible": false, }]
            }).fnSort([[1, 'asc']]);

            $("#SearchItemTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#SearchItemTable").dataTable().fnGetData(this.parentNode);
                var Item = easyFIS.getTableData($("#SearchItemTable"), Id, "Id", "Item");

                if (ButtonName.search("CmdPick") > 0) CmdPick_onclick(Id,Item);
            });

            $('#SearchItemModal').modal('show');
            $Modal02 = true;
        }
        function CmdCloseSearchItem_onclick() {
            $('#SearchItemModal').modal('hide');
            $Modal02 = false;
        }
        function CmdPick_onclick(Id,Item) {
            $('#SearchItemModal').modal('hide');
            $Modal02 = false;

            CmdAddLine_onclick();

            $('#LineItemId').val(Id).change();
            $('#LineItem').select2('data', { id: Id, text: Item });
        }

        // Select2 Controls
        function select2_Customer() {
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
        function select2_Term() {
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
        function select2_SoldBy() {
            $('#SoldBy').select2({
                placeholder: 'Sold By',
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
                $('#SoldById').val($('#SoldBy').select2('data').id).change();
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
        function select2_LineSONumber() {
            $('#LineSONumber').select2({
                placeholder: 'Sales Order',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectSalesOrder',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            customerId: $('#CustomerId').val()
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            });
        }
        function select2_LineItem() {
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
        function select2_LineItemInventoryNumber() {
            $('#LineItemInventoryNumber').select2({
                placeholder: 'Inventory Number',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectItemInventory',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            ItemId: $('#LineItemId').val(),
                            BranchId: $CurrentBranchId
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            });
        }
        function select2_LineUnit() {
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
            }).change(function () {
                $('#LineUnitId').val($('#LineUnit').select2('data').id).change();
            });
        }
        function select2_LineTax() {
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
        function select2_LineDiscount() {
            $('#LineDiscount').select2({
                placeholder: 'Discount',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectDiscount',
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
                    return JSONObject["Discount"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["Discount"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            });
        }
        function select2_LinePriceDescription() {
            $('#LinePriceDescription').select2({
                placeholder: 'Price',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectItemPrice',
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
                },
                formatResult: function (data) {
                    var JSONObject = JSON.parse(data.text);
                    return JSONObject["Line1PriceDescription"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["Line1PriceDescription"];
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
        function OnChange_Customer() {
            $('#Customer').on('keyup change', function () {
                var CustomerId = $('#Customer').select2('data').id;
                $('#CustomerId').val(CustomerId).change();

                select2_LineSONumber();
                OnChange_LineSONumber();

                $.getJSON("/api/MstArticleCustomer/" + CustomerId + "/CustomerByArticleId", function (data) {
                    if (data) {
                        $('#Term').select2('data', { id: data.TermId, text: data.Term });
                        $('#TermId').val(data.TermId).change();
                    }
                });
            });
        }
        function OnChange_LineSONumber() {
            $('#LineSONumber').on('keyup change', function () {
                $('#LineSOId').val($('#LineSONumber').select2('data').id).change();

                select2_LineItem();
                OnChange_LineItem();
            });
        }
        function OnChange_LineItem() {
            $('#LineItem').on('keyup change', function () {
                var ItemId = $('#LineItem').select2('data').id;
                var JSONObject = JSON.parse($('#LineItem').select2('data').text);

                $LineUnitId = JSONObject["UnitId"];
                $LineUnit = JSONObject["Unit"];
                $LineSalesTaxId = JSONObject["SalesTaxId"];
                $LineSalesTax = JSONObject["SalesTax"];
                $LineSalesTaxRate = (parseFloat(JSONObject["SalesTaxRate"]) / 100);
                $LineSalesTaxType = JSONObject["SalesTaxType"];
                $LinePriceId = JSONObject["DefaultPriceId"];
                $LinePriceDescription = JSONObject["DefaultPriceDescription"];
                $LinePrice = JSONObject["DefaultPrice"];

                $('#LineItemId').val(ItemId).change();

                select2_LineItemInventoryNumber();
                select2_LineUnit();
                select2_LinePriceDescription();

                OnChange_LineItemInventoryNumber();
                OnChange_LinePriceDescription();

                $('#LineItemInventoryId').val(0).change();
                $('#LineItemInventoryNumber').select2('data', { id: 0, text: "" });

                $('#LineUnitId').val($LineUnitId).change();
                $('#LineUnit').select2('data', { id: $LineUnitId, text: $LineUnit });

                $('#LinePriceId').val($LinePriceId).change();
                $('#LinePriceDescription').select2('data', { id: $LinePriceId, text: $LinePriceDescription });

                $('#LinePrice').val($LinePrice).change().trigger('focusout');
                $('#LineNetPrice').val($LinePrice).change().trigger('focusout');
                $('#LineQuantity').val(0).change().trigger('focusout');
                $('#LineAmount').val(0).change().trigger('focusout');

                $('#LineTaxId').val($LineSalesTaxId).change();
                $('#LineTax').select2('data', { id: $LineSalesTaxId, text: $LineSalesTax });
                $('#LineTaxRate').val($LineSalesTaxRate).change().trigger('focusout');
                $('#LineTaxAmount').val(0).change().trigger('focusout');

                $('#LineDiscount').select2('data', { id: 0, text: "" });
                $('#LineDiscountId').val(0).change();
                $('#LineDiscountRate').val(0).change().trigger('focusout');
                $('#LineDiscountAmount').val(0).change().trigger('focusout');

            });
        }
        function OnChange_LineItemInventoryNumber() {
            $('#LineItemInventoryNumber').on('keyup change', function () {
                $('#LineItemInventoryId').val($('#LineItemInventoryNumber').select2('data').id).change();

                $('#LineQuantity').val(0).change().trigger('focusout');
                $('#LineAmount').val(0).change().trigger('focusout');
                $('#LineTaxAmount').val(0).change().trigger('focusout');
            });
        }
        function OnChange_LineTax() {
            $('#LineTax').on('keyup change', function () {
                var TaxId = $('#LineTax').select2('data').id;
                var JSONObject = JSON.parse($('#LineTax').select2('data').text);

                $LineSalesTaxRate = (parseFloat(JSONObject["SalesTaxRate"]) / 100).toFixed(2);
                $LineSalesTaxType = JSONObject["SalesTaxType"];

                $('#LineTaxId').val(TaxId).change();
                $('#LineTaxRate').val($LineSalesTaxRate).change();

                ComputeTaxAmount();
            });
        }
        function OnChange_LineDiscount() {
            $('#LineDiscount').on('keyup change', function () {
                var DiscountId = $('#LineDiscount').select2('data').id;
                var JSONObject = JSON.parse($('#LineDiscount').select2('data').text);

                $LineDiscountId = DiscountId;
                $LineDiscount = JSONObject["Discount"];
                $LineDiscountRate = (parseFloat(JSONObject["DiscountRate"]) / 100).toFixed(2);

                $('#LineDiscountId').val(DiscountId).change();
                $('#LineDiscountRate').val($LineDiscountRate).change().trigger('focusout');
                $('#LineDiscountAmount').val(($LinePrice * $LineDiscountRate).toFixed(2)).change().trigger('focusout');

                ComputeNetPrice();
            });
        }
        function OnChange_LinePriceDescription() {
            $('#LinePriceDescription').on('keyup change', function () {
                var PriceId = $('#LinePriceDescription').select2('data').id;
                var JSONObject = JSON.parse($('#LineDiscount').select2('data').text);

                $LinePriceId = PriceId;
                $LinePriceDescription = JSONObject["Line1PriceDescription"];
                $LinePrice = parseFloat(JSONObject["Line1Price"]).toFixed(2);

                $('#LinePriceId').val($LinePriceId).change();
                $('#LinePrice').val($LinePrice).change().trigger('focusout');

                ComputeNetPrice();
            });
        }
        function OnChange_LinePrice() {
            $('#LinePrice').on('keyup change', function () {
                ComputeNetPrice();
            });
        }
        function OnChange_LineQuantity() {
            $('#LineQuantity').on('keyup change', function () {
                ComputeAmount();
            });
        }

        // Other functions
        function ComputeNetPrice() {
            var NetPrice = 0;
            var Price = parseFloat($('#LinePrice').val().replace(',', '')).toFixed(2);
            var DiscountAmount = parseFloat($('#LineDiscountAmount').val().replace(',', '')).toFixed(2);

            NetPrice = Price - DiscountAmount;

            $('#LineNetPrice').val(NetPrice.toFixed(2)).change().trigger('focusout');

            ComputeAmount();
        }
        function ComputeAmount() {
            var Amount = 0
            var NetPrice = parseFloat($('#LineNetPrice').val().replace(',', '')).toFixed(2);
            var Quantity = parseFloat($('#LineQuantity').val().replace(',', '')).toFixed(2);

            Amount = NetPrice * Quantity;

            $('#LineAmount').val(Amount.toFixed(2)).change().trigger('focusout');

            ComputeTaxAmount();
        }
        function ComputeTaxAmount() {
            var NetPrice = parseFloat($('#LineNetPrice').val().replace(',', '')).toFixed(2);
            var Quantity = parseFloat($('#LineQuantity').val().replace(',', '')).toFixed(2);

            if ($LineSalesTaxType == "INCLUSIVE") {
                var TaxAmount = ((NetPrice / (1 + $LineSalesTaxRate)) * $LineSalesTaxRate) * Quantity;
            } else {
                var TaxAmount = NetPrice * $LineSalesTaxRate * Quantity;
            }

            $('#LineTaxAmount').val(TaxAmount.toFixed(2)).change().trigger('focusout');
        }

        // On Page Load
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Date Pickers
            $('#SIDate').datepicker().on('changeDate', function (ev) {
                $koSalesInvoiceModel.SIDate($(this).val());
                $(this).datepicker('hide');
            });

            // Select2 Controls
            select2_Customer();
            select2_Term();
            select2_SoldBy();
            select2_PreparedBy();
            select2_CheckedBy();
            select2_ApprovedBy();
            select2_LineSONumber();
            select2_LineItem();
            select2_LineItemInventoryNumber();
            select2_LinePriceDescription();
            select2_LineDiscount();
            select2_LineTax();
            select2_LineUnit();

            OnChange_Customer();
            OnChange_LineSONumber();
            OnChange_LineItem();
            OnChange_LineItemInventoryNumber();
            OnChange_LineTax();
            OnChange_LineDiscount();
            OnChange_LinePriceDescription();
            OnChange_LinePrice();
            OnChange_LineQuantity();
            
            $('#TotalAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineQuantity').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LinePrice').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineDiscountRate').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineDiscountAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineNetPrice').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineTaxRate').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineTaxAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            // Event Handler Line Table
            $("#SalesInvoiceLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#SalesInvoiceLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) CmdEditLine_onclick(Id);
                if (ButtonName.search("CmdDeleteLine") > 0) CmdDeleteLine_onclick(Id);
            });

            // Bind the Page: TrnSalesInvoice
            if ($Id != "") {
                $koNamespace.getSalesInvoice($Id);
            } else {
                $koNamespace.getSalesInvoice(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#SalesInvoiceLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#SalesInvoiceLineModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Sales Invoice Detail</h2>

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

            <section id="SalesInvoiceDetail">
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
                        <label class="control-label">SI Number </label>
                        <div class="controls">
                            <input id="SINumber" type="text" data-bind="value: SINumber" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">SI Date </label>
                        <div class="controls">
                            <input id="SIDate" type="text" data-bind="value: SIDate" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">SI Manual Number </label>
                        <div class="controls">
                            <input id="SIManualNumber" type="text" data-bind="value: SIManualNumber" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Customer </label>
                        <div class="controls">
                            <input  id="CustomerId" type="hidden" data-bind="value: CustomerId" class="input-medium" />
                            <input  id="Customer" type="text" data-bind="value: Customer" class="input-xlarge" />
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
                        <label class="control-label">Salesman </label>
                        <div class="controls">
                            <input  id="SoldById" type="hidden" data-bind="value: SoldById" class="input-medium" />
                            <input  id="SoldBy" type="text" data-bind="value: SoldBy" class="input-xlarge" />
                        </div>
                    </div>
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
            
            <section id="SalesInvoiceLine">
            <div class="row">
                <div class="span12">
                    <table id="SalesInvoiceLineTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="9">
                                    <input runat="server" id="CmdAddLine" type="button" class="btn btn-primary" value="Add" onclick="CmdAddLine_onclick()" />
                                    <input runat="server" id="CmdSearchItem" type="button" class="btn btn-primary" value="Search" onclick="CmdOpenSearchItem_onclick()" />
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Quantity</th>
                                <th>Unit</th>
                                <th>Item</th>
                                <th>Particulars</th>
                                <th>Net Price</th>
                                <th>Tax</th>  
                                <th>Amount</th> 
                            </tr>
                        </thead>
                        <tbody id="SalesInvoiceLineTableBody"></tbody>
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

            <section id="SalesInvoiceLineDetail">
            <div id="SalesInvoiceLineModal" class="modal hide fade in" style="display: none;">  
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Sales Invoice Line Detail</h3>  
                </div>  
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <div class="controls">
                                    <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                    <input id="LineSIId" type="hidden" data-bind="value: LineSIId" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineSONumber" class="control-label">SO Number</label>
                                <div class="controls">
                                    <input id="LineSOId" type="hidden" data-bind="value: LineSOId" class="input-medium" />
                                    <input id="LineSONumber" type="text" data-bind="value: LineSONumber" class="input-medium" />
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
                                <label for="LineItemInventory" class="control-label">Inventory No</label>
                                <div class="controls">
                                    <input id="LineItemInventoryId" type="hidden" data-bind="value: LineItemInventoryId" class="input-medium" />
                                    <input id="LineItemInventoryNumber" type="text" data-bind="value: LineItemInventoryNumber" class="input-block-level" />
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
                                    <input id="LineQuantity" type="number" data-bind="value: LineQuantity" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePriceDescription" class="control-label">Price Description</label>
                                <div class="controls">
                                    <input id="LinePriceId" type="hidden" data-bind="value: LinePriceId" class="input-medium" />
                                    <input id="LinePriceDescription" type="text" data-bind="value: LinePriceDescription" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePrice" class="control-label">Price</label>
                                <div class="controls">
                                    <input id="LinePrice" type="number" data-bind="value: LinePrice" class="input-medium" data-validation-number-message="Numbers only please"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineDiscount" class="control-label">Discount</label>
                                <div class="controls">
                                    <input id="LineDiscountId" type="hidden" data-bind="value: LineDiscountId" class="input-medium" />
                                    <input id="LineDiscount" type="text" data-bind="value: LineDiscount" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineDiscountRate" class="control-label">Discount Rate</label>
                                <div class="controls">
                                    <input id="LineDiscountRate" type="number" data-bind="value: LineDiscountRate" disabled="disabled" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineDiscountAmount" class="control-label">Discount Amount</label>
                                <div class="controls">
                                    <input id="LineDiscountAmount" type="number" data-bind="value: LineDiscountAmount" disabled="disabled" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineNetPrice" class="control-label">Net Price</label>
                                <div class="controls">
                                    <input id="LineNetPrice" type="number" data-bind="value: LineNetPrice" disabled="disabled" class="input-medium pagination-right" data-validation-number-message="Numbers only please"/>
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

            <section id="SearchItemList">
            <div id="SearchItemModal" class="modal hide fade in" style="display: none;"> 
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Search Item</h3>  
                </div>
                <div class="modal-body">
                    <table id="SearchItemTable" class="table table-striped table-condensed" style="width:100%">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Item</th>
                                <th>Item</th>
                            </tr>
                        </thead>
                        <tbody id="SearchItemTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
                <div class="modal-footer">  
                    <a href="#" class="btn btn-danger" onclick="CmdCloseSearchItem_onclick()">Close</a>  
                </div>  
            </div>
            </section>

        </div>
    </div>
</asp:Content>
