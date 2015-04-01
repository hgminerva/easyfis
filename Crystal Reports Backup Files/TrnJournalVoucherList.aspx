<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnJournalVoucherList.aspx.cs" Inherits="wfmis.View.TrnJournalVoucherList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css" title="currentStyle">
			@import "../Content/datatable/datatable.page.css";
            @import "../Content/datatable/datatable.tools.css";
            @import "../Content/datatable/datatable.css";
	</style>

	<script type="text/javascript" src="../Scripts/datatable/jquery.dataTables.js"></script>
    <script type="text/javascript" src="../Scripts/datatable/TableTools.js"></script>
    <script type="text/javascript" src="../Scripts/datatable/ZeroClipboard.js"></script>

	<script type="text/javascript" charset="utf-8">
	    
	    // Journal Voucher Datatable
	    var $JournalVoucherTable;
	    $(function () {
	        $JournalVoucherTable = $("#tableJournalVoucher").dataTable({
	            "sPaginationType": "full_numbers",
	            "bProcessing": true,
	            "bRetrieve": true,
	            "sAjaxSource": '/api/TrnJournalVoucher',
	            "sAjaxDataProp": "",
	            "aLengthMenu": [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]],
	            "aoColumns": [
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<a href="TrnJournalVoucherDetail.aspx?Id=' + data + '" class="btn btn-primary">Edit</a>'
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
	        });
	    });

	    // Events
	    function cmdAdd_onclick() {
	        location.href = 'TrnJournalVoucherDetail.aspx';
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
                </table>
            </div>

        </div>
    </div>
</asp:Content>
