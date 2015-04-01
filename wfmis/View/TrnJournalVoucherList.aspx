﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnJournalVoucherList.aspx.cs" Inherits="wfmis.View.TrnJournalVoucherList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" /> 
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v3.js"></script>
    <%--Page--%>
	<script type="text/javascript" charset="utf-8">
	    // Events
	    function CmdAdd_onclick() {
	        location.href = 'TrnJournalVoucherDetail.aspx';
	    }
	    function CmdEdit_onclick(Id) {
	        if (Id > 0) {
	            location.href = 'TrnJournalVoucherDetail.aspx?Id=' + Id;
	        }
	    }
	    function CmdDelete_onclick(Id) {
	        if (confirm('Are you sure?')) {
	            $.ajax({
	                url: '/api/TrnJournalVoucher/' + Id,
	                cache: false,
	                type: 'DELETE',
	                contentType: 'application/json; charset=utf-8',
	                data: {},
	                success: function (data) {
	                    if (data == true) {
	                        location.href = 'TrnJournalVoucherList.aspx';
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

	    // Page Load
	    $(document).ready(function () {
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
                                return '<input runat="server" id="CmdEdit" type="button" class="btn btn-primary" value="Edit" />'
                            }
                        },
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<input runat="server" id="CmdDelete"  type="button" class="btn btn-danger" value="Delete" />'
                            }
                        },
                        { "mData": "JVDate", "sWidth": "100px" },
                        { "mData": "JVNumber", "sWidth": "100px" },
                        { "mData": "Particulars" },
                        {
                            "mData": "IsLocked", "sWidth": "100px",
                            "mRender": function (data) {
                                return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                            }
                        }
	            ]
	        }).fnSort([[2, 'asc']]);
	        $("#tableJournalVoucher").on("click", "input[type='button']", function () {
	            var ButtonName = $(this).attr("id");
	            var Id = $("#tableJournalVoucher").dataTable().fnGetData(this.parentNode);

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
            <h2>Journal Voucher</h2>

            <input runat="server" id="PageName" type="hidden" value="" class="text" />
            <input runat="server" id="PageCompanyId" type="hidden" value="0" class="text" />
            <input runat="server" id="PageId" type="hidden" value="0" class="text" />

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div class="row">

            <div id="loading-indicator-modal" class="modal hide fade in" style="display: none;">
                <div class="modal-body">
                    <div class="text-center" style="height:20px">
                        Please wait.  Contacting server: <img src="../Images/progress_bar.gif" id="loading-indicator"/>
                    </div>
                </div>
            </div>
            
                <div class="span12">
                    <table id="tableJournalVoucher" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="1"><input runat="server" id="CmdAdd" type="button" value="Add" class="btn btn-primary" onclick="CmdAdd_onclick()"/></th>
                                <th colspan="5" style="text-align:right">Journal Voucher</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>JV Date</th>
                                <th>JV Number</th>
                                <th>Particulars</th>
                                <th>Approved</th>    
                            </tr>
                        </thead>
                        <tbody id="tableBodyJournalVoucher"></tbody>
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
