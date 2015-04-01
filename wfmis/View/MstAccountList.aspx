<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstAccountList.aspx.cs" Inherits="wfmis.View.MstAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" />
    
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>

    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v4.js"></script>

    <%--Page--%>
	<script type="text/javascript" charset="utf-8">
	    // Events
	    function cmdAddAccount_onclick() {
	        location.href = 'MstAccountDetail.aspx';
	    }
	    function cmdEditAccount_onclick(Id) {
	        if (Id > 0) {
	            location.href = 'MstAccountDetail.aspx?Id=' + Id;
	        } 
	    }
	    function cmdDeleteAccount_onclick(Id) {
	        if (Id > 0) {
	            if (confirm('Delete ' + easyFIS.getTableData($("#tableAccount"), Id, "Id", "Account") + '?')) {
	                $.ajax({
	                    url: '/api/MstAccount/' + Id,
	                    cache: false,
	                    type: 'DELETE',
	                    contentType: 'application/json; charset=utf-8',
	                    data: {},
	                    success: function (data) {
	                        location.href = 'MstAccountList.aspx';
	                    }
	                }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
	            }
	        }
	    }
	    function cmdAddAccountType_onclick() {
	        location.href = 'MstAccountTypeDetail.aspx';
	    }
	    function cmdEditAccountType_onclick(Id) {
	        if (Id > 0) {
	            location.href = 'MstAccountTypeDetail.aspx?Id=' + Id;
	        }
	    }
	    function cmdDeleteAccountType_onclick(Id) {
	        if (confirm('Are you sure?')) {
	            $.ajax({
	                url: '/api/MstAccountType/' + Id,
	                cache: false,
	                type: 'DELETE',
	                contentType: 'application/json; charset=utf-8',
	                data: {},
	                success: function (data) {
	                    location.href = 'MstAccountList.aspx';
	                }
	            }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
	        }
	    }
	    function cmdAddAccountCashFlow_onclick() {
	        location.href = 'MstAccountCashFlowDetail.aspx';
	    }
	    function cmdEditAccountCashFlow_onclick(Id) {
	        if (Id > 0) {
	            location.href = 'MstAccountCashFlowDetail.aspx?Id=' + Id;
	        }
	    }
	    function cmdDeleteAccountCashFlow_onclick(Id) {
	        if (confirm('Are you sure?')) {
	            $.ajax({
	                url: '/api/MstAccountCashFlow/' + Id,
	                cache: false,
	                type: 'DELETE',
	                contentType: 'application/json; charset=utf-8',
	                data: {},
	                success: function (data) {
	                    location.href = 'MstAccountList.aspx';
	                }
	            }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
	        }
	    }
	    function cmdEditAccountCategory_onclick(Id) {
	    }
	    function cmdDeleteAccountCategory_onclick(Id) {
	    }

        // Render table
	    function renderTableAccount() {
	        var tableAccount = $("#tableAccount").dataTable({
	                                "bServerSide": true,
	                                "sAjaxSource": '/api/MstAccount',
	                                "sAjaxDataProp": "MstAccountData",
	                                "bProcessing": true,
	                                "bLengthChange": false,
	                                "sPaginationType": "full_numbers",
	                                "iDisplayLength": 20,
	                                "aoColumns": [
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input  runat="server" id="CmdEditAccount" type="button" class="btn btn-primary" value="Edit"/>'
                                                }
                                            },
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdDeleteAccount" type="button" class="btn btn-danger" value="Delete"/>'
                                                }
                                            },
                                            { "mData": "AccountCode", "sWidth": "150px" },
                                            { "mData": "Account" },
                                            { "mData": "AccountType", "sWidth": "200px" }, 
	                                        { "mData": "AccountCashFlow", "sWidth": "300px" }]
	                            }).fnSort([[2, 'asc']]);
	    }
	    function renderTableAccountType() {
	        var tableAccountType = $("#tableAccountType").dataTable({
	                                    "bServerSide": true,
	                                    "sAjaxSource": '/api/MstAccountType',
	                                    "sAjaxDataProp": "MstAccountTypeData",
	                                    "bProcessing": true,
	                                    "bLengthChange": false,
	                                    "sPaginationType": "full_numbers",
	                                    "aoColumns": [
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdEditAccountType" type="button" class="btn btn-primary" value="Edit"/>'
                                                }
                                            },
                                            {
                                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdDeleteAccountType"  type="button" class="btn btn-danger" value="Delete"/>'
                                                }
                                            },
                                            { "mData": "AccountTypeCode", "sWidth": "150px" },
                                            { "mData": "AccountType" },
                                            { "mData": "AccountCategory" }]
	                                }).fnSort([[2, 'asc']]);
	    }
	    function renderTableAccountCashFlow() {
	        var tableAccountCashFlow = $("#tableAccountCashFlow").dataTable({
	            "bServerSide": true,
	            "sAjaxSource": '/api/MstAccountCashFlow',
	            "sAjaxDataProp": "MstAccountCashFlowData",
	            "bProcessing": true,
	            "bLengthChange": false,
	            "sPaginationType": "full_numbers",
	            "aoColumns": [
                    {
                        "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                        "mRender": function (data) {
                            return '<input runat="server" id="CmdEditAccountCashFlow" type="button" class="btn btn-primary" value="Edit"/>'
                        }
                    },
                    {
                        "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                        "mRender": function (data) {
                            return '<input runat="server" id="CmdDeleteAccountCashFlow"  type="button" class="btn btn-danger" value="Delete"/>'
                        }
                    },
                    { "mData": "AccountCashFlowCode", "sWidth": "150px" },
                    { "mData": "AccountCashFlow" }]
	        }).fnSort([[2, 'asc']]);
	    }
	    function renderTableAccountCategory() {
	        var tableAccountCategory = $("#tableAccountCategory").dataTable({
	                                        "bServerSide": true,
	                                        "sAjaxSource": '/api/MstAccountCategory',
	                                        "sAjaxDataProp": "MstAccountCategoryData",
	                                        "bProcessing": true,
	                                        "bLengthChange": false,
	                                        "sPaginationType": "full_numbers",
	                                        "aoColumns": [
                                                {
                                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                    "mRender": function (data) {
                                                        return '<input runat="server" id="CmdEditAccountCategory" type="button" class="btn btn-primary" value="Edit" disabled="disabled"/>'
                                                    }
                                                },
                                                {
                                                    "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                    "mRender": function (data) {
                                                        return '<input runat="server" id="CmdDeleteAccountCategory"  type="button" class="btn btn-danger" value="Delete" disabled="disabled"/>'
                                                    }
                                                },
                                                { "mData": "AccountCategoryCode", "sWidth": "150px" },
                                                { "mData": "AccountCategory" }]
	                                    }).fnSort([[2, 'asc']]);
	    }

	    // On Page Load
	    $(document).ready(function () {
	        renderTableAccount();
	        renderTableAccountType();
	        renderTableAccountCashFlow();
	        renderTableAccountCategory();

	        $("#tableAccount").on("click", "input[type='button']", function () {
	            var ButtonName = $(this).attr("id");
	            var Id = $("#tableAccount").dataTable().fnGetData(this.parentNode);

	            if (ButtonName.search("CmdEditAccount") > 0) cmdEditAccount_onclick(Id);
	            if (ButtonName.search("CmdDeleteAccount") > 0) cmdDeleteAccount_onclick(Id);
	        });
	        $("#tableAccountType").on("click", "input[type='button']", function () {
	            var ButtonName = $(this).attr("id");
	            var Id = $("#tableAccountType").dataTable().fnGetData(this.parentNode);

	            if (ButtonName.search("CmdEditAccountType") > 0) cmdEditAccountType_onclick(Id);
	            if (ButtonName.search("CmdDeleteAccountType") > 0) cmdDeleteAccountType_onclick(Id);
	        });
	        $("#tableAccountCashFlow").on("click", "input[type='button']", function () {
	            var ButtonName = $(this).attr("id");
	            var Id = $("#tableAccountCashFlow").dataTable().fnGetData(this.parentNode);

	            if (ButtonName.search("CmdEditAccountCashFlow") > 0) cmdEditAccountCashFlow_onclick(Id);
	            if (ButtonName.search("CmdDeleteAccountCashFlow") > 0) cmdDeleteAccountCashFlow_onclick(Id);
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

            <h2>Chart Of Accounts</h2>

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
                    <div id="tab" class="btn-group" data-toggle="buttons-radio">
                      <a href="#tabAccount" class="btn" data-toggle="tab" id="tab1">Account</a>
                      <a href="#tabAccountType" class="btn" data-toggle="tab" id="tab2">Account Type</a>
                      <a href="#tabAccountCashFlow" class="btn" data-toggle="tab" id="tab4">Account Cash Flow</a>
                      <a href="#tabAccountCategory" class="btn" data-toggle="tab" id="tab3">Account Category</a>
                    </div>
                </div>
           </div>
                 
           <div class="row">
                <div class="span12">
                    <div class="tab-content">   
                        <div class="tab-pane active" id="tabAccount">
                            <table class="table table-striped table-condensed" id="tableAccount">
                                <thead>
                                    <tr>
                                        <th colspan="1"><input runat="server" id="CmdAddAccount"  type="button" class="btn btn-primary" value="Add" onclick="cmdAddAccount_onclick()"/></th>
                                        <th colspan="5" style="text-align:right">Chart of Accounts</th>
                                    </tr>
                                    <tr>
                                        <th></th>
                                        <th></th>
                                        <th>Code</th>
                                        <th>Account</th>
                                        <th>Account Type</th>  
                                        <th>Account Cash Flow</th>
                                    </tr>
                                </thead>
                                <tbody id="tableBodyAccount"></tbody>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
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

                        <div class="tab-pane" id="tabAccountType">
                            <table class="table table-striped table-condensed" id="tableAccountType">
                                <thead>
                                    <tr>
                                        <th colspan="1"><input runat="server" id="CmdAddAccountType" type="button" class="btn btn-primary" value="Add" onclick="cmdAddAccountType_onclick()"/></th>
                                        <th colspan="4" style="text-align:right">Account Type</th>
                                    </tr>
                                    <tr>
                                        <th></th>
                                        <th></th>
                                        <th>Code</th>
                                        <th>Account Type</th>
                                        <th>Account Category</th>
                                    </tr>
                                </thead>
                                <tbody id="tableBodyAccountType"></tbody>
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

                        <div class="tab-pane" id="tabAccountCashFlow">
                            <table class="table table-striped table-condensed" id="tableAccountCashFlow">
                                <thead>
                                    <tr>
                                        <th colspan="1"><input runat="server" id="CmdAddAccountCashFlow" type="button" class="btn btn-primary" value="Add" onclick="cmdAddAccountCashFlow_onclick()"/></th>
                                        <th colspan="3" style="text-align:right">Account Cash Flow</th>
                                    </tr>
                                    <tr>
                                        <th></th>
                                        <th></th>
                                        <th>Code</th>
                                        <th>Account Cash Flow</th>
                                    </tr>
                                </thead>
                                <tbody id="tableBodyAccountCashFlow"></tbody>
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

                        <div class="tab-pane" id="tabAccountCategory">
                            <table class="table table-striped table-condensed" id="tableAccountCategory">
                                <thead>
                                    <tr>
                                        <th colspan="4" style="text-align:right;">Account Category</th>
                                    </tr>
                                    <tr>
                                        <th></th>
                                        <th></th>
                                        <th>Code</th>
                                        <th>Account Category</th>
                                    </tr>
                                </thead>
                                <tbody id="tableBodyAccountCategory"></tbody>
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

        </div>
    </div>

    <%-- Chart of Account Modal --%>
    <div id="modalAccount" class="modal hide fade in" style="display: none;">  

        <div class="modal-header">  
            <a class="close" data-dismiss="modal">×</a>  
            <h3>Chart of Account Detail</h3>  
        </div>  
        <div class="modal-body">
            <div class="row">
                <div class="form-horizontal">
                    <div class="control-group">
                        <label for="accountId" class="control-label">Account Id</label>
                        <div class="controls">
                            <input name="accountIdMem" type="text" value="" id="accountIdMem" disabled="disabled"/>      
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="accountCode" class="control-label">Account Code</label>
                        <div class="controls">
                            <input name="accountCodeMem" type="text" value="" id="accountCodeMem" required="required"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="account" class="control-label">Account</label>
                        <div class="controls">
                            <input name="accountMem" type="text" class="input-block-level" value="" id="accountMem" required="required"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="accountType" class="control-label">Account Type</label>
                        <div class="controls">
                            <input name="accountTypeMem" type="text" class="input-block-level"  value="" id="accountTypeMem" required="required"/>
                            <input name="accountTypeIdMem" type="hidden" id="accountTypeIdMem" value="" />
                        </div>
                    </div>
                    <div class="control-group"><br /></div>
                </div>
            </div>             
        </div>  
        <div class="modal-footer">  
            <a href="#" class="btn btn-success">Save</a>  
            <a href="#" class="btn" data-dismiss="modal">Close</a>  
        </div>  
    </div>
    

</asp:Content>
