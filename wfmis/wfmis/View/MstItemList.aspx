<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstItemList.aspx.cs" Inherits="wfmis.View.MstItemList" %>
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
    <script src="../Scripts/easyfis/easyfis.utils.v1.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8"> 
        // Customer Datatable
        $(function () {
            var $ArticleItemDataTable;

            $ArticleItemDataTable = $("#TableArticleItemList").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstArticleItem',
                "sAjaxDataProp": "MstArticleItemData",
                "bProcessing": true,
                "bLengthChange": false,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<button type="button" class="btn btn-primary" onclick="CmdEdit_onclick(' + data + ')">Edit</button>'
                            }
                        },
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<button type="button" class="btn btn-danger" onclick="CmdDelete_onclick(' + data + ')">Delete</button>'
                            }
                        },
                        { "mData": "ItemCode", "sWidth": "150px" },
                        { "mData": "Item" },
                        { "mData": "Category", "sWidth": "300px" }
                ]
            });
            $ArticleItemDataTable.fnSort([[2, 'asc']]);
        });

        // Click events
        function CmdDelete_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TableArticleItemList"), Id, "Item") + '?')) {
                $.ajax({
                    url: '/api/MstArticleItem/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstItemList.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        function CmdEdit_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstItemDetail.aspx?Id=' + Id;
            }
        }

        function CmdAdd_onclick() {
            location.href = 'MstItemDetail.aspx';
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Item</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div>
                <table id="TableArticleItemList" class="table table-striped table-condensed" >
                    <thead>
                        <tr>
                            <th colspan="1"><button id="CmdAdd" type="button" class="btn btn-primary" onclick="CmdAdd_onclick()">Add</button></th>
                            <th colspan="4" style="text-align:right">Item List</th>
                        </tr>
                        <tr>
                            <th></th>
                            <th></th>
                            <th>Code</th>
                            <th>Item</th>
                            <th>Category</th>  
                        </tr>
                    </thead>
                    <tbody id="TableBodyArticleItemList"></tbody>
                    <tfoot>
                        <tr>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

</asp:Content>
