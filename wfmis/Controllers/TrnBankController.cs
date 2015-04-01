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
    public class TrnBankController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        public string CreateDocumentNumber(Data.TrnBank bank)
        {
            if (bank.CVId > 0)
            {
                return "(TrnDisbursementDetail.aspx?Id=" + bank.CVId + ")" + "CV-" + bank.TrnDisbursement.CVNumber;
            }
            else if (bank.ORId > 0)
            {
                return "(TrnCollectionDetail.aspx?Id=" + bank.ORId + ")" + "OR-" + bank.TrnCollection.ORNumber;
            }
            else if (bank.JVId > 0)
            {
                return "(TrnJournalVoucherDetail.aspx?Id=" + bank.JVId + ")" + "JV-" + bank.TrnJournalVoucher.JVNumber;
            }
            else
            {
                return "";
            }
        }

        // ===============
        // GET api/TrnBank
        // ===============

        public Models.SysDataTablePager Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            Int64 BankId = Convert.ToInt64(parameters["tab1BankId"]);
            DateTime DateStart = Convert.ToDateTime(parameters["tab1DateStart"]);
            DateTime DateEnd = Convert.ToDateTime(parameters["tab1DateEnd"]);

            var BankRecords = from d in db.TrnBanks
                              where d.BankId == BankId && 
                                    (d.BankDate >= DateStart && d.BankDate <= DateEnd)
                              select new Models.TrnBank
                              {
                                  Id = d.Id,
                                  CVId = d.CVId == null ? 0 : d.CVId.Value,
                                  ORId = d.ORId == null ? 0 : d.ORId.Value,
                                  JVId = d.JVId == null ? 0 : d.JVId.Value,
                                  DocumentNumber = CreateDocumentNumber(d),
                                  BankDate = d.BankDate.ToShortDateString(),
                                  BankId = d.BankId,
                                  Bank = d.MstArticle.Article,
                                  DebitAmount = d.DebitAmount,
                                  CreditAmount = d.CreditAmount,
                                  CheckNumber = d.CheckNumber,
                                  CheckDate = d.CheckDate.ToShortDateString(),
                                  IsCleared = d.IsCleared,
                                  DateCleared = d.DateCleared.ToShortDateString(),
                                  Particulars = d.Particulars,
                                  CreatedById = d.CreatedById,
                                  CreatedBy = d.MstUser.FullName,
                                  CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                  UpdatedById = d.UpdatedById,
                                  UpdatedBy = d.MstUser1.FullName,
                                  UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                              };

            var ReportPaged = new Models.SysDataTablePager();

            ReportPaged.sEcho = "1";
            ReportPaged.iTotalRecords = 0;
            ReportPaged.iTotalDisplayRecords = 0;
            ReportPaged.TrnBankData = BankRecords.ToList();

            return ReportPaged;
        }

        // ======================
        // GET api/TrnBank/5/Bank
        // ======================

        [HttpGet]
        [ActionName("Bank")]
        public Models.TrnBank Get(Int64 Id)
        {
            var BankRecords = from d in db.TrnBanks
                              where d.Id == Id 
                              select new Models.TrnBank
                              {
                                  Id = d.Id,
                                  CVId = d.CVId == null ? 0 : d.CVId.Value,
                                  ORId = d.ORId == null ? 0 : d.ORId.Value,
                                  JVId = d.JVId == null ? 0 : d.JVId.Value,
                                  DocumentNumber = CreateDocumentNumber(d),
                                  BankDate = d.BankDate.ToShortDateString(),
                                  BankId = d.BankId,
                                  Bank = d.MstArticle.Article,
                                  DebitAmount = d.DebitAmount,
                                  CreditAmount = d.CreditAmount,
                                  CheckNumber = d.CheckNumber,
                                  CheckDate = d.CheckDate.ToShortDateString(),
                                  IsCleared = d.IsCleared,
                                  DateCleared = d.DateCleared.ToShortDateString(),
                                  Particulars = d.Particulars,
                                  CreatedById = d.CreatedById,
                                  CreatedBy = d.MstUser.FullName,
                                  CreatedDateTime = d.CreatedDateTime.ToShortDateString(),
                                  UpdatedById = d.UpdatedById,
                                  UpdatedBy = d.MstUser1.FullName,
                                  UpdatedDateTime = d.UpdatedDateTime.ToShortDateString()
                              };

            if (BankRecords.Any())
            {
                return BankRecords.First();
            }
            else
            {
                return new Models.TrnBank();
            }
        }

        // ========================
        // PUT api/TrnBank/5/Update
        // ========================

        [HttpPut]
        [ActionName("Update")]
        public HttpResponseMessage Put(Int64 Id, Models.TrnBank value)
        {
            try
            {
                var BankRecords = from d in db.TrnBanks
                                  where d.Id == Id
                                  select d;

                if (BankRecords.Any())
                {
                    var UpdatedBankRecord = BankRecords.FirstOrDefault();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));

                    UpdatedBankRecord.Particulars = value.Particulars == null ? "NA" : value.Particulars;
                    UpdatedBankRecord.IsCleared = value.IsCleared;
                    UpdatedBankRecord.UpdatedById = secure.GetCurrentUser();
                    UpdatedBankRecord.UpdatedDateTime = SQLNow.Value;

                    db.SubmitChanges();
                }
                else
                {
                    return Request.CreateResponse(HttpStatusCode.NotFound);
                }
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (NullReferenceException)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }
        }


    }
}