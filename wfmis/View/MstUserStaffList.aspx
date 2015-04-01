﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstUserStaffList.aspx.cs" Inherits="wfmis.View.MstUserStaffList" %>

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
            if (confirm('Delete ' + easyFIS.getTableData($("#TableUserStaff"), Id,"Id", "UserStaff") + '?')) {
                $.ajax({
                    url: '/api/MstUserStaff/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstUserStaffList.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdEdit_onclick(Id) {
            if (Id > 0) {
                location.href = 'MstUserStaffDetail.aspx?Id=' + Id;
            }
        }
        function CmdAdd_onclick() {
            location.href = 'MstUserStaffDetail.aspx';
        }
    
        // Render table
        function renderTableUserStaff() {
            var TableUserStaff = $("#TableUserStaff").dataTable({
                                    "bServerSide": true,
                                    "sAjaxSource": '/api/MstUserStaff',
                                    "sAjaxDataProp": "MstUserStaffData",
                                    "bProcessing": true,
                                    "bLengthChange": false,
                                    "iDisplayLength": 20,
                                    "sPaginationType": "full_numbers",
                                    "aoColumns": [
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdEdit" type="button" class="btn btn-primary" value="Edit"/>'
                                                }
                                            },
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdDelete"  type="button" class="btn btn-danger" value="Delete"/>'
                                                }
                                            },
                                            { "mData": "UserStaff"},
                                            { "mData": "Role" }]
                                }).fnSort([[2, 'asc']]);
        }
        
        // Page Load
        $(document).ready(function () {
            renderTableUserStaff();

            $("#TableUserStaff").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TableUserStaff").dataTable().fnGetData(this.parentNode);

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
            <h2>User/Staff</h2>

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
                    <table id="TableUserStaff" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="1"><input runat="server" id="CmdAdd" type="button" class="btn btn-primary" value="Add" onclick="CmdAdd_onclick()"/></th>
                                <th colspan="3" style="text-align:right">User/Staff List</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Staff</th>
                                <th>Role</th>
                            </tr>
                        </thead>
                        <tbody id="TableBodyUserStaff"></tbody>
                        <tfoot>
                            <tr>
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
