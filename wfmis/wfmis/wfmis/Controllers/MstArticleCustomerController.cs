using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using wfmis.Models;

namespace wfmis.Controllers
{
    public class MstArticleCustomerController : ApiController
    {

        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private SysSecurity secure = new SysSecurity();

        // GET api/MstArticleCustomer
        public Models.SysDataTablePager Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = data.MstArticles.Where(d => d.MstUser.Id == secure.GetCurrentUser() &&
                                                    d.MstArticleType.ArticleType == "Customer" &&
                                                    d.MstArticleCustomers.Count() > 0).Count();


            var Customers = (from d in data.MstArticles
                             where d.MstUser.Id == secure.GetCurrentUser() &&
                                   d.MstArticleType.ArticleType == "Customer" &&
                                   d.MstArticleCustomers.Count() > 0 &&
                                   d.Article.Contains(sSearch)
                             select new Models.MstArticleCustomer
                             {
                                 Id = d.MstArticleCustomers.First().Id,
                                 ArticleId = d.Id,
                                 AccountId = d.MstAccount.Id,
                                 Account = d.MstAccount.Account,
                                 CustomerCode = d.ArticleCode,
                                 Customer = d.Article,
                                 Address = d.MstArticleCustomers.First().Address,
                                 ContactNumbers = d.MstArticleCustomers.First().ContactNumbers,
                                 ContactPerson = d.MstArticleCustomers.First().ContactPerson,
                                 EmailAddress = d.MstArticleCustomers.First().EmailAddress
                             });

            switch (iSortCol) 
            { 
                case 2:
                    if (sSortDir == "asc") Customers = Customers.OrderBy(d => d.CustomerCode).Skip(iDisplayStart).Take(10);
                    else Customers = Customers.OrderByDescending(d => d.CustomerCode).Skip(iDisplayStart).Take(10);
                    break;
                case 3:
                    if (sSortDir == "asc") Customers = Customers.OrderBy(d => d.Customer).Skip(iDisplayStart).Take(10);
                    else Customers = Customers.OrderByDescending(d => d.Customer).Skip(iDisplayStart).Take(10);
                    break;
                case 4:
                    if (sSortDir == "asc") Customers = Customers.OrderBy(d => d.ContactPerson).Skip(iDisplayStart).Take(10);
                    else Customers = Customers.OrderByDescending(d => d.ContactPerson).Skip(iDisplayStart).Take(10);
                    break;
                default:
                    Customers = Customers.Skip(iDisplayStart).Take(10);
                    break;
            }

            var CustomerPaged = new Models.SysDataTablePager();

            CustomerPaged.sEcho = sEcho;
            CustomerPaged.iTotalRecords = Count;
            CustomerPaged.iTotalDisplayRecords = Count;
            CustomerPaged.MstArticleCustomerData = Customers.ToList();

            return CustomerPaged; 
        }

        // GET api/MstArticleCustomer/5
        public Models.MstArticleCustomer Get(Int64 Id)
        {
            var Customer = (from d in data.MstArticles
                            where d.MstUser.Id == secure.GetCurrentUser() &&
                                  d.MstArticleType.ArticleType == "Customer" &&
                                  d.MstArticleCustomers.Count() > 0 &&
                                  d.Id == Id
                             select new Models.MstArticleCustomer
                             {
                                 Id = d.MstArticleCustomers.First().Id,
                                 ArticleId = d.Id,
                                 AccountId = d.MstAccount.Id,
                                 Account = d.MstAccount.Account,
                                 CustomerCode = d.ArticleCode,
                                 Customer = d.Article,
                                 Address = d.MstArticleCustomers.First().Address,
                                 ContactNumbers = d.MstArticleCustomers.First().ContactNumbers,
                                 ContactPerson = d.MstArticleCustomers.First().ContactPerson,
                                 EmailAddress = d.MstArticleCustomers.First().EmailAddress
                             });

            if (Customer.Any()) {
                return Customer.First();
            }
            else {
                return new Models.MstArticleCustomer();
            }
        }

        // POST api/MstArticleCustomer
        [HttpPost]
        public Models.MstArticleCustomer Post(Models.MstArticleCustomer value)
        {
            var MstArticleCustomerModel = new Models.MstArticleCustomer();
            try
            {
                Data.wfmisDataContext newData = new Data.wfmisDataContext();
                Data.MstArticle NewMstArticle = new Data.MstArticle();
                Data.MstArticleCustomer NewMstArticleCustomer = new Data.MstArticleCustomer();

                var UserId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentUserId);

                // ==========
                // MstArticle
                // ==========
                // MstArticle->ArticleCode
                var Articles = from d in data.MstArticles
                               where d.MstUser.Id == UserId && d.MstArticleType.ArticleType == "Customer"
                               select d;

                var MaxArticleCodeString = "";
                if (Articles != null)
                {
                    var MaxArticleCode = Convert.ToDouble(Articles.Max(a => a.ArticleCode)) + 10000000001;
                    MaxArticleCodeString = MaxArticleCode.ToString().Trim().Substring(1);
                    NewMstArticle.ArticleCode = MaxArticleCodeString;
                }
                else
                {
                    MaxArticleCodeString = "0000000001";
                    NewMstArticle.ArticleCode = MaxArticleCodeString;
                }
                // MstArticle->ArticleManualCode
                NewMstArticle.ArticleManualCode = MaxArticleCodeString;
                // MstArticle->Article
                NewMstArticle.Article = value.Customer;
                // MstArticle->ArticleTypeId
                NewMstArticle.ArticleTypeId = data.MstArticleTypes.Where(a => a.MstUser.Id == UserId && a.ArticleType == "Customer").First().Id;
                // MstArticle->AccountId
                NewMstArticle.AccountId = value.AccountId;
                // MstArticle->IsLocked
                NewMstArticle.IsLocked = true;
                // MstArticle->UserId
                NewMstArticle.UserId = UserId;
                // MstArticle->CreatedById
                NewMstArticle.CreatedById = UserId;
                // MstArticle->UpdatedById
                NewMstArticle.UpdatedById = UserId;
                // MstArticle->CreatedDateTime
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                NewMstArticle.CreatedDateTime = SQLNow.Value;
                // MstArticle->UpdatedDateTime
                NewMstArticle.UpdatedDateTime = SQLNow.Value;
                // MstArticle.Save
                newData.MstArticles.InsertOnSubmit(NewMstArticle);
                newData.SubmitChanges();

                // ==================
                // MstArticleCustomer
                // ==================
                // MstArticleCustomer->ArticleId
                NewMstArticleCustomer.ArticleId = data.MstArticles.Where(a => a.MstUser.Id == UserId && a.ArticleCode == MaxArticleCodeString).First().Id;
                // MstArticleCustomer->Address
                NewMstArticleCustomer.Address = value.Address == null ? "NA" : value.Address;
                // MstArticleCustomer->ContactNumbers
                NewMstArticleCustomer.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                // MstArticleCustomer->ContactPerson
                NewMstArticleCustomer.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;
                // MstArticleCustomer->EmailAddress
                NewMstArticleCustomer.EmailAddress = value.EmailAddress == null ? "NA" : value.EmailAddress;
                // MstArticleCustomer.Save
                newData.MstArticleCustomers.InsertOnSubmit(NewMstArticleCustomer);
                newData.SubmitChanges();

                return MstArticleCustomerModel;
            } catch
            {
                return MstArticleCustomerModel;
            }
        }

        // PUT api/TrnJournalVoucher/5
        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.MstArticleCustomer value)
        {
            try
            {
                // Update Article Customer
                var ArticleCustomer = from d in data.MstArticleCustomers
                                      where d.Id == id
                                      select d;
                if (ArticleCustomer.Any())
                {
                    var UpdatedArticleCustomer = ArticleCustomer.FirstOrDefault();

                    UpdatedArticleCustomer.Address = value.Address == null ? "NA" : value.Address;
                    UpdatedArticleCustomer.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                    UpdatedArticleCustomer.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;
                    UpdatedArticleCustomer.EmailAddress = value.EmailAddress == null ? "NA" : value.EmailAddress;

                    data.SubmitChanges();

                    // Update Article
                    var Article = from d in data.MstArticles
                                  where d.Id == value.ArticleId
                                  select d;
                    if (Article.Any())
                    {
                        var UpdatedArticle = Article.FirstOrDefault();

                        UpdatedArticle.Article = value.Customer == null ? "NA" : value.Customer;
                        UpdatedArticle.AccountId = value.AccountId;

                        data.SubmitChanges();

                        return Request.CreateResponse(HttpStatusCode.OK);
                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.NotFound);
                    }
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
            }
            catch
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }

        // DELETE api/MstArticleCustomer/5
        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstArticle DeleteArticle = data.MstArticles.Where(d => d.MstUser.Id == secure.GetCurrentUser() &&
                                                                        d.MstArticleType.ArticleType == "Customer" &&
                                                                        d.MstArticleItems.Count() > 0 &&
                                                                        d.MstArticleItems.First().Id == Id).First();

            if (DeleteArticle != null)
            {
                data.MstArticles.DeleteOnSubmit(DeleteArticle);
                try
                {
                    data.SubmitChanges();
                }
                catch
                {
                    returnVariable = false;
                }
            }
            else
            {
                returnVariable = false;
            }
            return returnVariable;
        }
    }
}