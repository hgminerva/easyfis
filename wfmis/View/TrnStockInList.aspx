<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnStockInList.aspx.cs" Inherits="wfmis.View.TrnStockInList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" /> 
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8">
        var $CurrentPage = "0";
        var $DefaultPage = "0";
        // Events
        function CmdAdd_onclick() {
            location.href = 'TrnStockInDetail.aspx?DefaultPage=' + $CurrentPage;
        }
        function CmdEdit_onclick(Id) {
            if (Id > 0) {
                location.href = 'TrnStockInDetail.aspx?Id=' + Id + '&DefaultPage=' + $CurrentPage;
            }
        }
        function CmdDelete_onclick(Id) {
            if (confirm('Are you sure?')) {
                $.ajax({
                    url: '/api/TrnStockIn/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        if (data == true) {
                            location.href = 'TrnStockInList.aspx';
                        } else {
                            alert('Not allowed.  Record is approved.');
                        }
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        function RenderStockInTable() {
            var StockInTable = $("#StockInTable").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/TrnStockIn',
                "sAjaxDataProp": "TrnStockInData",
                "bProcessing": true,
                "bLengthChange": false,
                "iDisplayLength": 20,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<input runat="server" id="CmdEdit" type="button" class="btn btn-primary" value="Edit" />';
                            }
                        },
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<input runat="server" id="CmdDelete" type="button" class="btn btn-danger" value="Delete" />';
                            }
                        },
                        { "mData": "INDate", "sWidth": "120px" },
                        { "mData": "INNumber", "sWidth": "120px" },
                        { "mData": "Particulars" },
                        {
                            "mData": "IsLocked", "sWidth": "100px",
                            "mRender": function (data) {
                                return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                            }
                        }
                ],
                "fnDrawCallback": function (oSettings) {
                    $CurrentPage = Math.ceil(oSettings._iDisplayStart / oSettings._iDisplayLength) + 1;
                }
            }).fnSort([[2, 'asc']]);
        }

        // On Page Load
        $(document).ready(function () {
            $DefaultPage = easyFIS.getParameterByName("DefaultPage") == "" ? "1" : easyFIS.getParameterByName("DefaultPage");

            RenderStockInTable();

            $("#StockInTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#StockInTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEdit") > 0) CmdEdit_onclick(Id);
                if (ButtonName.search("CmdDelete") > 0) CmdDelete_onclick(Id);
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
            
            <h2>Stock In</h2>

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
                    <table id="StockInTable" class="table table-striped table-condensed">
                        <thead>
                            <tr>
                                <th colspan="1">
                                    <input runat="server" id="CmdAdd" type="button" value="Add" class="btn btn-primary" onclick="CmdAdd_onclick()" /></th>
                                <th colspan="5" style="text-align: right">Stock In</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>IN Date</th>
                                <th>IN Number</th>
                                <th>Particulars</th>
                                <th>Approved</th>
                            </tr>
                        </thead>
                        <tbody id="StockInTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
