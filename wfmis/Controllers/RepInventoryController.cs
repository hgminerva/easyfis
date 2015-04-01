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
    public class RepInventoryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepInventory
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab1DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab1DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab1PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab1BranchId"]);

            var Inventories = (from d in db.TrnInventories
                               where d.BranchId == BranchId &&
                                     d.PeriodId == PeriodId &&
                                     d.InventoryDate < DateStart //Convert.ToDateTime("2014-02-15")
                               group d by new
                               {
                                   BranchId = d.BranchId,
                                   Branch = d.MstBranch.Branch,
                                   PeriodId = d.PeriodId,
                                   Period = d.MstPeriod.Period,
                                   ItemId = d.ItemId,
                                   Item = d.MstArticle.Article,
                                   Unit = d.MstUnit.Unit
                               } into g
                               select new
                               {
                                   Document = "Beginning Balance",
                                   BranchId = g.Key.BranchId,
                                   Branch = g.Key.Branch,
                                   PeriodId = g.Key.PeriodId,
                                   Period = g.Key.Period,
                                   ItemId = g.Key.ItemId,
                                   Item = g.Key.Item,
                                   Unit = g.Key.Unit,
                                   BeginningQuantity = g.Sum(q => q.Quantity),
                                   TotalQuantityIn = Convert.ToDecimal("0"),
                                   TotalQuantityOut = Convert.ToDecimal("0"),
                                   EndingQuantity = g.Sum(q => q.Quantity)
                               }).Union(
                                from d in db.TrnInventories
                                where d.BranchId == BranchId &&
                                      d.PeriodId == PeriodId &&
                                     (d.InventoryDate >= DateStart && d.InventoryDate <= DateEnd)
                                group d by new
                                {
                                    BranchId = d.BranchId,
                                    Branch = d.MstBranch.Branch,
                                    PeriodId = d.PeriodId,
                                    Period = d.MstPeriod.Period,
                                    ItemId = d.ItemId,
                                    Item = d.MstArticle.Article,
                                    Unit = d.MstUnit.Unit
                                } into g
                                select new
                                {
                                    Document = "Current",
                                    BranchId = g.Key.BranchId,
                                    Branch = g.Key.Branch,
                                    PeriodId = g.Key.PeriodId,
                                    Period = g.Key.Period,
                                    ItemId = g.Key.ItemId,
                                    Item = g.Key.Item,
                                    Unit = g.Key.Unit,
                                    BeginningQuantity = Convert.ToDecimal("0"),
                                    TotalQuantityIn = g.Sum(q => q.QuantityIn),
                                    TotalQuantityOut = g.Sum(q => q.QuantityOut),
                                    EndingQuantity = g.Sum(q => q.Quantity)
                                });

            var SumInventories = from d in Inventories
                                 group d by new
                                 {
                                     BranchId = d.BranchId,
                                     Branch = d.Branch,
                                     PeriodId = d.PeriodId,
                                     Period = d.Period,
                                     ItemId = d.ItemId,
                                     Item = d.Item,
                                     Unit = d.Unit
                                 } into g
                                 select new Models.RepInventory
                                 {
                                     PeriodId = g.Key.PeriodId,
                                     Period = g.Key.Period,
                                     BranchId = g.Key.BranchId,
                                     Branch = g.Key.Branch,
                                     Item = Convert.ToString(g.Key.ItemId) + " - " + g.Key.Item,
                                     Unit = g.Key.Unit,
                                     BeginningQuantity = g.Sum(q => q.BeginningQuantity),
                                     TotalQuantityIn = g.Sum(q => q.TotalQuantityIn),
                                     TotalQuantityOut = g.Sum(q => q.TotalQuantityOut),
                                     EndingQuantity = g.Sum(q => q.EndingQuantity)
                                 };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepInventoryData = SumInventories.ToList();

            return ReportPaged;
        }
    }
}