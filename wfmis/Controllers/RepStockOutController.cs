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
    public class RepStockOutController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepStockOut
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab4DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab4DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab4PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab4BranchId"]);

            var StockOuts = from d in db.TrnStockOutLines
                            where d.TrnStockOut.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                  d.TrnStockOut.PeriodId == PeriodId &&
                                  d.TrnStockOut.BranchId == BranchId &&
                                  d.TrnStockOut.IsLocked == true &&
                                 (d.TrnStockOut.OTDate >= DateStart && d.TrnStockOut.OTDate <= DateEnd)
                            select new Models.RepStockOut
                            {
                                PeriodId = d.TrnStockOut.PeriodId,
                                Period = d.TrnStockOut.MstPeriod.Period,
                                BranchId = d.TrnStockOut.BranchId,
                                Branch = d.TrnStockOut.MstBranch.Branch,
                                StockOut = "(TrnStockOutDetail.aspx?Id=" + d.OTId + ")" + d.TrnStockOut.OTNumber + " - " + d.TrnStockOut.Particulars,
                                OTDate = d.TrnStockOut.OTDate.ToShortDateString(),
                                Quantity = d.Quantity,
                                Unit = d.MstUnit.Unit,
                                Item = d.MstArticle.Article,
                                Particulars = d.Particulars,
                                Cost = d.Cost,
                                Amount = d.Amount
                            };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepStockOutData = StockOuts.ToList();

            return ReportPaged;
        }
    }
}