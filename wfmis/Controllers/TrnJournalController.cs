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
    public class TrnJournalController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ============================================
        // GET api/TrnJournal/5/PurchaseInvoiceJournals
        // ============================================

        [HttpGet]
        [ActionName("PurchaseInvoiceJournals")]
        public Models.SysDataTablePager PurchaseInvoiceJournals(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournals.Where(d => d.PIId == Id && 
                                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Journals = (from d in db.TrnJournals
                            where d.PIId == Id &&
                                  d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                            orderby d.Id
                            select new Models.TrnJournal
                                {
                                    Id = d.Id,
                                    Period = d.MstPeriod.Period,
                                    Branch = d.MstBranch.Branch,
                                    Account = d.MstAccount.Account,
                                    DebitAmount = d.DebitAmount,
                                    CreditAmount = d.CreditAmount
                                });

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Journals = Journals.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var JournalsPaged = new Models.SysDataTablePager();

            JournalsPaged.sEcho = sEcho;
            JournalsPaged.iTotalRecords = Count;
            JournalsPaged.iTotalDisplayRecords = Count;
            JournalsPaged.TrnJournalData = Journals.ToList();

            return JournalsPaged;
        }

        // =========================================
        // GET api/TrnJournal/5/DisbursementJournals
        // =========================================

        [HttpGet]
        [ActionName("DisbursementJournals")]
        public Models.SysDataTablePager DisbursementJournals(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournals.Where(d => d.PIId == Id && 
                                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Journals = (from d in db.TrnJournals
                            where d.CVId == Id &&
                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                            orderby d.Id
                            select new Models.TrnJournal
                            {
                                Id = d.Id,
                                Period = d.MstPeriod.Period,
                                Branch = d.MstBranch.Branch,
                                Account = d.MstAccount.Account,
                                DebitAmount = d.DebitAmount,
                                CreditAmount = d.CreditAmount
                            });

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Journals = Journals.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var JournalsPaged = new Models.SysDataTablePager();

            JournalsPaged.sEcho = sEcho;
            JournalsPaged.iTotalRecords = Count;
            JournalsPaged.iTotalDisplayRecords = Count;
            JournalsPaged.TrnJournalData = Journals.ToList();

            return JournalsPaged;
        }

        // =========================================
        // GET api/TrnJournal/5/SalesInvoiceJournals
        // =========================================

        [HttpGet]
        [ActionName("SalesInvoiceJournals")]
        public Models.SysDataTablePager SalesInvoiceJournals(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournals.Where(d => d.PIId == Id && 
                                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Journals = (from d in db.TrnJournals
                            where d.SIId == Id &&
                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                            orderby d.Id
                            select new Models.TrnJournal
                            {
                                Id = d.Id,
                                Period = d.MstPeriod.Period,
                                Branch = d.MstBranch.Branch,
                                Account = d.MstAccount.Account,
                                DebitAmount = d.DebitAmount,
                                CreditAmount = d.CreditAmount
                            });

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Journals = Journals.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var JournalsPaged = new Models.SysDataTablePager();

            JournalsPaged.sEcho = sEcho;
            JournalsPaged.iTotalRecords = Count;
            JournalsPaged.iTotalDisplayRecords = Count;
            JournalsPaged.TrnJournalData = Journals.ToList();

            return JournalsPaged;
        }

        // =======================================
        // GET api/TrnJournal/5/CollectionJournals
        // =======================================

        [HttpGet]
        [ActionName("CollectionJournals")]
        public Models.SysDataTablePager CollectionJournals(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournals.Where(d => d.ORId == Id && 
                                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser() ).Count();

            var Journals = (from d in db.TrnJournals
                            where d.ORId == Id &&
                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()
                            orderby d.Id
                            select new Models.TrnJournal
                            {
                                Id = d.Id,
                                Period = d.MstPeriod.Period,
                                Branch = d.MstBranch.Branch,
                                Account = d.MstAccount.Account,
                                DebitAmount = d.DebitAmount,
                                CreditAmount = d.CreditAmount
                            });

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Journals = Journals.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var JournalsPaged = new Models.SysDataTablePager();

            JournalsPaged.sEcho = sEcho;
            JournalsPaged.iTotalRecords = Count;
            JournalsPaged.iTotalDisplayRecords = Count;
            JournalsPaged.TrnJournalData = Journals.ToList();

            return JournalsPaged;
        }

        // ====================================
        // GET api/TrnJournal/5/StockInJournals
        // ====================================

        [HttpGet]
        [ActionName("StockInJournals")]
        public Models.SysDataTablePager StockInJournals(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournals.Where(d => d.INId == Id &&
                                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Journals = (from d in db.TrnJournals
                            where d.INId == Id &&
                                  d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                            orderby d.Id
                            select new Models.TrnJournal
                            {
                                Id = d.Id,
                                Period = d.MstPeriod.Period,
                                Branch = d.MstBranch.Branch,
                                Account = d.MstAccount.Account,
                                DebitAmount = d.DebitAmount,
                                CreditAmount = d.CreditAmount
                            });

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Journals = Journals.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var JournalsPaged = new Models.SysDataTablePager();

            JournalsPaged.sEcho = sEcho;
            JournalsPaged.iTotalRecords = Count;
            JournalsPaged.iTotalDisplayRecords = Count;
            JournalsPaged.TrnJournalData = Journals.ToList();

            return JournalsPaged;
        }

        // =====================================
        // GET api/TrnJournal/5/StockOutJournals
        // =====================================

        [HttpGet]
        [ActionName("StockOutJournals")]
        public Models.SysDataTablePager StockOutJournals(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournals.Where(d => d.OTId == Id &&
                                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Journals = (from d in db.TrnJournals
                            where d.OTId == Id &&
                                  d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                            orderby d.Id
                            select new Models.TrnJournal
                            {
                                Id = d.Id,
                                Period = d.MstPeriod.Period,
                                Branch = d.MstBranch.Branch,
                                Account = d.MstAccount.Account,
                                DebitAmount = d.DebitAmount,
                                CreditAmount = d.CreditAmount
                            });

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Journals = Journals.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var JournalsPaged = new Models.SysDataTablePager();

            JournalsPaged.sEcho = sEcho;
            JournalsPaged.iTotalRecords = Count;
            JournalsPaged.iTotalDisplayRecords = Count;
            JournalsPaged.TrnJournalData = Journals.ToList();

            return JournalsPaged;
        }


        // ==========================================
        // GET api/TrnJournal/5/StockTransferJournals
        // ==========================================

        [HttpGet]
        [ActionName("StockTransferJournals")]
        public Models.SysDataTablePager StockTransferJournals(Int64 Id)
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            int NumberOfRecords = 20;

            string sEcho = nvc["sEcho"].ToString();
            int iDisplayStart = Convert.ToInt32(nvc["iDisplayStart"]);
            string sSearch = nvc["sSearch"].ToString();
            int iSortCol = Convert.ToInt32(nvc["iSortCol_0"]);
            string sSortDir = nvc["sSortDir_0"].ToString();

            var Count = db.TrnJournals.Where(d => d.STId == Id &&
                                                  d.MstBranch.UserId == secure.GetCurrentSubscriberUser()).Count();

            var Journals = (from d in db.TrnJournals
                            where d.STId == Id &&
                                  d.MstBranch.MstUser.Id == secure.GetCurrentSubscriberUser()
                            orderby d.Id
                            select new Models.TrnJournal
                            {
                                Id = d.Id,
                                Period = d.MstPeriod.Period,
                                Branch = d.MstBranch.Branch,
                                Account = d.MstAccount.Account,
                                DebitAmount = d.DebitAmount,
                                CreditAmount = d.CreditAmount
                            });

            switch (iSortCol)
            {
                case 0:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Period).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                case 1:
                    if (sSortDir == "asc") Journals = Journals.OrderBy(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    else Journals = Journals.OrderByDescending(d => d.Branch).Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
                default:
                    Journals = Journals.Skip(iDisplayStart).Take(NumberOfRecords);
                    break;
            }

            var JournalsPaged = new Models.SysDataTablePager();

            JournalsPaged.sEcho = sEcho;
            JournalsPaged.iTotalRecords = Count;
            JournalsPaged.iTotalDisplayRecords = Count;
            JournalsPaged.TrnJournalData = Journals.ToList();

            return JournalsPaged;
        }    

    }
}