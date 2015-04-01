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
    public class RepPurchaseDetailController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepPurchaseDetail
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab2DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab2DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab2PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab2BranchId"]);

            var Purchases = from p in db.TrnPurchaseInvoiceLines
                            where p.TrnPurchaseInvoice.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                  p.TrnPurchaseInvoice.PeriodId == PeriodId &&
                                  p.TrnPurchaseInvoice.BranchId == BranchId &&
                                 (p.TrnPurchaseInvoice.PIDate >= DateStart && p.TrnPurchaseInvoice.PIDate <= DateEnd)
                            select new Models.RepPurchaseDetail
                            {
                                PeriodId = p.TrnPurchaseInvoice.PeriodId,
                                Period = p.TrnPurchaseInvoice.MstPeriod.Period,
                                BranchId = p.TrnPurchaseInvoice.BranchId,
                                Branch = p.TrnPurchaseInvoice.MstBranch.Branch,
                                PurchaseInvoice = "(TrnPurchaseInvoiceDetail.aspx?Id=" + p.PIId + ")" + p.TrnPurchaseInvoice.PINumber + " - " + p.TrnPurchaseInvoice.MstArticle.Article,
                                PIDate = p.TrnPurchaseInvoice.PIDate.ToShortDateString(),
                                Quantity = p.Quantity,
                                Unit = p.MstUnit.Unit,
                                Item = p.MstArticle.Article,
                                Particulars = p.Particulars,
                                Cost = p.Cost,
                                Amount = p.Amount,
                                Tax = p.MstTax.TaxCode,
                                TaxAmount = p.TaxAmount
                            };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepPurchaseDetailData = Purchases.ToList();

            return ReportPaged;
        }
    }
}