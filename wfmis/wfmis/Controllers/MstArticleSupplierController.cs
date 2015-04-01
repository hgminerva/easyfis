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
    public class MstArticleSupplierController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        private Business.Security secure = new Business.Security();

        // GET api/MstArticleSupplier
        public Models.SysDataTablePager Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.MstArticles.Where(d => d.MstUser.Id == secure.GetCurrentUser() &&
                                                  d.MstArticleType.ArticleType == "Supplier" &&
                                                  d.MstArticleSuppliers.Count() > 0).Count();


            var Suppliers = (from d in db.MstArticles
                             where d.MstUser.Id == secure.GetCurrentUser() &&
                                   d.MstArticleType.ArticleType == "Supplier" &&
                                   d.MstArticleSuppliers.Count() > 0 &&
                                   d.Article.Contains(sSearch)
                             select new Models.MstArticleSupplier
                             {
                                 Id = d.MstArticleSuppliers.First().Id,
                                 ArticleId = d.Id,
                                 AccountId = d.MstAccount.Id,
                                 Account = d.MstAccount.Account,
                                 SupplierCode = d.ArticleCode,
                                 Supplier = d.Article,
                                 Address = d.MstArticleSuppliers.First().Address,
                                 ContactNumbers = d.MstArticleSuppliers.First().ContactNumbers,
                                 ContactPerson = d.MstArticleSuppliers.First().ContactPerson,
                                 EmailAddress = d.MstArticleSuppliers.First().EmailAddress
                             });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Suppliers = Suppliers.OrderBy(d => d.SupplierCode).Skip(iDisplayStart).Take(10);
                    else Suppliers = Suppliers.OrderByDescending(d => d.SupplierCode).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") Suppliers = Suppliers.OrderBy(d => d.Supplier).Skip(iDisplayStart).Take(10);
                    else Suppliers = Suppliers.OrderByDescending(d => d.Supplier).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") Suppliers = Suppliers.OrderBy(d => d.ContactNumbers).Skip(iDisplayStart).Take(10);
                    else Suppliers = Suppliers.OrderByDescending(d => d.ContactNumbers).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    Suppliers = Suppliers.Skip(iDisplayStart).Take(10);
                    break;
            }

            var SupplierPaged = new Models.SysDataTablePager();

            SupplierPaged.sEcho = sEcho;
            SupplierPaged.iTotalRecords = Count;
            SupplierPaged.iTotalDisplayRecords = Count;
            SupplierPaged.MstArticleSupplierData = Suppliers.ToList();

            return SupplierPaged; 
        }

    }
}