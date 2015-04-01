<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="RepFinancialStatement.aspx.cs" Inherits="wfmis.View.RepFinancialStatement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Date Picker--%>
    <link href="../Content/bootstrap-datepicker/datepicker.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-datepicker/bootstrap-datepicker.js"></script>
    <%--Select2--%>
    <link href="../Content/bootstrap-select2/select2.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-select2/select2.js"></script>
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/report_datatable.css" rel="stylesheet" />
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v2.js"></script>
    <%--Page--%>
	<script type="text/javascript" charset="utf-8">
	    var $CompanyId = 0;
	    var $Company = "";
	    var $PeriodId = 0;
	    var $Period = "";
	    var $AsOfDate = easyFIS.getCurrentDate();

        // Insert TR Element
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
        // Initialized page controls
	    function initPage() {
	        $CompanyId = easyFIS.getParameterByName("CompanyId");
	        $Company = easyFIS.getParameterByName("Company");
	        $PeriodId = easyFIS.getParameterByName("PeriodId");
	        $Period = easyFIS.getParameterByName("Period");
	        $AsOfDate = easyFIS.getParameterByName("AsOfDate");

	        if ($CompanyId != "") {
	            $('#Company').select2('data', { id: $CompanyId, text: $Company });
	        } else {
	            $('#Company').select2('data', { id: 0, text: "" });
	            $CompanyId = 0;
	        }
	        if ($PeriodId != "") {
	            $('#Period').select2('data', { id: $PeriodId, text: $Period });
	        } else {
	            $('#Period').select2('data', { id: 0, text: "" });
	            $PeriodId = 0;
	        }
	        if ($AsOfDate != "") {
	            $('#AsOfDate').val($AsOfDate);
	        } else {
	            $AsOfDate = easyFIS.getCurrentDate();
	            $('#AsOfDate').val($AsOfDate);
	        }
	    }
        // Clicked events
	    function CmdViewBalanceSheet_onclick() {
	        location.href = 'RepFinancialStatement.aspx?CompanyId=' + $CompanyId + '&' +
                                                       'Company=' + $Company + '&' +
                                                       'PeriodId=' + $PeriodId + '&' +
                                                       'Period=' + $Period + '&' + 
                                                       'AsOfDate=' + $AsOfDate;
	    }
        // Page load
	    $(document).ready(function () {
	        var pageSize = 20;
	        var tableBalanceSheet;

	        // Balance Sheet DateAsOf Picker
	        $('#AsOfDate').datepicker().on('changeDate', function (ev) {
	            $AsOfDate = $(this).val();
	            $(this).datepicker('hide');
	        });

	        // Balance Sheet Company Select
	        $('#Company').select2({
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
	                        pageSize: pageSize,
	                        pageNum: page,
	                        searchTerm: term
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * pageSize) < data.Total;
	                    return { results: data.Results, more: more };
	                }
	            }
	        }).change(function () {
	            $CompanyId = $('#Company').select2('data').id;
	            $Company = $('#Company').select2('data').text;
	        });

	        // Balance Sheet Period Select
	        $('#Period').select2({
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
	                        pageSize: pageSize,
	                        pageNum: page,
	                        searchTerm: term
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * pageSize) < data.Total;
	                    return { results: data.Results, more: more };
	                }
	            }
	        }).change(function () {
	            $PeriodId = $('#Period').select2('data').id;
	            $Period = $('#Period').select2('data').text;
	        });

            // Initialize page controls
	        initPage();

	        // Render Balance Sheet Table
	        var d = new Date($AsOfDate);
	        AsOfDate = d.getFullYear() + "-" + (d.getMonth()+1) + "-" + d.getDate();
	        tableBalanceSheet = $("#tableBalanceSheet").dataTable({
	            "sAjaxSource": '/api/RepFSBalanceSheet?AsOfDate=' + AsOfDate + '&PeriodId=' + $PeriodId + '&CompanyId=' + $CompanyId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepFSBalanceSheetData",
	            "bLengthChange": false,
	            "aoColumns": [
                        { "mData": "AccountCategory", "bVisible": false },
                        { "mData": "AccountType", "sWidth": "150px", "bSortable": false, },
                        { "mData": "Account", "bSortable": false, },
                        {
                            "mData": "Amount", "sWidth": "150px", "sClass": "alignRight", "bSortable": false,
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        { "mData": "LEAmount", "bVisible": false }],
	            "fnDrawCallback": function (oSettings) {

	                if (oSettings.aiDisplay.length == 0) {
	                    return;
	                }

	                var nTrs = $('#tableBalanceSheet tbody tr');
	                var iColspan = nTrs[0].getElementsByTagName('td').length;
	                var sLastGroup = "";
	                var summed_balances = 0;
	                var summed_lebalances = 0;

	                for (var i = 0; i < nTrs.length; i++) {
	                    var iDisplayIndex = oSettings._iDisplayStart + i;
	                    var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["AccountCategory"];

	                    summed_lebalances += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["LEAmount"];

	                    if (sLastGroup == "") {
	                        insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader",false);
	                        summed_balances += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                        sLastGroup = sGroup;
	                    } else {
	                        if (sGroup == sLastGroup) {
	                            summed_balances += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                        } else {
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_balances, 2, ',', '.', '', '', '-', '') + '</b>', "alignRight",false);
	                            insertTR(nTrs[i], iColspan, '<b>' + sGroup + '</b>', "GroupHeader",false);
	                            summed_balances = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Amount"];
	                            sLastGroup = sGroup;
	                        }

	                        if (i == (nTrs.length - 1)) {
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_lebalances, 2, ',', '.', '', '', '-', '') + '</b>', "alignRight",true);
	                            insertTR(nTrs[i], iColspan, '<b>' + easyFIS.formatNumber(summed_balances, 2, ',', '.', '', '', '-', '') + '</b>', "alignRight", true);
	                        }
	                    }
	                }


	            }
	        });
   
	    });
    
        </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">

            <h2>Financial Statements</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div id="tab" class="btn-group" data-toggle="buttons-radio">
              <a href="#tabBalanceSheet" class="btn" data-toggle="tab" id="tab1">Balance Sheet</a>
              <a href="#tabProfitAndLoss" class="btn" data-toggle="tab" id="tab2">Profit and Loss</a>
              <a href="#tabTrialBalance" class="btn" data-toggle="tab" id="tab3">Trial Balance</a>
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
                                <input id="Company" type="text" class="input-large"/>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Period </label>
                            <div class="controls">
                                <input id="Period" type="text" class="input-large"/>
                            </div>
                        </div>                    
                        <div class="control-group">
                            <label class="control-label">As of date </label>
                            <div class="controls">
                                <input id="AsOfDate" name="AsOfDate" type="text" class="input-medium" />
                            </div>
                        </div>
                    </div>
                    <div class="span6 text-right">
                        <button type="button" class="btn btn-primary" onclick="CmdViewBalanceSheet_onclick()">View</button>
                    </div>
                </div>
                <div>
                    <h3 class="text-center">Balance Sheet</h3>
                    <table id="tableBalanceSheet" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th>Category</th>
                                <th>Type</th>
                                <th>Account</th>
                                <th>Balance</th>
                                <th>LEBalance</th>
                            </tr>
                        </thead>
                        <tbody id="tablebodyBalanceSheet"></tbody>
                        <tfoot id="tablefootBalanceSheet"></tfoot>
                    </table>
                </div>
              </div>

              <div class="tab-pane" id="tabProfitAndLoss">
              </div>

              <div class="tab-pane" id="tabTrialBalance">
              </div>

            </div>

        </div>
    </div>
</asp:Content>
