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
    public class MstCompanyController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/MstCompany
        // ======================

        [HttpGet]
        public Models.SysDataTablePager Get()
        {
            int NumberOfRecords = 20;
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = data.MstCompanies.Where(d => d.UserId == secure.GetCurrentSubscriberUser()).Count();


            var Companies = (from d in data.MstCompanies
                             where d.UserId == secure.GetCurrentSubscriberUser()
                             select new Models.MstCompany
                             {
                                 Id = d.Id,
                                 CompanyCode = d.CompanyCode,
                                 Company = d.Company
                             });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Companies = Companies.OrderBy(d => d.CompanyCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Companies = Companies.OrderByDescending(d => d.CompanyCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Companies = Companies.OrderBy(d => d.Company).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Companies = Companies.OrderByDescending(d => d.Company).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Companies = Companies.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var CompanyPaged = new Models.SysDataTablePager();

            CompanyPaged.sEcho = sEcho;
            CompanyPaged.iTotalRecords = Count;
            CompanyPaged.iTotalDisplayRecords = Count;
            CompanyPaged.MstCompanyData = Companies.ToList();

            return CompanyPaged;
        }        
    }
}