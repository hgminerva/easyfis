using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectSupplierController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectSupplier
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Suppliers = from d in data.MstArticles
                            where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                  d.MstArticleType.ArticleType == "Supplier" &&
                                  d.Article.Contains(searchTerm == null ? "" : searchTerm)
                            orderby d.Article
                            select new Models.SelectObject
                            {
                                id = d.Id,
                                text = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(
                                            new Models.MstArticleSupplier
                                            {
                                                Supplier = d.Article,
                                                TermId = d.MstArticleSuppliers.First().TermId,
                                                Term = d.MstArticleSuppliers.First().MstTerm.Term
                                            }
                                       )
                            };

            Int64 Count = Suppliers.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Suppliers.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}