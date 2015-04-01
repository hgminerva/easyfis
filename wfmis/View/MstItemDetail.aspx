<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstItemDetail.aspx.cs" Inherits="wfmis.View.MstItemDetail" %>

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
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';
        var $CurrentItemPurchaseAccountId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemPurchaseAccountId %>';
        var $CurrentItemPurchaseAccount = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemPurchaseAccount %>';
        var $CurrentItemSalesAccountId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemSalesAccountId %>';
        var $CurrentItemSalesAccount = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemSalesAccount %>';
        var $CurrentItemCostAccountId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemCostAccountId %>';
        var $CurrentItemCostAccount = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemCostAccount %>';
        var $CurrentItemAssetAccountId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemAssetAccountId %>';
        var $CurrentItemAssetAccount = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentItemAssetAccount %>';

        var $Id = 0;             
        var $ArticleId = 0;      
        var $koNamespace = {};
        var $pageSize = 20;

        // Bindings
        var $koItemModel;
        var $koItemPriceModel;
        var $koItemUnitModel;
        var $koItemComponentModel;

        var $Modal01 = false;
        var $Modal02 = false;
        var $Modal03 = false;

        $koNamespace.initItem = function (Item) {
            var self = this;

            self.Id = ko.observable(!Item ? 0 : Item.Id);
            self.ArticleId = ko.observable(!Item ? 0 : Item.ArticleId);
            self.ItemCode = ko.observable(!Item ? "" : Item.ItemCode);
            self.Item = ko.observable(!Item ? "" : Item.Item);
            self.BarCode = ko.observable(!Item ? "" : Item.BarCode);
            self.Category = ko.observable(!Item ? "" : Item.Category);
            self.UnitId = ko.observable(!Item ? 0 : Item.UnitId);
            self.Unit = ko.observable(!Item ? "" : Item.Unit);
            self.AccountId = ko.observable(!Item ? $CurrentItemAssetAccountId : Item.AccountId);
            self.Account = ko.observable(!Item ? $CurrentItemAssetAccount : Item.Account);
            self.PurchaseTaxId = ko.observable(!Item ? 0 : Item.PurchaseTaxId);
            self.PurchaseTax = ko.observable(!Item ? "" : Item.PurchaseTax);
            self.SalesTaxId = ko.observable(!Item ? 0 : Item.SalesTaxId);
            self.SalesTax = ko.observable(!Item ? "" : Item.SalesTax);
            self.PurchaseAccountId = ko.observable(!Item ? $CurrentItemPurchaseAccountId : Item.PurchaseAccountId);
            self.PurchaseAccount = ko.observable(!Item ? $CurrentItemPurchaseAccount : Item.PurchaseAccount);
            self.SalesAccountId = ko.observable(!Item ? $CurrentItemSalesAccountId : Item.SalesAccountId);
            self.SalesAccount = ko.observable(!Item ? $CurrentItemSalesAccount : Item.SalesAccount);
            self.CostAccountId = ko.observable(!Item ? $CurrentItemCostAccountId : Item.CostAccountId);
            self.CostAccount = ko.observable(!Item ? $CurrentItemCostAccount : Item.CostAccount);
            self.Remarks = ko.observable(!Item ? "" : Item.Remarks);
            self.IsAsset = ko.observable(!Item ? false : Item.IsAsset);
            self.AssetManualNumber = ko.observable(!Item ? "" : Item.AssetManualNumber);
            self.AssetAccountId = ko.observable(!Item ? $CurrentItemAssetAccountId : Item.AssetAccountId);
            self.AssetAccount = ko.observable(!Item ? $CurrentItemAssetAccount : Item.AssetAccount);
            self.AssetDateAcquired = ko.observable(!Item ? easyFIS.getCurrentDate() : Item.AssetDateAcquired);
            self.AssetLifeInYears = ko.observable(!Item ? 0 : Item.AssetLifeInYears);
            self.AssetSalvageValue = ko.observable(!Item ? 0 : Item.AssetSalvageValue);
            self.AssetDepreciationAccountId = ko.observable(!Item ? 0 : Item.AssetDepreciationAccountId);
            self.AssetDepreciationAccount = ko.observable(!Item ? "" : Item.AssetDepreciationAccount);
            self.AssetDepreciationExpenseAccountId = ko.observable(!Item ? 0 : Item.AssetDepreciationExpenseAccountId);
            self.AssetDepreciationExpenseAccount = ko.observable(!Item ? "" : Item.AssetDepreciationExpenseAccount);

            $('#Account').select2('data', { id: !Item ? $CurrentItemAssetAccountId : Item.AccountId, text: !Item ? $CurrentItemAssetAccount : Item.Account });
            $('#Unit').select2('data', { id: !Item ? 0 : Item.UnitId, text: !Item ? "" : Item.Unit });
            $('#PurchaseTax').select2('data', { id: !Item ? 0 : Item.PurchaseTaxId, text: !Item ? "" : Item.PurchaseTax });
            $('#SalesTax').select2('data', { id: !Item ? 0 : Item.SalesTaxId, text: !Item ? "" : Item.SalesTax });
            $('#PurchaseAccount').select2('data', { id: !Item ? $CurrentItemPurchaseAccountId : Item.PurchaseAccountId, text: !Item ? $CurrentItemPurchaseAccount : Item.PurchaseAccount });
            $('#SalesAccount').select2('data', { id: !Item ? $CurrentItemSalesAccountId : Item.SalesAccountId, text: !Item ? $CurrentItemSalesAccount : Item.SalesAccount });
            $('#CostAccount').select2('data', { id: !Item ? $CurrentItemCostAccountId : Item.CostAccountId, text: !Item ? $CurrentItemCostAccount : Item.CostAccount });
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
                                "mData": "Line1Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<input runat="server" id="CmdEditItemPrice" type="button" class="btn btn-primary" value="Edit"/>'
                                }
                            },
                            {
                                "mData": "Line1Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<input runat="server" id="CmdDeleteItemPrice"  type="button" class="btn btn-danger" value="Delete"/>'
                                }
                            },
                            { "mData": "Line1PriceDescription" },
                            {
                                "mData": "Line1Price", "sWidth": "150px", "sClass": "alignRight",
                                "mRender": function (data) {
                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                }
                            },
                            {
                                "mData": "Line1MarkUpPercentage", "sWidth": "150px", "sClass": "alignRight",
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
                                "mData": "Line2Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<input runat="server" id="CmdEditItemUnit" type="button" class="btn btn-primary" value="Edit"/>'
                                }
                            },
                            {
                                "mData": "Line2Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<input runat="server" id="CmdDeleteItemUnit" type="button" class="btn btn-danger" value="Delete"/>'
                                }
                            },
                            { "mData": "Line2Unit" },
                            {
                                "mData": "Line2Multiplier", "sWidth": "150px", "sClass": "alignRight",
                                "mRender": function (data) {
                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                }
                            }
                    ]
                }).fnSort([[2, 'asc']]);
                // Render item components
                $("#itemComponentTable").dataTable({
                    "bServerSide": true,
                    "sAjaxSource": '/api/MstArticleItem/' + Id + '/ItemComponents',
                    "sAjaxDataProp": "MstArticleItemComponentData",
                    "bProcessing": true,
                    "bLengthChange": false,
                    "sPaginationType": "full_numbers",
                    "aoColumns": [
                            {
                                "mData": "Line3Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<input runat="server" id="CmdEditItemComponent" type="button" class="btn btn-primary" value="Edit"/>'
                                }
                            },
                            {
                                "mData": "Line3Id", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                "mRender": function (data) {
                                    return '<input runat="server" id="CmdDeleteItemComponent"  type="button" class="btn btn-danger" value="Delete"/>'
                                }
                            },
                            {
                                "mData": "Line3Quantity", "sWidth": "150px", "sClass": "alignRight",
                                "mRender": function (data) {
                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                }
                            },
                            { "mData": "Line3Unit", "sWidth": "150px" },
                            { "mData": "Line3ComponentArticle" },
                    ]
                }).fnSort([[2, 'asc']]);
            }
        }
        $koNamespace.initItemPrice = function (ItemPrice) {
            var self = this;

            self.Line1Id = ko.observable(!ItemPrice ? 0 : ItemPrice.Line1Id);
            self.Line1ArticleId = ko.observable(!ItemPrice ? $ArticleId : ItemPrice.Line1ArticleId);
            self.Line1PriceDescription = ko.observable(!ItemPrice ? "NA" : ItemPrice.Line1PriceDescription);
            self.Line1Price = ko.observable(!ItemPrice ? 0 : ItemPrice.Line1Price);
            self.Line1MarkUpPercentage = ko.observable(!ItemPrice ? 0 : ItemPrice.Line1MarkUpPercentage);

            return self;
        }
        $koNamespace.bindItemPrice = function (ItemPrice) {
            try {
                var viewModel = $koNamespace.initItemPrice(ItemPrice);
                ko.applyBindings(viewModel, $("#itemPriceDetail")[0]); //Bind the section #itemPriceDetail (Modal)
                $koItemPriceModel = viewModel;
            } catch (e) {
                $('#Line1Id').val(!ItemPrice ? 0 : ItemPrice.Line1Id).change();
                $('#Line1ArticleId').val(!ItemPrice ? $ArticleId : ItemPrice.Line1ArticleId).change();
                $('#Line1PriceDescription').val(!ItemPrice ? "NA" : ItemPrice.Line1PriceDescription).change();
                $('#Line1Price').val(!ItemPrice ? 0 : ItemPrice.Line1Price).change();
                $('#Line1MarkUpPercentage').val(!ItemPrice ? 0 : ItemPrice.Line1MarkUpPercentage).change();
            }
        }
        $koNamespace.initItemUnit = function (ItemUnit) {
            var self = this;

            self.Line2Id = ko.observable(!ItemUnit ? 0 : ItemUnit.Line2Id);
            self.Line2ArticleId = ko.observable(!ItemUnit ? $ArticleId : ItemUnit.Line2ArticleId);
            self.Line2UnitId = ko.observable(!ItemUnit ? 0 : ItemUnit.Line2UnitId);
            self.Line2Unit = ko.observable(!ItemUnit ? "" : ItemUnit.Line2Unit);
            self.Line2Multiplier = ko.observable(!ItemUnit ? 0 : ItemUnit.Line2Multiplier);

            return self;
        }
        $koNamespace.bindItemUnit = function (ItemUnit) {
            try {
                var viewModel = $koNamespace.initItemUnit(ItemUnit);
                ko.applyBindings(viewModel, $("#itemUnitDetail")[0]); //Bind the section #itemUnitDetail (Modal)
                $koItemUnitModel = viewModel;
            } catch (e) {
                $koItemUnitModel['Line2Id'](!ItemUnit ? 0 : ItemUnit.Line2Id);
                $koItemUnitModel['Line2ArticleId'](!ItemUnit ? $ArticleId : ItemUnit.Line2ArticleId);
                $koItemUnitModel['Line2UnitId'](!ItemUnit ? 0 : ItemUnit.Line2UnitId);
                $koItemUnitModel['Line2Unit'](!ItemUnit ? "" : ItemUnit.Line2Unit);
                $koItemUnitModel['Line2Multiplier'](!ItemUnit ? 0 : ItemUnit.Line2Multiplier);
            }
            $('#Line2Unit').select2('data', { id: !ItemUnit ? 0 : ItemUnit.Line2UnitId, text: !ItemUnit ? "" : ItemUnit.Line2Unit });
        }
        $koNamespace.initItemComponent = function (ItemComponent) {
            var self = this;

            self.Line3Id = ko.observable(!ItemComponent ? 0 : ItemComponent.Line3Id);
            self.Line3ArticleId = ko.observable(!ItemComponent ? $ArticleId : ItemComponent.Line3ArticleId);
            self.Line3ComponentArticleId = ko.observable(!ItemComponent ? 0 : ItemComponent.Line3ComponentArticleId);
            self.Line3ComponentArticle = ko.observable(!ItemComponent ? "" : ItemComponent.Line3ComponentArticle);
            self.Line3Quantity = ko.observable(!ItemComponent ? 0 : ItemComponent.Line3Quantity);
            self.Line3UnitId = ko.observable(!ItemComponent ? 0 : ItemComponent.Line3UnitId);
            self.Line3Unit = ko.observable(!ItemComponent ? "" : ItemComponent.Line3Unit);

            return self;
        }
        $koNamespace.bindItemComponent = function (ItemComponent) {
            try {
                var viewModel = $koNamespace.initItemComponent(ItemComponent);
                ko.applyBindings(viewModel, $("#itemComponentDetail")[0]); 
                $koItemComponentModel = viewModel;
            } catch (e) {
                $koItemComponentModel['Line3Id'](!ItemComponent ? 0 : ItemComponent.Line3Id);
                $koItemComponentModel['Line3ArticleId'](!ItemComponent ? $ArticleId : ItemComponent.Line3ArticleId);
                $koItemComponentModel['Line3ComponentArticleId'](!ItemComponent ? 0 : ItemComponent.Line3ComponentArticleId);
                $koItemComponentModel['Line3ComponentArticle'](!ItemComponent ? "" : ItemComponent.Line3ComponentArticle);
                $koItemComponentModel['Line3UnitId'](!ItemComponent ? 0 : ItemComponent.Line3UnitId);
                $koItemComponentModel['Line3Unit'](!ItemComponent ? "" : ItemComponent.Line3Unit);
                $koItemComponentModel['Line3Quantity'](!ItemComponent ? 0 : ItemComponent.Line3Quantity);
            }
            $('#Line3ComponentArticle').select2('data', { id: !ItemComponent ? 0 : ItemComponent.Line3ComponentArticleId, text: !ItemComponent ? "" : ItemComponent.Line3ComponentArticle });
            $('#Line3Unit').select2('data', { id: !ItemComponent ? 0 : ItemComponent.Line3UnitId, text: !ItemComponent ? "" : ItemComponent.Line3Unit });
        }

        // Events
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
        function CmdAddItemPrice_onclick() {
            if ($ArticleId > 0) {
                $('#itemPriceModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindItemPrice(null);
                // FK
                $('#ArticleItemPriceArticleId').val($ArticleId).change();
            } else {
                alert("Item not yet saved.");
            }
        }
        function CmdEditItemPrice_onclick(Line1Id) {
            if (Line1Id > 0) {
                $.ajax({
                    url: '/api/MstArticleItemPrice/' + Line1Id + "/Price",
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindItemPrice(data);
                        $('#itemPriceModal').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteItemPrice_onclick(Line1Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#itemPriceTable"), Line1Id, "Line1Id", "Line1PriceDescription") + '?')) {
                $.ajax({
                    url: '/api/MstArticleItemPrice/' + Line1Id,
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
            var Line1Id = $('#Line1Id').val();

            $('#itemPriceModal').modal('hide');
            $Modal01 = false;

            if (Line1Id == 0) {
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
                        url: '/api/MstArticleItemPrice/' + Line1Id,
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
            $Modal01 = false;
        }
        function CmdAddItemUnit_onclick() {
            if ($ArticleId > 0) {
                $('#itemUnitModal').modal('show');
                $Modal02 = true;
                $koNamespace.bindItemUnit(null);
                // FK
                $('#Line2ArticleId').val($ArticleId).change();
            } else {
                alert("Item not yet saved.");
            }
        }
        function CmdEditItemUnit_onclick(Line2Id) {
            if (Line2Id > 0) {
                $.ajax({
                    url: '/api/MstArticleItemUnit/' + Line2Id + "/Unit",
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindItemUnit(data);
                        $('#itemUnitModal').modal('show');
                        $Modal02 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteItemUnit_onclick(Line2Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#itemUnitTable"), Line2Id, "Line2Id","Line2Unit") + '?')) {
                $.ajax({
                    url: '/api/MstArticleItemUnit/' + Line2Id,
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
            var Line2Id = $('#Line2Id').val();

            $('#itemUnitModal').modal('hide');
            $Modal02 = false;

            if (Line2Id == 0) {
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
                        url: '/api/MstArticleItemUnit/' + Line2Id,
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
            $Modal02 = false;
        }
        function CmdAddItemComponent_onclick() {
            if ($ArticleId > 0) {
                $.getJSON("/api/MstArticleItem/" + $ArticleId + "/ItemByArticleId", function (data) {
                    if (data) {
                        if (data.IsAsset == false) {
                            $('#itemComponentModal').modal('show');
                            $Modal03 = true;
                            $koNamespace.bindItemComponent(null);
                            // FK
                            $('#Line3ArticleId').val($ArticleId).change();
                        } else {
                            alert("Not allowed");
                        }
                    } else {
                        alert("Not allowed");
                    }
                });
            } else {
                alert("Item not yet saved.");
            }
        }
        function CmdEditItemComponent_onclick(Line3Id) {
            if (Line3Id > 0) {
                $.ajax({
                    url: '/api/MstArticleItemComponent/' + Line3Id + "/Component",
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindItemComponent(data);
                        $('#itemComponentModal').modal('show');
                        $Modal03 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteItemComponent_onclick(Line3Id) {
            if (confirm('Delete ' + easyFIS.getTableData($("#itemComponentTable"), Line3Id, "Line3Id", "Line3ComponentArticle") + '?')) {
                $.ajax({
                    url: '/api/MstArticleItemComponent/' + Line3Id,
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
        function CmdSaveItemComponentModal_onclick() {
            var Line3Id = $('#Line3Id').val();

            $('#itemComponentModal').modal('hide');
            $Modal03 = false;

            if (Line3Id == 0) {
                // New record (Insert)
                if (confirm('Save item component?')) {
                    $.ajax({
                        url: '/api/MstArticleItemComponent',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemComponentModel),
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
                if (confirm('Update item component?')) {
                    $.ajax({
                        url: '/api/MstArticleItemComponent/' + Line3Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koItemComponentModel),
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
        function CmdCloseItemComponentModal_onclick() {
            $('#itemComponentModal').modal('hide');
            $Modal03 = false;
        }

        // Select2
        function Select2_Unit() {
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
                $koItemModel['UnitId']($('#Unit').select2('data').id);
            });
        }
        function Select2_Account() {
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
                $koItemModel['AccountId']($('#Account').select2('data').id);
            });
        }
        function Select2_PurchaseTax() {
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
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                },
                formatResult: function (data) {
                    var JSONObject = JSON.parse(data.text);
                    return JSONObject["TaxCode"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["TaxCode"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            }).change(function () {
                $koItemModel['PurchaseTaxId']($('#PurchaseTax').select2('data').id);
            });
        }
        function Select2_SalesTax() {
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
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                },
                formatResult: function (data) {
                    var JSONObject = JSON.parse(data.text);
                    return JSONObject["TaxCode"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["TaxCode"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            }).change(function () {
                $koItemModel['SalesTaxId']($('#SalesTax').select2('data').id);
            });
        }
        function Select2_ArticleItemUnitUnit() {
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
                $koItemUnitModel['UnitId']($('#ArticleItemUnitUnit').select2('data').id);
            });
        }
        function Select2_CostAccount() {
            $('#CostAccount').select2({
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
                $koItemModel['CostAccountId']($('#CostAccount').select2('data').id);
            });
        }
        function Select2_SalesAccount() {
            $('#SalesAccount').select2({
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
                $koItemModel['SalesAccountId']($('#SalesAccount').select2('data').id);
            });
        }
        function Select2_PurchaseAccount() {
            $('#PurchaseAccount').select2({
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
                $koItemModel['PurchaseAccountId']($('#PurchaseAccount').select2('data').id);
            });
        }
        function Select2_AssetAccount() {
            $('#AssetAccount').select2({
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
                $koItemModel['AssetAccountId']($('#AssetAccount').select2('data').id);
            });
        }
        function Select2_AssetDepreciationAccount() {
            $('#AssetDepreciationAccount').select2({
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
                $koItemModel['AssetDepreciationAccountId']($('#AssetDepreciationAccount').select2('data').id);
            });
        }
        function Select2_AssetDepreciationExpenseAccount() {
            $('#AssetDepreciationExpenseAccount').select2({
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
                $koItemModel['AssetDepreciationExpenseAccountId']($('#AssetDepreciationExpenseAccount').select2('data').id);
            });
        }
        function Select2_Line2Unit() {
            $('#Line2Unit').select2({
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
                $koItemUnitModel['Line2UnitId']($('#Line2Unit').select2('data').id);
            });
        }
        function Select2_Line3ComponentArticle() {
            $('#Line3ComponentArticle').select2({
                placeholder: 'Item',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectItem',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term,
                            IsInventory: true
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                },
                formatResult: function (data) {
                    var JSONObject = JSON.parse(data.text);
                    return JSONObject["Item"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["Item"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            }).change(function () {
                $('#Line3ComponentArticleId').val($('#Line3ComponentArticle').select2('data').id).change();
                Select2_Line3Unit();
            });
        }
        function Select2_Line3Unit() {
            $('#Line3Unit').select2({
                placeholder: 'Unit',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectItemUnit',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $pageSize,
                            pageNum: page,
                            searchTerm: term,
                            itemId: $('#Line3ComponentArticleId').val()
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $pageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#Line3UnitId').val($('#Line3Unit').select2('data').id).change();
            });
        }

        // Page Load
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Date Pickers
            $('#AssetDateAcquired').datepicker().on('changeDate', function (ev) {
                $(this).datepicker('hide');
            });

            // Select2
            Select2_Unit();
            Select2_Account();
            Select2_PurchaseTax();
            Select2_SalesTax();
            Select2_SalesAccount();
            Select2_CostAccount();
            Select2_PurchaseAccount();
            Select2_AssetAccount();
            Select2_AssetDepreciationAccount();
            Select2_AssetDepreciationExpenseAccount();
            Select2_Line2Unit();
            Select2_Line3ComponentArticle();
            Select2_Line3Unit();

            // Checkbox
            $('#IsAsset').change(function () {
                $koItemModel['IsAsset']($('#IsAsset').prop('checked'));
            });

            // Numbers
            $('#AssetLifeInYears').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#AssetSalvageValue').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#Line1Price').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#Line2Multiplier').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            // Fill the page with data
            if ($Id != "") {
                $koNamespace.getItem($Id);
            } else {
                $koNamespace.getItem(null);
            }

            // Table event handler       
            $("#itemPriceTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#itemPriceTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditItemPrice") > 0) CmdEditItemPrice_onclick(Id);
                if (ButtonName.search("CmdDeleteItemPrice") > 0) CmdDeleteItemPrice_onclick(Id);
            });
            $("#itemUnitTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#itemUnitTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditItemUnit") > 0) CmdEditItemUnit_onclick(Id);
                if (ButtonName.search("CmdDeleteItemUnit") > 0) CmdDeleteItemUnit_onclick(Id);
            });
            $("#itemComponentTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#itemComponentTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditItemComponent") > 0) CmdEditItemComponent_onclick(Id);
                if (ButtonName.search("CmdDeleteItemComponent") > 0) CmdDeleteItemComponent_onclick(Id);
            });

        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#itemPriceModal').modal('hide');
                }
                if ($Modal02 == true) {
                    $('#itemUnitModal').modal('hide');
                }
                if ($Modal03 == true) {
                    $('#itemComponentModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#itemPriceModal').modal('show');
                }
                if ($Modal02 == true) {
                    $('#itemUnitModal').modal('show');
                }
                if ($Modal03 == true) {
                    $('#itemComponentModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">

            <h2>Item Detail</h2>

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
                        <input runat="server" id="CmdClose"  type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()"/>
                    </div>
                </div>
            </div>

            <section id="ItemDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Item Code</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="ArticleId" type="hidden" data-bind="value: ArticleId" disabled="disabled" />
                            <input id="ItemCode" type="text" data-bind="value: ItemCode" class="input-medium" disabled="disabled" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Item</label>
                        <div class="controls">
                            <textarea id="Item" rows="2" data-bind="value: Item" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Bar Code</label>
                        <div class="controls">
                            <input id="BarCode" type="text" data-bind="value: BarCode" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Category</label>
                        <div class="controls">
                            <input id="Category" type="text" data-bind="value: Category" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Unit</label>
                        <div class="controls">
                            <input id="UnitId" type="hidden" data-bind="value: UnitId" disabled="disabled" />
                            <input id="Unit" type="text" data-bind="value: Unit" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Remarks </label>
                        <div class="controls">
                            <textarea id="Remarks" rows="3" data-bind="value: Remarks" class="input-block-level"></textarea>
                        </div>
                    </div>
                </div>
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Purchase Tax</label>
                        <div class="controls">
                            <input id="PurchaseTaxId" type="hidden" data-bind="value: PurchaseTaxId" disabled="disabled" />
                            <input id="PurchaseTax" type="text" data-bind="value: PurchaseTax" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Sales Tax</label>
                        <div class="controls">
                            <input id="SalesTaxId" type="hidden" data-bind="value: SalesTaxId" disabled="disabled" />
                            <input id="SalesTax" type="text" data-bind="value: SalesTax" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Default Account</label>
                        <div class="controls">
                            <input id="AccountId" type="hidden" data-bind="value: AccountId" disabled="disabled" />
                            <input id="Account" type="text" data-bind="value: Account" class="input-xxlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Purchase Account</label>
                        <div class="controls">
                            <input id="PurchaseAccountId" type="hidden" data-bind="value: PurchaseAccountId" disabled="disabled" />
                            <input id="PurchaseAccount" type="text" data-bind="value: PurchaseAccount" class="input-xxlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Sales Account</label>
                        <div class="controls">
                            <input id="SalesAccountId" type="hidden" data-bind="value: SalesAccountId" disabled="disabled" />
                            <input id="SalesAccount" type="text" data-bind="value: SalesAccount" class="input-xxlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Cost Account</label>
                        <div class="controls">
                            <input id="CostAccountId" type="hidden" data-bind="value: CostAccountId" disabled="disabled" />
                            <input id="CostAccount" type="text" data-bind="value: CostAccount" class="input-xxlarge" />
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

            <%--Tab--%>
            <div class="row">
                <div class="span12">
                    <div id="tab" class="btn-group" data-toggle="buttons-radio">
                        <a href="#itemPriceTab" class="btn" data-toggle="tab" id="tab1">Prices</a>
                        <a href="#itemUnitTab" class="btn" data-toggle="tab" id="tab2">Unit Conversion</a>
                        <a href="#itemAssetTab" class="btn" data-toggle="tab" id="tab3">Asset Information</a>
                        <a href="#itemComponentTab" class="btn" data-toggle="tab" id="tab4">Components</a>
                    </div>
                </div>
            </div>

            <br />

            <%--Tab Content--%>
            <div class="tab-content">
                <div id="itemPriceTab" class="tab-pane active">
                    <table id="itemPriceTable" class="table table-striped table-condensed">
                        <thead>
                            <tr>
                                <th colspan="1"><input runat="server" id="CmdAddItemPrice"  type="button" class="btn btn-primary" value="Add" onclick="CmdAddItemPrice_onclick()"/></th>
                                <th colspan="4" style="text-align: right">Item Price List</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Price Description</th>
                                <th>Price</th>
                                <th>Mark Up %</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
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
                <div id="itemUnitTab" class="tab-pane">
                    <table id="itemUnitTable" class="table table-striped table-condensed">
                        <thead>
                            <tr>
                                <th colspan="1"><input runat="server" id="CmdAddItemUnit" type="button" class="btn btn-primary" value="Add" onclick="CmdAddItemUnit_onclick()"/></th>
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
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div> 
                <div id="itemAssetTab" class="tab-pane">
                    <section id="ItemAssetDetail">
                    <div class="row-fluid">
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Asset Manual Number</label>
                                <div class="controls">
                                    <input id="AssetManualNumber" type="text" data-bind="value: AssetManualNumber" class="input-xlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Date Acquired </label>
                                <div class="controls">
                                    <input id="AssetDateAcquired" name="AssetDateAcquired" type="text" data-bind="value: AssetDateAcquired" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Life in Years</label>
                                <div class="controls">
                                    <input id="AssetLifeInYears" type="text" data-bind="value: AssetLifeInYears" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Salvage Value</label>
                                <div class="controls">
                                    <input id="AssetSalvageValue" type="text" data-bind="value: AssetSalvageValue" class="input-medium" />
                                </div>
                            </div>
                        </div>
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label">Asset Account</label>
                                <div class="controls">
                                    <input id="AssetAccountId" type="hidden" data-bind="value: AssetAccountId" disabled="disabled" />
                                    <input id="AssetAccount" type="text" data-bind="value: AssetAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Depreciation Account</label>
                                <div class="controls">
                                    <input id="AssetDepreciationAccountId" type="hidden" data-bind="value: AssetDepreciationAccountId" disabled="disabled" />
                                    <input id="AssetDepreciationAccount" type="text" data-bind="value: AssetDepreciationAccount" class="input-xxlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Depreciation Expense Account</label>
                                <div class="controls">
                                    <input id="AssetDepreciationExpenseAccountId" type="hidden" data-bind="value: AssetDepreciationExpenseAccountId" disabled="disabled" />
                                    <input id="AssetDepreciationExpenseAccount" type="text" data-bind="value: AssetDepreciationExpenseAccount" class="input-xxlarge" />
                                </div>
                            </div>
                        </div>
                    </div>
                    </section>
                </div>
                <div id="itemComponentTab" class="tab-pane">
                    <table id="itemComponentTable" class="table table-striped table-condensed">
                        <thead>
                            <tr>
                                <th colspan="1"><input runat="server" id="CmdAddItemComponent" type="button" class="btn btn-primary" value="Add" onclick="CmdAddItemComponent_onclick()"/></th>
                                <th colspan="4" style="text-align: right">Item Components</th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Quantity</th>
                                <th>Unit</th>
                                <th>Item</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
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
            </div>

            <%--Modal Content--%>
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
                                    <input id="Line1Id" type="hidden" data-bind="value: Line1Id" disabled="disabled" />
                                    <input id="Line1ArticleId" type="hidden" data-bind="value: Line1ArticleId" disabled="disabled" />
                                    <input id="Line1PriceDescription" data-bind="value: Line1PriceDescription" type="text" class="input-medium"/>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="Customer" class="control-label">Price</label>
                                <div class="controls">
                                    <input id="Line1Price" data-bind="value: Line1Price" type="text" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="Customer" class="control-label">Mark Up Percentage</label>
                                <div class="controls">
                                    <input id="Line1MarkUpPercentage" data-bind="value: Line1MarkUpPercentage" type="text" class="input-medium" />
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
                                    <input id="Line2Id" type="hidden" data-bind="value: Line2Id" disabled="disabled" />
                                    <input id="Line2ArticleId" type="hidden" data-bind="value: Line2ArticleId" disabled="disabled" />
                                    <input id="Line2UnitId" type="hidden" data-bind="value: Line2UnitId" disabled="disabled" />
                                    <input id="Line2Unit" type="hidden" data-bind="value: Line2Unit" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Multiplier</label>
                                <div class="controls">
                                    <input id="Line2Multiplier" data-bind="value: Line2Multiplier" type="text" class="input-medium" />
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
                            
            <section id="itemComponentDetail">
            <div id="itemComponentModal" class="modal hide fade in" style="display: none;">  
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Item Component Detail</h3>  
                </div>  
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <label class="control-label">Item Component</label>
                                <div class="controls">
                                    <input id="Line3Id" type="hidden" data-bind="value: Line3Id" disabled="disabled" />
                                    <input id="Line3ArticleId" type="hidden" data-bind="value: Line3ArticleId" disabled="disabled" />
                                    <input id="Line3ComponentArticleId" type="hidden" data-bind="value: Line3ComponentArticleId" disabled="disabled" />
                                    <input id="Line3ComponentArticle" type="text" data-bind="value: Line3ComponentArticle" class="input-block-level" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Unit</label>
                                <div class="controls">
                                    <input id="Line3UnitId" type="hidden" data-bind="value: Line3UnitId" disabled="disabled" />
                                    <input id="Line3Unit" type="text" data-bind="value: Line3Unit" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label class="control-label">Quantity</label>
                                <div class="controls">
                                    <input id="Line3Quantity" data-bind="value: Line3Quantity" type="text" class="input-medium pagination-right" />
                                </div>
                            </div>
                        </div>
                    </div>             
                </div>  
                <div class="modal-footer">  
                    <a href="#" class="btn btn-primary" onclick="CmdSaveItemComponentModal_onclick()" >Save</a>  
                    <a href="#" class="btn btn-danger" onclick="CmdCloseItemComponentModal_onclick()" >Close</a>  
                </div>  
            </div>
            </section>
        
        </div>
    </div>
</asp:Content>
