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
    public class MstArticleBankController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ======================
        // GET api/MstArticleBank
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

            var Count = data.MstArticles.Where(d => d.UserId == secure.GetCurrentSubscriberUser() &&
                                                    d.MstArticleType.ArticleType == "Bank" &&
                                                    d.MstArticleBanks.Count() > 0).Count();

            var Banks = (from d in data.MstArticles
                         where d.UserId == secure.GetCurrentSubscriberUser() &&
                               d.MstArticleType.ArticleType == "Bank" &&
                               d.MstArticleBanks.Count() > 0 &&
                               d.Article.Contains(sSearch)
                         select new Models.MstArticleBank
                         {
                                Id = d.MstArticleBanks.First().Id,
                                ArticleId = d.Id,
                                AccountId = d.MstAccount.Id,
                                Account = d.MstAccount.Account,
                                BankCode = d.ArticleCode,
                                Bank = d.Article,
                                BankAccountNumber = d.MstArticleBanks.First().BankAccountNumber,
                                Particulars = d.MstArticleBanks.First().Particulars,
                                Address = d.MstArticleBanks.First().Address,
                                ContactNumbers = d.MstArticleBanks.First().ContactNumbers,
                                ContactPerson = d.MstArticleBanks.First().ContactPerson
                         });

            switch (iSortCol)
            {
                case 2:
                    if (sSortDir == "asc") Banks = Banks.OrderBy(d => d.BankCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Banks = Banks.OrderByDescending(d => d.BankCode).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 3:
                    if (sSortDir == "asc") Banks = Banks.OrderBy(d => d.Bank).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Banks = Banks.OrderByDescending(d => d.Bank).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 4:
                    if (sSortDir == "asc") Banks = Banks.OrderBy(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Banks = Banks.OrderByDescending(d => d.Particulars).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Banks = Banks.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var BankPaged = new Models.SysDataTablePager();

            BankPaged.sEcho = sEcho;
            BankPaged.iTotalRecords = Count;
            BankPaged.iTotalDisplayRecords = Count;
            BankPaged.MstArticleBankData = Banks.ToList();

            return BankPaged;
        }

        // =============================
        // GET api/MstArticleBank/5/Bank
        // =============================

        [HttpGet]
        [ActionName("Bank")]
        public Models.MstArticleBank Get(Int64 Id)
        {
            var Bank = (from d in data.MstArticles
                        where d.UserId == secure.GetCurrentSubscriberUser() &&
                              d.MstArticleType.ArticleType == "Bank" &&
                              d.MstArticleBanks.Count() > 0 &&
                              d.MstArticleBanks.First().Id == Id
                        select new Models.MstArticleBank
                        {
                            Id = d.MstArticleBanks.First().Id,
                            ArticleId = d.Id,
                            AccountId = d.MstAccount.Id,
                            Account = d.MstAccount.Account,
                            BankCode = d.ArticleCode,
                            Bank = d.Article,
                            BankAccountNumber = d.MstArticleBanks.First().BankAccountNumber,
                            Particulars = d.MstArticleBanks.First().Particulars,
                            Address = d.MstArticleBanks.First().Address,
                            ContactNumbers = d.MstArticleBanks.First().ContactNumbers,
                            ContactPerson = d.MstArticleBanks.First().ContactPerson
                        });

            if (Bank.Any())
            {
                return Bank.First();
            }
            else
            {
                return new Models.MstArticleBank();
            }
        }

        // =======================
        // POST api/MstArticleBank
        // =======================

        [HttpPost]
        public Models.MstArticleBank Post(Models.MstArticleBank value)
        {
            var MstArticleBankModel = new Models.MstArticleBank();
            SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                              DateTime.Now.Month, +
                                                              DateTime.Now.Day, +
                                                              DateTime.Now.Hour, +
                                                              DateTime.Now.Minute, +
                                                              DateTime.Now.Second));
            try
            {
                Data.MstArticle NewMstArticle = new Data.MstArticle();
                Data.MstArticleBank NewMstArticleBank = new Data.MstArticleBank();

                // MstArticle
                var Articles = from d in data.MstArticles
                               where d.MstUser.Id == secure.GetCurrentSubscriberUser() &&
                                     d.MstArticleType.ArticleType == "Bank"
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
                NewMstArticle.Article = value.Bank;
                NewMstArticle.ArticleTypeId = data.MstArticleTypes.Where(a => a.MstUser.Id == secure.GetCurrentSubscriberUser() && a.ArticleType == "Bank").First().Id;
                NewMstArticle.AccountId = value.AccountId;
                NewMstArticle.IsLocked = true;
                NewMstArticle.CreatedById = secure.GetCurrentUser();
                NewMstArticle.UpdatedById = secure.GetCurrentUser();
                NewMstArticle.CreatedDateTime = SQLNow.Value;
                NewMstArticle.UpdatedDateTime = SQLNow.Value;

                data.MstArticles.InsertOnSubmit(NewMstArticle);
                data.SubmitChanges();

                // MstArticleBank
                NewMstArticleBank.ArticleId = NewMstArticle.Id;
                NewMstArticleBank.BankAccountNumber = value.BankAccountNumber == null ? "NA" : value.BankAccountNumber;
                NewMstArticleBank.Particulars = value.Particulars == null ? "NA" : value.Particulars;
                NewMstArticleBank.Address = value.Address == null ? "NA" : value.Address;
                NewMstArticleBank.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                NewMstArticleBank.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;

                data.MstArticleBanks.InsertOnSubmit(NewMstArticleBank);
                data.SubmitChanges();

                return Get(NewMstArticleBank.Id);
            }
            catch
            {
                return new Models.MstArticleBank();
            }
        }

        // ========================
        // PUT api/MstArticleBank/5
        // ========================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstArticleBank value)
        {
            try
            {
                var ArticleBank = from d in data.MstArticleBanks
                                  where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                        d.Id == Id
                                  select d;

                if (ArticleBank.Any())
                {
                    // MstArticleBank
                    var UpdatedArticleBank = ArticleBank.FirstOrDefault();

                    UpdatedArticleBank.BankAccountNumber = value.BankAccountNumber == null ? "NA" : value.BankAccountNumber;
                    UpdatedArticleBank.Particulars = value.Particulars == null ? "NA" : value.Particulars;
                    UpdatedArticleBank.Address = value.Address == null ? "NA" : value.Address;
                    UpdatedArticleBank.ContactNumbers = value.ContactNumbers == null ? "NA" : value.ContactNumbers;
                    UpdatedArticleBank.ContactPerson = value.ContactPerson == null ? "NA" : value.ContactPerson;

                    data.SubmitChanges();

                    // MstArticle
                    var Article = from d in data.MstArticles
                                  where d.UserId == secure.GetCurrentSubscriberUser() &&
                                        d.Id == value.ArticleId
                                  select d;

                    if (Article.Any())
                    {
                        var UpdatedArticle = Article.FirstOrDefault();

                        UpdatedArticle.Article = value.Bank == null ? "NA" : value.Bank;
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

        // ===========================
        // DELETE api/MstArticleBank/5
        // ===========================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstArticle DeleteArticle = data.MstArticles.Where(d => d.UserId == secure.GetCurrentSubscriberUser() &&
                                                                        d.MstArticleType.ArticleType == "Bank" &&
                                                                        d.MstArticleBanks.Count() > 0 &&
                                                                        d.MstArticleBanks.First().Id == Id).First();
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