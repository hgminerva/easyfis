using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectSalesOrderController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectSalesOrder
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, Int64 customerId)
        {
            var SalesOrders = from d in data.TrnSalesOrders
                              where d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                    d.CustomerId == customerId &&
                                    d.SONumber.Contains(searchTerm == null ? "" : searchTerm)
                              orderby d.SONumber descending
                              select new Models.SelectObject
                                 {
                                     id = d.Id,
                                     text = d.SONumber
                                 };

            Int64 Count = SalesOrders.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = SalesOrders.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}