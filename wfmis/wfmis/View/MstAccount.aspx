<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstAccount.aspx.cs" Inherits="wfmis.View.MstAccount" %>

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
	    var $AccountTable;
	    var $AccountTypeTable;
	    var $AccountCategoryTable;

	    $(function () {
	        $AccountTable = $("#tableAccount").dataTable({
	                            "sPaginationType": "full_numbers",
	                            "bProcessing": true,
	                            "bRetrieve": true,
	                            "sAjaxSource": '/api/MstAccount',
	                            "sAjaxDataProp": "",
	                            "bLengthChange": false,
	                            "aoColumns": [
                                        {
                                            "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                            "fnRender": function (data) {
                                                return '<a data-id=' + data + ' data-toggle="modal" href="#modalAccount" class="open-modalAccount btn btn-primary">Edit</a>'
                                            }
                                        },
                                        {
                                            "mDataProp": null, "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                            "sDefaultContent": '<button type="button" name="deleteAccount" class="btn btn-danger">Delete</button>'
                                        },
	                                    { "mData": "AccountCode" },
	                                    { "mData": "Account" },
	                                    { "mData": "AccountType" }
	                            ]
	        });
	    });

	    $(function () {
	        $AccountTypeTable = $("#tableAccountType").dataTable({
	                                "sPaginationType": "full_numbers",
	                                "bProcessing": true,
	                                "bRetrieve": true,
	                                "sAjaxSource": '/api/MstAccountType',
	                                "sAjaxDataProp": "",
	                                "bLengthChange": false,
	                                "aoColumns": [
                                        {
                                            "mDataProp": null, "bSearchable": false, "bSortable": false,  "sWidth": "40px",
                                            "sDefaultContent": '<button type="button" name="editAccountType" class="btn btn-primary">Edit</button>'
                                        },
                                        {
                                            "mDataProp": null, "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                            "sDefaultContent": '<button type="button" name="deleteAccountType" class="btn btn-danger">Delete</button>'
                                        },
	                                    { "mData": "AccountTypeCode" },
	                                    { "mData": "AccountType" },
	                                    { "mData": "AccountCategory" }
	                                ],
	        });
	    });

	    $(function () {
	        $AccountCategory = $("#tableAccountCategory").dataTable({
	                                    "sPaginationType": "full_numbers",
	                                    "bProcessing": true,
	                                    "bRetrieve": true,
	                                    "sAjaxSource": '/api/MstAccountCategory',
	                                    "sAjaxDataProp": "",
	                                    "bLengthChange": false,
	                                    "aoColumns": [
                                            { "mData": "AccountCategoryCode" },
                                            { "mData": "AccountCategory" }
	                                    ]
	                                });
	    });



	    $(document).on("click", ".open-modalAccount", function () {
	        var $Id = $(this).data('id');

	        // Account Type list
	        var $AccountTypeMapped = {};
	        var $AccountTypeLabel = [];
	        $.getJSON("/api/MstAccountType", function (data) {
	            $.each(data, function (i, item) {
	                $AccountTypeMapped[item.AccountType] = item.Id
	                $AccountTypeLabel.push(item.AccountType)
	            });

	            $('#accountTypeMem').typeahead({
	                local: $AccountTypeLabel,
	                updater: function (item) {
	                    $("#accountTypeIdMem").val($AccountTypeMapped[item]);
	                }
	            });
	        });

            // Start Loading Chart of Account 
	        if ($Id > 0) {
	            $.getJSON("/api/MstAccount/" + $Id, function (data) {
	                $("#accountIdMem").val($Id);
	                $("#accountCodeMem").val(data.AccountCode);
	                $("#accountMem").val(data.Account);
	                $("#accountTypeMem").val(data.AccountType);
	            });
	        } else {
	            $('#accountIdMem').val(0);
	            $('#accountCodeMem').val(null);
	            $('#accountMem').val(null);
	            $('#accountTypeMem').val(null);
	        }
	    });


        
	</script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">

        <div class="container">

            <h2>Chart Of Accounts</h2>

            <p><asp:SiteMapPath ID="SiteMapPath1" Runat="server"></asp:SiteMapPath></p>

            <div id="tab" class="btn-group" data-toggle="buttons-radio">
              <a href="#account" class="btn" data-toggle="tab" id="tab1">Account</a>
              <a href="#accountType" class="btn" data-toggle="tab" id="tab2">Account Type</a>
              <a href="#accountCategory" class="btn" data-toggle="tab" id="tab3">Account Category</a>
            </div>
            
            <div class="tab-content">

              <div class="tab-pane active" id="account">
                  <br />
                  <div class="span10">
                      <table class="table table-striped table-condensed" id="tableAccount">
                            <thead>
                                <tr>
                                    <th colspan="1"><a data-toggle="modal" data-id="0" href="#modalAccount" class="open-modalAccount btn btn-primary">Add</a></th>
                                    <th colspan="1"><a data-id="0" href="MstAccountPreview.aspx" class="btn btn-primary">Preview</a></th>
                                    <th colspan="3" style="text-align:right">Chart of Accounts</th>
                                </tr>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th>Code</th>
                                    <th>Account</th>
                                    <th>Account Type</th>  
                                </tr>
                            </thead>
                            <tbody id="tableBodyAccount"></tbody>
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

              <div class="tab-pane" id="accountType">
                  <br />
                  <div class="span10">
                      <table class="table table-striped table-condensed" id="tableAccountType">
                            <thead>
                                <tr>
                                    <th colspan="1"><button type="button" name="addAccountType" class="btn btn-primary">Add</button></th>
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

              <div class="tab-pane" id="accountCategory">
                  <br />
                  <div class="span10">
                      <table class="table table-striped table-condensed" id="tableAccountCategory">
                            <thead>
                                <tr>
                                    <th colspan="2" style="text-align:right;">Account Category</th>
                                </tr>
                                <tr>
                                    <th>Code</th>
                                    <th>Account Category</th>
                                </tr>
                            </thead>
                            <tbody id="tableBodyAccountCategory"></tbody>
                            <tfoot>
                                <tr>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </tfoot>
                      </table>
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
    <%-- Chart of Account Modal ends here --%>

</asp:Content>
