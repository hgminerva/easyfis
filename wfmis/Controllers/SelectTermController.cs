﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectTermController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectTerm
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Terms = from d in data.MstTerms
                        where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                              d.Term.Contains(searchTerm == null ? "" : searchTerm)
                        orderby d.Term
                        select new Models.SelectObject
                        {
                            id = d.Id,
                            text = d.Term
                        };

            Int64 Count = Terms.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Terms.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}