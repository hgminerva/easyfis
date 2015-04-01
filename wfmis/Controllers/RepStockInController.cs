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
    public class RepStockInController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepStockIn
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab3DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab3DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab3PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab3BranchId"]);

            var StockIns = from d in db.TrnStockInLines
                           where d.TrnStockIn.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                 d.TrnStockIn.PeriodId == PeriodId &&
                                 d.TrnStockIn.BranchId == BranchId &&
                                 d.TrnStockIn.IsLocked == true &&
                                (d.TrnStockIn.INDate >= DateStart && d.TrnStockIn.INDate <= DateEnd)
                           select new Models.RepStockIn
                           {
                               PeriodId = d.TrnStockIn.PeriodId,
                               Period = d.TrnStockIn.MstPeriod.Period,
                               BranchId = d.TrnStockIn.BranchId,
                               Branch = d.TrnStockIn.MstBranch.Branch,
                               StockIn = "(TrnStockInDetail.aspx?Id=" + d.TrnStockIn.Id + ")" + d.TrnStockIn.INNumber + " - " + d.TrnStockIn.Particulars,
                               INDate = d.TrnStockIn.INDate.ToShortDateString(),
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
            ReportPaged.RepStockInData = StockIns.ToList();

            return ReportPaged;
        }
    }
}