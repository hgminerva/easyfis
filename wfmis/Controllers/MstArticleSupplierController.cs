using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstArticleSupplierController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ==========================
        // GET api/MstArticleSupplier
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
                                                    d.MstArticleType.ArticleType == "Supplier" &&
                                                    d.MstArticleSuppliers.Count() > 0).Count();

            var Suppliers = (from d in data.MstArticles
                             where d.UserId == secure.GetCurrentSubscriberUser() &&
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
                                 EmailAddress = d.MstArticleSuppliers.First().EmailAddress,
                                 TermId = d.MstArticleSuppliers.First().TermId,
                                 Term = d.MstArticleSuppliers.First().MstTerm.Term,
                                 TaxNumber = d.MstArticleSuppliers.First().TaxNumber
                             });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Suppliers = Suppliers.OrderBy(d => d.SupplierCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Suppliers = Suppliers.OrderByDescending(d => d.SupplierCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Suppliers = Suppliers.OrderBy(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Suppliers = Suppliers.OrderByDescending(d => d.Supplier).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Suppliers = Suppliers.OrderBy(d => d.ContactPerson).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Suppliers = Suppliers.OrderByDescending(d => d.ContactPerson).Skip(iDisplayStart).Take(NumberOfRecords);
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

        // =====================================
        // GET api/MstArticleSupplier/5/Supplier
        // =====================================

        [HttpGet]
        [ActionName("Supplier")]
        public Models.MstArticleSupplier Get(Int64 Id)
        {
            var Supplier = (from d in data.MstArticles
                            where d.UserId == secure.GetCurrentSubscriberUser() &&
                                  d.MstArticleType.ArticleType == "Supplier" &&
                                  d.MstArticleSuppliers.Count() > 0 &&
                                  d.MstArticleSuppliers.First().Id == Id
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
                                EmailAddress = d.MstArticleSuppliers.First().EmailAddress,
                                TermId = d.MstArticleSuppliers.First().TermId,
                                Term = d.MstArticleSuppliers.First().MstTerm.Term,
                                TaxNumber = d.MstArticleSuppliers.First().TaxNumber
                            });

            if (Supplier.Any())
            {
                return Supplier.First();
            }
            else
            {
                return new Models.MstArticleSupplier();
            }
        }

        // ================================================
        // GET api/MstArticleSupplier/5/SupplierByArticleId
        // ================================================

        [HttpGet]
        [ActionName("SupplierByArticleId")]
        public Models.MstArticleSupplier SupplierByArticleId(Int64 Id)
        {
            var Supplier = (from d in data.MstArticles
                            where d.UserId == secure.GetCurrentSubscriberUser() &&
                                  d.MstArticleType.ArticleType == "Supplier" &&
                                  d.MstArticleSuppliers.Count() > 0 &&
                                  d.Id == Id
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
                                EmailAddress = d.MstArticleSuppliers.First().EmailAddress,
                                TermId = d.MstArticleSuppliers.First().TermId,
                                Term = d.MstArticleSuppliers.First().MstTerm.Term,
                                TaxNumber = d.MstArticleSuppliers.First().TaxNumber
                            });

            if (Supplier.Any())
            {
                return Supplier.First();
            }
            else
            {
                return new Models.MstArticleSupplier();
            }
        }

        // ===========================
        // POST api/MstArticleSupplier
        // ===========================

        [HttpPost]
        public Models.MstArticleSupplier Post(Models.MstArticleSupplier value)
        {
            try
            {
                Data.MstArticle NewMstArticle = new Data.MstArticle();
                Data.MstArticleSupplier NewMstArticleSupplier = new Data.MstArticleSupplier();
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));

                // MstArticle
                var Articles = from d in data.MstArticles
                               where d.UserId == secure.GetCurrentSubscriberUser() &&
                                     d.MstArticleType.ArticleType == "Supplier"
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
                NewMstArticle.UserId = secure.GetCurrentSubscriberUser();
                NewMstArticle.ArticleManualCode = MaxArticleCodeString;
                NewMstArticle.Article = value.Supplier;
                NewMstArticle.ArticleTypeId = data.MstArticleTypes.Where(a => a.MstUser.Id == secure.GetCurrentSubscriberUser() && a.ArticleType == "Supplier").First().Id;
                NewMstArticle.AccountId = value.AccountId;
                NewMstArticle.IsLocked = true;
                NewMstArticle.CreatedById = secure.GetCurrentUser();
                NewMstArticle.UpdatedById = secure.GetCurrentUser();
                NewMstArticle.CreatedDateTime = SQLNow.Value;
                NewMstArticle.UpdatedDateTime = SQLNow.Value;

                data.MstArticles.InsertOnSubmit(NewMstArticle);
                data.SubmitChanges();

                // MstArticleSupplier
                NewMstArticleSupplier.ArticleId = NewMstArticle.Id;
                NewMstArticleSupplier.Address = value.Address == null ? "NA" : value.Address;
                NewMstArticleSupplier.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                NewMstArticleSupplier.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;
                NewMstArticleSupplier.EmailAddress = value.EmailAddress == null ? "NA" : value.EmailAddress;
                NewMstArticleSupplier.TermId = value.TermId;
                NewMstArticleSupplier.TaxNumber = value.TaxNumber == null ? "NA" : value.TaxNumber;

                data.MstArticleSuppliers.InsertOnSubmit(NewMstArticleSupplier);
                data.SubmitChanges();

                return Get(NewMstArticleSupplier.Id);
            }
            catch
            {
                return new Models.MstArticleSupplier();
            }
        }

        // ============================
        // PUT api/MstArticleSupplier/5
        // ============================

        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.MstArticleSupplier value)
        {
            try
            {
                SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                  DateTime.Now.Month, +
                                                                  DateTime.Now.Day, +
                                                                  DateTime.Now.Hour, +
                                                                  DateTime.Now.Minute, +
                                                                  DateTime.Now.Second));
                var ArticleSupplier = from d in data.MstArticleSuppliers
                                      where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                            d.Id == id
                                      select d;

                if (ArticleSupplier.Any())
                {
                    // MstArticleSupplier
                    var UpdatedArticleSupplier = ArticleSupplier.FirstOrDefault();

                    UpdatedArticleSupplier.Address = value.Address == null ? "NA" : value.Address;
                    UpdatedArticleSupplier.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                    UpdatedArticleSupplier.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;
                    UpdatedArticleSupplier.EmailAddress = value.EmailAddress == null ? "NA" : value.EmailAddress;
                    UpdatedArticleSupplier.TermId = value.TermId;
                    UpdatedArticleSupplier.TaxNumber = value.TaxNumber == null ? "NA" : value.TaxNumber;

                    data.SubmitChanges();

                    // MstArticle
                    var Article = from d in data.MstArticles
                                  where d.UserId == secure.GetCurrentSubscriberUser() &&
                                        d.Id == value.ArticleId
                                  select d;

                    if (Article.Any())
                    {
                        var UpdatedArticle = Article.FirstOrDefault();

                        UpdatedArticle.Article = value.Supplier == null ? "NA" : value.Supplier;
                        UpdatedArticle.AccountId = value.AccountId;
                        UpdatedArticle.UpdatedById = secure.GetCurrentUser();
                        UpdatedArticle.UpdatedDateTime = SQLNow.Value;

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
        // DELETE api/MstArticleSupplier/5
        // ===============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            var returnVariable = true;

            Data.MstArticle DeleteArticle = data.MstArticles.Where(d => d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                                                        d.MstArticleType.ArticleType == "Supplier" &&
                                                                        d.MstArticleSuppliers.Count() > 0 &&
                                                                        d.MstArticleSuppliers.First().Id == Id).First();
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