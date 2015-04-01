<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstDiscountDetail.aspx.cs" Inherits="wfmis.View.MstDiscountDetail" %>

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

        // Bindings
        var $koDiscount;

        $koNamespace.initDiscount = function (Discount) {
            var self = this;

            self.Id = ko.observable(!Discount ? 0 : Discount.Id);
            self.UserId = ko.observable(!Discount ? $CurrentUserId : Discount.UserId);
            self.Discount = ko.observable(!Discount ? "" : Discount.Discount);
            self.DiscountRate = ko.observable(!Discount ? 0 : Discount.DiscountRate);
            self.IsTaxLess = ko.observable(!Discount ? false : Discount.IsTaxLess);

            return self;
        };
        $koNamespace.bindDiscount = function (Discount) {
            var viewModel = $koNamespace.initDiscount(Discount);
            ko.applyBindings(viewModel, $("#DiscountDetail")[0]); //Bind the section #DiscountDetail
            $koDiscount = viewModel;
        };
        $koNamespace.getDiscount = function (Id) {
            if (!Id) {
                $koNamespace.bindDiscount(null);
            } else {
                // Render Discount
                $.getJSON("/api/MstDiscount/" + Id + "/Discount", function (data) {
                    $koNamespace.bindDiscount(data);
                });
            }
        };
    
        // Events
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                if (confirm('Update Discount?')) {
                    $.ajax({
                        url: '/api/MstDiscount/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koDiscount),
                        success: function (data) {
                            location.href = 'MstDiscountDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                if (confirm('Save Discount?')) {
                    $.ajax({
                        url: '/api/MstDiscount',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koDiscount),
                        success: function (data) {
                            location.href = 'MstDiscountDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdClose_onclick() {
            location.href = 'MstDiscountList.aspx';
        }

        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            $('#DiscountRate').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            if ($Id != "") {
                $koNamespace.getDiscount($Id);
            } else {
                $koNamespace.getDiscount(null);
            }
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

            <h2>Discount Detail</h2>

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

            <section id="DiscountDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label for="Discount" class="control-label">Discount</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="UserId" type="hidden" data-bind="value: UserId" disabled="disabled" />
                            <input id="Discount" data-bind="value: Discount" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="DiscountRate" class="control-label">Discount Rate</label>
                        <div class="controls">
                            <input id="DiscountRate" data-bind="value: DiscountRate" type="text" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Less Tax (if inclusive)</label>
                        <div class="controls">
                            <input id="IsTaxLess" type="checkbox" data-bind="checked: IsTaxLess" class="input-large" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

        </div>
    </div>
</asp:Content>
