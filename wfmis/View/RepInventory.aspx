<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="RepInventory.aspx.cs" Inherits="wfmis.View.RepInventory" %>

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
	    // Inventory
	    var $tab1BranchId = 0;
	    var $tab1Branch = "";
	    var $tab1PeriodId = 0;
	    var $tab1Period = "";
	    var $tab1DateStart = easyFIS.getCurrentDate();
	    var $tab1DateEnd = easyFIS.getCurrentDate();
	    // Stock card
	    var $tab2BranchId = 0;
	    var $tab2Branch = "";
	    var $tab2PeriodId = 0;
	    var $tab2Period = "";
	    var $tab2DateStart = easyFIS.getCurrentDate();
	    var $tab2DateEnd = easyFIS.getCurrentDate();
	    var $tab2ItemId = 0;
	    var $tab2Item = "";
	    // Stock In
	    var $tab3BranchId = 0;
	    var $tab3Branch = "";
	    var $tab3PeriodId = 0;
	    var $tab3Period = "";
	    var $tab3DateStart = easyFIS.getCurrentDate();
	    var $tab3DateEnd = easyFIS.getCurrentDate();
	    // Stock Out
	    var $tab4BranchId = 0;
	    var $tab4Branch = "";
	    var $tab4PeriodId = 0;
	    var $tab4Period = "";
	    var $tab4DateStart = easyFIS.getCurrentDate();
	    var $tab4DateEnd = easyFIS.getCurrentDate();
	    // Stock Transfer
	    var $tab5BranchId = 0;
	    var $tab5Branch = "";
	    var $tab5PeriodId = 0;
	    var $tab5Period = "";
	    var $tab5DateStart = easyFIS.getCurrentDate();
	    var $tab5DateEnd = easyFIS.getCurrentDate();
	    // Inventory Book
	    var $tab6BranchId = 0;
	    var $tab6Branch = "";
	    var $tab6PeriodId = 0;
	    var $tab6Period = "";
	    var $tab6DateStart = easyFIS.getCurrentDate();
	    var $tab6DateEnd = easyFIS.getCurrentDate();
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
	        $tab2ItemId = easyFIS.getParameterByName("tab2ItemId");
	        $tab2Item = easyFIS.getParameterByName("tab2Item");

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
	        if ($tab2ItemId != "") {
	            $('#tab2Item').select2('data', { id: $tab2ItemId, text: $tab2Item });
	        } else {
	            $('#tab2Item').select2('data', { id: 0, text: "" });
	            $tab2ItemId = 0;
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
	    function initTab4() {
	        $tab4BranchId = easyFIS.getParameterByName("tab4BranchId");
	        $tab4Branch = easyFIS.getParameterByName("tab4Branch");
	        $tab4PeriodId = easyFIS.getParameterByName("tab4PeriodId");
	        $tab4Period = easyFIS.getParameterByName("tab4Period");
	        $tab4DateStart = easyFIS.getParameterByName("tab4DateStart");
	        $tab4DateEnd = easyFIS.getParameterByName("tab4DateEnd");

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
	        $tab5BranchId = easyFIS.getParameterByName("tab5BranchId");
	        $tab5Branch = easyFIS.getParameterByName("tab5Branch");
	        $tab5PeriodId = easyFIS.getParameterByName("tab5PeriodId");
	        $tab5Period = easyFIS.getParameterByName("tab5Period");
	        $tab5DateStart = easyFIS.getParameterByName("tab5DateStart");
	        $tab5DateEnd = easyFIS.getParameterByName("tab5DateEnd");

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
	    function initTab6() {
	        $tab6BranchId = easyFIS.getParameterByName("tab6BranchId");
	        $tab6Branch = easyFIS.getParameterByName("tab6Branch");
	        $tab6PeriodId = easyFIS.getParameterByName("tab6PeriodId");
	        $tab6Period = easyFIS.getParameterByName("tab6Period");
	        $tab6DateStart = easyFIS.getParameterByName("tab6DateStart");
	        $tab6DateEnd = easyFIS.getParameterByName("tab6DateEnd");

	        if ($tab6BranchId != "") {
	            $('#tab6Branch').select2('data', { id: $tab6BranchId, text: $tab6Branch });
	        } else {
	            $('#tab6Branch').select2('data', { id: 0, text: "" });
	            $tab6BranchId = 0;
	        }
	        if ($tab6PeriodId != "") {
	            $('#tab6Period').select2('data', { id: $tab6PeriodId, text: $tab6Period });
	        } else {
	            $('#tab6Period').select2('data', { id: 0, text: "" });
	            $tab6PeriodId = 0;
	        }
	        if ($tab6DateStart != "") {
	            $('#tab6DateStart').val($tab6DateStart);
	        } else {
	            $tab6DateStart = easyFIS.getCurrentDate();
	            $('#tab6DateStart').val($tab6DateStart);
	        }
	        if ($tab6DateEnd != "") {
	            $('#tab6DateEnd').val($tab6DateEnd);
	        } else {
	            $tab6DateEnd = easyFIS.getCurrentDate();
	            $('#tab6DateEnd').val($tab6DateEnd);
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
	    function Select2_tab2Item() {
	        $('#tab2Item').select2({
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
	                        pageSize: $pageSize,
	                        pageNum: page,
	                        searchTerm: term,
	                        IsInventory: true
	                    };
	                },
	                results: function (data, page) {
	                    var more = (page * $pageSize) < data.Total;
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
	            $tab2ItemId = $('#tab2Item').select2('data').id;

	            var JSONObject = JSON.parse($('#tab2Item').select2('data').text);
	            $tab2Item = JSONObject["Item"];
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
	                        companyId: $CurrentCompanyId
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
	                        companyId: $CurrentCompanyId
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
	    function Select2_tab6Branch() {
	        $('#tab6Branch').select2({
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
	            $tab6BranchId = $('#tab6Branch').select2('data').id;
	            $tab6Branch = $('#tab6Branch').select2('data').text;
	        });
	    }
	    function Select2_tab6Period() {
	        $('#tab6Period').select2({
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
	            $tab6PeriodId = $('#tab6Period').select2('data').id;
	            $tab6Period = $('#tab6Period').select2('data').text;
	        });
	    }
	    // Events
	    function CmdViewInventory_onclick() {
	        location.href = 'RepInventory.aspx?tab1BranchId=' + $tab1BranchId + '&' +
                                              'tab1Branch=' + $tab1Branch + '&' +
                                              'tab1PeriodId=' + $tab1PeriodId + '&' +
                                              'tab1Period=' + $tab1Period + '&' +
                                              'tab1DateStart=' + $tab1DateStart + '&' +
	                                          'tab1DateEnd=' + $tab1DateEnd;
	    }
	    function CmdViewStockCard_onclick() {
	        location.href = 'RepInventory.aspx?tab2BranchId=' + $tab2BranchId + '&' +
                                              'tab2Branch=' + $tab2Branch + '&' +
                                              'tab2PeriodId=' + $tab2PeriodId + '&' +
                                              'tab2Period=' + $tab2Period + '&' +
                                              'tab2DateStart=' + $tab2DateStart + '&' +
	                                          'tab2DateEnd=' + $tab2DateEnd + '&' + 
	                                          'tab2ItemId=' + $tab2ItemId + '&' + 
	                                          'tab2Item=' + $tab2Item;
	    }
	    function CmdViewStockIn_onclick() {
	        location.href = 'RepInventory.aspx?tab3BranchId=' + $tab3BranchId + '&' +
                                              'tab3Branch=' + $tab3Branch + '&' +
                                              'tab3PeriodId=' + $tab3PeriodId + '&' +
                                              'tab3Period=' + $tab3Period + '&' +
                                              'tab3DateStart=' + $tab3DateStart + '&' +
	                                          'tab3DateEnd=' + $tab3DateEnd;
	    }
	    function CmdViewStockOut_onclick() {
	        location.href = 'RepInventory.aspx?tab4BranchId=' + $tab4BranchId + '&' +
                                              'tab4Branch=' + $tab4Branch + '&' +
                                              'tab4PeriodId=' + $tab4PeriodId + '&' +
                                              'tab4Period=' + $tab4Period + '&' +
                                              'tab4DateStart=' + $tab4DateStart + '&' +
	                                          'tab4DateEnd=' + $tab4DateEnd;
	    }
	    function CmdViewStockTransfer_onclick() {
	        location.href = 'RepInventory.aspx?tab5BranchId=' + $tab5BranchId + '&' +
                                              'tab5Branch=' + $tab5Branch + '&' +
                                              'tab5PeriodId=' + $tab5PeriodId + '&' +
                                              'tab5Period=' + $tab5Period + '&' +
                                              'tab5DateStart=' + $tab5DateStart + '&' +
	                                          'tab5DateEnd=' + $tab5DateEnd;
	    }
	    function CmdViewInventoryBook_onclick() {
	        location.href = 'RepInventory.aspx?tab6BranchId=' + $tab6BranchId + '&' +
                                              'tab6Branch=' + $tab6Branch + '&' +
                                              'tab6PeriodId=' + $tab6PeriodId + '&' +
                                              'tab6Period=' + $tab6Period + '&' +
                                              'tab6DateStart=' + $tab6DateStart + '&' +
	                                          'tab6DateEnd=' + $tab6DateEnd;
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
	    function RenderInventoryTable() {
	        var ds = new Date($tab1DateStart);
	        var de = new Date($tab1DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();
	        var tableInventory = $("#tableInventory").dataTable({
	                                    "sAjaxSource": '/api/RepInventory?tab1DateStart=' + DateStart + '&tab1DateEnd=' + DateEnd + '&tab1PeriodId=' + $tab1PeriodId + '&tab1BranchId=' + $tab1BranchId,
	                                    "bPaginate": false,
	                                    "sAjaxDataProp": "RepInventoryData",
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
                                                    "mData": "Item", "sWidth": "400px",
                                                    "mRender": function (data) {
                                                        var n = data.indexOf("-");
                                                        var ItemId = data.substring(0, n - 1);
                                                        var Item = data.substring(n + 2, data.length);
                                                        return '<a href="RepInventory.aspx?tab2BranchId=' + $tab1BranchId + '&' +
                                                                                          'tab2Branch=' + $tab1Branch + '&' +
                                                                                          'tab2PeriodId=' + $tab1PeriodId + '&' +
                                                                                          'tab2Period=' + $tab1Period + '&' +
                                                                                          'tab2DateStart=' + $tab1DateStart + '&' +
                                                                                          'tab2DateEnd=' + $tab1DateEnd + '&' +
                                                                                          'tab2ItemId=' + ItemId + '&' +
                                                                                          'tab2Item=' + Item + '">' + Item + '</a>'
                                                    }
                                                },
                                                { "mData": "Unit", "sWidth": "100px" },
                                                {
                                                    "mData": "BeginningQuantity", "sWidth": "200px", "sClass": "right",
                                                    "mRender": function (data) {
                                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                    }
                                                },
	                                            {
	                                                "mData": "TotalQuantityIn", "sWidth": "200px", "sClass": "right",
	                                                "mRender": function (data) {
	                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
	                                                }
	                                            },
                                                {
                                                    "mData": "TotalQuantityOut", "sWidth": "200px", "sClass": "right",
                                                    "mRender": function (data) {
                                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                    }
                                                },
                                                {
                                                    "mData": "EndingQuantity", "sWidth": "200px", "sClass": "right",
                                                    "mRender": function (data) {
                                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                    }
                                                }]
	                            });
	    }
	    function RenderStockCardTable() {
	        var ds = new Date($tab2DateStart);
	        var de = new Date($tab2DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();
	        var tableStockCard = $("#tableStockCard").dataTable({
	                                    "sAjaxSource": '/api/RepStockCard?tab2DateStart=' + DateStart + '&tab2DateEnd=' + DateEnd + '&tab2PeriodId=' + $tab2PeriodId + '&tab2BranchId=' + $tab2BranchId + '&tab2ItemId=' + $tab2ItemId,
	                                    "bPaginate": false,
	                                    "sAjaxDataProp": "RepStockCardData",
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
                                                { "mData": "InventoryDate", "sWidth": "150px" },
                                                {
                                                    "mData": "InventoryDocument", "sWidth": "150px",
                                                    "mRender": function (data) {
                                                        var n = data.indexOf(")");
                                                        if (n > 0) {
                                                            var Link = data.substring(1, n);
                                                            var DocumentNumber = data.substring(n + 1, data.length);
                                                            return '<a href="' + Link + '">' + DocumentNumber + '</a>';
                                                        } else {
                                                            return data;
                                                        }
	                                                }
                                                },
                                                { "mData": "Item", "sWidth": "400px" },
                                                { "mData": "InventoryNumber", "sWidth": "150px" },
                                                { "mData": "Unit", "sWidth": "100px" },
                                                {
                                                    "mData": "QuantityIn", "sWidth": "100px", "sClass": "right",
                                                    "mRender": function (data) {
                                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                    }
                                                },
                                                {
                                                    "mData": "QuantityOut", "sWidth": "100px", "sClass": "right",
                                                    "mRender": function (data) {
                                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                    }
                                                },
                                                {
                                                    "mData": "Quantity", "sWidth": "100px", "sClass": "right",
                                                    "mRender": function (data) {
                                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                    }
                                                }],
	                                    "fnDrawCallback": function (oSettings) {
	                                        if (oSettings.aiDisplay.length == 0) {
	                                            return;
	                                        } else {
	                                            var nTrs = $('#tableStockCard tbody tr');
	                                            var iColspan = nTrs[0].getElementsByTagName('td').length;

	                                            var TotalQuantity = 0;
	                                            for (var i = 0; i < nTrs.length; i++) {
	                                                var iDisplayIndex = oSettings._iDisplayStart + i;
	                                                TotalQuantity += oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["Quantity"];
	                                            }

	                                            insertTR(nTrs[i - 1], iColspan, '<b>' + easyFIS.formatNumber(TotalQuantity, 2, ',', '.', '', '', '-', '') + '</b>', "right", true);
	                                        }
	                                    }
	                                });
	    }
	    function RenderStockInTable() {
	        var ds = new Date($tab3DateStart);
	        var de = new Date($tab3DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var StockInDetailTable = $("#StockInDetailTable").dataTable({
	            "sAjaxSource": '/api/RepStockIn?tab3DateStart=' + DateStart + '&tab3DateEnd=' + DateEnd + '&tab3PeriodId=' + $tab3PeriodId + '&tab3BranchId=' + $tab3BranchId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepStockInData",
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
                            "mData": "StockIn", "bVisible": false,
                            "mRender": function (data) {
                                return easyFIS.returnLink(data);
                            }
                        },
                        { "mData": "INDate", "sWidth": "100px" },
                        {
                            "mData": "Quantity", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        { "mData": "Unit", "sWidth": "100px" },
                        { "mData": "Item", "sWidth": "300px" },
                        { "mData": "Particulars" },
                        {
                            "mData": "Cost", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
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
	                    var nTrs = $('#StockInDetailTable tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var group_Amount = 0;
	                    var total_Amount = 0;
	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["StockIn"];
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
	    function RenderStockOutTable() {
	        var ds = new Date($tab4DateStart);
	        var de = new Date($tab4DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var StockOutDetailTable = $("#StockOutDetailTable").dataTable({
	            "sAjaxSource": '/api/RepStockOut?tab4DateStart=' + DateStart + '&tab4DateEnd=' + DateEnd + '&tab4PeriodId=' + $tab4PeriodId + '&tab4BranchId=' + $tab4BranchId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepStockOutData",
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
                            "mData": "StockOut", "bVisible": false,
                            "mRender": function (data) {
                                return easyFIS.returnLink(data);
                            }
                        },
                        { "mData": "OTDate", "sWidth": "100px" },
                        {
                            "mData": "Quantity", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        { "mData": "Unit", "sWidth": "100px" },
                        { "mData": "Item", "sWidth": "300px" },
                        { "mData": "Particulars" },
                        {
                            "mData": "Cost", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
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
	                    var nTrs = $('#StockOutDetailTable tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var group_Amount = 0;
	                    var total_Amount = 0;
	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["StockOut"];
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
	    function RenderStockTransferTable() {
	        var ds = new Date($tab5DateStart);
	        var de = new Date($tab5DateEnd);
	        var DateStart = ds.getFullYear() + "-" + (ds.getMonth() + 1) + "-" + ds.getDate();
	        var DateEnd = de.getFullYear() + "-" + (de.getMonth() + 1) + "-" + de.getDate();

	        var StockTransferDetailTable = $("#StockTransferDetailTable").dataTable({
	            "sAjaxSource": '/api/RepStockTransfer?tab5DateStart=' + DateStart + '&tab5DateEnd=' + DateEnd + '&tab5PeriodId=' + $tab5PeriodId + '&tab5BranchId=' + $tab5BranchId,
	            "bPaginate": false,
	            "sAjaxDataProp": "RepStockTransferData",
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
                            "mData": "StockTransfer", "bVisible": false,
                            "mRender": function (data) {
                                return easyFIS.returnLink(data);
                            }
                        },
                        { "mData": "STDate", "sWidth": "100px" },
                        {
                            "mData": "Quantity", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
                        { "mData": "Unit", "sWidth": "100px" },
                        { "mData": "Item", "sWidth": "300px" },
                        { "mData": "Particulars" },
                        {
                            "mData": "Cost", "sWidth": "100px", "sClass": "right",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        },
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
	                    var nTrs = $('#StockTransferDetailTable tbody tr');
	                    var iColspan = nTrs[0].getElementsByTagName('td').length;
	                    var sLastGroup = "";
	                    var group_Amount = 0;
	                    var total_Amount = 0;
	                    for (var i = 0; i < nTrs.length; i++) {
	                        var iDisplayIndex = oSettings._iDisplayStart + i;
	                        var sGroup = oSettings.aoData[oSettings.aiDisplay[iDisplayIndex]]._aData["StockTransfer"];
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
	    function RenderInventoryBookTable() {
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
	        $('#tab6DateStart').datepicker().on('changeDate', function (ev) {
	            $tab6DateStart = $(this).val();
	            $(this).datepicker('hide');
	        });
	        $('#tab6DateEnd').datepicker().on('changeDate', function (ev) {
	            $tab6DateEnd = $(this).val();
	            $(this).datepicker('hide');
	        });
	        // Select2 controls
	        Select2_tab1Branch();
	        Select2_tab1Period();
	        Select2_tab2Branch();
	        Select2_tab2Period();
	        Select2_tab2Item();
	        Select2_tab3Branch();
	        Select2_tab3Period();
	        Select2_tab4Branch();
	        Select2_tab4Period();
	        Select2_tab5Branch();
	        Select2_tab5Period();
	        Select2_tab6Branch();
	        Select2_tab6Period();
	        // Initialize tab
	        initTab1();
	        initTab2();
	        initTab3();
	        initTab4();
	        initTab5();
	        initTab6();
	        // Default tab
	        if ($tab1BranchId > 0) {
	            $('#tab a[href="#tabInventory"]').tab('show');
	            RenderInventoryTable();
	        }
	        if ($tab2BranchId > 0) {
	            $('#tab a[href="#tabStockCard"]').tab('show');
	            RenderStockCardTable();
	        }
	        if ($tab3BranchId > 0) {
	            $('#tab a[href="#tabStockIn"]').tab('show');
	            RenderStockInTable();
	        }
	        if ($tab4BranchId > 0) {
	            $('#tab a[href="#tabStockOut"]').tab('show');
	            RenderStockOutTable();
	        }
	        if ($tab5BranchId > 0) {
	            $('#tab a[href="#tabStockTransfer"]').tab('show');
	            RenderStockTransferTable();
	        }
	        if ($tab6BranchId > 0) {
	            $('#tab a[href="#tabInventoryBook"]').tab('show');
	            RenderInventoryBookTable();
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
            <h2>Inventory Report</h2>

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
                <a href="#tabInventory" class="btn" data-toggle="tab" id="tab1">Inventory</a>
                <a href="#tabStockCard" class="btn" data-toggle="tab" id="tab2">Stock Card</a>
                <a href="#tabStockIn" class="btn" data-toggle="tab" id="tab3">Stock In</a>
                <a href="#tabStockOut" class="btn" data-toggle="tab" id="tab4">Stock Out</a>
                <a href="#tabStockTransfer" class="btn" data-toggle="tab" id="tab5">Stock Transfer</a>
                <a href="#tabInventoryBook" class="btn" data-toggle="tab" id="tab6">Inventory Book</a>
            </div>

            <br />

            <br />

            <div class="tab-content">

                <div class="tab-pane active" id="tabInventory">
                    <div class="row-fluid">
                        <div class="span6">
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
                            <input runat="server" id="CmdViewInventory" type="button" class="btn btn-primary" value="View" onclick="CmdViewInventory_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Inventory</h3>
                        <table id="tableInventory" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Unit</th>
                                    <th>Beginning Quantity</th>
                                    <th>Total Quantity In</th>
                                    <th>Total Quantity Out</th>
                                    <th>Ending Quantity</th>
                                </tr>
                            </thead>
                            <tbody id="tableBodyInventory"></tbody>
                            <tfoot id="tableFootInventory"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabStockCard">
                    <div class="row-fluid">
                        <div class="span6">
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
                            <div class="control-group">
                                <label class="control-label">Item </label>
                                <div class="controls">
                                    <input id="tab2Item" type="text" class="input-xxlarge"/>
                                </div>
                            </div>  
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewStockCard" type="button" class="btn btn-primary" value="View" onclick="CmdViewStockCard_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Stock Card</h3>
                        <table id="tableStockCard" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Inventory Doc.</th>
                                    <th>Item</th>
                                    <th>Inventory No.</th>
                                    <th>Unit</th>
                                    <th>Quantity In</th>
                                    <th>Quantity Out</th>
                                    <th>Quantity</th>
                                </tr>
                            </thead>
                            <tbody id="tableBodyStockCard"></tbody>
                            <tfoot id="tableFootStockCard"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabStockIn">
                    <div class="row-fluid">
                        <div class="span6">
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
                            <input runat="server" id="CmdStockIn" type="button" class="btn btn-primary" value="View" onclick="CmdViewStockIn_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Stock-In Detail</h3>
                        <table id="StockInDetailTable" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>StockIn</th>
                                    <th>IN No.</th>
                                    <th>Quantity</th>
                                    <th>Unit</th>
                                    <th>Item</th>
                                    <th>Particulars</th>
                                    <th>Cost</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="StockInDetailTableBody"></tbody>
                            <tfoot id="StockInDetailTableFoot"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabStockOut">
                    <div class="row-fluid">
                        <div class="span6">
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
                            <input runat="server" id="CmdViewStockOut" type="button" class="btn btn-primary" value="View" onclick="CmdViewStockOut_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Stock-Out Detail</h3>
                        <table id="StockOutDetailTable" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>StockOut</th>
                                    <th>OUT No.</th>
                                    <th>Quantity</th>
                                    <th>Unit</th>
                                    <th>Item</th>
                                    <th>Particulars</th>
                                    <th>Cost</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="StockOutDetailTableBody"></tbody>
                            <tfoot id="StockOutDetailTableFoot"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabStockTransfer">
                    <div class="row-fluid">
                        <div class="span6">
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
                            <input runat="server" id="CmdViewStockTransfer"  type="button" class="btn btn-primary" value="View" onclick="CmdViewStockTransfer_onclick()"/>
                        </div>
                    </div>
                    <div>
                        <h3 class="text-center">Stock-Transfer Detail</h3>
                        <table id="StockTransferDetailTable" class="table table-striped table-condensed" >
                            <thead>
                                <tr>
                                    <th>StockTransfer</th>
                                    <th>ST No.</th>
                                    <th>Quantity</th>
                                    <th>Unit</th>
                                    <th>Item</th>
                                    <th>Particulars</th>
                                    <th>Cost</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody id="StockTransferDetailTableBody"></tbody>
                            <tfoot id="StockTransferDetailTableFoot"></tfoot>
                        </table>
                    </div>
                </div>

                <div class="tab-pane" id="tabInventoryBook">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Branch </label>
                                <div class="controls">
                                    <input id="tab6Branch" type="text" class="input-xxlarge"/>
                                </div>
                            </div>  
                            <div class="control-group">
                                <label class="control-label">Period </label>
                                <div class="controls">
                                    <input id="tab6Period" type="text" class="input-large"/>
                                </div>
                            </div>  
                            <div class="control-group">
                                <label class="control-label">Date Start </label>
                                <div class="controls">
                                    <input id="tab6DateStart" name="tab6DateStart" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date End </label>
                                <div class="controls">
                                    <input id="tab6DateEnd" name="tab6DateEnd" type="text" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6 text-right">
                            <input runat="server" id="CmdViewInventoryBook" type="button" class="btn btn-primary" value="View" onclick="CmdViewInventoryBook_onclick()"/>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</asp:Content>
