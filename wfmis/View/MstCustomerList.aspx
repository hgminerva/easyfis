<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstCustomerList.aspx.cs" Inherits="wfmis.View.MstCustomer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" /> 
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--Knockout Binding--%>
    <script type='text/javascript' src="../Scripts/knockout/knockout-2.3.0.js"></script>
    <script type='text/javascript' src="../Scripts/knockout/json2.js"></script>   
    <%--Select2--%>
    <link href="../Content/bootstrap-select2/select2.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-select2/select2.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8"> 
        // Events
        function CmdDelete_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TableCustomer"), Id, "Id", "Customer") + '?')) {
                $.ajax({
                    url: '/api/MstArticleCustomer/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstCustomerList.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdEdit_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstCustomerDetail.aspx?Id=' + Id;
            }
        }
        function CmdAdd_onclick() {
            location.href = 'MstCustomerDetail.aspx';
        }

        // Render table
        function renderTableCustomer() {
            var TableCustomer = $("#TableCustomer").dataTable({
                                    "bServerSide": true,
                                    "sAjaxSource": '/api/MstArticleCustomer',
                                    "sAjaxDataProp": "MstArticleCustomerData",
                                    "bProcessing": true,
                                    "bLengthChange": false,
                                    "iDisplayLength": 20,
                                    "sPaginationType": "full_numbers",
                                    "aoColumns": [
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdEdit"  type="button" class="btn btn-primary" value="Edit" />'
                                                }
                                            },
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdDelete"  type="button" class="btn btn-danger" value="Delete" />'
                                                }
                                            },
                                            { "mData": "CustomerCode", "sWidth": "150px" },
                                            { "mData": "Customer" },
                                            { "mData": "ContactNumbers", "sWidth": "300px" }
                                    ]
                                }).fnSort([[2, 'asc']]);
        }

        // Page load
        $(document).ready(function () {
            renderTableCustomer();

            $("#TableCustomer").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TableCustomer").dataTable().fnGetData(this.parentNode);

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
            <h2>Customer</h2>

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
                    <table id="TableCustomer" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="1"><input runat="server" id="CmdAdd" type="button" class="btn btn-primary" value="Add" onclick="CmdAdd_onclick()"/></th>
                                <th colspan="4" style="text-align:right">Customer List</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Code</th>
                                <th>Customer</th>
                                <th>Contact Numbers</th>  
                            </tr>
                        </thead>
                        <tbody id="TableBodyCustomer"></tbody>
                        <tfoot>
                            <tr>
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
