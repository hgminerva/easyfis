using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectPurchaseOrderController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectPurchaseOrder
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, Int64 supplierId)
        {
            var PurchaseOrders = from d in data.TrnPurchaseOrders
                                 where d.MstUser.Id == secure.GetCurrentUser() &&
                                       d.SupplierId == supplierId &&
                                       d.PONumber.Contains(searchTerm == null ? "" : searchTerm)
                                 orderby d.PONumber descending
                                 select new Models.SelectObject
                                 {
                                     id = d.Id,
                                     text = d.PONumber
                                 };

            Int64 Count = PurchaseOrders.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = PurchaseOrders.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;            
        }

    }
}