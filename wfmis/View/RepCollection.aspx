﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="RepCollection.aspx.cs" Inherits="wfmis.View.RepCollection" %>

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
	    var $CurrentCompanyId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentCompanyId %>';

	    var $pageSize = 20;
	    // Sales Summary
	    var $tab1BranchId = 0;
	    var $tab1Branch = "";
	    var $tab1PeriodId = 0;
	    var $tab1Period = "";
	    var $tab1DateStart = easyFIS.getCurrentDate();
	    var $tab1DateEnd = easyFIS.getCurrentDate();
	    // Sales Detail
	    var $tab2BranchId = 0;
	    var $tab2Branch = "";
	    var $tab2PeriodId = 0;
	    var $tab2Period = "";
	    var $tab2DateStart = easyFIS.getCurrentDate();
	    var $tab2DateEnd = easyFIS.getCurrentDate();
	    // Sales Book
	    var $tab3BranchId = 0;
	    var $tab3Branch = "";
	    var $tab3PeriodId = 0;
	    var $tab3Period = "";
	    var $tab3DateStart = easyFIS.getCurrentDate();
	    var $tab3DateEnd = easyFIS.getCurrentDate();
	    // Events
	    function CmdViewCollectionSummary_onclick() {
	        location.href = 'RepCollection.aspx?tab1BranchId=' + $tab1BranchId + '&' +
                                               'tab1Branch=' + $tab1Branch + '&' +
                                               'tab1PeriodId=' + $tab1PeriodId + '&' +
                                               'tab1Period=' + $tab1Period + '&' +
                                               'tab1DateStart=' + $tab1DateStart + '&' +
	                                           'tab1DateEnd=' + $tab1DateEnd;
	    }
	    function CmdViewCollectionDetail_onclick() {
	        location.href = 'RepCollection.aspx?tab2BranchId=' + $tab2BranchId + '&' +
                                               'tab2Branch=' + $tab2Branch + '&' +
                                               'tab2PeriodId=' + $tab2PeriodId + '&' +
                                               'tab2Period=' + $tab2Period + '&' +
                                               'tab2DateStart=' + $tab2DateStart + '&' +
	                                           'tab2DateEnd=' + $tab2DateEnd;
	    }
	    function CmdViewCollectionBook_onclick() {
	        location.href = 'RepCollection.aspx?tab3BranchId=' + $tab3BranchId + '&' +
                                               'tab3Branch=' + $tab3Branch + '&' +
                                               'tab3PeriodId=' + $tab3PeriodId + '&' +
                                               'tab3Period=' + $tab3Period + '&' +
                                               'tab3DateStart=' + $tab3DateStart + '&' +
	                                           'tab3DateEnd=' + $tab3DateEnd;
	    }
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
	    function renderTableCollectionSummary() {
	        var ds = new Date($tab1DateStart);
	        var de = new Date($tab1DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var tableCollectionSummary = $("#tableCollectionSummary").dataTable({
	            "sAjaxSource": '/api/RepCollectionSummary?tab1DateStart=' + DateStart + '&tab1DateEnd=' + DateEnd + '&tab1PeriodId=' + $tab1PeriodId + '&tab1BranchId=' + $tab1BranchId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepCollectionSummaryData",
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
                        { "mData": "ORDate", "sWidth": "100px" },
                        {
                            "mData": "ORNumber", "sWidth": "100px",
                            "mRender": function (data) {
                                return easyFIS.returnLink(data);
                            }
                        },
                        { "mData": "ORManualNumber", "sWidth": "100px" },
                        { "mData": "Customer", "sWidth": "200px" },
                        { "mData": "Particulars", "bSortable": false, },
                        {
                            "mData": "TotalAmount", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }],
	            "fnDrawCallback": function (oSettings) {
	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                } else {
	                    var nTrs = $('#tableCollectionSummary tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;

	                    var summed_total_amount = 0;
	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        summed_total_amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["TotalAmount"];
	                    }

	                    insertTR(nTrs[i - 1], iColspan, '<b>' + easyFIS.formatNumber(summed_total_amount, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                }
	            }
	        });
	    }
	    function renderTableCollectionDetail() {
	        var ds = new Date($tab2DateStart);
	        var de = new Date($tab2DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var tableCollectionDetail = $("#tableCollectionDetail").dataTable({
	            "sAjaxSource": '/api/RepCollectionDetail?tab2DateStart=' + DateStart + '&tab2DateEnd=' + DateEnd + '&tab2PeriodId=' + $tab2PeriodId + '&tab2BranchId=' + $tab2BranchId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepCollectionDetailData",
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
                        {
                            "mData": "Collection", "bVisible": false,
                            "mRender": function (data) {
                                return easyFIS.returnLink(data);
                            }
                        },
                        { "mData": "ORDate", "sWidth": "100px" },
                        { "mData": "Account", "sWidth": "200px" },
                        { "mData": "SINumber", "sWidth": "100px" },
                        { "mData": "Particulars" },
                        { "mData": "PayType", "sWidth": "100px" },
                        { "mData": "PayTypeDetails"},
                        {
                            "mData": "Amount", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }],
	            "fnDrawCallback": function (oSettings) {
	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                } else {
	                    var nTrs = $('#tableCollectionDetail tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var group_Amount = 0;
	                    var total_Amount = 0;
	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Collection"];
	                        total_Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                        if (sLastGroup == "") {
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.returnLink(sGroup) + '</b>', "GroupHeader", false);
	                            sLastGroup = sGroup;
	                            group_Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                        } else {
	                            if (sGroup == sLastGroup) {
	                                group_Amount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                            } else {
	                                var groupTr = document.createElement('tr');
	                                var groupTrTd1To7 = document.createElement('td'); groupTrTd1To7.colSpan = 6; groupTrTd1To7.className = "right"; groupTrTd1To7.innerHTML = "<b>SUB TOTAL</b>"; groupTr.appendChild(groupTrTd1To7);
	                                var groupTrTd8 = document.createElement('td'); groupTrTd8.colSpan = 1; groupTrTd8.className = "right"; groupTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(group_Amount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd8);
	                                nTrs[i].parentNode.insertBefore(groupTr, nTrs[i]);

	                                insertTR(nTrs[i], iColspan, '<b>' + easyFIS.returnLink(sGroup) + '</b>', "GroupHeader", false);
	                                sLastGroup = sGroup;

	                                group_Amount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                            }
	                        }
	                    }
	                    var totalTr = document.createElement('tr');
	                    var totalTrTd1To7 = document.createElement('td'); totalTrTd1To7.colSpan = 6; totalTrTd1To7.className = "right"; totalTrTd1To7.innerHTML = "<b>TOTAL</b>"; totalTr.appendChild(totalTrTd1To7);
	                    var totalTrTd8 = document.createElement('td'); totalTrTd8.colSpan = 1; totalTrTd8.className = "right"; totalTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(total_Amount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd8);
	                    nTrs[i - 1].parentNode.insertBefore(totalTr, nTrs[i - 1].nextSibling);

	                    var lastGroupTr = document.createElement('tr');
	                    var lastGroupTrTd1To7 = document.createElement('td'); lastGroupTrTd1To7.colSpan = 6; lastGroupTrTd1To7.className = "right"; lastGroupTrTd1To7.innerHTML = "<b>SUB TOTAL</b>"; lastGroupTr.appendChild(lastGroupTrTd1To7);
	                    var lastGroupTrTd8 = document.createElement('td'); lastGroupTrTd8.colSpan = 1; lastGroupTrTd8.className = "right"; lastGroupTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(group_Amount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd8);
	                    nTrs[i - 1].parentNode.insertBefore(lastGroupTr, nTrs[i - 1].nextSibling);
	                }
	            }
	        });
	    }
	    function renderTableCollectionBook() {
	        var ds = new Date($tab3DateStart);
	        var de = new Date($tab3DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var tableCollectionBook = $("#tableCollectionBook").dataTable({
	            "sAjaxSource": '/api/RepCollectionBook?tab3DateStart=' + DateStart + '&tab3DateEnd=' + DateEnd + '&tab3PeriodId=' + $tab3PeriodId + '&tab3BranchId=' + $tab3BranchId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepCollectionBookData",
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
                        { "mData": "Collection", "bVisible": false },
                        { "mData": "ORDate", "sWidth": "100px" },
                        { "mData": "Branch", "sWidth": "150px" },
                        { "mData": "Account", "sWidth": "200px" },
                        { "mData": "Article", "sWidth": "200px" },
                        { "mData": "Particulars" },
                        {
                            "mData": "DebitAmount", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        {
                            "mData": "CreditAmount", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }],
	            "fnDrawCallback": function (oSettings) {
	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                } else {
	                    var nTrs = $('#tableCollectionBook tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var group_DebitAmount = 0;
	                    var group_CreditAmount = 0;
	                    var total_DebitAmount = 0;
	                    var total_CreditAmount = 0;
	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Collection"];
	                        total_DebitAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                        total_CreditAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];
	                        if (sLastGroup == "") {
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.returnLink(sGroup) + '</b>', "GroupHeader", false);
	                            sLastGroup = sGroup;
	                            group_DebitAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                            group_CreditAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];
	                        } else {
	                            if (sGroup == sLastGroup) {
	                                group_DebitAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                                group_CreditAmount += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];
	                            } else {
	                                var groupTr = document.createElement('tr');
	                                var groupTrTd1To6 = document.createElement('td'); groupTrTd1To6.colSpan = 5; groupTrTd1To6.className = "right"; groupTrTd1To6.innerHTML = "<b>SUB TOTAL</b>"; groupTr.appendChild(groupTrTd1To6);
	                                var groupTrTd7 = document.createElement('td'); groupTrTd7.colSpan = 1; groupTrTd7.className = "right"; groupTrTd7.innerHTML = '<b>' + easyFIS.formatNumber(group_DebitAmount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd7);
	                                var groupTrTd8 = document.createElement('td'); groupTrTd8.colSpan = 1; groupTrTd8.className = "right"; groupTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(group_CreditAmount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd8);
	                                nTrs[i].parentNode.insertBefore(groupTr, nTrs[i]);

	                                insertTR(nTrs[i], iColspan, '<b>' + easyFIS.returnLink(sGroup) + '</b>', "GroupHeader", false);
	                                sLastGroup = sGroup;

	                                group_DebitAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["DebitAmount"];
	                                group_CreditAmount = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["CreditAmount"];
	                            }
	                        }
	                    }
	                    var totalTr = document.createElement('tr');
	                    var totalTrTd1To6 = document.createElement('td'); totalTrTd1To6.colSpan = 5; totalTrTd1To6.className = "right"; totalTrTd1To6.innerHTML = "<b>TOTAL</b>"; totalTr.appendChild(totalTrTd1To6);
	                    var totalTrTd7 = document.createElement('td'); totalTrTd7.colSpan = 1; totalTrTd7.className = "right"; totalTrTd7.innerHTML = '<b>' + easyFIS.formatNumber(total_DebitAmount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd7);
	                    var totalTrTd8 = document.createElement('td'); totalTrTd8.colSpan = 1; totalTrTd8.className = "right"; totalTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(total_CreditAmount, 2, ',', '.', '', '', '-', '') + '</b>'; totalTr.appendChild(totalTrTd8);
	                    nTrs[i - 1].parentNode.insertBefore(totalTr, nTrs[i - 1].nextSibling);

	                    var lastGroupTr = document.createElement('tr');
	                    var lastGroupTrTd1To6 = document.createElement('td'); lastGroupTrTd1To6.colSpan = 5; lastGroupTrTd1To6.className = "right"; lastGroupTrTd1To6.innerHTML = "<b>SUB TOTAL</b>"; lastGroupTr.appendChild(lastGroupTrTd1To6);
	                    var lastGroupTrTd7 = document.createElement('td'); lastGroupTrTd7.colSpan = 1; lastGroupTrTd7.className = "right"; lastGroupTrTd7.innerHTML = '<b>' + easyFIS.formatNumber(group_DebitAmount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd7);
	                    var lastGroupTrTd8 = document.createElement('td'); lastGroupTrTd8.colSpan = 1; lastGroupTrTd8.className = "right"; lastGroupTrTd8.innerHTML = '<b>' + easyFIS.formatNumber(group_CreditAmount, 2, ',', '.', '', '', '-', '') + '</b>'; lastGroupTr.appendChild(lastGroupTrTd8);
	                    nTrs[i - 1].parentNode.insertBefore(lastGroupTr, nTrs[i - 1].nextSibling);
	                }
	            }
	        });
	    }
	    // Initialized Tab
	    function initTab1() {
	        $tab1BranchId = easyFIS.getParameterByName("tab1BranchId");
	        $tab1Branch = easyFIS.getParameterByName("tab1Branch");
	        $tab1PeriodId = easyFIS.getParameterByName("tab1PeriodId");
	        $tab1Period = easyFIS.getParameterByName("tab1Period");
	        $tab1DateStart = easyFIS.getParameterByName("tab1DateStart");
	        $tab1DateEnd = easyFIS.getParameterByName("tab1DateEnd");

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
	        if ($tab1DateStart != "") {
	            $('#tab1DateStart').val($tab1DateStart);
	        } else {
	            $tab1DateStart = easyFIS.getCurrentDate();
	            $('#tab1DateStart').val($tab1DateStart);
	        }
	        if ($tab1DateEnd != "") {
	            $('#tab1DateEnd').val($tab1DateEnd);
	        } else {
	            $tab1DateEnd = easyFIS.getCurrentDate();
	            $('#tab1DateEnd').val($tab1DateEnd);
	        }
	    }
	    function initTab2() {
	        $tab2BranchId = easyFIS.getParameterByName("tab2BranchId");
	        $tab2Branch = easyFIS.getParameterByName("tab2Branch");
	        $tab2PeriodId = easyFIS.getParameterByName("tab2PeriodId");
	        $tab2Period = easyFIS.getParameterByName("tab2Period");
	        $tab2DateStart = easyFIS.getParameterByName("tab2DateStart");
	        $tab2DateEnd = easyFIS.getParameterByName("tab2DateEnd");

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
	        $tab3BranchId = easyFIS.getParameterByName("tab3BranchId");
	        $tab3Branch = easyFIS.getParameterByName("tab3Branch");
	        $tab3PeriodId = easyFIS.getParameterByName("tab3PeriodId");
	        $tab3Period = easyFIS.getParameterByName("tab3Period");
	        $tab3DateStart = easyFIS.getParameterByName("tab3DateStart");
	        $tab3DateEnd = easyFIS.getParameterByName("tab3DateEnd");

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
	    // Select2 Control
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
	                        companyId: $CurrentCompanyId
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
	                        searchTerm: term,
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
	                        companyId: $CurrentCompanyId
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
	                        companyId: $CurrentCompanyId
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
	    // Page load
	    $(document).ready(function () {
	        // Datepicker controls
	        $('#tab1DateStart').datepicker().on('changeDate', function (ev) {
	            $tab1DateStart = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab1DateEnd').datepicker().on('changeDate', function (ev) {
	            $tab1DateEnd = $(this).val();
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
	        // Select2 controls
	        Select2_tab1Branch();
	        Select2_tab1Period();
	        Select2_tab2Branch();
	        Select2_tab2Period();
	        Select2_tab3Branch();
	        Select2_tab3Period();
	        // Initialize tab
	        initTab1();
	        initTab2();
	        initTab3();
	        // Render table
	        renderTableCollectionSummary();
	        renderTableCollectionDetail();
	        renderTableCollectionBook();
	        // Default tab
	        if ($tab1BranchId > 0) $('#tab a[href="#tabCollectionSummary"]').tab('show');
	        if ($tab2BranchId > 0) $('#tab a[href="#tabCollectionDetail"]').tab('show');
	        if ($tab3BranchId > 0) $('#tab a[href="#tabCollectionBook"]').tab('show');
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

            <h2>Collection Report</h2>

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
              <a href="#tabCollectionSummary" class="btn" data-toggle="tab" id="tab1">Collection Summary</a>
              <a href="#tabCollectionDetail" class="btn" data-toggle="tab" id="tab2">Collection Detail</a>
              <a href="#tabCollectionBook" class="btn" data-toggle="tab" id="tab3">Collection Book</a>
            </div>

            <br />

            <br />

            <div class="tab-content">

                <div class="tab-pane active" id="tabCollectionSummary">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab1Branch" type="text" class="input-large"/>
                                </div>
                            </div>  
                            <div class="control-group">
                                <label class="control-label">Period </label>
                                <div class="controls">
                                    <input id="tab1Period" type="text" class="input-large"/>
                                </div>
                            </div>  
                            <div class="control-group">
                                <label class="control-label">Date Start </label>
                                <div class="controls">
                                    <input id="tab1DateStart" name="tab1DateStart" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date End </label>
                                <div class="controls">
                                    <input id="tab1DateEnd" name="tab1DateEnd" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewCollectionSummary" type="button" class="btn btn-primary" value="View" onclick="CmdViewCollectionSummary_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Collection Summary</h3>
                        <table id="tableCollectionSummary" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>OR Date</th>
                                    <th>OR No.</th>
                                    <th>Manual No.</th>
                                    <th>Customer</th>
                                    <th>Particulars</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyCollectionSummary"></tbody>
                            <tfoot id="tablefootCollectionSummary"></tfoot>
                        </table>
                    </div>
                </div>
                <div class="tab-pane" id="tabCollectionDetail">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab2Branch" type="text" class="input-large"/>
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
                            <input runat="server" id="CmdViewCollectionDetail" type="button" class="btn btn-primary" value="View" onclick="CmdViewCollectionDetail_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Collection Detail</h3>
                        <table id="tableCollectionDetail" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>Collection</th>
                                    <th>OR Date</th>
                                    <th>Account</th>
                                    <th>SI No.</th>
                                    <th>Particulars</th>
                                    <th>Pay Type</th>
                                    <th>Pay Details</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyCollectionDetail"></tbody>
                            <tfoot id="tablefootCollectionDetail"></tfoot>
                        </table>
                    </div>
                </div>
                <div class="tab-pane" id="tabCollectionBook">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab3Branch" type="text" class="input-large"/>
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
                            <input runat="server" id="CmdViewCollectionBook" type="button" class="btn btn-primary" value="View" onclick="CmdViewCollectionBook_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Collection Book</h3>
                        <table id="tableCollectionBook" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>Collection</th>
                                    <th>Journal Date</th>
                                    <th>Branch</th>
                                    <th>Account</th>
                                    <th>Article</th>
                                    <th>Particulars</th>
                                    <th>Debit Amount</th>
                                    <th>Credit Amount</th>
                                </tr>
                            </thead>
                            <tbody id="tablebodyCollectionBook"></tbody>
                            <tfoot id="tablefootCollectionBook"></tfoot>
                        </table>
                    </div>
                </div>

            </div>

        </div>
    </div>
</asp:Content>
