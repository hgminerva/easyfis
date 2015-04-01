<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstCustomer.aspx.cs" Inherits="wfmis.View.MstCustomer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <%--Datatables--%>
    <link href="../Content/datatable/demo_page.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table.css" rel="stylesheet" />
    <link href="../Content/datatable/demo_table_jui.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables.css" rel="stylesheet" />
    <link href="../Content/datatable/jquery.dataTables_themeroller.css" rel="stylesheet" />
    
    <script src="../Scripts/datatable/jquery.dataTables.js"></script>

    <%--Select2--%>
    <link href="../Content/bootstrap-select2/select2.css" rel="stylesheet" />
    <script type='text/javascript' src="../Scripts/bootstrap-select2/select2.js"></script>

    <%--Knockout Binding--%>
    <script type='text/javascript' src="../Scripts/knockout/knockout-2.3.0.js"></script>
    <script type='text/javascript' src="../Scripts/knockout/json2.js"></script>

    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v1.js"></script>

    <%--Page--%>
    <script type="text/javascript" charset="utf-8"> 
        var $ArticleCustomerDataTable;
        var $koNameSpace = {};
        var $koCustomerModel;

        // Page Knockout Binding
        $koNameSpace.InitCustomerDetail = function (Customer)
        {
            var $Model;
            if (!Customer) {
                // New Record
                $Model = {
                    Id: ko.observable(0),
                    ArticleId: ko.observable(0),
                    CustomerCode: ko.observable(),
                    Customer: ko.observable(),
                    AccountId: ko.observable(),
                    Account: ko.observable(),
                    Address: ko.observable(),
                    ContactNumbers: ko.observable(),
                    ContactPerson: ko.observable(),
                    EmailAddress: ko.observable()
                };
            } else {
                // Existing Record
                $Model = {
                    Id: ko.observable(Customer.Id),
                    ArticleId: ko.observable(Customer.ArticleId),
                    CustomerCode: ko.observable(Customer.CustomerCode),
                    Customer: ko.observable(Customer.Customer),
                    AccountId: ko.observable(Customer.AccountId),
                    Account: ko.observable(),
                    Address: ko.observable(Customer.Address),
                    ContactNumbers: ko.observable(Customer.ContactNumbers),
                    ContactPerson: ko.observable(Customer.ContactPerson),
                    EmailAddress: ko.observable(Customer.EmailAddress)
                };
                $('#Account').select2('data', { id: Customer.AccountId, text: Customer.Account });
            }
            return $Model;
        };

        $koNameSpace.BindCustomerDetail = function (Customer) {
            try {
                // New binding
                var $Model = $koNameSpace.InitCustomerDetail(Customer);
                ko.applyBindings($Model);
                $koCustomerModel = $Model;
            }
            catch(e) {
                // Update binding 
                $koCustomerModel['Id'](!Customer ? 0 : Customer.Id);
                $koCustomerModel['ArticleId'](!Customer ? 0 : Customer.ArticleId);
                $koCustomerModel['CustomerCode'](!Customer ? "" : Customer.CustomerCode);
                $koCustomerModel['Customer'](!Customer ? "" : Customer.Customer);
                $koCustomerModel['AccountId'](!Customer ? 0 : Customer.AccountId);
                $koCustomerModel['Account'](!Customer ? "" : Customer.Account);
                $koCustomerModel['Address'](!Customer ? "" : Customer.Address);
                $koCustomerModel['ContactNumbers'](!Customer ? "" : Customer.ContactNumbers);
                $koCustomerModel['ContactPerson'](!Customer ? "" : Customer.ContactPerson);
                $koCustomerModel['EmailAddress'](!Customer ? "" : Customer.EmailAddress);

                if (!!Customer) $('#Account').select2('data', { id: Customer.AccountId, text: Customer.Account });
            }
        }

        // On Load
        $(document).ready(function () {
            var pageSize = 20;
            // Select Control: Detail Account
            $('#Account').select2({
                placeholder: 'Account',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectAccount',
                    data: function (term, page) {
                        return {
                            pageSize: pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $koCustomerModel['AccountId']($('#Account').select2('data').id);
            });

        });

        // Customer Datatable
        $(function () {
            $ArticleCustomerDataTable = $("#TableArticleCustomerList").dataTable({
                "bServerSide": true,
                "sAjaxSource": '/api/MstArticleCustomer',
                "sAjaxDataProp": "MstArticleCustomerData",
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
                                return '<button type="button" class="btn btn-danger" onclick="CmdDelete_onclick(' + data + ')">Delete</button>'
                            }
                        },
                        { "mData": "CustomerCode", "sWidth": "150px" },
                        { "mData": "Customer" },
                        { "mData": "ContactNumbers", "sWidth": "300px" }
                ]
            });

            $ArticleCustomerDataTable.fnSort([[2, 'asc']]);
        });

        // Click events
        function CmdDelete_onclick(Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#TableArticleCustomerList"), Id, "Customer") + '?')) {
                $.ajax({
                    url: '/api/MstArticleCustomer/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstCustomer.aspx';
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        function CmdAdd_onclick() {
            $koNameSpace.BindCustomerDetail(null);
            $('#ModalCustomer').modal('show');
        }

        function CmdEdit_onclick(Id) {
            if (Id > 0) {
                $('#ModalCustomer').modal('show');
                $.getJSON("/api/MstArticleCustomer/" + Id, function (data) {
                    $koNameSpace.BindCustomerDetail(data);
                });
            }
        }

        function CmdSaveModal_onclick() {
            var Id = $koCustomerModel.Id();
            if (Id == 0) {
                if (confirm('Save customer?')) {
                    $.ajax({
                        url: '/api/MstArticleCustomer',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koCustomerModel),
                        success: function (data) {
                            location.href = 'MstCustomer.aspx';
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                if (confirm('Update customer?')) {
                    $.ajax({
                        url: '/api/MstArticleCustomer/' + Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koCustomerModel),
                        success: function (data) {
                            location.href = 'MstCustomer.aspx';
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            }
        }

        function CmdCloseModal_onclick() {
            $('#ModalCustomer').modal('hide');
        }

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Customer</h2>

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
                    <table id="TableArticleCustomerList" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="1"><button id="CmdAdd" type="button" class="btn btn-primary" onclick="CmdAdd_onclick()">Add</button></th>
                                <th colspan="4" style="text-align:right">Customer List</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Code</th>
                                <th>Customer</th>
                                <th>Contact Numbers</th>  
                            </tr>
                        </thead>
                        <tbody id="TableBodyArticleCustomerList"></tbody>
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

    </div>

    <div id="ModalCustomer" class="modal hide fade in" style="display: none;">  
        <div class="modal-header">  
            <a class="close" data-dismiss="modal">×</a>  
            <h3>Customer Detail</h3>  
        </div>  
        <div class="modal-body">
            <div class="row">
                <div class="form-horizontal">
                    <div class="control-group">
                        <label for="CustomerCode" class="control-label">Customer Code</label>
                        <div class="controls">
                            <input id="CustomerCode" data-bind="value: CustomerCode" type="text" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Customer" class="control-label">Customer</label>
                        <div class="controls">
                            <input id="Customer" data-bind="value: Customer" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Account" class="control-label">Account</label>
                        <div class="controls">
                            <input id="Account" data-bind="value: Account" type="hidden" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="Address" class="control-label">Address</label>
                        <div class="controls">
                            <textarea rows="3" id="Address" data-bind="value: Address" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="ContactNumbers" class="control-label">Contact Numbers</label>
                        <div class="controls">
                            <input  id="ContactNumbers" data-bind="value: ContactNumbers" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="ContactPerson" class="control-label">Contact Person</label>
                        <div class="controls">
                            <input  id="ContactPerson" data-bind="value: ContactPerson" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="EmailAddress" class="control-label">Email Address</label>
                        <div class="controls">
                            <input  id="EmailAddress" data-bind="value: EmailAddress" type="email" class="input-xlarge" />
                        </div>
                    </div>
                </div>
            </div>             
        </div>  
        <div class="modal-footer">  
            <a href="#" class="btn btn-primary" onclick="CmdSaveModal_onclick()" >Save</a>  
            <a href="#" class="btn btn-danger" onclick="CmdCloseModal_onclick()" >Close</a>  
        </div>  
    </div>
</asp:Content>
