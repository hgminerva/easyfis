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
    public class RepStockTransferController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepStockTransfer
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab5DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab5DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab5PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab5BranchId"]);

            var StockTransfers = from d in db.TrnStockTransferLines
                                 where d.TrnStockTransfer.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                       d.TrnStockTransfer.PeriodId == PeriodId &&
                                       d.TrnStockTransfer.BranchId == BranchId &&
                                      (d.TrnStockTransfer.STDate >= DateStart && d.TrnStockTransfer.STDate <= DateEnd)
                                 select new Models.RepStockTransfer
                                 {
                                     PeriodId = d.TrnStockTransfer.PeriodId,
                                     Period = d.TrnStockTransfer.MstPeriod.Period,
                                     BranchId = d.TrnStockTransfer.BranchId,
                                     Branch = d.TrnStockTransfer.MstBranch.Branch,
                                     StockTransfer = "(TrnStockTransferDetail.aspx?Id=" + d.STId + ")" + d.TrnStockTransfer.STNumber + " - " + d.TrnStockTransfer.Particulars,
                                     STDate = d.TrnStockTransfer.STDate.ToShortDateString(),
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
            ReportPaged.RepStockTransferData = StockTransfers.ToList();

            return ReportPaged;
        }
    }
}