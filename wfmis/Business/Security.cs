using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using wfmis.Models;

namespace wfmis.Business
{
    public class Security
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        private bool GetPageLockStatus(string PageName, Int64 PageId)
        {
            bool IsLocked = false;

            if (PageName == "TrnCollectionDetail")
            {
                var Collections = db.TrnCollections.Where(d => d.Id == PageId);
                if (Collections.Any()) IsLocked = Collections.First().IsLocked;
            }
            else if (PageName == "TrnDisbursementDetail")
            {
                var Disbursements = db.TrnDisbursements.Where(d => d.Id == PageId);
                if (Disbursements.Any()) IsLocked = Disbursements.First().IsLocked;
            }
            else if (PageName == "TrnJournalVoucherDetail")
            {
                var JournalVouchers = db.TrnJournalVouchers.Where(d => d.Id == PageId);
                if (JournalVouchers.Any()) IsLocked = JournalVouchers.First().IsLocked;
            }
            else if (PageName == "TrnPurchaseInvoiceDetail")
            {
                var PurchaseInvoices = db.TrnPurchaseInvoices.Where(d => d.Id == PageId);
                if (PurchaseInvoices.Any()) IsLocked = PurchaseInvoices.First().IsLocked;
            }
            else if (PageName == "TrnPurchaseOrderDetail")
            {
                var PurchaseOrders = db.TrnPurchaseOrders.Where(d => d.Id == PageId);
                if (PurchaseOrders.Any()) IsLocked = PurchaseOrders.First().IsLocked;
            }
            else if (PageName == "TrnSalesInvoiceDetail")
            {
                var SalesInvoices = db.TrnSalesInvoices.Where(d => d.Id == PageId);
                if (SalesInvoices.Any()) IsLocked = SalesInvoices.First().IsLocked;
            }
            else if (PageName == "TrnSalesOrderDetail")
            {
                var SalesOrders = db.TrnSalesOrders.Where(d => d.Id == PageId);
                if (SalesOrders.Any()) IsLocked = SalesOrders.First().IsLocked;
            }
            else if (PageName == "TrnStockInDetail")
            {
                var StockIns = db.TrnStockIns.Where(d => d.Id == PageId);
                if (StockIns.Any()) IsLocked = StockIns.First().IsLocked;
            }
            else if (PageName == "TrnStockOutDetail")
            {
                var StockOuts = db.TrnStockOuts.Where(d => d.Id == PageId);
                if (StockOuts.Any()) IsLocked = StockOuts.First().IsLocked;
            }
            else if (PageName == "TrnStockTransferDetail")
            {
                var StockTransfers = db.TrnStockTransfers.Where(d => d.Id == PageId);
                if (StockTransfers.Any()) IsLocked = StockTransfers.First().IsLocked;
            }

            return IsLocked;
        }

        public Int64 GetCurrentUser()
        {
            var User = db.MstUsers.FirstOrDefault(u => u.Membership.User.UserName == Membership.GetUser().UserName);
            if (User != null)
            {
                return User.Id;
            }
            else
            {
                return 0;
            }
        }

        public Int64 GetCurrentSubscriberUser()
        {
            var User = db.MstUsers.FirstOrDefault(u => u.Membership.User.UserName == Membership.GetUser().UserName);
            if (User != null)
            {
                if (User.DefaultBranchId > 0)
                {
                    return User.MstBranch.UserId;
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                return 0;
            }
        }

        private HtmlControl FindHtmlControl(Control control, string id)
        {
            foreach (Control childControl in control.Controls)
            {
                if (childControl.ID != null && childControl.ID.Equals(id, StringComparison.OrdinalIgnoreCase) && childControl is HtmlControl)
                {
                    return (HtmlControl)childControl;
                }

                if (childControl.HasControls())
                {
                    HtmlControl result = FindHtmlControl(childControl, id);
                    if (result != null) return result;
                }
            }

            return null;
        }

        public bool SecurePage(Control Parent)
        {
            Int64 UserId = GetCurrentUser();
            string PageName = "";
            Int64 PageCompanyId = 0;
            Int64 PageId = 0;

            var PageNameControl = FindHtmlControl(Parent, "PageName");
            var PageCompanyIdControl = FindHtmlControl(Parent, "PageCompanyId");
            var PageIdControl = FindHtmlControl(Parent, "PageId");

            if (PageNameControl != null) PageName = PageNameControl.Attributes["value"];
            if (PageCompanyIdControl != null) PageCompanyId = Convert.ToInt64(PageCompanyIdControl.Attributes["value"]);
            if (PageIdControl != null) PageId = Convert.ToInt64(PageIdControl.Attributes["value"]);

            bool IsLocked = GetPageLockStatus(PageName, PageId);

            if (UserId == GetCurrentSubscriberUser())
            {
                if (IsLocked == true)
                {
                    var CmdAdd = FindHtmlControl(Parent, "CmdAdd");
                    var CmdSave = FindHtmlControl(Parent, "CmdSave");
                    var CmdEdit = FindHtmlControl(Parent, "CmdEdit");
                    var CmdDelete = FindHtmlControl(Parent, "CmdDelete");
                    var CmdApprove = FindHtmlControl(Parent, "CmdApprove");
                    var CmdAddLine = FindHtmlControl(Parent, "CmdAddLine");
                    var CmdEditLine = FindHtmlControl(Parent, "CmdEditLine");
                    var CmdDeleteLine = FindHtmlControl(Parent, "CmdDeleteLine");
                    var CmdSearchItem = FindHtmlControl(Parent, "CmdSearchItem");

                    if (CmdAdd != null) CmdAdd.Attributes["disabled"] = "disabled";
                    if (CmdSave != null) CmdSave.Attributes["disabled"] = "disabled";
                    if (CmdEdit != null) CmdEdit.Attributes["disabled"] = "disabled";
                    if (CmdDelete != null) CmdDelete.Attributes["disabled"] = "disabled";
                    if (CmdApprove != null) CmdApprove.Attributes["disabled"] = "disabled";
                    if (CmdAddLine != null) CmdAddLine.Attributes["disabled"] = "disabled";
                    if (CmdEditLine != null) CmdEditLine.Attributes["disabled"] = "disabled";
                    if (CmdDeleteLine != null) CmdDeleteLine.Attributes["disabled"] = "disabled";
                    if (CmdSearchItem != null) CmdSearchItem.Attributes["disabled"] = "disabled";
                }

                return true;
            }
            else
            {
                var UserStaffRoles = from d in db.MstUserStaffRoles
                                     where d.MstUserStaff.UserStaffId == UserId &&
                                           d.SysPage.Page == PageName &&
                                           d.CompanyId == PageCompanyId
                                     select d;

                if (UserStaffRoles.Any())
                {
                    var CmdAdd = FindHtmlControl(Parent, "CmdAdd");
                    var CmdSave = FindHtmlControl(Parent, "CmdSave");
                    var CmdEdit = FindHtmlControl(Parent, "CmdEdit");
                    var CmdDelete = FindHtmlControl(Parent, "CmdDelete");
                    var CmdPrint = FindHtmlControl(Parent, "CmdPrint");
                    var CmdApprove = FindHtmlControl(Parent, "CmdApprove");
                    var CmdDisapprove = FindHtmlControl(Parent, "CmdDisapprove");
                    var CmdAddLine = FindHtmlControl(Parent, "CmdAddLine");
                    var CmdEditLine = FindHtmlControl(Parent, "CmdEditLine");
                    var CmdDeleteLine = FindHtmlControl(Parent, "CmdDeleteLine");
                    var CmdSearchItem = FindHtmlControl(Parent, "CmdSearchItem");

                    var CanAdd = UserStaffRoles.First().CanAdd;
                    var CanSave = UserStaffRoles.First().CanSave;
                    var CanEdit = UserStaffRoles.First().CanEdit;
                    var CanDelete = UserStaffRoles.First().CanDelete;
                    var CanPrint = UserStaffRoles.First().CanPrint;
                    var CanApprove = UserStaffRoles.First().CanApprove;
                    var CanDisapprove = UserStaffRoles.First().CanDisapprove;

                    if (IsLocked == false)
                    {
                        if (CmdAdd != null && CanAdd == false) CmdAdd.Attributes["disabled"] = "disabled";
                        if (CmdSave != null && CanSave == false) CmdSave.Attributes["disabled"] = "disabled";
                        if (CmdEdit != null && CanEdit == false) CmdEdit.Attributes["disabled"] = "disabled";
                        if (CmdDelete != null && CanDelete == false) CmdDelete.Attributes["disabled"] = "disabled";
                        if (CmdPrint != null) CmdPrint.Attributes["disabled"] = "disabled";
                        if (CmdApprove != null && CanApprove == false) CmdApprove.Attributes["disabled"] = "disabled";
                        if (CmdDisapprove != null) CmdDisapprove.Attributes["disabled"] = "disabled";
                        if (CmdAddLine != null && CanAdd == false) CmdAddLine.Attributes["disabled"] = "disabled";
                        if (CmdEditLine != null && CanEdit == false) CmdEditLine.Attributes["disabled"] = "disabled";
                        if (CmdDeleteLine != null && CanDelete == false) CmdDeleteLine.Attributes["disabled"] = "disabled";
                        if (CmdSearchItem != null && CanAdd == false) CmdSearchItem.Attributes["disabled"] = "disabled";
                    }
                    else
                    {
                        if (CmdAdd != null) CmdAdd.Attributes["disabled"] = "disabled";
                        if (CmdSave != null) CmdSave.Attributes["disabled"] = "disabled";
                        if (CmdEdit != null) CmdEdit.Attributes["disabled"] = "disabled";
                        if (CmdDelete != null) CmdDelete.Attributes["disabled"] = "disabled";
                        if (CmdPrint != null && CanPrint == false) CmdPrint.Attributes["disabled"] = "disabled";
                        if (CmdApprove != null) CmdApprove.Attributes["disabled"] = "disabled";
                        if (CmdDisapprove != null && CanDisapprove == false) CmdDisapprove.Attributes["disabled"] = "disabled";
                        if (CmdAddLine != null) CmdAddLine.Attributes["disabled"] = "disabled";
                        if (CmdEditLine != null) CmdEditLine.Attributes["disabled"] = "disabled";
                        if (CmdDeleteLine != null) CmdDeleteLine.Attributes["disabled"] = "disabled";
                        if (CmdSearchItem != null) CmdSearchItem.Attributes["disabled"] = "disabled";
                    }

                    // MstAccount List

                    var CmdAddAccount = FindHtmlControl(Parent, "CmdAddAccount");
                    var CmdEditAccount = FindHtmlControl(Parent, "CmdEditAccount");
                    var CmdDeleteAccount = FindHtmlControl(Parent, "CmdDeleteAccount");
                    var CmdAddAccountType = FindHtmlControl(Parent, "CmdAddAccountType");
                    var CmdEditAccountType = FindHtmlControl(Parent, "CmdEditAccountType");
                    var CmdDeleteAccountType = FindHtmlControl(Parent, "CmdDeleteAccountType");
                    var CmdAddAccountCategory = FindHtmlControl(Parent, "CmdAddAccountCategory");
                    var CmdEditAccountCategory = FindHtmlControl(Parent, "CmdEditAccountCategory");
                    var CmdDeleteAccountCategory = FindHtmlControl(Parent, "CmdDeleteAccountCategory");

                    if (CmdAddAccount != null && CanAdd == false) CmdAddAccount.Attributes["disabled"] = "disabled";
                    if (CmdEditAccount != null && CanEdit == false) CmdEditAccount.Attributes["disabled"] = "disabled";
                    if (CmdDeleteAccount != null && CanDelete == false) CmdDeleteAccount.Attributes["disabled"] = "disabled";
                    if (CmdAddAccountType != null && CanAdd == false) CmdAddAccountType.Attributes["disabled"] = "disabled";
                    if (CmdEditAccountType != null && CanEdit == false) CmdEditAccountType.Attributes["disabled"] = "disabled";
                    if (CmdDeleteAccountType != null && CanDelete == false) CmdDeleteAccountType.Attributes["disabled"] = "disabled";
                    if (CmdAddAccountCategory != null && CanAdd == false) CmdAddAccountCategory.Attributes["disabled"] = "disabled";
                    if (CmdEditAccountCategory != null && CanEdit == false) CmdEditAccountCategory.Attributes["disabled"] = "disabled";
                    if (CmdDeleteAccountCategory != null && CanDelete == false) CmdDeleteAccountCategory.Attributes["disabled"] = "disabled";

                    // MstAccount Detail

                    var CmdEditBudgetLine = FindHtmlControl(Parent, "CmdEditBudgetLine");
                    var CmdDeleteBudgetLine = FindHtmlControl(Parent, "CmdDeleteBudgetLine");

                    if (CmdEditBudgetLine != null && CanEdit == false) CmdEditBudgetLine.Attributes["disabled"] = "disabled";
                    if (CmdDeleteBudgetLine != null && CanDelete == false) CmdDeleteBudgetLine.Attributes["disabled"] = "disabled";

                    // SysFolders

                    var CmdAddUnit = FindHtmlControl(Parent, "CmdAddUnit");
                    var CmdEditUnit = FindHtmlControl(Parent, "CmdEditUnit");
                    var CmdDeleteUnit = FindHtmlControl(Parent, "CmdDeleteUnit");
                    var CmdAddTax = FindHtmlControl(Parent, "CmdAddTax");
                    var CmdEditTax = FindHtmlControl(Parent, "CmdEditTax");
                    var CmdDeleteTax = FindHtmlControl(Parent, "CmdDeleteTax");
                    var CmdAddBank = FindHtmlControl(Parent, "CmdAddBank");
                    var CmdEditBank = FindHtmlControl(Parent, "CmdEditBank");
                    var CmdDeleteBank = FindHtmlControl(Parent, "CmdDeleteBank");
                    var CmdAddTerm = FindHtmlControl(Parent, "CmdAddTerm");
                    var CmdEditTerm = FindHtmlControl(Parent, "CmdEditTerm");
                    var CmdDeleteTerm = FindHtmlControl(Parent, "CmdDeleteTerm");
                    var CmdAddPayType = FindHtmlControl(Parent, "CmdAddPayType");
                    var CmdEditPayType = FindHtmlControl(Parent, "CmdEditPayType");
                    var CmdDeletePayType = FindHtmlControl(Parent, "CmdDeletePayType");

                    if (CmdAddUnit != null && CanAdd == false) CmdAddUnit.Attributes["disabled"] = "disabled";
                    if (CmdEditUnit != null && CanEdit == false) CmdEditUnit.Attributes["disabled"] = "disabled";
                    if (CmdDeleteUnit != null && CanDelete == false) CmdDeleteUnit.Attributes["disabled"] = "disabled";
                    if (CmdAddTax != null && CanAdd == false) CmdAddTax.Attributes["disabled"] = "disabled";
                    if (CmdEditTax != null && CanEdit == false) CmdEditTax.Attributes["disabled"] = "disabled";
                    if (CmdDeleteTax != null && CanDelete == false) CmdDeleteTax.Attributes["disabled"] = "disabled";
                    if (CmdAddBank != null && CanAdd == false) CmdAddBank.Attributes["disabled"] = "disabled";
                    if (CmdEditBank != null && CanEdit == false) CmdEditBank.Attributes["disabled"] = "disabled";
                    if (CmdDeleteBank != null && CanDelete == false) CmdDeleteBank.Attributes["disabled"] = "disabled";
                    if (CmdAddTerm != null && CanAdd == false) CmdAddTerm.Attributes["disabled"] = "disabled";
                    if (CmdEditTerm != null && CanEdit == false) CmdEditTerm.Attributes["disabled"] = "disabled";
                    if (CmdDeleteTerm != null && CanDelete == false) CmdDeleteTerm.Attributes["disabled"] = "disabled";
                    if (CmdAddPayType != null && CanAdd == false) CmdAddPayType.Attributes["disabled"] = "disabled";
                    if (CmdEditPayType != null && CanEdit == false) CmdEditPayType.Attributes["disabled"] = "disabled";
                    if (CmdDeletePayType != null && CanDelete == false) CmdDeletePayType.Attributes["disabled"] = "disabled";

                    // MstItemDetail

                    var CmdAddItemPrice = FindHtmlControl(Parent, "CmdAddItemPrice");
                    var CmdEditItemPrice = FindHtmlControl(Parent, "CmdEditItemPrice");
                    var CmdDeleteItemPrice = FindHtmlControl(Parent, "CmdDeleteItemPrice");
                    var CmdAddItemUnit = FindHtmlControl(Parent, "CmdAddItemUnit");
                    var CmdEditItemUnit = FindHtmlControl(Parent, "CmdEditItemUnit");
                    var CmdDeleteItemUnit = FindHtmlControl(Parent, "CmdDeleteItemUnit");
                    var CmdAddItemComponent = FindHtmlControl(Parent, "CmdAddItemComponent");
                    var CmdEditItemComponent = FindHtmlControl(Parent, "CmdEditItemComponent");
                    var CmdDeleteItemComponent = FindHtmlControl(Parent, "CmdDeleteItemComponent");

                    if (CmdAddItemPrice != null && CanAdd == false) CmdAddItemPrice.Attributes["disabled"] = "disabled";
                    if (CmdEditItemPrice != null && CanEdit == false) CmdEditItemPrice.Attributes["disabled"] = "disabled";
                    if (CmdDeleteItemPrice != null && CanDelete == false) CmdDeleteItemPrice.Attributes["disabled"] = "disabled";
                    if (CmdAddItemUnit != null && CanAdd == false) CmdAddItemUnit.Attributes["disabled"] = "disabled";
                    if (CmdEditItemUnit != null && CanEdit == false) CmdEditItemUnit.Attributes["disabled"] = "disabled";
                    if (CmdDeleteItemUnit != null && CanDelete == false) CmdDeleteItemUnit.Attributes["disabled"] = "disabled";
                    if (CmdAddItemComponent != null && CanAdd == false) CmdAddItemComponent.Attributes["disabled"] = "disabled";
                    if (CmdEditItemComponent != null && CanEdit == false) CmdEditItemComponent.Attributes["disabled"] = "disabled";
                    if (CmdDeleteItemComponent != null && CanDelete == false) CmdDeleteItemComponent.Attributes["disabled"] = "disabled";

                    // MstUserStaffDetail

                    var CmdAddRole = FindHtmlControl(Parent, "CmdAddRole");
                    var CmdAddDownloadedRoles = FindHtmlControl(Parent, "CmdAddDownloadedRoles");
                    var CmdEditRole = FindHtmlControl(Parent, "CmdEditRole");
                    var CmdDeleteRole = FindHtmlControl(Parent, "CmdDeleteRole");

                    if (CmdAddRole != null && CanAdd == false) CmdAddRole.Attributes["disabled"] = "disabled";
                    if (CmdAddDownloadedRoles != null && CanAdd == false) CmdAddDownloadedRoles.Attributes["disabled"] = "disabled";
                    if (CmdEditRole != null && CanEdit == false) CmdEditRole.Attributes["disabled"] = "disabled";
                    if (CmdDeleteRole != null && CanDelete == false) CmdDeleteRole.Attributes["disabled"] = "disabled";

                    // RepAccountsPayable
                    var CmdViewAccountsPayable = FindHtmlControl(Parent, "CmdViewAccountsPayable");

                    if (CmdViewAccountsPayable != null && CanPrint == false) CmdViewAccountsPayable.Attributes["disabled"] = "disabled";

                    // RepAccountsReceivable

                    var CmdViewAccountsReceivable = FindHtmlControl(Parent, "CmdViewAccountsReceivable");

                    if (CmdViewAccountsReceivable != null && CanPrint == false) CmdViewAccountsReceivable.Attributes["disabled"] = "disabled";

                    // RepCollection

                    var CmdViewCollectionSummary = FindHtmlControl(Parent, "CmdViewCollectionSummary");
                    var CmdViewCollectionDetail = FindHtmlControl(Parent, "CmdViewCollectionDetail");
                    var CmdViewCollectionBook = FindHtmlControl(Parent, "CmdViewCollectionBook");

                    if (CmdViewCollectionSummary != null && CanPrint == false) CmdViewCollectionSummary.Attributes["disabled"] = "disabled";
                    if (CmdViewCollectionDetail != null && CanPrint == false) CmdViewCollectionDetail.Attributes["disabled"] = "disabled";
                    if (CmdViewCollectionBook != null && CanPrint == false) CmdViewCollectionBook.Attributes["disabled"] = "disabled";

                    // RepDisbursement

                    var CmdViewDisbursementSummary = FindHtmlControl(Parent, "CmdViewDisbursementSummary");
                    var CmdViewDisbursementDetail = FindHtmlControl(Parent, "CmdViewDisbursementDetail");
                    var CmdViewDisbursementBook = FindHtmlControl(Parent, "CmdViewDisbursementBook");

                    if (CmdViewDisbursementSummary != null && CanPrint == false) CmdViewDisbursementSummary.Attributes["disabled"] = "disabled";
                    if (CmdViewDisbursementDetail != null && CanPrint == false) CmdViewDisbursementDetail.Attributes["disabled"] = "disabled";
                    if (CmdViewDisbursementBook != null && CanPrint == false) CmdViewDisbursementBook.Attributes["disabled"] = "disabled";

                    // RepFinancialStatement

                    var CmdViewBalanceSheet = FindHtmlControl(Parent, "CmdViewBalanceSheet");
                    var CmdViewIncomeStatement = FindHtmlControl(Parent, "CmdViewIncomeStatement");
                    var CmdViewTrialBalance = FindHtmlControl(Parent, "CmdViewTrialBalance");
                    var CmdViewAccountLedger = FindHtmlControl(Parent, "CmdViewAccountLedger");
                    var CmdViewCashFlowStatement = FindHtmlControl(Parent, "CmdViewCashFlowStatement");

                    if (CmdViewBalanceSheet != null && CanPrint == false) CmdViewBalanceSheet.Attributes["disabled"] = "disabled";
                    if (CmdViewIncomeStatement != null && CanPrint == false) CmdViewIncomeStatement.Attributes["disabled"] = "disabled";
                    if (CmdViewTrialBalance != null && CanPrint == false) CmdViewTrialBalance.Attributes["disabled"] = "disabled";
                    if (CmdViewAccountLedger != null && CanPrint == false) CmdViewAccountLedger.Attributes["disabled"] = "disabled";
                    if (CmdViewCashFlowStatement != null && CanPrint == false) CmdViewCashFlowStatement.Attributes["disabled"] = "disabled";

                    // RepInventory

                    var CmdViewInventory = FindHtmlControl(Parent, "CmdViewInventory");
                    var CmdViewStockCard = FindHtmlControl(Parent, "CmdViewStockCard");
                    var CmdStockIn = FindHtmlControl(Parent, "CmdStockIn");
                    var CmdViewStockOut = FindHtmlControl(Parent, "CmdViewStockOut");
                    var CmdViewInventoryBook = FindHtmlControl(Parent, "CmdViewInventoryBook");

                    if (CmdViewInventory != null && CanPrint == false) CmdViewInventory.Attributes["disabled"] = "disabled";
                    if (CmdViewStockCard != null && CanPrint == false) CmdViewStockCard.Attributes["disabled"] = "disabled";
                    if (CmdStockIn != null && CanPrint == false) CmdStockIn.Attributes["disabled"] = "disabled";
                    if (CmdViewStockOut != null && CanPrint == false) CmdViewStockOut.Attributes["disabled"] = "disabled";
                    if (CmdViewInventoryBook != null && CanPrint == false) CmdViewInventoryBook.Attributes["disabled"] = "disabled";

                    // RepPurchases

                    var CmdViewPurchaseSummary = FindHtmlControl(Parent, "CmdViewPurchaseSummary");
                    var CmdViewPurchaseDetail = FindHtmlControl(Parent, "CmdViewPurchaseDetail");
                    var CmdViewPurchaseBook = FindHtmlControl(Parent, "CmdViewPurchaseBook");

                    if (CmdViewPurchaseSummary != null && CanPrint == false) CmdViewPurchaseSummary.Attributes["disabled"] = "disabled";
                    if (CmdViewPurchaseDetail != null && CanPrint == false) CmdViewPurchaseDetail.Attributes["disabled"] = "disabled";
                    if (CmdViewPurchaseBook != null && CanPrint == false) CmdViewPurchaseBook.Attributes["disabled"] = "disabled";

                    // RepSales

                    var CmdViewSalesSummary = FindHtmlControl(Parent, "CmdViewSalesSummary");
                    var CmdViewSalesDetail = FindHtmlControl(Parent, "CmdViewSalesDetail");
                    var CmdViewSalesBook = FindHtmlControl(Parent, "CmdViewSalesBook");

                    if (CmdViewSalesSummary != null && CanPrint == false) CmdViewSalesSummary.Attributes["disabled"] = "disabled";
                    if (CmdViewSalesDetail != null && CanPrint == false) CmdViewSalesDetail.Attributes["disabled"] = "disabled";
                    if (CmdViewSalesBook != null && CanPrint == false) CmdViewSalesBook.Attributes["disabled"] = "disabled";

                    // TrnBank

                    var CmdEditBankRecon = FindHtmlControl(Parent, "CmdEditBankRecon");
                    var CmdViewBankRecon = FindHtmlControl(Parent, "CmdViewBankRecon");

                    if (CmdEditBankRecon != null && CanEdit == false) CmdEditBankRecon.Attributes["disabled"] = "disabled";
                    if (CmdViewBankRecon != null && CanPrint == false) CmdViewBankRecon.Attributes["disabled"] = "disabled";

                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
    }
}