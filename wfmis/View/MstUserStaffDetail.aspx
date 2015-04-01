<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstUserStaffDetail.aspx.cs" Inherits="wfmis.View.MstUserStaffDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Date Picker--%>
    <link href="../Content/bootstrap-datepicker/datepicker.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-datepicker/bootstrap-datepicker.js"></script>
    <%--Select2--%>
    <link href="../Content/bootstrap-select2/select2.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-select2/select2.js"></script>
    <%--Knockout--%>
    <script type='text/javascript' src="../Scripts/knockout/knockout-2.3.0.js"></script>
    <script type='text/javascript' src="../Scripts/knockout/json2.js"></script>
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_v1.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" />
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8">
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $Id = 0;
        var $koNamespace = {};
        var $pageSize = 20;
        var $Modal01 = false;

        var $koUserStaff;
        var $koUserStaffRole;

        $koNamespace.initUserStaff = function (UserStaff) {
            var self = this;

            self.Id = ko.observable(!UserStaff ? 0 : UserStaff.Id);
            self.UserId = ko.observable(!UserStaff ? $CurrentUserId : UserStaff.UserId);
            self.UserStaffId = ko.observable(!UserStaff ? 0 : UserStaff.UserStaffId);
            self.UserStaff = ko.observable(!UserStaff ? "" : UserStaff.UserStaff);
            self.RoleId = ko.observable(!UserStaff ? 0 : UserStaff.RoleId);
            self.Role = ko.observable(!UserStaff ? "" : UserStaff.Role);

            $('#UserStaff').select2('data', { id: !UserStaff ? 0 : UserStaff.UserStaffId, text: !UserStaff ? "" : UserStaff.UserStaff });
            $('#Role').select2('data', { id: !UserStaff ? 0 : UserStaff.RoleId, text: !UserStaff ? "" : UserStaff.Role });

            return self;
        };
        $koNamespace.bindUserStaff = function (UserStaff) {
            var viewModel = $koNamespace.initUserStaff(UserStaff);
            ko.applyBindings(viewModel, $("#UserStaffDetail")[0]); //Bind the section #UserStaffDetail
            $koUserStaff = viewModel;
        };
        $koNamespace.getUserStaff = function (Id) {
            if (!Id) {
                $koNamespace.bindUserStaff(null);
            } else {
                // Render User/Staff
                $.getJSON("/api/MstUserStaff/" + Id + "/UserStaff", function (data) {
                    $koNamespace.bindUserStaff(data);
                });

                // Render User/Staff Roles
                $("#TableUserStaffRole").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/MstUserStaff/' + Id + '/UserStaffRoles',
                    "sAjaxDataProp": "MstUserStaffRoleData",
                    "bProcessing": true,
                    "bLengthChange": false,
                    "iDisplayLength": 20,
                    "sPaginationType": "full_numbers",
                    "aoColumns": [
                                    {
                                        "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                        "mRender": function (data) {
                                            return '<input runat="server" id="CmdEditRole" type="button" class="btn btn-primary" value="Edit"/>'
                                        }
                                    },
                                    {
                                        "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                        "mRender": function (data) {
                                            return '<input runat="server" id="CmdDeleteRole"  type="button" class="btn btn-danger" value="Delete"/>'
                                        }
                                    },
                                    { "mData": "LineCompany", "sWidth": "200px" },
                                    { "mData": "LinePage"},
                                    {
                                        "mData": "LineCanAdd", "sWidth": "70px",
                                        "mRender": function (data) {
                                            return '<input type="checkbox" ' + (data==true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                        }
                                    },
                                    {
                                        "mData": "LineCanSave", "sWidth": "70px",
                                        "mRender": function (data) {
                                            return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                        }
                                    },
                                    {
                                        "mData": "LineCanEdit", "sWidth": "70px",
                                        "mRender": function (data) {
                                            return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                        }
                                    },
                                    {
                                        "mData": "LineCanDelete", "sWidth": "70px",
                                        "mRender": function (data) {
                                            return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                        }
                                    },
                                    {
                                        "mData": "LineCanPrint", "sWidth": "70px",
                                        "mRender": function (data) {
                                            return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                        }
                                    },
                                    {
                                        "mData": "LineCanApprove", "sWidth": "70px",
                                        "mRender": function (data) {
                                            return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                        }
                                    },
                                    {
                                        "mData": "LineCanDisapprove", "sWidth": "70px",
                                        "mRender": function (data) {
                                            return '<input type="checkbox" ' + (data == true ? 'checked="checked"' : '') + ' disabled="disabled" />'
                                        }
                                    }]
                }).fnSort([[2, 'asc']]);
            }
        };

        $koNamespace.initUserStaffRole = function (UserStaffRole) {
            var self = this;

            self.LineId = ko.observable(!UserStaffRole ? 0 : UserStaffRole.LineId);
            self.LineUserStaffId = ko.observable(!UserStaffRole ? 0 : UserStaffRole.LineUserStaffId);
            self.LineCompanyId = ko.observable(!UserStaffRole ? 0 : UserStaffRole.LineCompanyId);
            self.LineCompany = ko.observable(!UserStaffRole ? "" : UserStaffRole.LineCompany);
            self.LinePageId = ko.observable(!UserStaffRole ? 0 : UserStaffRole.LinePageId);
            self.LinePage = ko.observable(!UserStaffRole ? "" : UserStaffRole.LinePage);
            self.LineCanAdd = ko.observable(!UserStaffRole ? false : UserStaffRole.LineCanAdd);
            self.LineCanSave = ko.observable(!UserStaffRole ? false : UserStaffRole.LineCanSave);
            self.LineCanEdit = ko.observable(!UserStaffRole ? false : UserStaffRole.LineCanEdit);
            self.LineCanDelete = ko.observable(!UserStaffRole ? false : UserStaffRole.LineCanDelete);
            self.LineCanPrint = ko.observable(!UserStaffRole ? false : UserStaffRole.LineCanPrint);
            self.LineCanApprove = ko.observable(!UserStaffRole ? false : UserStaffRole.LineCanApprove);
            self.LineCanDisapprove = ko.observable(!UserStaffRole ? false : UserStaffRole.LineCanDisapprove);

            return self;
        }
        $koNamespace.bindUserStaffRole = function (UserStaffRole) {
            try {
                var viewModel = $koNamespace.initUserStaffRole(UserStaffRole);
                ko.applyBindings(viewModel, $("#UserStaffRoleDetail")[0]);
                $koUserStaffRole = viewModel;

                $('#LineCompany').select2('data', { id: !UserStaffRole ? 0 : UserStaffRole.LineCompanyId, text: !UserStaffRole ? "" : UserStaffRole.LineCompany });
                $('#LinePage').select2('data', { id: !UserStaffRole ? 0 : UserStaffRole.LinePageId, text: !UserStaffRole ? "" : UserStaffRole.LinePage });

                $("#LineCanAdd").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanAdd);
                $("#LineCanSave").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanSave);
                $("#LineCanEdit").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanEdit);
                $("#LineCanDelete").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanDelete);
                $("#LineCanPrint").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanPrint);
                $("#LineCanApprove").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanApprove);
                $("#LineCanDisapprove").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanDisapprove);
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!UserStaffRole ? 0 : UserStaffRole.LineId).change();
                $('#LineUserStaffId').val(!UserStaffRole ? 0 : UserStaffRole.LineUserStaffId).change();

                $('#LineCompanyId').val(!UserStaffRole ? 0 : UserStaffRole.LineCompanyId).change();
                $('#LineCompany').select2('data', { id: !UserStaffRole ? 0 : UserStaffRole.LineCompanyId, text: !UserStaffRole ? "" : UserStaffRole.LineCompany });

                $('#LinePageId').val(!UserStaffRole ? 0 : UserStaffRole.LinePageId).change();
                $('#LinePage').select2('data', { id: !UserStaffRole ? 0 : UserStaffRole.LinePageId, text: !UserStaffRole ? "" : UserStaffRole.LinePageId });

                $("#LineCanAdd").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanAdd);
                $("#LineCanSave").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanSave);
                $("#LineCanEdit").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanEdit);
                $("#LineCanDelete").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanDelete);
                $("#LineCanPrint").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanPrint);
                $("#LineCanApprove").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanApprove);
                $("#LineCanDisapprove").prop("checked", !UserStaffRole ? false : UserStaffRole.LineCanDisapprove);
            }
        }

        // Events
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                // Existing record (Update)
                if (confirm('Update User/Staff?')) {
                    $.ajax({
                        url: '/api/MstUserStaff/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koUserStaff),
                        success: function (data) {
                            location.href = 'MstUserStaffDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                // New record (Insert)
                if (confirm('Save User/Staff?')) {
                    $.ajax({
                        url: '/api/MstUserStaff',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koUserStaff),
                        success: function (data) {
                            location.href = 'MstUserStaffDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdClose_onclick() {
            location.href = 'MstUserStaffList.aspx';
        }
        function CmdAddRole_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#ModalUserStaffRole').modal('show');
                $Modal01 = true;
                $koNamespace.bindUserStaffRole(null);
                // FK
                $('#LineUserStaffId').val($Id).change();
            } else {
                alert('User Staff not yet saved.');
            }
        }
        function CmdDownloadRole_onclick() {
        }
        function CmdEditRole_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/MstUserStaffRole/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindUserStaffRole(data);
                        $('#ModalUserStaffRole').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteRole_onclick(LineId) {
            if (confirm('Are you sure?')) {
                $.ajax({
                    url: '/api/MstUserStaffRole/' + LineId,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstUserStaffDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdSaveRole_onclick() {
            var LineId = $('#LineId').val();

            $('#ModalUserStaffRole').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/MstUserStaffRole/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koUserStaffRole),
                    success: function (data) {
                        location.href = 'MstUserStaffDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/MstUserStaffRole',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koUserStaffRole),
                    success: function (data) {
                        location.href = 'MstUserStaffDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdCloseRole_onclick() {
            $('#ModalUserStaffRole').modal('hide');
            $Modal01 = false;
        }

        // Select2 controls
        function Select2_UserStaff() {
            $('#UserStaff').select2({
                placeholder: 'User',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectUser',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $koUserStaff['UserStaffId']($('#UserStaff').select2('data').id);
            });
        }
        function Select2_Role() {
            $('#Role').select2({
                placeholder: 'Role',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectRole',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $koUserStaff['RoleId']($('#Role').select2('data').id);
            });
        }
        function Select2_LineCompany() {
            $('#LineCompany').select2({
                placeholder: 'Company',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectCompany',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $koUserStaffRole['LineCompanyId']($('#LineCompany').select2('data').id);
            });
        }
        function Select2_LinePage() {
            $('#LinePage').select2({
                placeholder: 'Page',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectPage',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $koUserStaffRole['LinePageId']($('#LinePage').select2('data').id);
            });
        }

        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Select2
            Select2_UserStaff();
            Select2_Role();
            Select2_LineCompany();
            Select2_LinePage();

            $("#TableUserStaffRole").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#TableUserStaffRole").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditRole") > 0) CmdEditRole_onclick(Id);
                if (ButtonName.search("CmdDeleteRole") > 0) CmdDeleteRole_onclick(Id);
            });

            // Fill the page with data
            if ($Id != "") {
                $koNamespace.getUserStaff($Id);
            } else {
                $koNamespace.getUserStaff(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#ModalUserStaffRole').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#ModalUserStaffRole').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">

            <h2>User/Staff Detail</h2>

            <input runat="server" id="PageName" type="hidden" value="" class="text" />
            <input runat="server" id="PageCompanyId" type="hidden" value="0" class="text" />
            <input runat="server" id="PageId" type="hidden" value="0" class="text" />

            <p><asp:SiteMapPath ID="SiteMapPath1" runat="server"></asp:SiteMapPath></p>

            <div id="loading-indicator-modal" class="modal hide fade in" style="display: none;">
                <div class="modal-body">
                    <div class="text-center" style="height:20px">
                        Please wait.  Contacting server: <img src="../Images/progress_bar.gif" id="loading-indicator"/>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="span12 text-right">
                    <div class="control-group">
                        <input runat="server" id="CmdSave" type="button" class="btn btn-primary" value="Save" onclick="CmdSave_onclick()"/>
                        <input runat="server" id="CmdClose" type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()"/>
                    </div>
                </div>
            </div>

            <section id="UserStaffDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label for="UserStaff" class="control-label">User/Staff</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="UserId" type="hidden" data-bind="value: UserId" disabled="disabled" />
                            <input id="UserStaffId" type="hidden" data-bind="value: UserStaffId" disabled="disabled" />
                            <input id="UserStaff" data-bind="value: UserStaff" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="UserStaff" class="control-label">Role</label>
                        <div class="controls">
                            <input id="RoleId" type="hidden" data-bind="value: RoleId" disabled="disabled" />
                            <input id="Role" data-bind="value: Role" type="text" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

            <section id="UserStaffRole">
            <div class="row">
                <div class="span12">
                    <table id="TableUserStaffRole" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="11">
                                    <input runat="server" id="CmdAddRole" type="button" class="btn btn-primary" value="Add" onclick="CmdAddRole_onclick()"/>
                                    <input runat="server" id="CmdAddDownloadedRoles" type="button" class="btn btn-primary" value="Download Roles" onclick="CmdDownloadRole_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Company</th>
                                <th>Page</th>
                                <th>Add</th>
                                <th>Save</th>
                                <th>Edit</th> 
                                <th>Delete</th> 
                                <th>Print</th> 
                                <th>Approve</th> 
                                <th>Disapprove</th> 
                            </tr>
                        </thead>
                        <tbody id="TableBodyUserStaffRole"></tbody>
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
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
            </section>

            <section id="UserStaffRoleDetail">
            <div id="ModalUserStaffRole" class="modal hide fade in" style="display: none;">
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>User/Staff Role Detail</h3>  
                </div> 
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <div class="controls">
                                    <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                    <input id="LineUserStaffId" type="hidden" data-bind="value: LineUserStaffId" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineCompany" class="control-label">Company </label>
                                <div class="controls">
                                    <input id="LineCompanyId" type="hidden" data-bind="value: LineCompanyId" class="input-medium" />
                                    <input id="LineCompany" type="text" data-bind="value: LineCompany" class="input-block-level" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePage" class="control-label">Page </label>
                                <div class="controls">
                                    <input id="LinePageId" type="hidden" data-bind="value: LinePageId" class="input-medium" />
                                    <input id="LinePage" type="text" data-bind="value: LinePage" class="input-block-level" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Can Add</label>
                                <div class="controls">
                                    <input id="LineCanAdd" type="checkbox" data-bind="checked: LineCanAdd" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Can Save</label>
                                <div class="controls">
                                    <input id="LineCanSave" type="checkbox" data-bind="checked: LineCanSave" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Can Edit</label>
                                <div class="controls">
                                    <input id="LineCanEdit" type="checkbox" data-bind="checked: LineCanEdit" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Can Delete</label>
                                <div class="controls">
                                    <input id="LineCanDelete" type="checkbox" data-bind="checked: LineCanDelete" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Can Print</label>
                                <div class="controls">
                                    <input id="LineCanPrint" type="checkbox" data-bind="checked: LineCanPrint" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Can Approve</label>
                                <div class="controls">
                                    <input id="LineCanApprove" type="checkbox" data-bind="checked: LineCanApprove" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Can Disapprove</label>
                                <div class="controls">
                                    <input id="LineCanDisapprove" type="checkbox" data-bind="checked: LineCanDisapprove" class="input-large" />
                                </div>
                            </div>
                        </div>
                    </div>             
                </div> 
                <div class="modal-footer">  
                    <a href="#" class="btn btn-primary" onclick="CmdSaveRole_onclick()">Save</a>  
                    <a href="#" class="btn btn-danger" onclick="CmdCloseRole_onclick()">Close</a>  
                </div>  
            </div>
            </section>

        </div>
    </div>
</asp:Content>
