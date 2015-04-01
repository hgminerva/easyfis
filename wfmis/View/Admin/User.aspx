<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="User.aspx.cs" Inherits="wfmis.View.Admin.User" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Datatables--%>
    <link href="/Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="/Content/datatable/demo_table.css" rel="stylesheet" />
    <link href="/Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="/Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="/Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" /> 
    <script src="/Scripts/datatable/jquery.dataTables.js"></script>
    <%--Knockout Binding--%>
    <script type='text/javascript' src="/Scripts/knockout/knockout-2.3.0.js"></script>
    <script type='text/javascript' src="/Scripts/knockout/json2.js"></script>   
    <%--Select2--%>
    <link href="/Content/bootstrap-select2/select2.css" rel="stylesheet" />
    <script type='text/javascript' src="/Scripts/bootstrap-select2/select2.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="/Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8">
        var $UserId = 0;
        var $User = "";
        var $selectPageSize = 20;
        var $Modal01 = false;
        // Select2
        function Select2_User() {
            $('#User').select2({
                placeholder: 'User',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectUser',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#UserId').val($('#User').select2('data').id).change();
            });
        }
        function Select2_TemplateUser() {
            $('#TemplateUser').select2({
                placeholder: 'Template',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectTemplate',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#TemplateUserId').val($('#TemplateUser').select2('data').id).change();
            });
        }
        // Events
        function CmdActivity_onclick(Id) {
            $UserId = Id;
            $User = easyFIS.getTableData($("#UserTable"), Id, "Id", "FullName");

            $('#User').select2('data', { id: $UserId, text: $User });

            $('#ActivityModal').modal('show');
            $Modal01 = true;
        }
        function CmdCloseActivity_onclick() {
            $('#ActivityModal').modal('hide');
            $Modal01 = false;
        }
        function CmdActivityChangeTemplate_onclick() {
            var TemplateUserId = $('#TemplateUserId').val();

            if (TemplateUserId) {
                if (confirm('Change Template?')) {
                    $.ajax({
                        url: '/api/AdminUser?UserId=' + $UserId +'&TemplateUserId=' + TemplateUserId,
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        success: function (data) {
                            alert("Success!");
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }
        function CmdActivityChangePassword_onclick() {
            var Id = $UserId;
            var NewPassword = $('#NewPassword').val();

            if (NewPassword) {
                if (confirm('Change Password?')) {
                    $.ajax({
                        url: '/api/AdminUser/' + Id + '/ChangePassword?&NewPassword=' + NewPassword,
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        success: function (data) {
                            alert("Success!");
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }
        function CmdActivityClearTransactions_onclick() {
            var Id = $UserId;
            if (Id) {
                if (confirm('Clear Transactions?')) {
                    $.ajax({
                        url: '/api/AdminUser/' + Id + '/ClearTransactions',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        success: function (data) {
                            if (data == true) {
                                alert("Success!");
                            } else {
                                alert("Failed!");
                            }     
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }
        // Render
        function RenderUserTable() {
            var UserTable = $("#UserTable").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/AdminUser',
                "sAjaxDataProp": "AdminUserData",
                "bProcessing": true,
                "bLengthChange": false,
                "iDisplayLength": 20,
                "sPaginationType": "full_numbers",
                "aoColumns": [
                        {
                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                            "mRender": function (data) {
                                return '<button type="button" class="btn btn-primary" onclick="CmdActivity_onclick(' + data + ')">Activity</button>'
                            }
                        },
                        { "mData": "UserAccountNumber", "sWidth": "150px" },
                        { "mData": "UserName", "sWidth": "150px" },
                        { "mData": "FullName" },
                        { "mData": "TemplateUser", "sWidth": "300px" },
                        {
                            "mData": "IsTemplate", "sWidth": "100px",
                            "mRender": function (data) {
                                return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                            }
                        }
                ]
            }).fnSort([[1, 'asc']]);
        }
        // On Page Load
        $(document).ready(function () {
            RenderUserTable();

            Select2_User();
            Select2_TemplateUser();
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#ActivityModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#ActivityModal').modal('show');
                }
            }
        });
    </script> 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Admin: User List</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div id="loading-indicator-modal" class="modal hide fade in" style="display: none;">
                <div class="modal-body">
                    <div class="text-center" style="height:20px">
                        Please wait.  Contacting server: <img src="/Images/progress_bar.gif" id="loading-indicator"/>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="span12">
                    <table id="UserTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="1"></th>
                                <th colspan="5" style="text-align:right">User List</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th>Account No</th>
                                <th>User Name</th>
                                <th>FullName</th>  
                                <th>Template</th>
                                <th>Is Template</th>
                            </tr>
                        </thead>
                        <tbody id="UserTableBody"></tbody>
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
        
            <section id="ActivityDetail">
                <div id="ActivityModal" class="modal hide fade in" style="display: none;">
                    <div class="modal-header">
                        <a class="close" data-dismiss="modal">×</a>
                        <h3>Activity</h3>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="form-horizontal">
                                <div class="control-group">
                                    <label class="control-label">User</label>
                                    <div class="controls">
                                        <input id="UserId" type="hidden" data-bind="value: UserId" class="input-medium" />
                                        <input id="User" type="text" data-bind="value: User" class="input-xlarge" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label class="control-label">Change Template</label>
                                    <div class="controls">
                                        <input id="TemplateUserId" type="hidden" data-bind="value: TemplateUserId" class="input-medium" />
                                        <input id="TemplateUser" type="text" data-bind="value: TemplateUser" class="input-xlarge" />
                                        <button type="button" class="btn btn-primary" onclick="CmdActivityChangeTemplate_onclick()">Go</button>
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label class="control-label">Change Password</label>
                                    <div class="controls">
                                        <input id="NewPassword" type="text" data-bind="value: NewPassword" class="input-xlarge" />
                                        <button type="button" class="btn btn-primary" onclick="CmdActivityChangePassword_onclick()">Go</button>
                                    </div>
                                </div>
                                <div class="control-group">
                                    <label class="control-label">Clear Transactions</label>
                                    <div class="controls">
                                        <button type="button" class="btn btn-primary" onclick="CmdActivityClearTransactions_onclick()">Clear Transactions</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="#" class="btn btn-danger" onclick="CmdCloseActivity_onclick()">Close</a>
                    </div>
                </div>
            </section>

        </div>
    </div>

</asp:Content>
