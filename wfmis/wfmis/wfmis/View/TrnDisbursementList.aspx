<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnDisbursementList.aspx.cs" Inherits="wfmis.View.TrnDisbursementList" %>

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
	    // Events
	    function cmdAdd_onclick() {
	        location.href = 'TrnDisbursementDetail.aspx';
	    }

        // On Page Load
	    $(document).ready(function () {
	        var tableDisbursement;
	        tableDisbursement = $("#tableDisbursement").dataTable({
	            "bServerSide": true,
	            "sAjaxSource": '/api/TrnDisbursement',
	            "sAjaxDataProp": "TrnDisbursementData",
	            "bProcessing": true,
	            "bLengthChange": false,
	            "sPaginationType": "full_numbers",
	            "aoColumns": [
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<button type="button" class="btn btn-primary" onclick="cmdEdit_onclick(' + data + ')">Edit</button>'
                            }
                        },
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<button type="button" class="btn btn-danger" onclick="cmdDelete_onclick(' + data + ')">Delete</button>'
                            }
                        },
                        { "mData": "CVDate", "sWidth": "120px" },
                        { "mData": "CVNumber", "sWidth": "120px" },
                        { "mData": "Supplier" },
                        { "mData": "CheckNumber", "sWidth": "120px" },
                        {
                            "mData": "TotalAmount", "sWidth": "120px", "sClass": "alignRight",
                            "mRender": function (data) {
                                return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                            }
                        }]
	        }).fnSort([[2, 'asc']]);
	    });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Disbursement</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div class="row">

                <div class="span12">
                    <div class="alert alert-info">
                        User: <b><%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %></b> |
                        Period: <b><%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %></b> |
                        Branch: <b><%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentCompany %> \ <%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %></b> (
                        <a href="SysSettings.aspx">Change Settings </a>)
                    </div>
                </div>

                <div class="span12">
                    <table id="tableDisbursement" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="1"><input id="cmdAdd" type="button" value="Add" class="btn btn-primary" onclick="cmdAdd_onclick()"/></th>
                                <th colspan="6" style="text-align:right">Disbursement</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>CV Date</th>
                                <th>CV Number</th>
                                <th>Supplier</th>  
                                <th>Check Number</th>
                                <th>Amount</th>
                            </tr>
                        </thead>
                        <tbody id="tableBodyDisbursement"></tbody>
                        <tfoot>
                            <tr>
                                <td></td>
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
