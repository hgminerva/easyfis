<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="TrnCollectionDetail.aspx.cs" Inherits="wfmis.View.TrnCollectionDetail" %>

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
    <%--EasyFIS Utilities--%>
    <script src="../Scripts/easyfis/easyfis.utils.v2.js"></script>
    <%--Auto Numeric--%>
    <script src="../Scripts/autonumeric/autoNumeric.js"></script>
    <%--Page--%>
    <script type='text/javascript'>
        // Page variables
        var $CurrentUserId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId %>';
        var $CurrentUser = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUser %>';
        var $CurrentPeriodId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriodId %>';
        var $CurrentPeriod = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentPeriod %>';
        var $CurrentBranchId = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId %>';
        var $CurrentBranch = '<%=((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranch %>';

        var $Id = 0;
        var $koNamespace = {};
        var $selectPageSize = 20;
        var $Modal01 = false;

        // Collection Model (Detail)
        var $koCollectionModel;
        $koNamespace.initCollection = function (Collection) {
            var self = this;

            self.Id = ko.observable(!Collection ? $Id : Collection.Id),
            self.PeriodId = ko.observable(!Collection ? Collection : Collection.PeriodId),
            self.Period = ko.observable(!Collection ? $CurrentPeriod : Collection.Period),
            self.BranchId = ko.observable(!Collection ? $CurrentBranchId : Collection.BranchId),
            self.Branch = ko.observable(!Collection ? $CurrentBranch : Collection.Branch),
            self.ORNumber = ko.observable(!Collection ? "" : Collection.ORNumber),
            self.ORManualNumber = ko.observable(!Collection ? "" : Collection.ORManualNumber),
            self.ORDate = ko.observable(!Collection ? easyFIS.getCurrentDate() : Collection.ORDate),
            self.CustomerId = ko.observable(!Collection ? 0 : Collection.CustomerId),
            self.Customer = ko.observable(!Collection ? "" : Collection.Customer),
            self.Particulars = ko.observable(!Collection ? "NA" : Collection.Particulars),
            self.TotalAmount = ko.observable(easyFIS.formatNumber(!Collection ? 0 : Collection.TotalAmount, 2, ',', '.', '', '', '-', '')),
            self.PreparedById = ko.observable(!Collection ? $CurrentUserId : Collection.PreparedById),
            self.PreparedBy = ko.observable(!Collection ? $CurrentUser : Collection.PreparedBy),
            self.CheckedById = ko.observable(!Collection ? $CurrentUserId : Collection.CheckedById),
            self.CheckedBy = ko.observable(!Collection ? $CurrentUser : Collection.CheckedBy),
            self.ApprovedById = ko.observable(!Collection ? $CurrentUserId : Collection.ApprovedById),
            self.ApprovedBy = ko.observable(!Collection ? $CurrentUser : Collection.ApprovedBy),
            self.IsLocked = ko.observable(!Collection ? false : Collection.IsLocked),
            self.CreatedById = ko.observable(!Collection ? $CurrentUserId : Collection.CreatedById),
            self.CreatedBy = ko.observable(!Collection ? $CurrentUser : Collection.CreatedBy),
            self.CreatedDateTime = ko.observable(!Collection ? "" : Collection.CreatedDateTime),
            self.UpdatedById = ko.observable(!Collection ? $CurrentUserId : Collection.UpdatedById),
            self.UpdatedBy = ko.observable(!Collection ? $CurrentUser : Collection.UpdatedBy),
            self.UpdatedDateTime = ko.observable(!Collection ? "" : Collection.UpdatedDateTime),

            // Select2 defaults
            $('#Customer').select2('data', { id: !Collection ? 0 : Collection.CustomerId, text: !Collection ? "" : Collection.Customer });
            $('#PreparedBy').select2('data', { id: !Collection ? $CurrentUserId : Collection.PreparedById, text: !Collection ? $CurrentUser : Collection.PreparedBy });
            $('#CheckedBy').select2('data', { id: !Collection ? $CurrentUserId : Collection.CheckedById, text: !Collection ? $CurrentUser : Collection.CheckedBy });
            $('#ApprovedBy').select2('data', { id: !Collection ? $CurrentUserId : Collection.ApprovedById, text: !Collection ? $CurrentUser : Collection.ApprovedBy });

            if ((!Collection ? false : Collection.IsLocked) == true) {
                $(document).find('input[type="text"],textarea').prop("disabled", true);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#ORNumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);

                $('#Customer').select2('disable');
                $('#PreparedBy').select2('disable');
                $('#CheckedBy').select2('disable');
                $('#ApprovedBy').select2('disable');
            } else {
                $(document).find('input[type="text"],textarea').prop("disabled", false);

                $('#Period').prop("disabled", true);
                $('#Branch').prop("disabled", true);
                $('#ORNumber').prop("disabled", true);
                $('#TotalAmount').prop("disabled", true);

                $('#Customer').select2('enable');
                $('#PreparedBy').select2('enable');
                $('#CheckedBy').select2('enable');
                $('#ApprovedBy').select2('enable');
            }

            return self;
        };
        $koNamespace.bindCollection = function (Collection) {
            var viewModel = $koNamespace.initCollection(Collection);
            ko.applyBindings(viewModel, $("#CollectionDetail")[0]); //Bind the section #CollectionDetail
            $koCollectionModel = viewModel;
        }
        $koNamespace.getCollection = function (Id) {
            if (!Id) {
                $koNamespace.bindCollection(null);
            } else {
                // Render Collection
                $.ajax({
                    url: '/api/TrnCollection/' + Id + '/Collection',
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (Collection) {
                        $koNamespace.bindCollection(Collection);

                        // Render Collection Line
                        $("#CollectionLineTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnCollection/' + Id + '/CollectionLines',
                            "sAjaxDataProp": "TrnCollectionLineData",
                            "bProcessing": true,
                            "bLengthChange": false,
                            "sPaginationType": "full_numbers",
                            "aoColumns": [
                                            {
                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdEditLine" type="button" class="btn btn-primary" value="Edit"/>'
                                                }
                                            },
                                            {
                                                "mData": "LineId", "bSearchable": false, "bSortable": false, "sWidth": "40px",
                                                "mRender": function (data) {
                                                    return '<input runat="server" id="CmdDeleteLine" type="button" class="btn btn-danger" value="Delete"/>'
                                                }
                                            },
                                            { "mData": "LineAccount", "sWidth": "300px" },
                                            { "mData": "LineSINumber", "sWidth": "150px" },
                                            { "mData": "LineParticulars" },
                                            { "mData": "LinePayType", "sWidth": "150px" },
                                            {
                                                "mData": "LineAmount", "sWidth": "100px", "sClass": "alignRight",
                                                "mRender": function (data) {
                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                }
                                            }],
                            "fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                                var TotalAmount = 0;

                                for (var i = 0 ; i < aaData.length ; i++) {
                                    TotalAmount += aaData[i]['LineAmount'] * 1;
                                }

                                var nCells = nRow.getElementsByTagName('td');
                                nCells[6].innerHTML = easyFIS.formatNumber(TotalAmount, 2, ',', '.', '', '', '-', '');
                            }
                        });

                        // Render Journal Entries
                        $("#JournalEntryTable").dataTable({
                            "bServerSide": true,
                            "sAjaxSource": '/api/TrnJournal/' + Id + '/CollectionJournals',
                            "sAjaxDataProp": "TrnJournalData",
                            "bProcessing": true,
                            "bLengthChange": false,
                            "sPaginationType": "full_numbers",
                            "aoColumns": [
                                            { "mData": "Period", "sWidth": "200px" },
                                            { "mData": "Branch", "sWidth": "200px" },
                                            { "mData": "Account" },
                                            {
                                                "mData": "DebitAmount", "sWidth": "150px", "sClass": "alignRight",
                                                "mRender": function (data) {
                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                }
                                            },
                                            {
                                                "mData": "CreditAmount", "sWidth": "150px", "sClass": "alignRight",
                                                "mRender": function (data) {
                                                    return easyFIS.formatNumber(data, 2, ',', '.', '', '', '-', '');
                                                }
                                            }],
                            "fnFooterCallback": function (nRow, aaData, iStart, iEnd, aiDisplay) {
                                var DebitAmount = 0;
                                var CreditAmount = 0;

                                for (var i = 0 ; i < aaData.length ; i++) {
                                    DebitAmount += aaData[i]['DebitAmount'] * 1;
                                    CreditAmount += aaData[i]['CreditAmount'] * 1;
                                }

                                var nCells = nRow.getElementsByTagName('td');
                                nCells[3].innerHTML = easyFIS.formatNumber(DebitAmount, 2, ',', '.', '', '', '-', '');
                                nCells[4].innerHTML = easyFIS.formatNumber(CreditAmount, 2, ',', '.', '', '', '-', '');
                            }
                        });
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }

        // Collection Line Model
        var $koCollectionLineModel;
        $koNamespace.initCollectionLine = function (CollectionLine) {
            var self = this;

            self.LineId = ko.observable(!CollectionLine ? 0 : CollectionLine.LineId);
            self.LineORId = ko.observable(!CollectionLine ? 0 : CollectionLine.LineORId);
            self.LineAccountId = ko.observable(!CollectionLine ? 0 : CollectionLine.LineAccountId);
            self.LineAccount = ko.observable(!CollectionLine ? "" : CollectionLine.LineAccount);
            self.LineSIId = ko.observable(!CollectionLine ? 0 : CollectionLine.LineSIId);
            self.LineSINumber = ko.observable(!CollectionLine ? "" : CollectionLine.LineSINumber);
            self.LineParticulars = ko.observable(!CollectionLine ? "NA" : CollectionLine.LineParticulars);
            self.LineAmount = ko.observable(!CollectionLine ? 0 : CollectionLine.LineAmount);
            self.LinePayTypeId = ko.observable(!CollectionLine ? 0 : CollectionLine.LinePayTypeId);
            self.LinePayType = ko.observable(!CollectionLine ? "" : CollectionLine.LinePayType);
            self.LineCheckNumber = ko.observable(!CollectionLine ? "NA" : CollectionLine.LineCheckNumber);
            self.LineCheckDate = ko.observable(!CollectionLine ? easyFIS.getCurrentDate() : CollectionLine.LineCheckDate);
            self.LineCheckBank = ko.observable(!CollectionLine ? "NA" : CollectionLine.LineCheckBank);
            self.LineBankId = ko.observable(!CollectionLine ? 0 : CollectionLine.LineBankId);
            self.LineBank = ko.observable(!CollectionLine ? "" : CollectionLine.LineBank);

            return self;
        }
        $koNamespace.bindCollectionLine = function (CollectionLine) {
            try {
                var viewModel = $koNamespace.initCollectionLine(CollectionLine);
                ko.applyBindings(viewModel, $("#CollectionLineDetail")[0]);
                $koCollectionLineModel = viewModel;

                $('#LineAccount').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LineAccountId, text: !CollectionLine ? "" : CollectionLine.LineAccount });
                $('#LineSINumber').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LineSIId, text: !CollectionLine ? "" : CollectionLine.LineSINumber });
                $('#LinePayType').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LinePayTypeId, text: !CollectionLine ? "" : CollectionLine.LinePayType });
                $('#LineBank').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LineBankId, text: !CollectionLine ? "" : CollectionLine.LineBank });
            } catch (e) {
                // Fill the controls directly (Multiple binding occurs)
                $('#LineId').val(!CollectionLine ? 0 : CollectionLine.LineId).change();
                $('#LineORId').val(!CollectionLine ? 0 : CollectionLine.LineORId).change();

                $('#LineAccountId').val(!CollectionLine ? 0 : CollectionLine.LineAccountId).change();
                $('#LineAccount').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LineAccountId, text: !CollectionLine ? "" : CollectionLine.LineAccount });

                $('#LineSIId').val(!CollectionLine ? 0 : CollectionLine.LineSIId).change();
                $('#LineSINumber').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LineSIId, text: !CollectionLine ? "" : CollectionLine.LineSINumber });

                $('#LineParticulars').val(!CollectionLine ? "NA" : CollectionLine.LineParticulars).change();

                $('#LineAmount').val(!CollectionLine ? 0 : CollectionLine.LineAmount).change();

                $('#LinePayTypeId').val(!CollectionLine ? 0 : CollectionLine.LinePayTypeId).change();
                $('#LinePayType').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LinePayTypeId, text: !CollectionLine ? "" : CollectionLine.LinePayType });

                $('#LineCheckNumber').val(!CollectionLine ? "NA" : CollectionLine.LineCheckNumber).change(); 
                $('#LineCheckDate').val(!CollectionLine ? easyFIS.getCurrentDate() : CollectionLine.LineCheckDate).change();
                $('#LineCheckBank').val(!CollectionLine ? "NA" : CollectionLine.LineCheckBank).change();

                $('#LineBankId').val(!CollectionLine ? 0 : CollectionLine.LineBankId).change();
                $('#LineBank').select2('data', { id: !CollectionLine ? 0 : CollectionLine.LineBankId, text: !CollectionLine ? "" : CollectionLine.LineBank });
            }
        }

        // Click events
        function CmdSave_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id == "") {
                if (confirm('Save record?')) {
                    $.ajax({
                        url: '/api/TrnCollection',
                        cache: false,
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: ko.toJSON($koCollectionModel),
                        success: function (data) {
                            location.href = 'TrnCollectionDetail.aspx?Id=' + data.Id;
                        }
                    }).fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                if (confirm('Update record?')) {
                    $Id = easyFIS.getParameterByName("Id");
                    if ($Id != "") {
                        $.ajax({
                            url: '/api/TrnCollection/' + $Id + '/Update',
                            cache: false,
                            type: 'PUT',
                            contentType: 'application/json; charset=utf-8',
                            data: ko.toJSON($koCollectionModel),
                            success: function (data) {
                                alert("Record updated successfully!");
                            }
                        })
                        .fail(
                        function (xhr, textStatus, err) {
                            alert(err);
                        });
                    }
                }
            }
        }
        function CmdPrint_onclick() {
            if ($Id > 0) {
                window.location.href = '/api/SysReport?Report=Collection&Id=' + $Id;
            }
        }
        function CmdClose_onclick() {
            location.href = 'TrnCollectionList.aspx';
        }
        function CmdAddLine_onclick() {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                $('#CollectionLineModal').modal('show');
                $Modal01 = true;
                $koNamespace.bindCollectionLine(null);
                // FK
                $('#LineORId').val($Id).change();
            } else {
                alert('Collection not yet saved.');
            }
        }
        function CmdCloseLine_onclick() {
            $('#CollectionLineModal').modal('hide');
            $Modal01 = false;
        }
        function CmdSaveLine_onclick() {
            var LineId = $('#LineId').val();

            $('#CollectionLineModal').modal('hide');
            $Modal01 = false;

            if (LineId != 0) {
                // Update Existing Record
                $.ajax({
                    url: '/api/TrnCollectionLine/' + LineId,
                    cache: false,
                    type: 'PUT',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koCollectionLineModel),
                    success: function (data) {
                        location.href = 'TrnCollectionDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                })
                .fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            } else {
                // Add Record
                $.ajax({
                    url: '/api/TrnCollectionLine',
                    cache: false,
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: ko.toJSON($koCollectionLineModel),
                    success: function (data) {
                        location.href = 'TrnCollectionDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdEditLine_onclick(LineId) {
            if (LineId > 0) {
                $.ajax({
                    url: '/api/TrnCollectionLine/' + LineId,
                    cache: false,
                    type: 'GET',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        $koNamespace.bindCollectionLine(data);
                        $('#CollectionLineModal').modal('show');
                        $Modal01 = true;
                    }
                }).fail(function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdDeleteLine_onclick(Id) {
            if (confirm('Are you sure?')) {
                $.ajax({
                    url: '/api/TrnCollectionLine/' + Id,
                    cache: false,
                    type: 'DELETE',
                    contentType: 'application/json; charset=utf-8',
                    data: {},
                    success: function (data) {
                        location.href = 'TrnCollectionDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                    }
                }).fail(
                function (xhr, textStatus, err) {
                    alert(err);
                });
            }
        }
        function CmdApproval_onclick(Approval) {
            $Id = easyFIS.getParameterByName("Id");
            if ($Id != "") {
                if (confirm('Change approval.  Are you sure?')) {
                    $.ajax({
                        url: '/api/TrnCollection/' + $Id + '/Approval?Approval=' + Approval,
                        cache: false,
                        type: 'PUT',
                        contentType: 'application/json; charset=utf-8',
                        data: {},
                        success: function (data) {
                            location.href = 'TrnCollectionDetail.aspx?Id=' + easyFIS.getParameterByName("Id");
                        }
                    })
                    .fail(
                    function (xhr, textStatus, err) {
                        alert(err);
                    });
                }
            } else {
                alert('Collection not yet saved.');
            }
        }

        // Select2  control
        function select2_Customer() {
            $('#Customer').select2({
                placeholder: 'Customer',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectCustomer',
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
                $('#CustomerId').val($('#Customer').select2('data').id).change();
            });
        }
        function select2_PreparedBy() {
            $('#PreparedBy').select2({
                placeholder: 'Prepared By',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectStaff',
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
                $('#PreparedById').val($('#PreparedBy').select2('data').id).change();
            });
        }
        function select2_CheckedBy() {
            $('#CheckedBy').select2({
                placeholder: 'Checked By',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectStaff',
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
                $('#CheckedById').val($('#CheckedBy').select2('data').id).change();
            });
        }
        function select2_ApprovedBy() {
            $('#ApprovedBy').select2({
                placeholder: 'Approved By',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectStaff',
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
                $('#ApprovedById').val($('#ApprovedBy').select2('data').id).change();
            });
        }
        function select2_LinePayType() {
            $('#LinePayType').select2({
                placeholder: 'Pay Type',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectPayType',
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
                $('#LinePayTypeId').val($('#LinePayType').select2('data').id).change();
            });
        }
        function select2_LineSINumber() {
            $('#LineSINumber').select2({
                placeholder: 'Sales Invoice',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectSalesInvoice',
                    dataType: 'json',
                    cache: false,
                    type: 'GET',
                    data: function (term, page) {
                        return {
                            pageSize: $selectPageSize,
                            pageNum: page,
                            searchTerm: term,
                            customerId: $('#CustomerId').val()
                        };
                    },
                    results: function (data, page) {
                        var more = (page * $selectPageSize) < data.Total;
                        return { results: data.Results, more: more };
                    }
                }
            }).change(function () {
                $('#LineSIId').val($('#LineSINumber').select2('data').id).change();
            });
        }
        function select2_LineAccount() {
            $('#LineAccount').select2({
                placeholder: 'Account',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectAccount',
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
                $('#LineAccountId').val($('#LineAccount').select2('data').id).change();
            });
        }
        function select2_LineBank() {
            $('#LineBank').select2({
                placeholder: 'Bank',
                allowClear: false,
                ajax: {
                    quietMillis: 150,
                    url: '/api/SelectBank',
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
                },
                formatResult: function (data) {
                    var JSONObject = JSON.parse(data.text);
                    return JSONObject["Bank"];
                },
                formatSelection: function (data) {
                    if (data) {
                        try {
                            var JSONObject = JSON.parse(data.text);
                            return JSONObject["Bank"];
                        } catch (err) {
                            return data.text;
                        }
                    } else {
                        return "";
                    }
                }
            }).change(function () {
                $('#LineBankId').val($('#LineBank').select2('data').id).change();
            });
        }

        // On Page Load
        $(document).ready(function () {
            $Id = easyFIS.getParameterByName("Id");

            // Date Pickers
            $('#ORDate').datepicker().on('changeDate', function (ev) {
                $koCollectionModel.ORDate($(this).val());
                $(this).datepicker('hide');
            });

            // Select2 Controls
            select2_Customer();
            select2_PreparedBy();
            select2_CheckedBy();
            select2_ApprovedBy();
            select2_LinePayType();
            select2_LineSINumber();
            select2_LineAccount();
            select2_LineBank();

            $('#TotalAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });
            $('#LineAmount').autoNumeric('init', { aSep: ',', dGroup: '3', aDec: '.', nBracket: '(,)', vMin: '0' });

            $("#CollectionLineTable").on("click", "input[type='button']", function () {
                var ButtonName = $(this).attr("id");
                var Id = $("#CollectionLineTable").dataTable().fnGetData(this.parentNode);

                if (ButtonName.search("CmdEditLine") > 0) CmdEditLine_onclick(Id);
                if (ButtonName.search("CmdDeleteLine") > 0) CmdDeleteLine_onclick(Id);
            });

            // Bind the Page: TrnCollection
            if ($Id != "") {
                $koNamespace.getCollection($Id);
            } else {
                $koNamespace.getCollection(null);
            }
        });
        $(document).ajaxSend(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                if ($Modal01 == true) {
                    $('#CollectionLineModal').modal('hide');
                }
                $('#loading-indicator-modal').modal('show');
            }
        });
        $(document).ajaxComplete(function (event, request, settings) {
            if (settings.url.substr(0, 11) != "/api/Select" && settings.url.indexOf("sEcho") < 0) {
                $('#loading-indicator-modal').modal('hide');
                if ($Modal01 == true) {
                    $('#CollectionLineModal').modal('show');
                }
            }
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div id="main-content">
        <div class="container">
            <h2>Collection Detail</h2>

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
                <div class="span12 text-right">
                    <div class="control-group">
                        <input runat="server" id="CmdSave" type="button" class="btn btn-primary" value="Save" onclick="CmdSave_onclick()"/>
                        <input runat="server" id="CmdApprove" type="button" class="btn btn-primary" value="Approve" onclick="CmdApproval_onclick(true)"/>
                        <input runat="server" id="CmdDisapprove" type="button" class="btn btn-primary" value="Disapprove" onclick="CmdApproval_onclick(false)"/>                       
                        <input runat="server" id="CmdPrint" type="button" class="btn btn-primary" value="Print" onclick="CmdPrint_onclick()"/>
                        <input runat="server" id="CmdClose" type="button" class="btn btn-danger" value="Close" onclick="CmdClose_onclick()"/>
                    </div>
                </div>
            </div>

            <section id="CollectionDetail">
            <div class="row">
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Period </label>
                        <div class="controls">
                            <input id="Period" type="text" data-bind="value: Period" class="input-large" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Branch </label>
                        <div class="controls">
                            <input id="Branch" type="text" data-bind="value: Branch" class="input-large" disabled="disabled"/>
                        </div>
                    </div> 
                    <div class="control-group">
                        <label class="control-label">OR Number </label>
                        <div class="controls">
                            <input id="ORNumber" type="text" data-bind="value: ORNumber" class="input-medium" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">OR Date </label>
                        <div class="controls">
                            <input id="ORDate" name="ORDate" type="text" data-bind="value: ORDate" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">OR Manual Number </label>
                        <div class="controls">
                            <input id="ORManualNumber" type="text" data-bind="value: ORManualNumber" class="input-medium" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Customer </label>
                        <div class="controls">
                            <input  id="CustomerId" type="hidden" data-bind="value: CustomerId" class="input-medium" />
                            <input  id="Customer" type="text" data-bind="value: Customer" class="input-xlarge" />
                        </div>
                    </div>
                </div>
                <div class="span6">
                    <div class="control-group">
                        <label class="control-label">Particulars </label>
                        <div class="controls">
                            <textarea id="Particulars" rows="3" data-bind="value: Particulars" class="input-block-level"></textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Prepared By </label>
                        <div class="controls">
                            <input  id="PreparedById" type="hidden" data-bind="value: PreparedById" class="input-medium" />
                            <input  id="PreparedBy" type="text" data-bind="value: PreparedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Checked By </label>
                        <div class="controls">
                            <input  id="CheckedById" type="hidden" data-bind="value: CheckedById" class="input-medium" />
                            <input  id="CheckedBy" type="text" data-bind="value: CheckedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Approved By </label>
                        <div class="controls">
                            <input  id="ApprovedById" type="hidden" data-bind="value: ApprovedById" class="input-medium" />
                            <input  id="ApprovedBy" type="text" data-bind="value: ApprovedBy" class="input-xlarge" />
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Total Amount </label>
                        <div class="controls">
                            <input id="TotalAmount" type="text" data-bind="value: TotalAmount" class="text-right input-medium" disabled="disabled"/>
                        </div>
                    </div>
                </div>
            </div>
            </section>

            <section id="CollectionLine">
            <div class="row">
                <div class="span12">
                    <table id="CollectionLineTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="7">
                                    <input runat="server" id="CmdAddLine" type="button" class="btn btn-primary" value="Add" onclick="CmdAddLine_onclick()"/>
                                </th>
                            </tr>
                            <tr>
                                <th></th>
                                <th></th>
                                <th>Account</th>
                                <th>SI Number</th>
                                <th>Particulars</th>
                                <th>Pay Type</th>
                                <th>Amount</th> 
                            </tr>
                        </thead>
                        <tbody id="CollectionLineTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td>Total:</td> 
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td style="text-align:right"></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
            </section>

            <br />

            <section id="JournalEntries">
            <div class="row">
                <div class="span12">
                    <table id="JournalEntryTable" class="table table-striped table-condensed" >
                        <thead>
                            <tr>
                                <th colspan="5">
                                    Journal Entries
                                </th>
                            </tr>
                            <tr>
                                <th>Period</th>
                                <th>Banch</th>
                                <th>Account</th>
                                <th>Debit Amount</th>
                                <th>Credit Amount</th>
                            </tr>
                        </thead>
                        <tbody id="JournalEntryTableBody"></tbody>
                        <tfoot>
                            <tr>
                                <td>Total:</td> 
                                <td></td>
                                <td></td>
                                <td style="text-align:right"></td>
                                <td style="text-align:right"></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
            </section>

            <section id="CollectionLineDetail">
            <div id="CollectionLineModal" class="modal hide fade in" style="display: none;">
                <div class="modal-header">  
                    <a class="close" data-dismiss="modal">×</a>  
                    <h3>Collection Line Detail</h3>  
                </div> 
                <div class="modal-body">
                    <div class="row">
                        <div class="form-horizontal">
                            <div class="control-group">
                                <div class="controls">
                                    <input id="LineId" type="hidden" data-bind="value: LineId" class="input-medium" />
                                    <input id="LineORId" type="hidden" data-bind="value: LineORId" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineAccount" class="control-label">Account </label>
                                <div class="controls">
                                    <input id="LineAccountId" type="hidden" data-bind="value: LineAccountId" class="input-medium" />
                                    <input id="LineAccount" type="text" data-bind="value: LineAccount" class="input-block-level" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineSINumber" class="control-label">SI Number </label>
                                <div class="controls">
                                    <input id="LineSIId" type="hidden" data-bind="value: LineSIId" class="input-medium" />
                                    <input id="LineSINumber" type="text" data-bind="value: LineSINumber" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineParticulars" class="control-label">Particulars </label>
                                <div class="controls">
                                    <textarea id="LineParticulars" rows="3" data-bind="value: LineParticulars" class="input-block-level"></textarea>
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineAmount" class="control-label">Amount </label>
                                <div class="controls">
                                    <input id="LineAmount" type="number" data-bind="value: LineAmount" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePayType" class="control-label">Pay Type </label>
                                <div class="controls">
                                    <input id="LinePayTypeId" type="hidden" data-bind="value: LinePayTypeId" class="input-medium" />
                                    <input id="LinePayType" type="text" data-bind="value: LinePayType" class="input-medium" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineCheckNumber" class="control-label">Check Number </label>
                                <div class="controls">
                                    <input id="LineCheckNumber" type="text" data-bind="value: LineCheckNumber" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineCheckDate" class="control-label">Check Date </label>
                                <div class="controls">
                                    <input id="LineCheckDate" type="text" data-bind="value: LineCheckDate" class="input-large" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LineCheckBank" class="control-label">Check Bank </label>
                                <div class="controls">
                                    <input id="LineCheckBank" type="text" data-bind="value: LineCheckBank" class="input-xlarge" />
                                </div>
                            </div>
                            <div class="control-group">
                                <label for="LinePayType" class="control-label">Depository Bank</label>
                                <div class="controls">
                                    <input id="LineBankId" type="hidden" data-bind="value: LineBankId" class="input-xlarge" />
                                    <input id="LineBank" type="text" data-bind="value: LineBank" class="input-xlarge" />
                                </div>
                            </div>
                        </div>
                    </div>             
                </div> 
                <div class="modal-footer">  
                    <a href="#" class="btn btn-primary" onclick="CmdSaveLine_onclick()">Save</a>  
                    <a href="#" class="btn btn-danger" onclick="CmdCloseLine_onclick()">Close</a>  
                </div>  
            </div>
            </section>

        </div>
    </div>
</asp:Content>
