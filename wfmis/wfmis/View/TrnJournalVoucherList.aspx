<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnJournalVoucherList.aspx.cs" Inherits="wfmis.View.TrnJournalVoucherList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" /> 
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v1.js"></script>
    <%--Page--%>
	<script type="text/javascript" charset="utf-8">
        // JV Datatables
	    $(function () {
	        var $JournalVoucherTable;
	        $JournalVoucherTable = $("#tableJournalVoucher").dataTable({
	            "bServerSide": true,
	            "sAjaxSource": '/api/TrnJournalVoucher',
	            "sAjaxDataProp": "TrnJournalVoucherData",
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
                                return '<button type="button" class="btn btn-danger" onclick="cmdDelete_onclick(' + data + ')">Delete</button>'
                            }
                        },
                        { "mData": "JVDate", "sWidth": "100px" },
                        { "mData": "JVNumber", "sWidth": "100px" },
                        { "mData": "Particulars" }
	            ]
	        }).fnSort([[2, 'asc']]);
	    });
	    // Click events
	    function cmdAdd_onclick() {
	        location.href = 'TrnJournalVoucherDetail.aspx';
	    }
	    function CmdEdit_onclick(Id) {
	        if (Id > 0) {
	            location.href = 'TrnJournalVoucherDetail.aspx?Id=' + Id;
	        }
	    }
	    function cmdDelete_onclick(Id) {
	        if (confirm('Are you sure?')) {
	            $.ajax({
	                url: '/api/TrnJournalVoucher/' + Id,
	                cache: false,
	                type: 'DELETE',
	                contentType: 'application/json; charset=utf-8',
	                data: {},
	                success: function (data) {
	                    location.href = 'TrnJournalVoucherList.aspx';
	                }
	            }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
	        }
	    }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Journal Voucher</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <br />

            <div class="span12">
                <table id="tableJournalVoucher" class="table table-striped table-condensed" >
                    <thead>
                        <tr>
                            <th colspan="1"><input id="cmdAdd" type="button" value="Add" class="btn btn-primary" onclick="cmdAdd_onclick()"/></th>
                            <th colspan="4" style="text-align:right">Journal Voucher</th>
                        </tr>
                        <tr>
                            <th></th>
                            <th></th>
                            <th>JV Date</th>
                            <th>JV Number</th>
                            <th>Particulars</th>  
                        </tr>
                    </thead>
                    <tbody id="tableBodyJournalVoucher"></tbody>
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
