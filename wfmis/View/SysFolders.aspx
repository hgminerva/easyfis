<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="SysFolders.aspx.cs" Inherits="wfmis.View.SysFolders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        // Render Table
        function RenderTableUnit() {
            $("#TableUnit").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstUnit',
                "sAjaxDataProp": "MstUnitData",
                "bProcessing": true,
                "bLengthChange": false,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdEditUnit" type="button" class="btn btn-primary" value="Edit"/>'
                                    }
                                },
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdDeleteUnit" type="button" class="btn btn-danger" value="Delete"/>'
                                    }
                                },
                                { "mData": "Unit" }]
            }).fnSort([[2, 'asc']]);
        }
        function RenderTableTax() {
            $("#TableTax").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstTax',
                "sAjaxDataProp": "MstTaxData",
                "bProcessing": true,
                "bLengthChange": false,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdEditTax" type="button" class="btn btn-primary" value="Edit"/>'
                                    }
                                },
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdDeleteTax" type="button" class="btn btn-danger" value="Delete"/>'
                                    }
                                },
                                { "mData": "TaxCode", "sWidth": "300px" },
                                {
                                    "mData": "TaxRate", "sWidth": "200px", "sClass": "alignRight",
                                    "mRender": function (data) {
                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                    }
                                },
                                { "mData": "Account" }]
            }).fnSort([[2, 'asc']]);
        }
        function RenderTableBank() {
            $("#TableBank").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstArticleBank',
                "sAjaxDataProp": "MstArticleBankData",
                "bProcessing": true,
                "bLengthChange": false,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdEditBank" type="button" class="btn btn-primary" value="Edit"/>'
                                    }
                                },
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdDeleteBank" type="button" class="btn btn-danger" value="Delete"/>'
                                    }
                                },
                                { "mData": "BankCode", "sWidth": "150px" },
                                { "mData": "Bank", "sWidth": "300px" },
                                { "mData": "Particulars" }]
            }).fnSort([[2, 'asc']]);
        }
        function RenderTableTerm() {
            $("#TableTerm").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstTerm',
                "sAjaxDataProp": "MstTermData",
                "bProcessing": true,
                "bLengthChange": false,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdEditTerm" type="button" class="btn btn-primary" value="Edit"/>'
                                    }
                                },
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdDeleteTerm" type="button" class="btn btn-danger" value="Delete"/>'
                                    }
                                },
                                { "mData": "Term"},
                                {
                                    "mData": "NumberOfDays", "sWidth": "200px", "sClass": "alignRight",
                                    "mRender": function (data) {
                                        return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                    }
                                }]
            }).fnSort([[2, 'asc']]);
        }
        function RenderTablePayType() {
            $("#TablePayType").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstPayType',
                "sAjaxDataProp": "MstPayTypeData",
                "bProcessing": true,
                "bLengthChange": false,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdEditPayType" type="button" class="btn btn-primary" value="Edit"/>'
                                    }
                                },
                                {
                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                    "mRender": function (data) {
                                        return '<input runat="server" id="CmdDeletePayType" type="button" class="btn btn-danger" value="Delete"/>'
                                    }
                                },
                                { "mData": "PayType", "sWidth": "300px" },
                                { "mData": "Account" }]
            }).fnSort([[2, 'asc']]);
        }

        // Events
        function CmdAddUnit_onclick() {
            location.href = 'MstUnitDetail.aspx';
        }
        function CmdAddTax_onclick() {
            location.href = 'MstTaxDetail.aspx';
        }
        function CmdAddBank_onclick() {
            location.href = 'MstArticleBankDetail.aspx';
        }
        function CmdAddTerm_onclick() {
            location.href = 'MstTermDetail.aspx';
        }
        function CmdAddPayType_onclick() {
            location.href = 'MstPayTypeDetail.aspx';
        }
        function CmdEditUnit_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstUnitDetail.aspx?Id=' + Id;
            }
        }
        function CmdEditTax_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstTaxDetail.aspx?Id=' + Id;
            }
        }
        function CmdEditBank_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstArticleBankDetail.aspx?Id=' + Id;
            }
        }
        function CmdEditTerm_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstTermDetail.aspx?Id=' + Id;
            }
        }
        function CmdEditPayType_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstPayTypeDetail.aspx?Id=' + Id;
            }
        }
        function CmdDeleteUnit_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TableUnit"), Id, "Id", "Unit") + '?')) {
                $.ajax({
                    url: '/api/MstUnit/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'SysFolders.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteTax_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TableTax"), Id, "Id", "TaxCode") + '?')) {
                $.ajax({
                    url: '/api/MstTax/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'SysFolders.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteBank_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TableBank"), Id, "Id", "Bank") + '?')) {
                $.ajax({
                    url: '/api/MstArticleBank/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'SysFolders.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteTerm_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TableTerm"), Id, "Id", "Term") + '?')) {
                $.ajax({
                    url: '/api/MstTerm/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'SysFolders.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeletePayType_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TablePayType"), Id, "Id", "PayType") + '?')) {
                $.ajax({
                    url: '/api/MstPayType/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'SysFolders.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        // On Page Load
        $(document).ready(function () {
            RenderTableUnit();
            RenderTableTax();
            RenderTableBank();
            RenderTableTerm();
            RenderTablePayType();

            $("#TableUnit").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TableUnit").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditUnit") > 0) CmdEditUnit_onclick(Id);
                if (ButtonName.search("CmdDeleteUnit") > 0) CmdDeleteUnit_onclick(Id);
            });
            $("#TableTax").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TableTax").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditTax") > 0) CmdEditTax_onclick(Id);
                if (ButtonName.search("CmdDeleteTax") > 0) CmdDeleteTax_onclick(Id);
            });
            $("#TableBank").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TableBank").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditBank") > 0) CmdEditBank_onclick(Id);
                if (ButtonName.search("CmdDeleteBank") > 0) CmdDeleteBank_onclick(Id);
            });
            $("#TableTerm").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TableTerm").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditTerm") > 0) CmdEditTerm_onclick(Id);
                if (ButtonName.search("CmdDeleteTerm") > 0) CmdDeleteTerm_onclick(Id);
            });
            $("#TablePayType").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TablePayType").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditPayType") > 0) CmdEditPayType_onclick(Id);
                if (ButtonName.search("CmdDeletePayType") > 0) CmdDeletePayType_onclick(Id);
            });

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
            <h2>System Folders</h2>

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
                <a href="#TabUnit" class="btn" data-toggle="tab" id="tab1">Unit</a>
                <a href="#TabTax" class="btn" data-toggle="tab" id="tab2">Tax</a>
                <a href="#TabBank" class="btn" data-toggle="tab" id="tab3">Bank</a>
                <a href="#TabTerm" class="btn" data-toggle="tab" id="tab4">Term</a>
                <a href="#TabPayType" class="btn" data-toggle="tab" id="tab5">Pay Type</a>
            </div>

            <br />

            <br />

            <div class="tab-content">
                <div class="tab-pane active" id="TabUnit">
                    <table id="TableUnit" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="3">
                                    <input runat="server" type="button" id="CmdAddUnit" class="btn btn-primary" value="Add" onclick="CmdAddUnit_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Unit</th>
                            </tr>
                        </thead>
                        <tbody id="TableBodyUnit"></tbody>
                        <tfoot id="TableFooterUnit"></tfoot>
                    </table>
                </div>
                <div class="tab-pane" id="TabTax">
                    <table id="TableTax" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="5">
                                    <input runat="server" type="button" id="CmdAddTax" class="btn btn-primary" value="Add" onclick="CmdAddTax_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Tax Code</th>
                                <th>Tax Rate (%)</th>
                                <th>Account</th>
                            </tr>
                        </thead>
                        <tbody id="TableBodyTax"></tbody>
                        <tfoot id="TableFooterTax"></tfoot>
                    </table>
                </div>
                <div class="tab-pane" id="TabBank">
                    <table id="TableBank" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="5">
                                    <input runat="server" type="button" id="CmdAddBank" class="btn btn-primary" value="Add" onclick="CmdAddBank_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Bank Code</th>
                                <th>Bank</th>
                                <th>Particulars</th>
                            </tr>
                        </thead>
                        <tbody id="TableBodyBank"></tbody>
                        <tfoot id="TableFooterBank"></tfoot>
                    </table>
                </div>
                <div class="tab-pane" id="TabTerm">
                    <table id="TableTerm" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="4">
                                    <input runat="server" type="button" id="CmdAddTerm" class="btn btn-primary" value="Add" onclick="CmdAddTerm_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Term</th>
                                <th>No. of Days</th>
                            </tr>
                        </thead>
                        <tbody id="TableBodyTerm"></tbody>
                        <tfoot id="TableFooterTerm"></tfoot>
                    </table>
                </div>
                <div class="tab-pane" id="TabPayType">
                    <table id="TablePayType" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="4">
                                    <input runat="server" type="button" id="CmdAddPayType" class="btn btn-primary" value="Add" onclick="CmdAddPayType_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Pay Type</th>
                                <th>Account</th>
                            </tr>
                        </thead>
                        <tbody id="TableBodyPayType"></tbody>
                        <tfoot id="TableFotterPayType"></tfoot>
                    </table>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
