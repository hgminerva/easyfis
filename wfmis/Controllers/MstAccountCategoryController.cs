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
    public class MstAccountCategoryController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/MstAccountType
        // ======================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.MstAccountCategories.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();

            var AccountCategories = from d in db.MstAccountCategories
                                    where d.UserId == secure.GetCurrentSubscriberUser() &&
                                          d.AccountCategory.Contains(sSearch == null ? "" : sSearch)
                                    select new Models.MstAccountCategory {
                                          Id = d.Id,
                                          AccountCategoryCode = d.AccountCategoryCode,
                                          AccountCategory = d.AccountCategory,
                                          IsLocked = d.IsLocked,
                                          CreatedById = d.CreatedById,
                                          CreatedBy = d.MstUser1.FullName,
                                          CreatedDateTime = Convert.ToString(d.CreatedDateTime.Day) + "/" + Convert.ToString(d.CreatedDateTime.Month) + "/" + Convert.ToString(d.CreatedDateTime.Year),
                                          UpdatedById = d.UpdatedById,
                                          UpdatedBy = d.MstUser2.FullName,
                                          UpdatedDateTime = Convert.ToString(d.UpdatedDateTime.Day) + "/" + Convert.ToString(d.UpdatedDateTime.Month) + "/" + Convert.ToString(d.UpdatedDateTime.Year)
                                    };

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") AccountCategories = AccountCategories.OrderBy(d => d.AccountCategoryCode).Skip(iDisplayStart).Take(10);
                    else AccountCategories = AccountCategories.OrderByDescending(d => d.AccountCategoryCode).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") AccountCategories = AccountCategories.OrderBy(d => d.AccountCategory).Skip(iDisplayStart).Take(10);
                    else AccountCategories = AccountCategories.OrderByDescending(d => d.AccountCategory).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    AccountCategories = AccountCategories.Skip(iDisplayStart).Take(10);
                    break;
            }

            var AccountCategoryPaged = new Models.SysDataTablePager();

            AccountCategoryPaged.sEcho = sEcho;
            AccountCategoryPaged.iTotalRecords = Count;
            AccountCategoryPaged.iTotalDisplayRecords = Count;
            AccountCategoryPaged.MstAccountCategoryData = AccountCategories.ToList();

            return AccountCategoryPaged;
        }

    }
}