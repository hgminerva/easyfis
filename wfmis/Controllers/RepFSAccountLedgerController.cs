using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class RepFSAccountLedgerController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        private Int64 GetDocumentId(Data.TrnJournal j)
        {
            Int64 DocumentId;

            DocumentId = 0;

            if (j.PIId > 0) DocumentId = j.PIId.Value;
            if (j.CVId > 0) DocumentId = j.CVId.Value;
            if (j.SIId > 0) DocumentId = j.SIId.Value;
            if (j.ORId > 0) DocumentId = j.ORId.Value;
            if (j.INId > 0) DocumentId = j.INId.Value;
            if (j.OTId > 0) DocumentId = j.OTId.Value;
            if (j.JVId > 0) DocumentId = j.JVId.Value;

            return DocumentId;
        }
        private string GetDocument(Data.TrnJournal j)
        {
            string Document;

            Document = "NA";

            if (j.PIId > 0) Document = "PI";
            if (j.CVId > 0) Document = "CV";
            if (j.SIId > 0) Document = "SI";
            if (j.ORId > 0) Document = "OR";
            if (j.INId > 0) Document = "IN";
            if (j.OTId > 0) Document = "OT";
            if (j.JVId > 0) Document = "JV";

            return Document;
        }
        private string GetDocumentNumber(Data.TrnJournal j)
        {
            string DocumentNumber;

            DocumentNumber = "NA-0000000000";

            if (j.PIId > 0) DocumentNumber = "(TrnPurchaseInvoiceDetail.aspx?Id=" + j.PIId + ")PI-" + j.TrnPurchaseInvoice.PINumber;
            if (j.CVId > 0) DocumentNumber = "(TrnDisbursementDetail.aspx?Id=" + j.CVId + ")CV-" + j.TrnDisbursement.CVNumber;
            if (j.SIId > 0) DocumentNumber = "(TrnSalesInvoiceDetail.aspx?Id=" + j.SIId + ")SI-" + j.TrnSalesInvoice.SINumber;
            if (j.ORId > 0) DocumentNumber = "(TrnCollectionDetail.aspx?Id=" + j.ORId + ")OR-" + j.TrnCollection.ORNumber;
            if (j.INId > 0) DocumentNumber = "(TrnStockInDetail.aspx?Id=" + j.INId + ")IN-" + j.TrnStockIn.INNumber;
            if (j.OTId > 0) DocumentNumber = "(TrnSalesOrderDetail.aspx?Id=" + j.OTId + ")OT-" + j.TrnStockOut.OTNumber;
            if (j.JVId > 0) DocumentNumber = "(TrnJournalVoucherDetail.aspx?Id=" + j.JVId + ")JV-" + j.TrnJournalVoucher.JVNumber;

            return DocumentNumber;
        }

        // GET api/RepFSAccountLedger
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab4DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab4DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab4PeriodId"]);
            Int64 CompanyId = Convert.ToInt64(parameters["tab4CompanyId"]);
            Int64 AccountId = Convert.ToInt64(parameters["tab4AccountId"]);

            var JournalEntries = from j in db.TrnJournals
                                 where j.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                       j.PeriodId == PeriodId &&
                                       j.MstBranch.CompanyId == CompanyId &&
                                       j.AccountId == AccountId &&
                                      (j.JournalDate >= DateStart && j.JournalDate <= DateEnd)
                                 select new Models.RepFSAccountLedger
                                 {
                                     PeriodId = j.MstPeriod.Id,
                                     Period = j.MstPeriod.Period,
                                     CompanyId = j.MstBranch.CompanyId,
                                     Company = j.MstBranch.MstCompany.Company,
                                     AccountId = j.AccountId,
                                     AccountCode = j.MstAccount.AccountCode,
                                     Account = j.MstAccount.AccountCode + " - " + j.MstAccount.Account,
                                     DocumentId = GetDocumentId(j),
                                     DocumentDate = j.JournalDate.ToShortDateString(),
                                     Document = GetDocument(j),
                                     DocumentNumber = GetDocumentNumber(j),
                                     ArticleId = j.ArticleId==null?0:j.ArticleId.Value,
                                     Article = j.ArticleId==null?"":j.MstArticle.Article,
                                     Particulars = j.Particulars,
                                     DebitAmount = j.DebitAmount,
                                     CreditAmount = j.CreditAmount
                                 };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepFSAccountLedgerData = JournalEntries.ToList();

            return ReportPaged;
        }
    }
}