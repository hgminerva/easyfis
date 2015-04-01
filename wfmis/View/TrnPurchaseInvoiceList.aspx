<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnPurchaseInvoiceList.aspx.cs" Inherits="wfmis.View.TrnPurchaseInvoiceList" %>

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
	    // Global Application Variables
	    var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
	    var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
	    var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';

	    // Events
	    function CmdAdd_onclick() {
	        location.href = 'TrnPurchaseInvoiceDetail.aspx';
	    }
	    function CmdEdit_onclick(Id) {
	        if (Id > 0) {
	            location.href = 'TrnPurchaseInvoiceDetail.aspx?Id=' + Id;
	        }
	    }
	    function CmdDelete_onclick(Id) {
	        if (confirm('Are you sure?')) {
	            $.ajax({
	                url: '/api/TrnPurchaseInvoice/' + Id,
	                cache: false,
	                type: 'DELETE',
	                contentType: 'application/json; charset=utf-8',
	                data: {},
	                success: function (data) {
	                    if (data == true) {
	                        location.href = 'TrnPurchaseInvoiceList.aspx';
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

	    // On Page Load
	    $(document).ready(function () {
	        var tablePurchaseInvoice;
	        tablePurchaseInvoice = $("#tablePurchaseInvoice").dataTable({
	            "bServerSide": true,
	            "sAjaxSource": '/api/TrnPurchaseInvoice',
	            "sAjaxDataProp": "TrnPurchaseInvoiceData",
	            "bProcessing": true,
	            "bLengthChange": false,
	            "iDisplayLength": 20,
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
                                return '<input runat="server" id="CmdDelete" type="button" class="btn btn-danger" value="Delete" />'
                            }
                        },
                        { "mData": "PIDate", "sWidth": "120px" },
                        { "mData": "PINumber", "sWidth": "120px" },
                        { "mData": "Supplier" },
                        { "mData": "DocumentReference", "sWidth": "120px" },
                        { "mData": "TotalAmount", "sWidth": "120px", "sClass": "alignRight", 
                          "mRender": function (data) {
                              return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                          }
                        },
                        {
                            "mData": "IsLocked", "sWidth": "100px",
                            "mRender": function (data) {
                                return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                            }
                        }]
	        }).fnSort([[2, 'asc']]);
	        $("#tablePurchaseInvoice").on("click", "input[type='button']", function () {
	            var ButtonName = $(this).attr("id");
	            var Id = $("#tablePurchaseInvoice").dataTable().fnGetData(this.parentNode);

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
            <h2>Purchase Invoice</h2>

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
                    <table id="tablePurchaseInvoice" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="1"><input runat="server" id="CmdAdd" type="button" value="Add" class="btn btn-primary" onclick="CmdAdd_onclick()"/></th>
                                <th colspan="7" style="text-align:right">Purchase Invoice</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>PI Date</th>
                                <th>PI Number</th>
                                <th>Supplier</th>  
                                <th>Doc. Ref</th>
                                <th>Amount</th>
                                <th>Approved</th>
                            </tr>
                        </thead>
                        <tbody id="tableBodyPurchaseInvoice"></tbody>
                        <tfoot>
                            <tr>
                                <td></td>
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
