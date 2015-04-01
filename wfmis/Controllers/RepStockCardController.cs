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
    public class RepStockCardController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security security = new Business.Security();

        // GET api/RepStockCard
        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            DateTime DateStart = Convert.ToDateTime(parameters["tab2DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab2DateEnd"]);
            Int64 PeriodId = Convert.ToInt64(parameters["tab2PeriodId"]);
            Int64 BranchId = Convert.ToInt64(parameters["tab2BranchId"]);
            Int64 ItemId = Convert.ToInt64(parameters["tab2ItemId"]);

            var BeginningInventories = from d in db.TrnInventories
                                       where d.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                              d.PeriodId == PeriodId &&
                                              d.BranchId == BranchId &&
                                              d.ItemId == ItemId &&
                                              d.InventoryDate < DateStart 
                                       group d by new
                                       {
                                           BranchId = d.BranchId,
                                           Branch = d.MstBranch.Branch,
                                           PeriodId = d.PeriodId,
                                           Period = d.MstPeriod.Period,
                                           Item = d.MstArticle.Article,
                                           Unit = d.MstUnit.Unit,
                                           InventoryDocument = "BEGINNING",
                                           InventoryDate = Convert.ToString(DateStart.Year) + "-" + Convert.ToString(DateStart.Month) + "-" + Convert.ToString(DateStart.Day),
                                           InventoryNumber = "CONSOLIDATED"
                                       } into g
                                       select new Models.RepStockCard
                                       {
                                           PeriodId = g.Key.PeriodId,
                                           Period = g.Key.Period,
                                           BranchId = g.Key.BranchId,
                                           Branch = g.Key.Branch,
                                           Item = g.Key.Item,
                                           Unit = g.Key.Unit,
                                           InventoryDocument = g.Key.InventoryDocument,
                                           InventoryDate = g.Key.InventoryDate,
                                           InventoryNumber = g.Key.InventoryNumber,
                                           BeginningQuantity = g.Sum(q => q.Quantity),
                                           QuantityIn = Convert.ToDecimal(0),
                                           QuantityOut = Convert.ToDecimal(0),
                                           Quantity = g.Sum(q => q.Quantity)
                                       };


            var CurrentInventories = from d in db.TrnInventories
                                     where  d.MstBranch.UserId == security.GetCurrentSubscriberUser() &&
                                            d.PeriodId == PeriodId &&
                                            d.BranchId == BranchId &&
                                            d.ItemId == ItemId &&
                                           (d.InventoryDate >= DateStart && d.InventoryDate <= DateEnd)
                                     group d by new
                                     {
                                         BranchId = d.BranchId,
                                         Branch = d.MstBranch.Branch,
                                         PeriodId = d.PeriodId,
                                         Period = d.MstPeriod.Period,
                                         Item = d.MstArticle.Article,
                                         Unit = d.MstUnit.Unit,
                                         InventoryDocument = d.INId > 0 ? "(TrnStockInDetail.aspx?Id=" + d.INId + ")IN-" + d.TrnStockIn.INNumber :
                                                             d.OTId > 0 ? "(TrnStockOutDetail.aspx?Id=" + d.OTId + ")OT-" + d.TrnStockOut.OTNumber :
                                                             d.STId > 0 ? "(TrnStockTransferDetail.aspx?Id=" + d.STId + ")ST-" + d.TrnStockTransfer.STNumber : "NA",
                                         InventoryDate = Convert.ToString(d.InventoryDate.Year) + "-" + Convert.ToString(d.InventoryDate.Month) + "-" + Convert.ToString(d.InventoryDate.Day),
                                         InventoryNumber = d.MstArticleItemInventory.InventoryNumber
                                     } into g
                                     select new Models.RepStockCard
                                     {
                                          PeriodId = g.Key.PeriodId,
                                          Period = g.Key.Period,
                                          BranchId = g.Key.BranchId,
                                          Branch = g.Key.Branch,
                                          Item = g.Key.Item,
                                          Unit = g.Key.Unit,
                                          InventoryDocument = g.Key.InventoryDocument,
                                          InventoryDate = g.Key.InventoryDate,
                                          InventoryNumber = g.Key.InventoryNumber,
                                          BeginningQuantity = 0,
                                          QuantityIn = g.Sum(q => q.QuantityIn),
                                          QuantityOut = g.Sum(q => q.QuantityOut),
                                          Quantity = g.Sum(q => q.Quantity)
                                     };

            var Inventories = (from d in BeginningInventories select d).Union
                              (from d in CurrentInventories select d);

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.RepStockCardData = Inventories.ToList();

            return ReportPaged;
        }
    }
}