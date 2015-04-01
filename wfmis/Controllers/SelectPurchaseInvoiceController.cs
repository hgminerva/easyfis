using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectPurchaseInvoiceController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectPurchaseInvoice
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, Int64 supplierId)
        {
            if (supplierId > 0)
            {
                var PurchaseInvoices =  from d in db.TrnPurchaseInvoices
                                        where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                                d.SupplierId == supplierId &&
                                                d.PINumber.Contains(searchTerm == null ? "" : searchTerm)
                                        orderby d.PINumber descending
                                        select new Models.SelectObject
                                        {
                                            id = d.Id,
                                            text = d.PINumber
                                        };

                Int64 Count = PurchaseInvoices.Count();

                Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

                PagedResult.Total = Count;
                PagedResult.Results = PurchaseInvoices.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

                return PagedResult;
            } 
            else
            {
                var PurchaseInvoices = from d in db.TrnPurchaseInvoices
                                       where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                               d.PINumber.Contains(searchTerm == null ? "" : searchTerm)
                                       orderby d.PINumber descending
                                       select new Models.SelectObject
                                       {
                                           id = d.Id,
                                           text = d.PINumber
                                       };
                Int64 Count = PurchaseInvoices.Count();

                Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

                PagedResult.Total = Count;
                PagedResult.Results = PurchaseInvoices.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

                return PagedResult;
            }
        }
   
    }
}