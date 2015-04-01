<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="RepAccountsPayable.aspx.cs" Inherits="wfmis.View.RepAccountsPayable" %>

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

	    // Click events
	    function cmdViewAccountsPayable_onclick() {
	        location.href = 'RepAccountsPayable.aspx?tab1CompanyId=' + $tab1CompanyId + '&' +
                                                    'tab1Company=' + $tab1Company + '&' +
                                                    'tab1PeriodId=' + $tab1PeriodId + '&' +
                                                    'tab1Period=' + $tab1Period + '&' +
                                                    'tab1AsOfDate=' + $tab1AsOfDate;
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
	    function renderTableAccountsPayable() {
	        var d = new Date($tab1AsOfDate);
	        var formattedAsOfDate = d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();

	        var tableAccountsPayable = $("#tableAccountsPayable").dataTable({
	            "sAjaxSource": '/api/RepAccountsPayable?tab1AsOfDate=' + formattedAsOfDate + '&tab1PeriodId=' + $tab1PeriodId + '&tab1CompanyId=' + $tab1CompanyId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepAccountsPayableData",
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
                        { "mData": "Supplier", "bVisible": false },
                        {
                            "mData": "PINumber", "sWidth": "100px", "bSortable": false,
                            "mRender": function (data) {
                                var n = data.indexOf("-");
                                var PIId = data.substring(0, n - 1);
                                var PINumber = data.substring(n + 2, data.length);
                                return '<a href="TrnPurchaseInvoiceDetail.aspx?Id=' + PIId + '">' + PINumber + '</a>'
                            }
                        },
                        { "mData": "PIDate", "sWidth": "100px", "bSortable": false, },
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

	                var nTrs = $('#tableAccountsPayable tbody tr');
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
	                    var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Supplier"];

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
	                            var groupTrTd7 = document.createElement('td'); groupTrTd7.colSpan = 1; groupTrTd7.className = "right"; groupTrTd7.innerHTML =  '<b>' + easyFIS.formatNumber(groupCurrentAmount, 2, ',', '.', '', '', '-', '') + '</b>'; groupTr.appendChild(groupTrTd7);
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

            // Initialized tab1
	        initTab1();

            // Render table
	        renderTableAccountsPayable();
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

            <h2>Accounts Payable</h2>

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
                      <a href="#tabAccountsPayable" class="btn" data-toggle="tab" id="tab1">Accounts Payable</a>
                    </div>
                </div>

                <div class="span12">
                    
                    <div class="tab-content">
                        
                        <div class="tab-pane active" id="tabAccountsPayable">

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
                                            <input id="tab1AsOfDate" name="AsOfDate" type="text" class="input-medium" />
                                        </div>
                                    </div>
                                </div>
                                <div class="span6 text-right">
                                    <input runat="server" id="CmdViewAccountsPayable" type="button" class="btn btn-primary" value="View" onclick="cmdViewAccountsPayable_onclick()" />
                                </div>
                            </div>

                            <div>
                                <h3 class="text-center">Accounts Payable</h3>
                                <table id="tableAccountsPayable" class="table table-striped table-condensed" >
                                    <thead>
                                        <tr>
                                            <th>Supplier</th>
                                            <th>PI Number</th>
                                            <th>PI Date</th>
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
                                    <tbody id="tablebodyAccountsPayable"></tbody>
                                    <tfoot id="tablefootAccountsPayable"></tfoot>
                                </table>
                             </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>
    </div>

</asp:Content>
