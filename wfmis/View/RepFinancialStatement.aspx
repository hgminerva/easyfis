<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="RepFinancialStatement.aspx.cs" Inherits="wfmis.View.RepFinancialStatement" %>

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
	    var $pageSize = 20;

        // Balance Sheet Parameters
	    var $tab1CompanyId = 0;
	    var $tab1Company = "";
	    var $tab1BranchId = 0;
	    var $tab1Branch = "";
	    var $tab1PeriodId = 0;
	    var $tab1Period = "";
	    var $tab1AsOfDate = easyFIS.getCurrentDate();
        // Income Statement Parameters
	    var $tab2CompanyId = 0;
	    var $tab2Company = "";
	    var $tab2BranchId = 0;
	    var $tab2Branch = "";
	    var $tab2PeriodId = 0;
	    var $tab2Period = "";
	    var $tab2DateStart = easyFIS.getCurrentDate();
	    var $tab2DateEnd = easyFIS.getCurrentDate();
	    // Trial Balance Parameters
	    var $tab3CompanyId = 0;
	    var $tab3Company = "";
	    var $tab3BranchId = 0;
	    var $tab3Branch = "";
	    var $tab3PeriodId = 0;
	    var $tab3Period = "";
	    var $tab3DateStart = easyFIS.getCurrentDate();
	    var $tab3DateEnd = easyFIS.getCurrentDate();
	    // Account Ledger Parameters
	    var $tab4CompanyId = 0;
	    var $tab4Company = "";
	    var $tab4BranchId = 0;
	    var $tab4Branch = "";
	    var $tab4PeriodId = 0;
	    var $tab4Period = "";
	    var $tab4AccountId = 0;
	    var $tab4Account = "";
	    var $tab4DateStart = easyFIS.getCurrentDate();
	    var $tab4DateEnd = easyFIS.getCurrentDate();
	    // Cash Flow Statement Parameters
	    var $tab5CompanyId = 0;
	    var $tab5Company = "";
	    var $tab5BranchId = 0;
	    var $tab5Branch = "";
	    var $tab5PeriodId = 0;
	    var $tab5Period = "";
	    var $tab5DateStart = easyFIS.getCurrentDate();
	    var $tab5DateEnd = easyFIS.getCurrentDate();

        // Render Tables
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
	    function renderTableBalanceSheet() {
	        var d = new Date($tab1AsOfDate);
	        var AsOfDate = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
	        var tableBalanceSheet = $("#tableBalanceSheet").dataTable({
	                    "sAjaxSource": '/api/RepFSBalanceSheet?tab1AsOfDate=' + AsOfDate + '&tab1PeriodId=' + $tab1PeriodId + '&tab1CompanyId=' + $tab1CompanyId,
	                    "bPaginate": false,
	                    "sAjaxDataProp": "RepFSBalanceSheetData",
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
                                { "mData": "AccountCategory", "bVisible": false },
                                { "mData": "AccountType", "sWidth": "150px", "bSortable": false },
                                {
                                    "mData": "Account", "bSortable": false,
                                    "mRender": function (data) {
                                        var n = data.indexOf("-");
                                        var AccountId = data.substring(0, n - 1);
                                        var Account = data.substring(n + 2, data.length);
                                        return '<a href="RepFinancialStatement.aspx?tab4CompanyId=' + $tab1CompanyId + '&' +
                                                                                   'tab4Company=' + $tab1Company + '&' +
                                                                                   'tab4BranchId=' + $tab1BranchId + '&' +
                                                                                   'tab4Branch=' + $tab1Branch + '&' +
                                                                                   'tab4PeriodId=' + $tab1PeriodId + '&' +
                                                                                   'tab4Period=' + $tab1Period + '&' +
                                                                                   'tab4AccountId=' + AccountId + '&' +
                                                                                   'tab4Account=' + Account + '&' +
                                                                                   'tab4DateStart=1/1/1901&' +
                                                                                   'tab4DateEnd=' + $tab1AsOfDate + '&' + '">' + Account + '</a>'
                                    }
                                },
                                {
                                    "mData": "Amount", "sWidth": "150px", "sClass": "right", "bSortable": false,
                                    "mRender": function (data) {
                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                    }
                                },
                                { "mData": "LEAmount", "bVisible": false }],
	                    "fnDrawCallback": function (oSettings) {
	                        if (oSettings.aiDisplay.length == 0) {
	                            return;
	                        } else {
	                            var nTrs = $('#tableBalanceSheet tbody tr');
	                            var iColspan = nTrs[0].getElementsByTagName('td').length;
	                            var sLastGroup = "";
	                            var summed_balances = 0;
	                            var summed_lebalances = 0;

	                            for (var i = 0; i < nTrs.length; i++) {
	                                var iDisplayIndex = oSettings._iDisplayStart + i;
	                                var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["AccountCategory"];

	                                summed_lebalances += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["LEAmount"];

                                    // Group Total
	                                if (sLastGroup == "") {
	                                    insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
	                                    summed_balances += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                                    sLastGroup = sGroup;
	                                } else {
	                                    if (sGroup == sLastGroup) {
	                                        summed_balances += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                                    } else {
	                                        insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_balances, 2, ',', '.', '', '', '-', '') + '</b>', "right", false);
	                                        insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
	                                        summed_balances = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                                        sLastGroup = sGroup;
	                                    }
	                                }

                                    // Grand Total
	                                if (i == (nTrs.length - 1)) {
	                                    insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_lebalances, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                                    insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_balances, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                                }
	                            }
	                        }
	                    }
	                });
	    }
	    function renderTableIncomeStatement() {
	        var ds = new Date($tab2DateStart);
	        var de = new Date($tab2DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var tableIncomeStatement = $("#tableIncomeStatement").dataTable({
	            "sAjaxSource": '/api/RepFSIncomeStatement?tab2DateStart=' + DateStart + '&tab2DateEnd=' + DateEnd + '&tab2PeriodId=' + $tab2PeriodId + '&tab2CompanyId=' + $tab2CompanyId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepFSIncomeStatementData",
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
                        { "mData": "AccountCategory", "bVisible": false },
                        { "mData": "AccountType", "sWidth": "150px", "bSortable": false, },
                        {
                            "mData": "Account", "bSortable": false,
                            "mRender": function (data) {
                                var n = data.indexOf("-");
                                var AccountId = data.substring(0, n - 1);
                                var Account = data.substring(n + 2, data.length);
                                return '<a href="RepFinancialStatement.aspx?tab4CompanyId=' + $tab2CompanyId + '&' +
                                                                           'tab4Company=' + $tab2Company + '&' +
                                                                           'tab4BranchId=' + $tab2BranchId + '&' +
                                                                           'tab4Branch=' + $tab2Branch + '&' +
                                                                           'tab4PeriodId=' + $tab2PeriodId + '&' +
                                                                           'tab4Period=' + $tab2Period + '&' +
                                                                           'tab4AccountId=' + AccountId + '&' +
                                                                           'tab4Account=' + Account + '&' +
                                                                           'tab4DateStart=' + $tab2DateStart + '&' +
                                                                           'tab4DateEnd=' + $tab2DateEnd + '&' + '">' + Account + '</a>'
                            }
                        },
                        {
                            "mData": "Amount", "sWidth": "150px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        { "mData": "IEAmount", "bVisible": false }],
	            "fnDrawCallback": function (oSettings) {
	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                } else {
	                    var nTrs = $('#tableIncomeStatement tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var summed_group_amount = 0;
	                    var summed_total_amount = 0;

	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["AccountCategory"];

	                        summed_total_amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["IEAmount"];

                            // Group Total
	                        if (sLastGroup == "") {
	                            insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
	                            summed_group_amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                            sLastGroup = sGroup;
	                        } else {
	                            if (sGroup == sLastGroup) {
	                                summed_group_amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                            } else {
	                                insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_group_amount, 2, ',', '.', '', '', '-', '') + '</b>', "right", false);
	                                insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
	                                summed_group_amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                                sLastGroup = sGroup;
	                            }
	                        }
                            // Grand Total
	                        if (i == (nTrs.length - 1)) {
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_total_amount, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_group_amount, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                        }
	                    }
	                }
	            }
	        });
	    }
	    function renderTableCashFlowStatement() {
	        var ds = new Date($tab5DateStart);
	        var de = new Date($tab5DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var tableCashFlowStatement = $("#tableCashFlowStatement").dataTable({
	            "sAjaxSource": '/api/RepFSCashFlowStatement?tab5DateStart=' + DateStart + '&tab5DateEnd=' + DateEnd + '&tab5PeriodId=' + $tab5PeriodId + '&tab5CompanyId=' + $tab5CompanyId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepFSCashFlowStatementData",
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
                        { "mData": "AccountCashFlow", "bVisible": false },
                        { "mData": "AccountType", "sWidth": "150px", "bSortable": false },
                        { "mData": "Account", "bSortable": false, },
                        {
                            "mData": "Amount", "sWidth": "150px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }],
	            "fnDrawCallback": function (oSettings) {
	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                } else {
	                    var nTrs = $('#tableCashFlowStatement tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var summed_group_amount = 0;
	                    var summed_total_amount = 0;

	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["AccountCashFlow"];

	                        summed_total_amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];

	                        // Group Total
	                        if (sLastGroup == "") {
	                            insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
	                            summed_group_amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                            sLastGroup = sGroup;
	                        } else {
	                            if (sGroup == sLastGroup) {
	                                summed_group_amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                            } else {
	                                insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_group_amount, 2, ',', '.', '', '', '-', '') + '</b>', "right", false);
	                                insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
	                                summed_group_amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                                sLastGroup = sGroup;
	                            }
	                        }
	                        // Grand Total
	                        if (i == (nTrs.length - 1)) {
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_total_amount, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_group_amount, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                        }
	                    }
	                }
	            }
	        });
	    }
	    function renderTableTrialBalance() {
	        var ds = new Date($tab3DateStart);
	        var de = new Date($tab3DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var tableTrialBalance = $("#tableTrialBalance").dataTable({
	            "sAjaxSource": '/api/RepFSTrialBalance?tab3DateStart=' + DateStart + '&tab3DateEnd=' + DateEnd + '&tab3PeriodId=' + $tab3PeriodId + '&tab3CompanyId=' + $tab3CompanyId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepFSTrialBalanceData",
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
                        { "mData": "AccountCategory", "bVisible": false },
                        { "mData": "AccountType", "sWidth": "150px", "bSortable": false, },
                        {
                            "mData": "Account", "bSortable": false,
                            "mRender": function (data) {
                                var n = data.indexOf("-");
                                var AccountId = data.substring(0, n-1);
                                var Account = data.substring(n+2, data.length);
                                return '<a href="RepFinancialStatement.aspx?tab4CompanyId=' + $tab3CompanyId + '&' +
                                                                           'tab4Company=' + $tab3Company + '&' +
                                                                           'tab4BranchId=' + $tab3BranchId + '&' +
                                                                           'tab4Branch=' + $tab3Branch + '&' +
                                                                           'tab4PeriodId=' + $tab3PeriodId + '&' +
                                                                           'tab4Period=' + $tab3Period + '&' +
                                                                           'tab4AccountId=' + AccountId + '&' +
                                                                           'tab4Account=' + Account + '&' +
                                                                           'tab4DateStart=' + $tab3DateStart + '&' +
                                                                           'tab4DateEnd=' + $tab3DateEnd + '&' + '">' + Account + '</a>'
                            }
                        },
                        {
                            "mData": "DebitAmount", "sWidth": "150px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "CreditAmount", "sWidth": "150px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }],
	            "fnDrawCallback": function (oSettings) {
	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                } else {
	                    var nTrs = $('#tableTrialBalance tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var group_DebitAmount = 0;
	                    var group_CreditAmount = 0;
	                    var total_DebitAmount = 0;
	                    var total_CreditAmount = 0;

	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["AccountCategory"];

                            // Increment Grand Total
	                        total_DebitAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                        total_CreditAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];

	                        if (sLastGroup == "") {
                                // Insert Group TR
	                            insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
                                // Increment Group Total
	                            group_DebitAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                            group_CreditAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];

	                            sLastGroup = sGroup;
	                        } else {
	                            if (sGroup == sLastGroup) {
	                                group_DebitAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                                group_CreditAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];
	                            } else {
	                                // Insert Group Total TR
	                                var groupTr = document.createElement('tr');
	                                var groupTrTd1To3 = document.createElement('td'); groupTrTd1To3.colSpan = 2; groupTrTd1To3.className = "right"; groupTrTd1To3.innerHTML = "<b>SUB TOTAL</b>"; groupTr.appendChild(groupTrTd1To3);
	                                var groupTrTd4 = document.createElement('td'); groupTrTd4.colSpan = 1; groupTrTd4.className = "right"; groupTrTd4.innerHTML = '<b>' + easyFIS.formatNumber(group_DebitAmount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd4);
	                                var groupTrTd5 = document.createElement('td'); groupTrTd5.colSpan = 1; groupTrTd5.className = "right"; groupTrTd5.innerHTML = '<b>' + easyFIS.formatNumber(group_CreditAmount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd5);
	                                nTrs[i].parentNode.insertBefore(groupTr, nTrs[i]);
	                                // Insert Group TR
	                                insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader", false);
	                                // Set Group Total
	                                group_DebitAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                                group_CreditAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];

	                                sLastGroup = sGroup;
	                            }
	                        }

                            // Grand Total
	                        if (i == (nTrs.length - 1)) {
                                // Insert Grand Total TR
	                            var grandTr = document.createElement('tr');
	                            var grandTrTd1To3 = document.createElement('td'); grandTrTd1To3.colSpan = 2; grandTrTd1To3.className = "right"; grandTrTd1To3.innerHTML = "<b>TOTAL</b>"; grandTr.appendChild(grandTrTd1To3);
	                            var grandTrTd4 = document.createElement('td'); grandTrTd4.colSpan = 1; grandTrTd4.className = "right"; grandTrTd4.innerHTML = '<b>' + easyFIS.formatNumber(total_DebitAmount, 2, ',', '.', '', '', '-', '') + '</b>'; grandTr.appendChild(grandTrTd4);
	                            var grandTrTd5 = document.createElement('td'); grandTrTd5.colSpan = 1; grandTrTd5.className = "right"; grandTrTd5.innerHTML = '<b>' + easyFIS.formatNumber(total_CreditAmount, 2, ',', '.', '', '', '-', '') + '</b>'; grandTr.appendChild(grandTrTd5);
	                            nTrs[i].parentNode.insertBefore(grandTr, nTrs[i].nextSibling);
	                            // Insert Last Group Total TR
	                            var lastgroupTr = document.createElement('tr');
	                            var lastgroupTrTd1To3 = document.createElement('td'); lastgroupTrTd1To3.colSpan = 2; lastgroupTrTd1To3.className = "right"; lastgroupTrTd1To3.innerHTML = "<b>SUB TOTAL</b>"; lastgroupTr.appendChild(lastgroupTrTd1To3);
	                            var lastgroupTrTd4 = document.createElement('td'); lastgroupTrTd4.colSpan = 1; lastgroupTrTd4.className = "right"; lastgroupTrTd4.innerHTML = '<b>' + easyFIS.formatNumber(group_DebitAmount, 2, ',', '.', '', '', '-', '') + '</b>'; lastgroupTr.appendChild(lastgroupTrTd4);
	                            var lastgroupTrTd5 = document.createElement('td'); lastgroupTrTd5.colSpan = 1; lastgroupTrTd5.className = "right"; lastgroupTrTd5.innerHTML = '<b>' + easyFIS.formatNumber(group_CreditAmount, 2, ',', '.', '', '', '-', '') + '</b>'; lastgroupTr.appendChild(lastgroupTrTd5);
	                            nTrs[i].parentNode.insertBefore(lastgroupTr, nTrs[i].nextSibling);
	                        }
	                    }
	                }
	            }
	        });
	    }
	    function renderTableAccountLedger() {
	        var ds = new Date($tab4DateStart);
	        var de = new Date($tab4DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var tableAccountLedger = $("#tableAccountLedger").dataTable({
	            "sAjaxSource": '/api/RepFSAccountLedger?tab4DateStart=' + DateStart + '&tab4DateEnd=' + DateEnd + '&tab4PeriodId=' + $tab4PeriodId + '&tab4CompanyId=' + $tab4CompanyId + '&tab4AccountId=' + $tab4AccountId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepFSAccountLedgerData",
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
                        { "mData": "DocumentDate", "sWidth": "100px" },
                        {
                            "mData": "DocumentNumber", "sWidth": "150px",
                            "mRender": function (data) {
                                var n = data.indexOf(")");
                                var Link = data.substring(1, n);
                                var DocumentNumber = data.substring(n + 1, data.length);
                                return '<a href="' + Link + '">' + DocumentNumber + '</a>'
                            }
                        },
                        { "mData": "Article", "sWidth": "250px" },
                        { "mData": "Particulars" },
                        {
                            "mData": "DebitAmount", "sWidth": "150px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "CreditAmount", "sWidth": "150px", "sClass": "right", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }],
	            "fnDrawCallback": function (oSettings) {
	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                } else {
	                    var nTrs = $('#tableAccountLedger tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;

	                    var total_DebitAmount = 0;
	                    var total_CreditAmount = 0;

	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;

	                        // Increment Grand Total
	                        total_DebitAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                        total_CreditAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];

	                        // Grand Total
	                        if (i == (nTrs.length - 1)) {
	                            // Insert Grand Total TR
	                            var grandTr = document.createElement('tr');
	                            var grandTrTd1To4 = document.createElement('td'); grandTrTd1To4.colSpan = 4; grandTrTd1To4.className = "right"; grandTrTd1To4.innerHTML = "<b>TOTAL</b>"; grandTr.appendChild(grandTrTd1To4);
	                            var grandTrTd5 = document.createElement('td'); grandTrTd5.colSpan = 1; grandTrTd5.className = "right"; grandTrTd5.innerHTML = '<b>' + easyFIS.formatNumber(total_DebitAmount, 2, ',', '.', '', '', '-', '') + '</b>'; grandTr.appendChild(grandTrTd5);
	                            var grandTrTd6 = document.createElement('td'); grandTrTd6.colSpan = 1; grandTrTd6.className = "right"; grandTrTd6.innerHTML = '<b>' + easyFIS.formatNumber(total_CreditAmount, 2, ',', '.', '', '', '-', '') + '</b>'; grandTr.appendChild(grandTrTd6);
	                            nTrs[i].parentNode.insertBefore(grandTr, nTrs[i].nextSibling);
	                        }
	                    }
	                }
	            }
	        });
	    }

	    // Initialized tab controls
	    function initTab1() {
	        $tab1CompanyId = easyFIS.getParameterByName("tab1CompanyId");
	        $tab1Company = easyFIS.getParameterByName("tab1Company");
	        $tab1BranchId = easyFIS.getParameterByName("tab1BranchId");
	        $tab1Branch = easyFIS.getParameterByName("tab1Branch");
	        $tab1PeriodId = easyFIS.getParameterByName("tab1PeriodId");
	        $tab1Period = easyFIS.getParameterByName("tab1Period");
	        $tab1AsOfDate = easyFIS.getParameterByName("tab1AsOfDate");

	        if ($tab1CompanyId != "") {
	            $('#tab1Company').select2('data', { id: $tab1CompanyId, text: $tab1Company });
	        } else {
	            $('#tab1Company').select2('data', { id: 0, text: "" });
	            $tab1CompanyId = 0;
	        }
	        if ($tab1BranchId != "") {
	            $('#tab1Branch').select2('data', { id: $tab1BranchId, text: $tab1Branch });
	        } else {
	            $('#tab1Branch').select2('data', { id: 0, text: "" });
	            $tab1BranchId = 0;
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
	        $tab2BranchId = easyFIS.getParameterByName("tab2BranchId");
	        $tab2Branch = easyFIS.getParameterByName("tab2Branch");
	        $tab2PeriodId = easyFIS.getParameterByName("tab2PeriodId");
	        $tab2Period = easyFIS.getParameterByName("tab2Period");
	        $tab2DateStart = easyFIS.getParameterByName("tab2DateStart");
	        $tab2DateEnd = easyFIS.getParameterByName("tab2DateEnd");

	        if ($tab2CompanyId != "") {
	            $('#tab2Company').select2('data', { id: $tab2CompanyId, text: $tab2Company });
	        } else {
	            $('#tab2Company').select2('data', { id: 0, text: "" });
	            $tab2CompanyId = 0;
	        }
	        if ($tab2BranchId != "") {
	            $('#tab2Branch').select2('data', { id: $tab2BranchId, text: $tab2Branch });
	        } else {
	            $('#tab2Branch').select2('data', { id: 0, text: "" });
	            $tab2BranchId = 0;
	        }
	        if ($tab2PeriodId != "") {
	            $('#tab2Period').select2('data', { id: $tab2PeriodId, text: $tab2Period });
	        } else {
	            $('#tab2Period').select2('data', { id: 0, text: "" });
	            $tab2PeriodId = 0;
	        }
	        if ($tab2DateStart != "") {
	            $('#tab2DateStart').val($tab2DateStart);
	        } else {
	            $tab2DateStart = easyFIS.getCurrentDate();
	            $('#tab2DateStart').val($tab2DateStart);
	        }
	        if ($tab2DateEnd != "") {
	            $('#tab2DateEnd').val($tab2DateEnd);
	        } else {
	            $tab2DateEnd = easyFIS.getCurrentDate();
	            $('#tab2DateEnd').val($tab2DateEnd);
	        }
	    }
	    function initTab3() {
	        $tab3CompanyId = easyFIS.getParameterByName("tab3CompanyId");
	        $tab3Company = easyFIS.getParameterByName("tab3Company");
	        $tab3BranchId = easyFIS.getParameterByName("tab3BranchId");
	        $tab3Branch = easyFIS.getParameterByName("tab3Branch");
	        $tab3PeriodId = easyFIS.getParameterByName("tab3PeriodId");
	        $tab3Period = easyFIS.getParameterByName("tab3Period");
	        $tab3DateStart = easyFIS.getParameterByName("tab3DateStart");
	        $tab3DateEnd = easyFIS.getParameterByName("tab3DateEnd");

	        if ($tab3CompanyId != "") {
	            $('#tab3Company').select2('data', { id: $tab3CompanyId, text: $tab3Company });
	        } else {
	            $('#tab3Company').select2('data', { id: 0, text: "" });
	            $tab3CompanyId = 0;
	        }
	        if ($tab3BranchId != "") {
	            $('#tab3Branch').select2('data', { id: $tab3BranchId, text: $tab3Branch });
	        } else {
	            $('#tab3Branch').select2('data', { id: 0, text: "" });
	            $tab3BranchId = 0;
	        }
	        if ($tab3PeriodId != "") {
	            $('#tab3Period').select2('data', { id: $tab3PeriodId, text: $tab3Period });
	        } else {
	            $('#tab3Period').select2('data', { id: 0, text: "" });
	            $tab3PeriodId = 0;
	        }
	        if ($tab3DateStart != "") {
	            $('#tab3DateStart').val($tab3DateStart);
	        } else {
	            $tab3DateStart = easyFIS.getCurrentDate();
	            $('#tab3DateStart').val($tab3DateStart);
	        }
	        if ($tab3DateEnd != "") {
	            $('#tab3DateEnd').val($tab3DateEnd);
	        } else {
	            $tab3DateEnd = easyFIS.getCurrentDate();
	            $('#tab3DateEnd').val($tab3DateEnd);
	        }
	    }
	    function initTab4() {
	        $tab4CompanyId = easyFIS.getParameterByName("tab4CompanyId");
	        $tab4Company = easyFIS.getParameterByName("tab4Company");
	        $tab4BranchId = easyFIS.getParameterByName("tab4BranchId");
	        $tab4Branch = easyFIS.getParameterByName("tab4Branch");
	        $tab4PeriodId = easyFIS.getParameterByName("tab4PeriodId");
	        $tab4Period = easyFIS.getParameterByName("tab4Period");
	        $tab4AccountId = easyFIS.getParameterByName("tab4AccountId");
	        $tab4Account = easyFIS.getParameterByName("tab4Account");
	        $tab4DateStart = easyFIS.getParameterByName("tab4DateStart");
	        $tab4DateEnd = easyFIS.getParameterByName("tab4DateEnd");

	        if ($tab4CompanyId != "") {
	            $('#tab4Company').select2('data', { id: $tab4CompanyId, text: $tab4Company });
	        } else {
	            $('#tab4Company').select2('data', { id: 0, text: "" });
	            $tab4CompanyId = 0;
	        }
	        if ($tab4BranchId != "") {
	            $('#tab4Branch').select2('data', { id: $tab4BranchId, text: $tab4Branch });
	        } else {
	            $('#tab4Branch').select2('data', { id: 0, text: "" });
	            $tab4BranchId = 0;
	        }
	        if ($tab4PeriodId != "") {
	            $('#tab4Period').select2('data', { id: $tab4PeriodId, text: $tab4Period });
	        } else {
	            $('#tab4Period').select2('data', { id: 0, text: "" });
	            $tab4PeriodId = 0;
	        }
	        if ($tab4AccountId != "") {
	            $('#tab4Account').select2('data', { id: $tab4AccountId, text: $tab4Account });
	        } else {
	            $('#tab4Account').select2('data', { id: 0, text: "" });
	            $tab4AccountId = 0;
	        }
	        if ($tab4DateStart != "") {
	            $('#tab4DateStart').val($tab4DateStart);
	        } else {
	            $tab4DateStart = easyFIS.getCurrentDate();
	            $('#tab4DateStart').val($tab4DateStart);
	        }
	        if ($tab4DateEnd != "") {
	            $('#tab4DateEnd').val($tab4DateEnd);
	        } else {
	            $tab4DateEnd = easyFIS.getCurrentDate();
	            $('#tab4DateEnd').val($tab4DateEnd);
	        }
	    }
	    function initTab5() {
	        $tab5CompanyId = easyFIS.getParameterByName("tab5CompanyId");
	        $tab5Company = easyFIS.getParameterByName("tab5Company");
	        $tab5BranchId = easyFIS.getParameterByName("tab5BranchId");
	        $tab5Branch = easyFIS.getParameterByName("tab5Branch");
	        $tab5PeriodId = easyFIS.getParameterByName("tab5PeriodId");
	        $tab5Period = easyFIS.getParameterByName("tab5Period");
	        $tab5DateStart = easyFIS.getParameterByName("tab5DateStart");
	        $tab5DateEnd = easyFIS.getParameterByName("tab5DateEnd");

	        if ($tab5CompanyId != "") {
	            $('#tab5Company').select2('data', { id: $tab5CompanyId, text: $tab5Company });
	        } else {
	            $('#tab5Company').select2('data', { id: 0, text: "" });
	            $tab5CompanyId = 0;
	        }
	        if ($tab5BranchId != "") {
	            $('#tab5Branch').select2('data', { id: $tab5BranchId, text: $tab5Branch });
	        } else {
	            $('#tab5Branch').select2('data', { id: 0, text: "" });
	            $tab5BranchId = 0;
	        }
	        if ($tab5PeriodId != "") {
	            $('#tab5Period').select2('data', { id: $tab5PeriodId, text: $tab5Period });
	        } else {
	            $('#tab5Period').select2('data', { id: 0, text: "" });
	            $tab5PeriodId = 0;
	        }
	        if ($tab5DateStart != "") {
	            $('#tab5DateStart').val($tab5DateStart);
	        } else {
	            $tab5DateStart = easyFIS.getCurrentDate();
	            $('#tab5DateStart').val($tab5DateStart);
	        }
	        if ($tab5DateEnd != "") {
	            $('#tab5DateEnd').val($tab5DateEnd);
	        } else {
	            $tab5DateEnd = easyFIS.getCurrentDate();
	            $('#tab5DateEnd').val($tab5DateEnd);
	        }
	    }

	    // Clicked events
	    function CmdViewBalanceSheet_onclick() {
	        location.href = 'RepFinancialStatement.aspx?tab1CompanyId=' + $tab1CompanyId + '&' +
                                                       'tab1Company=' + $tab1Company + '&' +
                                                       'tab1BranchId=' + $tab1BranchId + '&' +
                                                       'tab1Branch=' + $tab1Branch + '&' +
                                                       'tab1PeriodId=' + $tab1PeriodId + '&' +
                                                       'tab1Period=' + $tab1Period + '&' +
                                                       'tab1AsOfDate=' + $tab1AsOfDate;
	    }
	    function CmdViewIncomeStatement_onclick() {
	        location.href = 'RepFinancialStatement.aspx?tab2CompanyId=' + $tab2CompanyId + '&' +
                                                       'tab2Company=' + $tab2Company + '&' +
                                                       'tab2BranchId=' + $tab2BranchId + '&' +
                                                       'tab2Branch=' + $tab2Branch + '&' +
                                                       'tab2PeriodId=' + $tab2PeriodId + '&' +
                                                       'tab2Period=' + $tab2Period + '&' +
                                                       'tab2DateStart=' + $tab2DateStart + '&' + 
	                                                   'tab2DateEnd=' + $tab2DateEnd;
	    }
	    function CmdViewTrialBalance_onclick() {
	        location.href = 'RepFinancialStatement.aspx?tab3CompanyId=' + $tab3CompanyId + '&' +
                                                       'tab3Company=' + $tab3Company + '&' +
                                                       'tab3BranchId=' + $tab3BranchId + '&' +
                                                       'tab3Branch=' + $tab3Branch + '&' +
                                                       'tab3PeriodId=' + $tab3PeriodId + '&' +
                                                       'tab3Period=' + $tab3Period + '&' +
                                                       'tab3DateStart=' + $tab3DateStart + '&' +
	                                                   'tab3DateEnd=' + $tab3DateEnd;
	    }
	    function CmdViewAccountLedger_onclick() {
	        location.href = 'RepFinancialStatement.aspx?tab4CompanyId=' + $tab4CompanyId + '&' +
                                                       'tab4Company=' + $tab4Company + '&' +
                                                       'tab4BranchId=' + $tab4BranchId + '&' +
                                                       'tab4Branch=' + $tab4Branch + '&' +
                                                       'tab4PeriodId=' + $tab4PeriodId + '&' +
                                                       'tab4Period=' + $tab4Period + '&' +
                                                       'tab4AccountId=' + $tab4AccountId + '&' +
                                                       'tab4Account=' + $tab4Account + '&' +
                                                       'tab4DateStart=' + $tab4DateStart + '&' +
	                                                   'tab4DateEnd=' + $tab4DateEnd;
	    }
	    function CmdViewCashFlowStatement_onclick() {
	        location.href = 'RepFinancialStatement.aspx?tab5CompanyId=' + $tab5CompanyId + '&' +
                                                       'tab5Company=' + $tab5Company + '&' +
                                                       'tab5BranchId=' + $tab5BranchId + '&' +
                                                       'tab5Branch=' + $tab5Branch + '&' +
                                                       'tab5PeriodId=' + $tab5PeriodId + '&' +
                                                       'tab5Period=' + $tab5Period + '&' +
                                                       'tab5DateStart=' + $tab5DateStart + '&' +
	                                                   'tab5DateEnd=' + $tab5DateEnd;
	    }

	    // Select2 controls
	    function Select2_tab1Company() {
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
	    function Select2_tab1Branch() {
	        $('#tab1Branch').select2({
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
	                        pageSize: $pageSize,
	                        pageNum: page,
	                        searchTerm: term,
	                        fromBranchId: 0,
	                        companyId: $tab1CompanyId
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * $pageSize) < data.Total;
	                    return { results: data.Results, more: more };
	                }
	            }
	        }).change(function () {
	            $tab1BranchId = $('#tab1Branch').select2('data').id;
	            $tab1Branch = $('#tab1Branch').select2('data').text;
	        });
	    }
	    function Select2_tab1Period() {
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
	    function Select2_tab2Company() {
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
	    function Select2_tab2Branch() {
	        $('#tab2Branch').select2({
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
	                        pageSize: $pageSize,
	                        pageNum: page,
	                        searchTerm: term,
	                        fromBranchId: 0,
	                        companyId: $tab2CompanyId
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * $pageSize) < data.Total;
	                    return { results: data.Results, more: more };
	                }
	            }
	        }).change(function () {
	            $tab2BranchId = $('#tab2Branch').select2('data').id;
	            $tab2Branch = $('#tab2Branch').select2('data').text;
	        });
	    }
	    function Select2_tab2Period() {
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
	    function Select2_tab3Company() {
	        $('#tab3Company').select2({
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
	            $tab3CompanyId = $('#tab3Company').select2('data').id;
	            $tab3Company = $('#tab3Company').select2('data').text;
	        });
	    }
	    function Select2_tab3Branch() {
	        $('#tab3Branch').select2({
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
	                        pageSize: $pageSize,
	                        pageNum: page,
	                        searchTerm: term,
	                        fromBranchId: 0,
	                        companyId: $tab3CompanyId
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * $pageSize) < data.Total;
	                    return { results: data.Results, more: more };
	                }
	            }
	        }).change(function () {
	            $tab3BranchId = $('#tab3Branch').select2('data').id;
	            $tab3Branch = $('#tab3Branch').select2('data').text;
	        });
	    }
	    function Select2_tab3Period() {
	        $('#tab3Period').select2({
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
	            $tab3PeriodId = $('#tab3Period').select2('data').id;
	            $tab3Period = $('#tab3Period').select2('data').text;
	        });
	    }
	    function Select2_tab4Company() {
	        $('#tab4Company').select2({
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
	            $tab4CompanyId = $('#tab4Company').select2('data').id;
	            $tab4Company = $('#tab4Company').select2('data').text;
	        });
	    }
	    function Select2_tab4Branch() {
	        $('#tab4Branch').select2({
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
	                        pageSize: $pageSize,
	                        pageNum: page,
	                        searchTerm: term,
	                        fromBranchId: 0,
	                        companyId: $tab4CompanyId
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * $pageSize) < data.Total;
	                    return { results: data.Results, more: more };
	                }
	            }
	        }).change(function () {
	            $tab4BranchId = $('#tab4Branch').select2('data').id;
	            $tab4Branch = $('#tab4Branch').select2('data').text;
	        });
	    }
	    function Select2_tab4Period() {
	        $('#tab4Period').select2({
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
	            $tab4PeriodId = $('#tab4Period').select2('data').id;
	            $tab4Period = $('#tab4Period').select2('data').text;
	        });
	    }
	    function Select2_tab4Account() {
	        $('#tab4Account').select2({
	            placeholder: 'Period',
	            allowClear: false,
	            ajax: {
	                quietMillis: 150,
	                url: '/api/SelectAccount',
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
	            $tab4AccountId = $('#tab4Account').select2('data').id;
	            $tab4Account = $('#tab4Account').select2('data').text;
	        });
	    }
	    function Select2_tab5Company() {
	        $('#tab5Company').select2({
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
	            $tab5CompanyId = $('#tab5Company').select2('data').id;
	            $tab5Company = $('#tab5Company').select2('data').text;
	        });
	    }
	    function Select2_tab5Branch() {
	        $('#tab5Branch').select2({
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
	                        pageSize: $pageSize,
	                        pageNum: page,
	                        searchTerm: term,
	                        fromBranchId: 0,
	                        companyId: $tab5CompanyId
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * $pageSize) < data.Total;
	                    return { results: data.Results, more: more };
	                }
	            }
	        }).change(function () {
	            $tab5BranchId = $('#tab5Branch').select2('data').id;
	            $tab5Branch = $('#tab5Branch').select2('data').text;
	        });
	    }
	    function Select2_tab5Period() {
	        $('#tab5Period').select2({
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
	            $tab5PeriodId = $('#tab5Period').select2('data').id;
	            $tab5Period = $('#tab5Period').select2('data').text;
	        });
	    }

	    // Page load
	    $(document).ready(function () {
	        // DatePicker
	        $('#tab1AsOfDate').datepicker().on('changeDate', function (ev) {
	            $tab1AsOfDate = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab2DateStart').datepicker().on('changeDate', function (ev) {
	            $tab2DateStart = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab2DateEnd').datepicker().on('changeDate', function (ev) {
	            $tab2DateEnd = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab3DateStart').datepicker().on('changeDate', function (ev) {
	            $tab3DateStart = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab3DateEnd').datepicker().on('changeDate', function (ev) {
	            $tab3DateEnd = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab4DateStart').datepicker().on('changeDate', function (ev) {
	            $tab4DateStart = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab4DateEnd').datepicker().on('changeDate', function (ev) {
	            $tab4DateEnd = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab5DateStart').datepicker().on('changeDate', function (ev) {
	            $tab5DateStart = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab5DateEnd').datepicker().on('changeDate', function (ev) {
	            $tab5DateEnd = $(this).val();
	            $(this).datepicker('hide');
	        });

	        // Select2 controls
	        Select2_tab1Company();
	        Select2_tab1Branch();
	        Select2_tab1Period();
	        Select2_tab2Company();
	        Select2_tab2Branch();
	        Select2_tab2Period();
	        Select2_tab3Company();
	        Select2_tab3Branch();
	        Select2_tab3Period();
	        Select2_tab4Company();
	        Select2_tab4Branch();
	        Select2_tab4Period();
	        Select2_tab4Account();
	        Select2_tab5Company();
	        Select2_tab5Branch();
	        Select2_tab5Period();

	        // Initialized tab
	        initTab1();
	        initTab2();
	        initTab3();
	        initTab4();
	        initTab5();

	        // Render table
	        if ($tab1CompanyId > 0) {
	            $('#tab a[href="#tabBalanceSheet"]').tab('show');
	            renderTableBalanceSheet();
	        }
	        if ($tab2CompanyId > 0)  {
	            $('#tab a[href="#tabIncomeStatement"]').tab('show');
	            renderTableIncomeStatement();
	        }
	        if ($tab3CompanyId > 0) {
	            $('#tab a[href="#tabTrialBalance"]').tab('show');
	            renderTableTrialBalance();
	        }
	        if ($tab4CompanyId > 0) {
	            $('#tab a[href="#tabAccountLedger"]').tab('show');
	            renderTableAccountLedger();
	        }
	        if ($tab5CompanyId > 0) {
	            $('#tab a[href="#tabCashFlowStatement"]').tab('show');
	            renderTableCashFlowStatement();
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

            <h2>Financial Statements</h2>

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

            <div id="tab" class="btn-group" data-toggle="buttons-radio">
              <a href="#tabBalanceSheet" class="btn" data-toggle="tab" id="tab1">Balance Sheet</a>
              <a href="#tabIncomeStatement" class="btn" data-toggle="tab" id="tab2">Income Statement</a>
              <a href="#tabCashFlowStatement" class="btn" data-toggle="tab" id="tab5">Cash Flow Statement</a>
              <a href="#tabTrialBalance" class="btn" data-toggle="tab" id="tab3">Trial Balance</a>
              <a href="#tabAccountLedger" class="btn" data-toggle="tab" id="tab4">Account Ledger</a>
            </div>

            <br />

            <br />

            <div class="tab-content">

                <div class="tab-pane active" id="tabBalanceSheet">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Company </label>
                                <div class="controls">
                                    <input id="tab1Company" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab1Branch" type="text" class="input-xxlarge"/>
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
                                    <input id="tab1AsOfDate" name="AsOfDate" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewBalanceSheet" type="button" class="btn btn-primary" value="View" onclick="CmdViewBalanceSheet_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Balance Sheet</h3>
                        <table id="tableBalanceSheet" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Type</th>
                                    <th>Account</th>
                                    <th>Balance</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyBalanceSheet"></tbody>
                            <tfoot id="tablefootBalanceSheet"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabIncomeStatement">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Company </label>
                                <div class="controls">
                                    <input id="tab2Company" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab2Branch" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Period </label>
                                <div class="controls">
                                    <input id="tab2Period" type="text" class="input-large"/>
                                </div>
                            </div>                    
                            <div class="control-group">
                                <label class="control-label">Date Start </label>
                                <div class="controls">
                                    <input id="tab2DateStart" name="tab2DateStart" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date End </label>
                                <div class="controls">
                                    <input id="tab2DateEnd" name="tab2DateEnd" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewIncomeStatement" type="button" class="btn btn-primary" value="View" onclick="CmdViewIncomeStatement_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Income Statement</h3>
                        <table id="tableIncomeStatement" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th></th>
                                    <th>Type</th>
                                    <th>Account</th>
                                    <th>Balance</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyIncomeStatement"></tbody>
                            <tfoot id="tablefootIncomeStatement"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabCashFlowStatement">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Company </label>
                                <div class="controls">
                                    <input id="tab5Company" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab5Branch" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Period </label>
                                <div class="controls">
                                    <input id="tab5Period" type="text" class="input-large"/>
                                </div>
                            </div>                    
                            <div class="control-group">
                                <label class="control-label">Date Start </label>
                                <div class="controls">
                                    <input id="tab5DateStart" name="tab5DateStart" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date End </label>
                                <div class="controls">
                                    <input id="tab5DateEnd" name="tab5DateEnd" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewCashFlowStatement" type="button" class="btn btn-primary" value="View" onclick="CmdViewCashFlowStatement_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Cash Flow Statement</h3>
                        <table id="tableCashFlowStatement" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>Cash Flow</th>
                                    <th>Type</th>
                                    <th>Account</th>
                                    <th>Balance</th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyCashFlowStatement"></tbody>
                            <tfoot id="tablefootCashFlowStatement"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabTrialBalance">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Company </label>
                                <div class="controls">
                                    <input id="tab3Company" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab3Branch" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Period </label>
                                <div class="controls">
                                    <input id="tab3Period" type="text" class="input-large"/>
                                </div>
                            </div>                    
                            <div class="control-group">
                                <label class="control-label">Date Start </label>
                                <div class="controls">
                                    <input id="tab3DateStart" name="tab3DateStart" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date End </label>
                                <div class="controls">
                                    <input id="tab3DateEnd" name="tab3DateEnd" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewTrialBalance" type="button" class="btn btn-primary" value="View" onclick="CmdViewTrialBalance_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Trial Balance</h3>
                        <table id="tableTrialBalance" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Type</th>
                                    <th>Account</th>
                                    <th>Debit Amount</th>
                                    <th>Credit Amount</th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyTrialBalance"></tbody>
                            <tfoot id="tablefootTrialBalance"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabAccountLedger">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Company </label>
                                <div class="controls">
                                    <input id="tab4Company" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab4Branch" type="text" class="input-xxlarge"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Period </label>
                                <div class="controls">
                                    <input id="tab4Period" type="text" class="input-large"/>
                                </div>
                            </div>        
                            <div class="control-group">
                                <label class="control-label">Account </label>
                                <div class="controls">
                                    <input id="tab4Account" type="text" class="input-xlarge"/>
                                </div>
                            </div>                                          
                            <div class="control-group">
                                <label class="control-label">Date Start </label>
                                <div class="controls">
                                    <input id="tab4DateStart" name="tab4DateStart" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date End </label>
                                <div class="controls">
                                    <input id="tab4DateEnd" name="tab4DateEnd" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewAccountLedger" type="button" class="btn btn-primary" value="View" onclick="CmdViewAccountLedger_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Account Ledger</h3>
                        <table id="tableAccountLedger" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Document</th>
                                    <th>Article</th>
                                    <th>Particulars</th>
                                    <th>Debit Amount</th>
                                    <th>Credit Amount</th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyAccountLedger"></tbody>
                            <tfoot id="tablefootAccountLedger"></tfoot>
                        </table>
                    </div>
                </div>

            </div>

        </div>
    </div>
</asp:Content>
