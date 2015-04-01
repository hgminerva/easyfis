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
    public class SysItemSearchController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // =====================
        // GET api/SysItemSearch
        // =====================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            int NumberOfRecords = 6;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = data.MstArticles.Where(d => d.UserId == secure.GetCurrentSubscriberUser() &&
                                                    d.MstArticleType.ArticleType == "Item" &&
                                                    d.MstArticleItems.Count() > 0 && 
                                                    d.MstArticleItemInventories.Count() > 0).Count();


            var Items = (from d in data.MstArticles
                         where d.UserId == secure.GetCurrentSubscriberUser() &&
                               d.MstArticleType.ArticleType == "Item" &&
                               d.MstArticleItems.Count() > 0 &&
                               d.MstArticleItemInventories.Count() > 0 &&
                               d.Article.Contains(sSearch)
                         select new Models.MstArticleItem
                         {
                             Id = d.Id,
                             Item = d.Article,
                             Remarks = "<b>" + d.Article + "</b><br>" +
                                       "Available: " + d.MstArticleItemInventories.Where(i => i.BranchId == d.MstUser.DefaultBranchId).Sum(i => i.BalanceQuantity).ToString() + " " + d.MstArticleItems.First().MstUnit.Unit
                         });

            switch (iSortCol)
            {
                case 1:
                    if (sSortDir == "asc") Items = Items.OrderBy(d => d.Item).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Items = Items.OrderByDescending(d => d.Item).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Items = Items.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var ItemPaged = new Models.SysDataTablePager();

            ItemPaged.sEcho = sEcho;
            ItemPaged.iTotalRecords = Count;
            ItemPaged.iTotalDisplayRecords = Count;
            ItemPaged.MstArticleItemData = Items.ToList();

            return ItemPaged;
        }
    }
}