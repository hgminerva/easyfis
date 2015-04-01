using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectSalesInvoiceController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // GET api/SelectSalesInvoice
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum, Int64 customerId)
        {
            if (customerId > 0)
            {
                var SalesInvoices = from d in data.TrnSalesInvoices
                                    where d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                          d.CustomerId == customerId &&
                                          d.SINumber.Contains(searchTerm == null ? "" : searchTerm)
                                    orderby d.SINumber descending
                                    select new Models.SelectObject
                                    {
                                        id = d.Id,
                                        text = d.SINumber
                                    };

                Int64 Count = SalesInvoices.Count();

                Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

                PagedResult.Total = Count;
                PagedResult.Results = SalesInvoices.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

                return PagedResult;
            }
            else
            {
                var SalesInvoices = from d in data.TrnSalesInvoices
                                    where d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                          d.SINumber.Contains(searchTerm == null ? "" : searchTerm)
                                    orderby d.SINumber descending
                                    select new Models.SelectObject
                                    {
                                        id = d.Id,
                                        text = d.SINumber
                                    };

                Int64 Count = SalesInvoices.Count();

                Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

                PagedResult.Total = Count;
                PagedResult.Results = SalesInvoices.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

                return PagedResult;
            }
        }
    }
}