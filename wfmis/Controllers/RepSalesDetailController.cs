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
    public class RepSalesDetailController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepSalesDetail
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab2DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab2DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab2PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab2BranchId"]);

            var Sales = from s in db.TrnSalesInvoiceLines
                        where s.TrnSalesInvoice.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                              s.TrnSalesInvoice.PeriodId == PeriodId &&
                              s.TrnSalesInvoice.BranchId == BranchId &&
                             (s.TrnSalesInvoice.SIDate >= DateStart && s.TrnSalesInvoice.SIDate <= DateEnd)
                        select new Models.RepSalesDetail
                        {
                            PeriodId = s.TrnSalesInvoice.PeriodId,
                            Period = s.TrnSalesInvoice.MstPeriod.Period,
                            BranchId = s.TrnSalesInvoice.BranchId,
                            Branch = s.TrnSalesInvoice.MstBranch.Branch,
                            SalesInvoice = "(TrnSalesInvoiceDetail.aspx?Id=" + s.SIId + ")" + s.TrnSalesInvoice.SINumber + " - " + s.TrnSalesInvoice.MstArticle.Article,
                            SIDate = s.TrnSalesInvoice.SIDate.ToShortDateString(),
                            Quantity = s.Quantity,
                            Unit = s.MstUnit.Unit,
                            Item = s.MstArticle.Article,
                            Particulars = s.Particulars,
                            NetPrice = s.NetPrice,
                            Amount = s.Amount,
                            Tax = s.MstTax.TaxCode,
                            TaxAmount = s.TaxAmount
                        };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepSalesDetailData = Sales.ToList();

            return ReportPaged;
        }
    }
}