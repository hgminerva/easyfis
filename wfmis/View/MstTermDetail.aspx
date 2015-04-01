<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="MstTermDetail.aspx.cs" Inherits="wfmis.View.MstTermDetail" %>
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
        var $koTerm;
        $koNamespace.initTerm = function (Term) {
            var self = this;

            self.Id = ko.observable(!Term ? 0 : Term.Id);
            self.UserId = ko.observable(!Term ? $CurrentUserId : Term.UserId);
            self.Term = ko.observable(!Term ? "" : Term.Term);
            self.NumberOfDays = ko.observable(!Term ? 0 : Term.NumberOfDays);

            return self;
        };
        $koNamespace.bindTerm = function (Term) {
            var viewModel = $koNamespace.initTerm(Term);
            ko.applyBindings(viewModel, $("#TermDetail")[0]);
            $koTerm = viewModel;
        };
        $koNamespace.getTerm = function (Id) {
            if (!Id) {
                $koNamespace.bindTerm(null);
            } else {
                // Render Term
                $.getJSON("/api/MstTerm/" + Id + "/Term", function (data) {
                    $koNamespace.bindTerm(data);
                });
            }
        };

        // Events
        function CmdSave_onclick() {
            var $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                if (confirm('Update Term?')) {
                    $.ajax({
                        url: '/api/MstTerm/' + $Id,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koTerm),
                        success: function (data) {
                            location.href = 'MstTermDetail.aspx?Id=' + $Id;
                        }
                    })
                    .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            } else {
                if (confirm('Save Term?')) {
                    $.ajax({
                        url: '/api/MstTerm',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koTerm),
                        success: function (data) {
                            location.href = 'MstTermDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                }
            }
        }
        function CmdClose_onclick() {
            location.href = 'SysFolders.aspx';
        }

        // Page Load
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Numbers
            $('#NumberOfDays').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            // Fill the page with data
            if ($Id != "") {
                $koNamespace.getTerm($Id);
            } else {
                $koNamespace.getTerm(null);
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

            <h2>Term Detail</h2>

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

            <section id="TermDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label for="Term" class="control-label">Term</label>
                        <div class="controls">
                            <input id="Id" type="hidden" data-bind="value: Id" disabled="disabled" />
                            <input id="Term" data-bind="value: Term" type="text" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="NumberOfDays" class="control-label">Number of days</label>
                        <div class="controls">
                            <input id="NumberOfDays" data-bind="value: NumberOfDays" type="text" class="input-medium" />
                        </div>
                    </div>
                </div>
            </div>
            </section>

        </div>
    </div>
</asp:Content>
