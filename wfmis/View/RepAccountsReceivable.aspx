<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="RepAccountsReceivable.aspx.cs" Inherits="wfmis.View.RepAccountsReceivable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Date Picker--%>
    <link href="../Content/bootstrap-datepicker/datepicker.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-datepicker/bootstrap-datepicker.js"></script>
    <%--Select2--%>
    <link href="../Content/bootstrap-select2/select2.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-select2/select2.js"></script>
    <%--Datatables--%>
    <link href="../Content/datatables-1.10.0/media/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="../Content/datatables-1.10.0/media/css/jquery.dataTables_themeroller.min.css" rel="stylesheet" />
    <script src="../Content/datatables-1.10.0/media/js/jquery.dataTables.min.js"></script>

    <link href="../Content/datatables-1.10.0/extensions/TableTools/css/dataTables.tableTools.min.css" rel="stylesheet" />
    <script src="../Content/datatables-1.10.0/extensions/TableTools/js/dataTables.tableTools.min.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8">
        var $tab1CompanyId = 0;
        var $tab1Company = "";
        var $tab1PeriodId = 0;
        var $tab1Period = "";
        var $tab1AsOfDate = easyFIS.getCurrentDate();
        var $tab2CompanyId = 0;
        var $tab2Company = "";
        var $tab2PeriodId = 0;
        var $tab2Period = "";
        var $tab2AsOfDate = easyFIS.getCurrentDate();
        var $pageSize = 20;

        // Select2
        function select2_tab1Company() {
            $('#tab1Company').select2({
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
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $tab1CompanyId = $('#tab1Company').select2('data').id;
                $tab1Company = $('#tab1Company').select2('data').text;
            });
        }
        function select2_tab1Period() {
            $('#tab1Period').select2({
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
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $tab1PeriodId = $('#tab1Period').select2('data').id;
                $tab1Period = $('#tab1Period').select2('data').text;
            });
        }
        function select2_tab2Company() {
            $('#tab2Company').select2({
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
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $tab2CompanyId = $('#tab2Company').select2('data').id;
                $tab2Company = $('#tab2Company').select2('data').text;
            });
        }
        function select2_tab2Period() {
            $('#tab2Period').select2({
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
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $tab2PeriodId = $('#tab2Period').select2('data').id;
                $tab2Period = $('#tab2Period').select2('data').text;
            });
        }

        // Click events
        function cmdViewAccountsReceivable_onclick() {
            location.href = 'RepAccountsReceivable.aspx?tab1CompanyId=' + $tab1CompanyId + '&' +
                                                        'tab1Company=' + $tab1Company + '&' +
                                                        'tab1PeriodId=' + $tab1PeriodId + '&' +
                                                        'tab1Period=' + $tab1Period + '&' +
                                                        'tab1AsOfDate=' + $tab1AsOfDate;
        }
        function cmdViewAccountsReceivableSummary_onclick() {
            location.href = 'RepAccountsReceivable.aspx?tab2CompanyId=' + $tab2CompanyId + '&' +
                                                       'tab2Company=' + $tab2Company + '&' +
                                                       'tab2PeriodId=' + $tab2PeriodId + '&' +
                                                       'tab2Period=' + $tab2Period + '&' +
                                                       'tab2AsOfDate=' + $tab2AsOfDate;
        }
        function cmdPrintStatementOfAccount_onclick(CustomerId) {
            if (CustomerId > 0) {
                window.location.href = '/api/SysReport?Report=StatementOfAccount&Id=' + CustomerId + '&AsOfDate=' + $tab2AsOfDate;
            }
        }

        // Initialized Tab data
        function initTab1() {
            $tab1CompanyId = easyFIS.getParameterByName("tab1CompanyId");
            $tab1Company = easyFIS.getParameterByName("tab1Company");
            $tab1PeriodId = easyFIS.getParameterByName("tab1PeriodId");
            $tab1Period = easyFIS.getParameterByName("tab1Period");
            $tab1AsOfDate = easyFIS.getParameterByName("tab1AsOfDate");

            if ($tab1CompanyId != "") {
                $('#tab1Company').select2('data', { id: $tab1CompanyId, text: $tab1Company });
            } else {
                $('#tab1Company').select2('data', { id: 0, text: "" });
                $tab1CompanyId = 0;
            }
            if ($tab1PeriodId != "") {
                $('#tab1Period').select2('data', { id: $tab1PeriodId, text: $tab1Period });
            } else {
                $('#tab1Period').select2('data', { id: 0, text: "" });
                $tab1PeriodId = 0;
            }
            if ($tab1AsOfDate != "") {
                $('#tab1AsOfDate').val($tab1AsOfDate);
            } else {
                $tab1AsOfDate = easyFIS.getCurrentDate();
                $('#tab1AsOfDate').val($tab1AsOfDate);
            }
        }
        function initTab2() {
            $tab2CompanyId = easyFIS.getParameterByName("tab2CompanyId");
            $tab2Company = easyFIS.getParameterByName("tab2Company");
            $tab2PeriodId = easyFIS.getParameterByName("tab2PeriodId");
            $tab2Period = easyFIS.getParameterByName("tab2Period");
            $tab2AsOfDate = easyFIS.getParameterByName("tab2AsOfDate");

            if ($tab2CompanyId != "") {
                $('#tab2Company').select2('data', { id: $tab2CompanyId, text: $tab2Company });
            } else {
                $('#tab2Company').select2('data', { id: 0, text: "" });
                $tab2CompanyId = 0;
            }
            if ($tab2PeriodId != "") {
                $('#tab2Period').select2('data', { id: $tab2PeriodId, text: $tab2Period });
            } else {
                $('#tab2Period').select2('data', { id: 0, text: "" });
                $tab2PeriodId = 0;
            }
            if ($tab2AsOfDate != "") {
                $('#tab2AsOfDate').val($tab2AsOfDate);
            } else {
                $tab2AsOfDate = easyFIS.getCurrentDate();
                $('#tab2AsOfDate').val($tab2AsOfDate);
            }
        }

        // Report Rendering
        function insertTR(element, iColspan, value, className, after) {
            var nGroup = document.createElement('tr');
            var nCell = document.createElement('td');

            nCell.colSpan = iColspan;
            nCell.className = className;

            nCell.innerHTML = value;
            nGroup.appendChild(nCell);

            if (after == false) {
                element.parentNode.insertBefore(nGroup, element);
            } else {
                element.parentNode.insertBefore(nGroup, element.nextSibling);
            }
        }
        function renderTableAccountsReceivable() {
            var d = new Date($tab1AsOfDate);
            var formattedAsOfDate = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();

            var AccountsReceivableTable = $("#AccountsReceivableTable").dataTable({
                "sAjaxSource": '/api/RepAccountsReceivable?tab1AsOfDate=' + formattedAsOfDate + '&tab1PeriodId=' + $tab1PeriodId + '&tab1CompanyId=' + $tab1CompanyId,
                "bPaginate": false,
                "sAjaxDataProp": "RepAccountsReceivableData",
                "bLengthChange": false,
                "sDom": '<"top"Tf>rt<"bottom"p><"clear">',
                "oTableTools": {
                    "aButtons": [
                        {
                            "sExtends": "collection",
                            "sButtonText": "Export",
                            "sButtonClass": "btn btn-primary",
                            "aButtons": ["csv", "xls", "pdf"]
                        }
                    ],
                    "sSwfPath": "/Content/datatables-1.10.0/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
                },
                "aoColumns": [
                        { "mData": "Customer", "bVisible": false },
                        {
                            "mData": "SINumber", "sWidth": "100px", "bSortable": false,
                            "mRender": function (data) {
                                var n = data.indexOf("-");
                                var SIId = data.substring(0, n - 1);
                                var SINumber = data.substring(n + 2, data.length);
                                return '<a href="TrnSalesInvoiceDetail.aspx?Id=' + SIId + '">' + SINumber + '</a>'
                            }
                        },
                        { "mData": "SIDate", "sWidth": "100px", "bSortable": false, },
                        { "mData": "Term", "sWidth": "100px", "bSortable": false, },
                        { "mData": "DueDate", "sWidth": "100px", "bSortable": false, },
                        { "mData": "DocumentReference", "bSortable": false, },
                        {
                            "mData": "CurrentAmount", "sWidth": "100px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "Age30Amount", "sWidth": "100px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "Age60Amount", "sWidth": "100px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "Age90Amount", "sWidth": "100px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "Age120Amount", "sWidth": "100px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }],
                "fnDrawCallback": function (oSettings) {

                    if (oSettings.aiDisplay.length == 0) {
                        return;
                    }

                    var nTrs = $('#AccountsReceivableTable tbody tr');
                    var iColspan = nTrs[0].getElementsByTagName('td').length;
                    var sLastGroup = "";
                    var groupCurrentAmount = 0;
                    var groupAge30Amount = 0;
                    var groupAge60Amount = 0;
                    var groupAge90Amount = 0;
                    var groupAge120Amount = 0;
                    var totalCurrentAmount = 0;
                    var totalAge30Amount = 0;
                    var totalAge60Amount = 0;
                    var totalAge90Amount = 0;
                    var totalAge120Amount = 0;

                    for (var i = 0; i < nTrs.length; i++) {
                        var iDisplayIndex = oSettings._iDisplayStart + i;
                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Customer"];

                        totalCurrentAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CurrentAmount"];
                        totalAge30Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age30Amount"];
                        totalAge60Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age60Amount"];
                        totalAge90Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age90Amount"];
                        totalAge120Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age120Amount"];

                        if (sLastGroup == "") {
                            // Display Group header before the first record
                            insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);

                            groupCurrentAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CurrentAmount"];
                            groupAge30Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age30Amount"];
                            groupAge60Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age60Amount"];
                            groupAge90Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age90Amount"];
                            groupAge120Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age120Amount"];

                            sLastGroup = sGroup;
                        } else {
                            if (sGroup == sLastGroup) {
                                groupCurrentAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CurrentAmount"];
                                groupAge30Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age30Amount"];
                                groupAge60Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age60Amount"];
                                groupAge90Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age90Amount"];
                                groupAge120Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age120Amount"];
                            } else {
                                var groupTr = document.createElement('tr');
                                var groupTrTd1To6 = document.createElement('td'); groupTrTd1To6.colSpan = 5; groupTrTd1To6.className = "right"; groupTrTd1To6.innerHTML = "<b>SUB TOTAL</b>"; groupTr.appendChild(groupTrTd1To6);
                                var groupTrTd7 = document.createElement('td'); groupTrTd7.colSpan = 1; groupTrTd7.className = "right"; groupTrTd7.innerHTML = '<b>' + easyFIS.formatNumber(groupCurrentAmount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd7);
                                var groupTrTd8 = document.createElement('td'); groupTrTd8.colSpan = 1; groupTrTd8.className = "right"; groupTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(groupAge30Amount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd8);
                                var groupTrTd9 = document.createElement('td'); groupTrTd9.colSpan = 1; groupTrTd9.className = "right"; groupTrTd9.innerHTML = '<b>' + easyFIS.formatNumber(groupAge60Amount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd9);
                                var groupTrTd10 = document.createElement('td'); groupTrTd10.colSpan = 1; groupTrTd10.className = "right"; groupTrTd10.innerHTML = '<b>' + easyFIS.formatNumber(groupAge90Amount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd10);
                                var groupTrTd11 = document.createElement('td'); groupTrTd11.colSpan = 1; groupTrTd11.className = "right"; groupTrTd11.innerHTML = '<b>' + easyFIS.formatNumber(groupAge120Amount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd11);

                                nTrs[i].parentNode.insertBefore(groupTr, nTrs[i]);

                                // Display the Group header before the group first record
                                insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);

                                groupCurrentAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CurrentAmount"];
                                groupAge30Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age30Amount"];
                                groupAge60Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age60Amount"];
                                groupAge90Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age90Amount"];
                                groupAge120Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Age120Amount"];

                                sLastGroup = sGroup;
                            }

                            if (i == (nTrs.length - 1)) {
                                var totalTr = document.createElement('tr');
                                var totalTrTd1To6 = document.createElement('td'); totalTrTd1To6.colSpan = 5; totalTrTd1To6.className = "right"; totalTrTd1To6.innerHTML = "<b>TOTAL</b>"; totalTr.appendChild(totalTrTd1To6);
                                var totalTrTd7 = document.createElement('td'); totalTrTd7.colSpan = 1; totalTrTd7.className = "right"; totalTrTd7.innerHTML = '<b>' + easyFIS.formatNumber(totalCurrentAmount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd7);
                                var totalTrTd8 = document.createElement('td'); totalTrTd8.colSpan = 1; totalTrTd8.className = "right"; totalTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(totalAge30Amount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd8);
                                var totalTrTd9 = document.createElement('td'); totalTrTd9.colSpan = 1; totalTrTd9.className = "right"; totalTrTd9.innerHTML = '<b>' + easyFIS.formatNumber(totalAge60Amount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd9);
                                var totalTrTd10 = document.createElement('td'); totalTrTd10.colSpan = 1; totalTrTd10.className = "right"; totalTrTd10.innerHTML = '<b>' + easyFIS.formatNumber(totalAge90Amount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd10);
                                var totalTrTd11 = document.createElement('td'); totalTrTd11.colSpan = 1; totalTrTd11.className = "right"; totalTrTd11.innerHTML = '<b>' + easyFIS.formatNumber(totalAge120Amount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd11);

                                nTrs[i].parentNode.insertBefore(totalTr, nTrs[i].nextSibling);

                                var lastGroupTr = document.createElement('tr');
                                var lastGroupTrTd1To6 = document.createElement('td'); lastGroupTrTd1To6.colSpan = 5; lastGroupTrTd1To6.className = "right"; lastGroupTrTd1To6.innerHTML = "<b>SUB TOTAL</b>"; lastGroupTr.appendChild(lastGroupTrTd1To6);
                                var lastGroupTrTd7 = document.createElement('td'); lastGroupTrTd7.colSpan = 1; lastGroupTrTd7.className = "right"; lastGroupTrTd7.innerHTML = '<b>' + easyFIS.formatNumber(groupCurrentAmount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd7);
                                var lastGroupTrTd8 = document.createElement('td'); lastGroupTrTd8.colSpan = 1; lastGroupTrTd8.className = "right"; lastGroupTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(groupAge30Amount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd8);
                                var lastGroupTrTd9 = document.createElement('td'); lastGroupTrTd9.colSpan = 1; lastGroupTrTd9.className = "right"; lastGroupTrTd9.innerHTML = '<b>' + easyFIS.formatNumber(groupAge60Amount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd9);
                                var lastGroupTrTd10 = document.createElement('td'); lastGroupTrTd10.colSpan = 1; lastGroupTrTd10.className = "right"; lastGroupTrTd10.innerHTML = '<b>' + easyFIS.formatNumber(groupAge90Amount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd10);
                                var lastGroupTrTd11 = document.createElement('td'); lastGroupTrTd11.colSpan = 1; lastGroupTrTd11.className = "right"; lastGroupTrTd11.innerHTML = '<b>' + easyFIS.formatNumber(groupAge120Amount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd11);

                                nTrs[i].parentNode.insertBefore(lastGroupTr, nTrs[i].nextSibling);
                            }
                        }
                    }


                }
            });
        }
        function renderTableAccountsReceivableSummary() {
            var d = new Date($tab2AsOfDate);
            var formattedAsOfDate = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();

            var AccountsReceivableSummaryTable = $("#AccountsReceivableSummaryTable").dataTable({
                "sAjaxSource": '/api/RepAccountsReceivableSummary?tab2AsOfDate=' + formattedAsOfDate + '&tab2PeriodId=' + $tab2PeriodId + '&tab2CompanyId=' + $tab2CompanyId,
                "bPaginate": false,
                "sAjaxDataProp": "RepAccountsReceivableSummaryData",
                "bLengthChange": false,
                "sDom": '<"top"Tf>rt<"bottom"p><"clear">',
                "oTableTools": {
                    "aButtons": [
                        {
                            "sExtends": "collection",
                            "sButtonText": "Export",
                            "sButtonClass": "btn btn-primary",
                            "aButtons": ["csv", "xls", "pdf"]
                        }
                    ],
                    "sSwfPath": "/Content/datatables-1.10.0/extensions/TableTools/swf/copy_csv_xls_pdf.swf"
                },
                "aoColumns": [
                        { "mData": "Customer"},
                        {
                            "mData": "BalanceAmount", "sWidth": "100px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "CustomerId","bSortable": false, "sWidth": "150px",
                            "mRender": function (data) {
                                return '<input runat="server" id="CmdStatementOfAccount" type="button" class="btn btn-primary" value="Print"/>'
                            }
                        }

                        ],
                "fnDrawCallback": function (oSettings) {

                    if (oSettings.aiDisplay.length == 0) {
                        return;
                    }

                    var nTrs = $('#AccountsReceivableSummaryTable tbody tr');
                    var iColspan = nTrs[0].getElementsByTagName('td').length;

                    var totalBalanceAmount = 0;

                    for (var i = 0; i < nTrs.length; i++) {
                        var iDisplayIndex = oSettings._iDisplayStart + i;

                        totalBalanceAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["BalanceAmount"];

                            if (i == (nTrs.length - 1)) {
                                var totalTr = document.createElement('tr');
                                var totalTrTd1 = document.createElement('td'); totalTrTd1.colSpan = 1; totalTrTd1.className = "right"; totalTrTd1.innerHTML = "<b>TOTAL</b>"; totalTr.appendChild(totalTrTd1);
                                var totalTrTd2 = document.createElement('td'); totalTrTd2.colSpan = 1; totalTrTd2.className = "right"; totalTrTd2.innerHTML = '<b>' + easyFIS.formatNumber(totalBalanceAmount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd2);
                            }
                    }
                }
            });
        }

        // Page load
        $(document).ready(function () {
            // Datepickers
            $('#tab1AsOfDate').datepicker().on('changeDate', function (ev) {
                $tab1AsOfDate = $(this).val();
                $(this).datepicker('hide');
            });

            // Select2
            select2_tab1Company();
            select2_tab1Period();
            select2_tab2Company();
            select2_tab2Period();

            // Initialized tab1
            initTab1();
            initTab2();

            // Render table
            if ($tab1CompanyId > 0) {
                $('#tab a[href="#AccountsReceivableTab"]').tab('show');
                renderTableAccountsReceivable();
            }
            if ($tab2CompanyId > 0) {
                $('#tab a[href="#AccountsReceivableSummaryTab"]').tab('show');
                renderTableAccountsReceivableSummary();

                $("#AccountsReceivableSummaryTable").on("click", "input[type='button']", function () {
                    var ButtonName = $(this).attr("id");
                    var Id = $("#AccountsReceivableSummaryTable").dataTable().fnGetData(this.parentNode);

                    if (ButtonName.search("CmdStatementOfAccount") > 0) cmdPrintStatementOfAccount_onclick(Id);
                });
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Accounts Receivable</h2>

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

                <div class="span12">
                    <div id="tab" class="btn-group" data-toggle="buttons-radio">
                      <a href="#AccountsReceivableTab" class="btn" data-toggle="tab" id="tab1">Accounts Receivable Aging</a>
                      <a href="#AccountsReceivableSummaryTab" class="btn" data-toggle="tab" id="tab2">Accounts Receivable Summary</a>
                    </div>
                </div>

                <div class="span12">
                    <div class="tab-content">
                        <div class="tab-pane active" id="AccountsReceivableTab">
                            <div class="row-fluid">
                                <div class="span6">
                                    <br />
                                    <div class="control-group">
                                        <label class="control-label">Company </label>
                                        <div class="controls">
                                            <input id="tab1Company" type="text" class="input-large"/>
                                        </div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label">Period </label>
                                        <div class="controls">
                                            <input id="tab1Period" type="text" class="input-large"/>
                                        </div>
                                    </div>                    
                                    <div class="control-group">
                                        <label class="control-label">As of date </label>
                                        <div class="controls">
                                            <input id="tab1AsOfDate" type="text" class="input-medium" />
                                        </div>
                                    </div>
                                </div>
                                <div class="span6 text-right">
                                    <input runat="server" id="CmdViewAccountsReceivable" type="button" class="btn btn-primary" value="View" onclick="cmdViewAccountsReceivable_onclick()"/>
                                </div>
                            </div>
                            <div>
                                <h3 class="text-center">Accounts Receivable</h3>
                                <table id="AccountsReceivableTable" class="table table-striped table-condensed" >
                                    <thead>
                                        <tr>
                                            <th>Customer</th>
                                            <th>SI Number</th>
                                            <th>SI Date</th>
                                            <th>Term</th>
                                            <th>Due Date</th>
                                            <th>Doc Ref</th>
                                            <th>Current</th>
                                            <th>30 Days</th>
                                            <th>60 Days</th>
                                            <th>90 Days</th>
                                            <th>>120 Days</th>
                                        </tr>
                                    </thead>
                                    <tbody id="AccountsReceivableTableBody"></tbody>
                                    <tfoot id="AccountsReceivableTableFoot"></tfoot>
                                </table>
                             </div>
                        </div>
                        
                        <div class="tab-pane" id="AccountsReceivableSummaryTab">
                            <div class="row-fluid">
                                <div class="span6">
                                    <br />
                                    <div class="control-group">
                                        <label class="control-label">Company </label>
                                        <div class="controls">
                                            <input id="tab2Company" type="text" class="input-large"/>
                                        </div>
                                    </div>
                                    <div class="control-group">
                                        <label class="control-label">Period </label>
                                        <div class="controls">
                                            <input id="tab2Period" type="text" class="input-large"/>
                                        </div>
                                    </div>                    
                                    <div class="control-group">
                                        <label class="control-label">As of date </label>
                                        <div class="controls">
                                            <input id="tab2AsOfDate" type="text" class="input-medium" />
                                        </div>
                                    </div>
                                </div>
                                <div class="span6 text-right">
                                    <input runat="server" id="cmdViewAccountsReceivableSummary" type="button" class="btn btn-primary" value="View" onclick="cmdViewAccountsReceivableSummary_onclick()"/>
                                </div>
                            </div>
                            <div>
                                <h3 class="text-center">Accounts Receivable Summary</h3>
                                <table id="AccountsReceivableSummaryTable" class="table table-striped table-condensed" >
                                    <thead>
                                        <tr>
                                            <th>Customer</th>
                                            <th>Balance</th>
                                            <th>Statement of Account</th>
                                        </tr>
                                    </thead>
                                    <tbody id="AccountsReceivableSummaryTableBody"></tbody>
                                    <tfoot id="AccountsReceivableSummaryTableFoot"></tfoot>
                                </table>
                             </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</asp:Content>
