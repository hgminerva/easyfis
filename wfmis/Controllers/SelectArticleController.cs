using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SelectArticleController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/SelectArticle
        [HttpGet]
        public Models.SelectPagedObject Get(string searchTerm, int pageSize, int pageNum)
        {

            var Articles = from d in data.MstArticles
                           where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                 d.Article.Contains(searchTerm == null ? "" : searchTerm)
                           select new Models.SelectObject
                           {
                               id = d.Id,
                               text = d.MstArticleType.ArticleType + " - " + d.Article
                           };

            Int64 Count = Articles.Count();

            Models.SelectPagedObject PagedResult = new Models.SelectPagedObject();

            PagedResult.Total = Count;
            PagedResult.Results = Articles.Skip((pageNum - 1) * pageSize).Take(pageSize).ToList();

            return PagedResult;
        }
    }
}