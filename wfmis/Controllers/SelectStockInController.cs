using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectStockInController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectStockIn
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {
            var StockIns = from d in data.TrnStockIns
                           where d.MstBranch.UserId == secure.GetCurrentSubscriberUser() &&
                                d.INNumber.Contains(searchTerm == null ? "" : searchTerm)
                           orderby d.INNumber descending
                           select new Models.SelectObject
                           {
                                id = d.Id,
                                text = d.INNumber
                           };

            Int64 Count = StockIns.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = StockIns.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}