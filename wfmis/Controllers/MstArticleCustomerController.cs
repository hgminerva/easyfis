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
        private Business.Security secure = new Business.Security();

        // ==========================
        // GET api/MstArticleCustomer
        // ==========================

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

            var Count = data.MstArticles.Where(d => d.UserId == secure.GetCurrentSubscriberUser() &&
                                                    d.MstArticleType.ArticleType == "Customer" &&
                                                    d.MstArticleCustomers.Count() > 0).Count();

            var Customers = (from d in data.MstArticles
                             where d.UserId == secure.GetCurrentSubscriberUser() &&
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
                                 EmailAddress = d.MstArticleCustomers.First().EmailAddress,
                                 TermId = d.MstArticleCustomers.First().TermId,
                                 Term = d.MstArticleCustomers.First().MstTerm.Term,
                                 TaxNumber = d.MstArticleCustomers.First().TaxNumber
                             });

            switch (iSortCol) 
            { 
                case 2:
                    if (sSortDir == "asc") Customers = Customers.OrderBy(d => d.CustomerCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Customers = Customers.OrderByDescending(d => d.CustomerCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Customers = Customers.OrderBy(d => d.Customer).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Customers = Customers.OrderByDescending(d => d.Customer).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Customers = Customers.OrderBy(d => d.ContactPerson).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Customers = Customers.OrderByDescending(d => d.ContactPerson).Skip(iDisplayStart).Take(NumberOfRecords);
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

        // =====================================
        // GET api/MstArticleCustomer/5/Customer
        // =====================================

        [HttpGet]
        [ActionName("Customer")]
        public Models.MstArticleCustomer Get(Int64 Id)
        {
            var Customer = (from d in data.MstArticles
                            where d.UserId == secure.GetCurrentSubscriberUser() &&
                                  d.MstArticleType.ArticleType == "Customer" &&
                                  d.MstArticleCustomers.Count() > 0 &&
                                  d.MstArticleCustomers.First().Id == Id
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
                                 EmailAddress = d.MstArticleCustomers.First().EmailAddress,
                                 TermId = d.MstArticleCustomers.First().TermId,
                                 Term = d.MstArticleCustomers.First().MstTerm.Term,
                                 TaxNumber = d.MstArticleCustomers.First().TaxNumber
                             });

            if (Customer.Any()) {
                return Customer.First();
            }
            else {
                return new Models.MstArticleCustomer();
            }
        }

        // ================================================
        // GET api/MstArticleCustomer/5/CustomerByArticleId
        // ================================================

        [HttpGet]
        [ActionName("CustomerByArticleId")]
        public Models.MstArticleCustomer CustomerByArticleId(Int64 Id)
        {
            var Customer = (from d in data.MstArticles
                            where d.UserId == secure.GetCurrentSubscriberUser() &&
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
                                EmailAddress = d.MstArticleCustomers.First().EmailAddress,
                                TermId = d.MstArticleCustomers.First().TermId,
                                Term = d.MstArticleCustomers.First().MstTerm.Term,
                                TaxNumber = d.MstArticleCustomers.First().TaxNumber
                            });

            if (Customer.Any())
            {
                return Customer.First();
            }
            else
            {
                return new Models.MstArticleCustomer();
            }
        }

        // ===========================
        // POST api/MstArticleCustomer
        // ===========================

        [HttpPost]
        public Models.MstArticleCustomer Post(Models.MstArticleCustomer value)
        {
            try
            {
                Data.MstArticle NewMstArticle = new Data.MstArticle();
                Data.MstArticleCustomer NewMstArticleCustomer = new Data.MstArticleCustomer();
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                // MstArticle
                var Articles = from d in data.MstArticles
                               where d.UserId == secure.GetCurrentSubscriberUser() && 
                                     d.MstArticleType.ArticleType == "Customer"
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
                NewMstArticle.ArticleManualCode = MaxArticleCodeString;
                NewMstArticle.Article = value.Customer;
                NewMstArticle.ArticleTypeId = data.MstArticleTypes.Where(a => a.UserId == secure.GetCurrentSubscriberUser() && a.ArticleType == "Customer").First().Id;
                NewMstArticle.AccountId = value.AccountId;
                NewMstArticle.IsLocked = true;
                NewMstArticle.UserId = secure.GetCurrentSubscriberUser();
                NewMstArticle.CreatedById = secure.GetCurrentUser();
                NewMstArticle.UpdatedById = secure.GetCurrentUser();
                NewMstArticle.CreatedDateTime = SQLNow.Value;
                NewMstArticle.UpdatedDateTime = SQLNow.Value;

                data.MstArticles.InsertOnSubmit(NewMstArticle);
                data.SubmitChanges();

                // MstArticleCustomer
                NewMstArticleCustomer.ArticleId = NewMstArticle.Id;
                NewMstArticleCustomer.Address = value.Address == null ? "NA" : value.Address;
                NewMstArticleCustomer.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                NewMstArticleCustomer.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;
                NewMstArticleCustomer.EmailAddress = value.EmailAddress == null ? "NA" : value.EmailAddress;
                NewMstArticleCustomer.TermId = value.TermId;
                NewMstArticleCustomer.TaxNumber = value.TaxNumber == null ? "NA" : value.TaxNumber;

                data.MstArticleCustomers.InsertOnSubmit(NewMstArticleCustomer);
                data.SubmitChanges();

                return Get(NewMstArticleCustomer.Id);
            } catch
            {
                return new Models.MstArticleCustomer();
            }
        }

        // ============================
        // PUT api/MstArticleCustomer/5
        // ============================

        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.MstArticleCustomer value)
        {
            try
            {
                var ArticleCustomer = from d in data.MstArticleCustomers
                                      where d.MstArticle.UserId  == secure.GetCurrentSubscriberUser() && 
                                            d.Id == id
                                      select d;

                if (ArticleCustomer.Any())
                {
                    // MstArticleCustomer
                    var UpdatedArticleCustomer = ArticleCustomer.FirstOrDefault();

                    UpdatedArticleCustomer.Address = value.Address == null ? "NA" : value.Address;
                    UpdatedArticleCustomer.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                    UpdatedArticleCustomer.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;
                    UpdatedArticleCustomer.EmailAddress = value.EmailAddress == null ? "NA" : value.EmailAddress;
                    UpdatedArticleCustomer.TermId = value.TermId;
                    UpdatedArticleCustomer.TaxNumber = value.TaxNumber == null ? "NA" : value.TaxNumber;

                    data.SubmitChanges();

                    // MstArticle
                    var Article = from d in data.MstArticles
                                  where d.UserId == secure.GetCurrentSubscriberUser() && 
                                        d.Id == value.ArticleId
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

        // ===============================
        // DELETE api/MstArticleCustomer/5
        // ===============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstArticle DeleteArticle = data.MstArticles.Where(d => d.UserId == secure.GetCurrentSubscriberUser() &&
                                                                        d.MstArticleType.ArticleType == "Customer" &&
                                                                        d.MstArticleCustomers.Count() > 0 &&
                                                                        d.MstArticleCustomers.First().Id == Id).First();
            if (DeleteArticle != null)
            {
                data.MstArticles.DeleteOnSubmit(DeleteArticle);
                try
                {
                    data.SubmitChanges();
                    return true;
                }
                catch
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
    }
}