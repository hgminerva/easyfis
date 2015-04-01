<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstItemDetail.aspx.cs" Inherits="wfmis.View.MstItemDetail" %>

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
    <script src="../Scripts/easyfis/easyfis.utils.v1.js"></script>
    <%--Page--%>
    <script type="text/javascript" charset="utf-8">
        // =======
        // Binding
        // =======
        var $Id = 0;             // ArticleItemId
        var $ArticleId = 0;      // ArticleId
        var $koNamespace = {};
        // Item Model
        var $koItemModel;
        $koNamespace.initItem = function (Item) {
            var self = this;

            self.Id = ko.observable(!Item ? 0 : Item.Id);
            self.ArticleId = ko.observable(!Item ? 0 : Item.ArticleId);
            self.AccountId = ko.observable(!Item ? 0 : Item.AccountId);
            self.UnitId = ko.observable(!Item ? 0 : Item.UnitId);
            self.PurchaseTaxId = ko.observable(!Item ? 0 : Item.PurchaseTaxId);
            self.SalesTaxId = ko.observable(!Item ? 0 : Item.SalesTaxId);
            self.ItemCode = ko.observable(!Item ? "" : Item.ItemCode);
            self.Item = ko.observable(!Item ? "" : Item.Item);
            self.BarCode = ko.observable(!Item ? "" : Item.BarCode);
            self.Category = ko.observable(!Item ? "" : Item.Category);
            self.Unit = ko.observable(!Item ? "" : Item.Unit);
            self.Account = ko.observable(!Item ? "" : Item.Account);
            self.PurchaseTax = ko.observable(!Item ? "" : Item.PurchaseTax);
            self.SalesTax = ko.observable(!Item ? "" : Item.SalesTax);
            self.Remarks = ko.observable(!Item ? "" : Item.Remarks);
            self.IsAsset = ko.observable(!Item ? false : Item.IsAsset);

            $('#Account').select2('data', { id: !Item ? 0 : Item.AccountId, text: !Item ? "" : Item.Account });
            $('#Unit').select2('data', { id: !Item ? 0 : Item.UnitId, text: !Item ? "" : Item.Unit });
            $('#PurchaseTax').select2('data', { id: !Item ? 0 : Item.PurchaseTaxId, text: !Item ? "" : Item.PurchaseTax });
            $('#SalesTax').select2('data', { id: !Item ? 0 : Item.SalesTaxId, text: !Item ? "" : Item.SalesTax });
            $('#IsAsset').prop('checked', !Item ? false : Item.IsAsset);

            return self;
        };
        $koNamespace.bindItem = function (Item) {
            var viewModel = $koNamespace.initItem(Item);
            ko.applyBindings(viewModel, $("#ItemDetail")[0]); //Bind the section #ItemDetail
            $koItemModel = viewModel;
        }
        $koNamespace.getItem = function (Id) {
            if (!Id) {
                $koNamespace.bindItem(null);
            } else {
                // Render item
                $.getJSON("/api/MstArticleItem/" + Id + "/Item", function (data) {
                    $koNamespace.bindItem(data);
                    $ArticleId = data.ArticleId;
                });
                // Render item prices
                $("#itemPriceTable").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/MstArticleItem/' + Id + '/ItemPrices',
                    "sAjaxDataProp": "MstArticleItemPriceData",
                    "bProcessing": true,
                    "bLengthChange": false,
                    "sPaginationType": "full_numbers",
                    "aoColumns": [
                            {
                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<button type="button" class="btn btn-primary" onclick="CmdEditItemPrice_onclick(' + data + ')">Edit</button>'
                                }
                            },
                            {
                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<button type="button" class="btn btn-danger" onclick="CmdDeleteItemPrice_onclick(' + data + ')">Delete</button>'
                                }
                            },
                            { "mData": "PriceDescription" },
                            {
                                "mData": "Price", "sWidth": "150px", "sClass": "alignRight",
                                "mRender": function (data) {
                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                }
                            }
                    ]
                }).fnSort([[2, 'asc']]);
                // Render item units
                $("#itemUnitTable").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/MstArticleItem/' + Id + '/ItemUnits',
                    "sAjaxDataProp": "MstArticleItemUnitData",
                    "bProcessing": true,
                    "bLengthChange": false,
                    "sPaginationType": "full_numbers",
                    "aoColumns": [
                            {
                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<button type="button" class="btn btn-primary" onclick="CmdEditItemUnit_onclick(' + data + ')">Edit</button>'
                                }
                            },
                            {
                                "mData": "Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<button type="button" class="btn btn-danger" onclick="CmdDeleteItemUnit_onclick(' + data + ')">Delete</button>'
                                }
                            },
                            { "mData": "Unit" },
                            {
                                "mData": "Multiplier", "sWidth": "150px", "sClass": "alignRight",
                                "mRender": function (data) {
                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                }
                            }
                    ]
                }).fnSort([[2, 'asc']]);
            }
        }
        // Item Price Model
        var $koItemPriceModel;
        $koNamespace.initItemPrice = function (ItemPrice) {
            var self = this;

            self.Id = ko.observable(!ItemPrice ? 0 : ItemPrice.Id);
            self.ArticleId = ko.observable(!ItemPrice ? 0 : ItemPrice.ArticleId);
            self.PriceDescription = ko.observable(!ItemPrice ? "NA" : ItemPrice.PriceDescription);
            self.Price = ko.observable(!ItemPrice ? 0 : ItemPrice.Price);

            return self;
        }
        $koNamespace.bindItemPrice = function (ItemPrice) {
            try {
                var viewModel = $koNamespace.initItemPrice(ItemPrice);
                ko.applyBindings(viewModel, $("#itemPriceDetail")[0]); //Bind the section #itemPriceDetail (Modal)
                $koItemPriceModel = viewModel;
            } catch (e) {
                $('#ArticleItemPriceId').val(!ItemPrice ? 0 : ItemPrice.Id).change();
                $('#ArticleItemPriceArticleId').val(!ItemPrice ? $('#ArticleId').val() : ItemPrice.ArticleId).change();
                $('#ArticleItemPriceDescription').val(!ItemPrice ? "NA" : ItemPrice.PriceDescription).change();
                $('#ArticleItemPrice').val(!ItemPrice ? 0 : ItemPrice.Price).change();
            }
        }
        // Item Unit Model
        var $koItemUnitModel;
        $koNamespace.initItemUnit = function (ItemUnit) {
            var self = this;

            self.Id = ko.observable(!ItemUnit ? 0 : ItemUnit.Id);
            self.ArticleId = ko.observable(!ItemUnit ? 0 : ItemUnit.ArticleId);
            self.UnitId = ko.observable(!ItemUnit ? 0 : ItemUnit.UnitId);
            self.Unit = ko.observable(!ItemUnit ? "" : ItemUnit.Unit);
            self.Multiplier = ko.observable(!ItemUnit ? 0 : ItemUnit.Multiplier);

            return self;
        }
        $koNamespace.bindItemUnit = function (ItemUnit) {
            try {
                var viewModel = $koNamespace.initItemUnit(ItemUnit);
                ko.applyBindings(viewModel, $("#itemUnitDetail")[0]); //Bind the section #itemUnitDetail (Modal)
                $koItemUnitModel = viewModel;
            } catch (e) {
                $koItemUnitModel['Id'](!ItemUnit ? 0 : ItemUnit.Id);
                $koItemUnitModel['ArticleId'](!ItemUnit ? 0 : ItemUnit.ArticleId);
                $koItemUnitModel['UnitId'](!ItemUnit ? 0 : ItemUnit.UnitId);
                $koItemUnitModel['Unit'](!ItemUnit ? "" : ItemUnit.Unit);
                $koItemUnitModel['Multiplier'](!ItemUnit ? 0 : ItemUnit.Multiplier);
            }
            $('#ArticleItemUnitUnit').select2('data', { id: !ItemUnit ? 0 : ItemUnit.UnitId, text: !ItemUnit ? "" : ItemUnit.Unit });
        }
        // =============
        // Button Events
        // =============
        // Item
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                // Existing record (Update)
                if (confirm('Update item?')) {
                    $.ajax({
                        url: '/api/MstArticleItem/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemModel),
                        success: function (data) {
                            location.href = 'MstItemDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                // New record (Insert)
                if (confirm('Save item?')) {
                    $.ajax({
                        url: '/api/MstArticleItem',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemModel),
                        success: function (data) {
                            location.href = 'MstItemDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdClose_onclick() {
            location.href = 'MstItemList.aspx';
        }
        // Item Price
        function CmdAddItemPrice_onclick() {
            $('#itemPriceModal').modal('show');
            $koNamespace.bindItemPrice(null);
            // FK
            $('#ArticleItemPriceArticleId').val($ArticleId).change();
        }
        function CmdEditItemPrice_onclick(ItemPriceId) {
            if (ItemPriceId > 0) {
                $('#itemPriceModal').modal('show');
                $.getJSON("/api/MstArticleItemPrice/" + ItemPriceId + "/Price", function (data) {
                    $koNamespace.bindItemPrice(data);
                });
            }
        }
        function CmdDeleteItemPrice_onclick(ItemPriceId) {
            if (confirm('Delete ' + easyFIS.getTableData($("#itemPriceTable"), ItemPriceId, "PriceDescription") + '?')) {
                $.ajax({
                    url: '/api/MstArticleItemPrice/' + ItemPriceId,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstItemDetail.aspx?Id=' + $Id;
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdSaveItemPriceModal_onclick() {
            var ArticleItemPriceId = $('#ArticleItemPriceId').val();
            if (ArticleItemPriceId == 0) {
                // New record (Insert)
                if (confirm('Save item price?')) {
                    $.ajax({
                        url: '/api/MstArticleItemPrice',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemPriceModel),
                        success: function (data) {
                            location.href = 'MstItemDetail.aspx?Id=' + $Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                // Existing record (Update)
                if (confirm('Update item price?')) {
                    $.ajax({
                        url: '/api/MstArticleItemPrice/' + ArticleItemPriceId,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemPriceModel),
                        success: function (data) {
                            location.href = 'MstItemDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdCloseItemPriceModal_onclick() {   
            $('#itemPriceModal').modal('hide');
        }
        // Item Unit
        function CmdAddItemUnit_onclick() {
            $('#itemUnitModal').modal('show');
            $koNamespace.bindItemUnit(null);
            // FK
            $('#ArticleItemUnitArticleId').val($ArticleId).change();
        }
        function CmdEditItemUnit_onclick(ItemUnitId) {
            if (ItemUnitId > 0) {
                $('#itemUnitModal').modal('show');
                $.getJSON("/api/MstArticleItemUnit/" + ItemUnitId + "/Unit", function (data) {
                    $koNamespace.bindItemUnit(data);
                });
            }
        }
        function CmdDeleteItemUnit_onclick(ItemUnitId) {
            if (confirm('Delete ' + easyFIS.getTableData($("#itemUnitTable"), ItemUnitId, "Unit") + '?')) {
                $.ajax({
                    url: '/api/MstArticleItemUnit/' + ItemUnitId,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'MstItemDetail.aspx?Id=' + $Id;
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdSaveItemUnitModal_onclick() {
            var ArticleItemUnitId = $('#ArticleItemUnitId').val();
            if (ArticleItemUnitId == 0) {
                // New record (Insert)
                if (confirm('Save item unit?')) {
                    $.ajax({
                        url: '/api/MstArticleItemUnit',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemUnitModel),
                        success: function (data) {
                            location.href = 'MstItemDetail.aspx?Id=' + $Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                // Existing record (Update)
                if (confirm('Update item unit?')) {
                    $.ajax({
                        url: '/api/MstArticleItemUnit/' + ArticleItemUnitId,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemUnitModel),
                        success: function (data) {
                            location.href = 'MstItemDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdCloseItemUnitModal_onclick() {
            $('#itemUnitModal').modal('hide');
        }
        // ===========
        // Page Events
        // ===========
        $(document).ready(function () {
            var pageSize = 20;
            // ----------------------------
            // Initialize the page controls
            // ----------------------------
            // Select Control: Item->Unit
            $('#Unit').select2({
                placeholder: 'Unit',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectUnit',
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
                $koItemModel['UnitId']($('#Unit').select2('data').id);
            });
            // Select Control: Item->Account
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
                $koItemModel['AccountId']($('#Account').select2('data').id);
            });
            // Select Control: Item->Purchase Tax
            $('#PurchaseTax').select2({
                placeholder: 'Purchase Tax',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectTax',
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
                $koItemModel['PurchaseTaxId']($('#PurchaseTax').select2('data').id);
            });
            // Select Control: Item->Sales Tax
            $('#SalesTax').select2({
                placeholder: 'Sales Tax',
                allowClear: true,
                ajax: {
                    quietMillis: 10,
                    cache: false,
                    dataType: 'json',
                    type: 'GET',
                    url: '/api/SelectTax',
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
                $koItemModel['SalesTaxId']($('#SalesTax').select2('data').id);
            });
            // Checkbox Control: Item->IsAsset
            $('#IsAsset').change(function () {
                $koItemModel['IsAsset']($('#IsAsset').prop('checked'));
            });
            // -----------------------
            // Fill the page with data
            // -----------------------
            if (easyFIS.getParameterByName("Id") != "") {
                $Id = easyFIS.getParameterByName("Id");
                $koNamespace.getItem($Id);
            } else {
                $Id = 0;
                $koNamespace.getItem(null);
            }
            // -----
            // Modal
            // -----
            $('#itemPriceModal').on('show.bs.modal', function (e) {
                if ($ArticleId == 0) return e.preventDefault()
            });
            $('#itemUnitModal').on('show.bs.modal', function (e) {
                if ($ArticleId == 0) return e.preventDefault()
                $('#ArticleItemUnitUnit').select2({
                    placeholder: 'Unit',
                    allowClear: true,
                    ajax: {
                        quietMillis: 10,
                        cache: false,
                        dataType: 'json',
                        type: 'GET',
                        url: '/api/SelectUnit',
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
                    $koItemUnitModel['UnitId']($('#ArticleItemUnitUnit').select2('data').id);
                });
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">

            <h2>Item Detail</h2>

            <p>
                <asp:SiteMapPath ID="SiteMapPath1" runat="server"></asp:SiteMapPath>
            </p>

            <br />

            <div class="row">
                <div class="span12 text-right">
                    <div class="control-group">
                        <button type="button" class="btn btn-primary" onclick="CmdSave_onclick()">Save</button>
                        <button type="button" class="btn btn-danger" onclick="CmdClose_onclick()">Close</button>
                    </div>
                </div>
            </div>

            <section id="ItemDetail">
                <div class="row">
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label">Item Code</label>
                            <div class="controls">
                                <input type="hidden" data-bind="value: Id" disabled="disabled" />
                                <input id="ArticleId" type="hidden" data-bind="value: ArticleId" disabled="disabled" />
                                <input type="hidden" data-bind="value: AccountId" disabled="disabled" />
                                <input type="hidden" data-bind="value: UnitId" disabled="disabled" />
                                <input type="hidden" data-bind="value: PurchaseTaxId" disabled="disabled" />
                                <input type="hidden" data-bind="value: SalesTaxId" disabled="disabled" />

                                <input type="text" data-bind="value: ItemCode" class="input-medium" disabled="disabled" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Item</label>
                            <div class="controls">
                                <textarea rows="2" data-bind="value: Item" class="input-block-level"></textarea>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Bar Code</label>
                            <div class="controls">
                                <input type="text" data-bind="value: BarCode" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Category</label>
                            <div class="controls">
                                <input type="text" data-bind="value: Category" class="input-medium" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Unit</label>
                            <div class="controls">
                                <input id="Unit" type="hidden" data-bind="value: Unit" class="input-medium" />
                            </div>
                        </div>
                    </div>
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label">Account</label>
                            <div class="controls">
                                <input id="Account" type="hidden" data-bind="value: Account" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Purchase Tax</label>
                            <div class="controls">
                                <input id="PurchaseTax" type="hidden" data-bind="value: PurchaseTax" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Sales Tax</label>
                            <div class="controls">
                                <input id="SalesTax" type="hidden" data-bind="value: SalesTax" class="input-xlarge" />
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Remarks </label>
                            <div class="controls">
                                <textarea rows="3" data-bind="value: Remarks" class="input-block-level"></textarea>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="checkbox">
                                <input id="IsAsset" type="checkbox" data-bind="value: IsAsset" />
                                Is Asset (e.g., Inventory, Fixed Asset, etc.)
                            </label>
                        </div>

                    </div>
                </div>
            </section>

            <br />

            <div class="row">
                <div id="tab" class="btn-group" data-toggle="buttons-radio">
                    <a href="#itemPriceTab" class="btn" data-toggle="tab" id="tab1">Prices</a>
                    <a href="#itemUnitTab" class="btn" data-toggle="tab" id="tab2">Unit Conversion</a>
                    <a href="#itemComponentTab" class="btn" data-toggle="tab" id="tab3">Components</a>
                    <a href="#itemInventoryTab" class="btn" data-toggle="tab" id="tab4">Inventory</a>
                </div>
            </div>

            <br />

            <%--Tab Content--%>

            <div class="tab-content">
                <%--Price Tab--%>
                <div id="itemPriceTab" class="tab-pane active">
                    <table id="itemPriceTable" class="table table-striped table-condensed">
                        <thead>
                            <tr>
                                <th colspan="1">
                                    <button id="CmdAddItemPrice" type="button" class="btn btn-primary" onclick="CmdAddItemPrice_onclick()">Add</button></th>
                                <th colspan="3" style="text-align: right">Item Price List</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Price Description</th>
                                <th>Price</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>
                        </tfoot>
                    </table>
                </div> 
                <%--Unit Tab--%>
                <div id="itemUnitTab" class="tab-pane">
                    <table id="itemUnitTable" class="table table-striped table-condensed">
                        <thead>
                            <tr>
                                <th colspan="1">
                                    <button id="CmdAddItemUnit" type="button" class="btn btn-primary" onclick="CmdAddItemUnit_onclick()">Add</button></th>
                                <th colspan="3" style="text-align: right">Item Unit Conversion Table</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Unit</th>
                                <th>Multiplier</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                            </tr>
                        </tfoot>
                    </table>
                </div> 

            </div>

            <%--Modal Content--%>

            <%--Item Price Modal--%>
            <section id="itemPriceDetail">
            <div id="itemPriceModal" class="modal hide fade in" style="display: none;">  
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Item Price Detail</h3>  
                </div>  
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <label class="control-label">Price Description</label>
                                <div class="controls">
                                    <input id="ArticleItemPriceId" type="hidden" data-bind="value: Id" disabled="disabled" />
                                    <input id="ArticleItemPriceArticleId" type="hidden" data-bind="value: ArticleId" disabled="disabled" />
                                    <input id="ArticleItemPriceDescription" data-bind="value: PriceDescription" type="text" class="input-medium"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="Customer" class="control-label">Price</label>
                                <div class="controls">
                                    <input id="ArticleItemPrice" data-bind="value: Price" type="text" class="input-medium pagination-right" />
                                </div>
                            </div>
                        </div>
                    </div>             
                </div>  
                <div class="modal-footer">  
                    <a href="#" class="btn btn-primary" onclick="CmdSaveItemPriceModal_onclick()" >Save</a>  
                    <a href="#" class="btn btn-danger" onclick="CmdCloseItemPriceModal_onclick()" >Close</a>  
                </div>  
            </div>
            </section>

            <%--Item Unit Modal--%>
            <section id="itemUnitDetail">
            <div id="itemUnitModal" class="modal hide fade in" style="display: none;">  
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Item Unit Detail</h3>  
                </div>  
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <label class="control-label">Unit</label>
                                <div class="controls">
                                    <input id="ArticleItemUnitId" type="hidden" data-bind="value: Id" disabled="disabled" />
                                    <input id="ArticleItemUnitArticleId" type="hidden" data-bind="value: ArticleId" disabled="disabled" />
                                    <input id="ArticleItemUnitUnitId" type="hidden" data-bind="value: UnitId" disabled="disabled" />
                                    <input id="ArticleItemUnitUnit" type="hidden" data-bind="value: Unit" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Multiplier</label>
                                <div class="controls">
                                    <input id="ArticleItemUnitMultiplier" data-bind="value: Multiplier" type="text" class="input-medium pagination-right" />
                                </div>
                            </div>
                        </div>
                    </div>             
                </div>  
                <div class="modal-footer">  
                    <a href="#" class="btn btn-primary" onclick="CmdSaveItemUnitModal_onclick()" >Save</a>  
                    <a href="#" class="btn btn-danger" onclick="CmdCloseItemUnitModal_onclick()" >Close</a>  
                </div>  
            </div>
            </section>
                            
        </div>

    </div>

</asp:Content>
