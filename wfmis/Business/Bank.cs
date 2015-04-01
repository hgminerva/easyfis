using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Web;

namespace wfmis.Business
{
    public class Bank
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        public bool FlushBankRecord(string Document, Int64 Id)
        {
            try
            {
                switch (Document)
                {
                    case "CV":
                        // Delete TrnBank
                        var DeleteTrnBanksCV = db.TrnBanks.Where(d => d.CVId == Id &&
                                                                      d.ORId == null &&
                                                                      d.JVId == null);
                        if (DeleteTrnBanksCV.Any())
                        {
                            foreach (Data.TrnBank DeleteTrnBankCV in DeleteTrnBanksCV)
                            {
                                db.TrnBanks.DeleteOnSubmit(DeleteTrnBankCV);
                                db.SubmitChanges();
                            }
                        }
                        break;
                    case "OR":
                        // Delete TrnBank
                        var DeleteTrnBanksOR = db.TrnBanks.Where(d => d.CVId == null &&
                                                                      d.ORId == Id &&
                                                                      d.JVId == null);
                        if (DeleteTrnBanksOR.Any())
                        {
                            foreach (Data.TrnBank DeleteTrnBankOR in DeleteTrnBanksOR)
                            {
                                db.TrnBanks.DeleteOnSubmit(DeleteTrnBankOR);
                                db.SubmitChanges();
                            }
                        }
                        break;
                    case "JV":
                        // Delete TrnBank
                        var DeleteTrnBanksJV = db.TrnBanks.Where(d => d.CVId == null &&
                                                                      d.ORId == null &&
                                                                      d.JVId == Id);
                        if (DeleteTrnBanksJV.Any())
                        {
                            foreach (Data.TrnBank DeleteTrnBankJV in DeleteTrnBanksJV)
                            {
                                db.TrnBanks.DeleteOnSubmit(DeleteTrnBankJV);
                                db.SubmitChanges();
                            }
                        }
                        break;
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool BankRecordCV(Int64 CVId)
        {
            try
            {
                this.FlushBankRecord("CV", CVId);

                var TrnDisbursements = from d in db.TrnDisbursements
                                       where d.Id == CVId &&
                                             d.IsLocked == true
                                       select d;

                if (TrnDisbursements.Any())
                {
                    Data.TrnBank NewTrnBank = new Data.TrnBank();
                    SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                      DateTime.Now.Month, +
                                                                      DateTime.Now.Day, +
                                                                      DateTime.Now.Hour, +
                                                                      DateTime.Now.Minute, +
                                                                      DateTime.Now.Second));
                    NewTrnBank.CVId = CVId;
                    NewTrnBank.BankDate = TrnDisbursements.First().CheckDate;
                    NewTrnBank.BankId = TrnDisbursements.First().BankId;
                    NewTrnBank.DebitAmount = 0;
                    NewTrnBank.CreditAmount = TrnDisbursements.First().TotalAmount;
                    NewTrnBank.CheckNumber = TrnDisbursements.First().CheckNumber;
                    NewTrnBank.CheckDate = TrnDisbursements.First().CheckDate;
                    NewTrnBank.IsCleared = true;
                    NewTrnBank.DateCleared = TrnDisbursements.First().CheckDate;
                    NewTrnBank.Particulars = TrnDisbursements.First().Particulars;
                    NewTrnBank.CreatedById = secure.GetCurrentUser();
                    NewTrnBank.CreatedDateTime = SQLNow.Value;
                    NewTrnBank.UpdatedById = secure.GetCurrentUser();
                    NewTrnBank.UpdatedDateTime = SQLNow.Value;

                    db.TrnBanks.InsertOnSubmit(NewTrnBank);
                    db.SubmitChanges();
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool BankRecordOR(Int64 ORId)
        {
            try
            {
                this.FlushBankRecord("OR", ORId);

                var TrnCollectionLines = from d in db.TrnCollectionLines
                                         where d.ORId == ORId && 
                                               d.Amount > 0 &&
                                               d.BankId > 0 &&
                                               d.TrnCollection.IsLocked == true
                                         select d;

                if (TrnCollectionLines.Any())
                {
                    foreach (var Line in TrnCollectionLines)
                    {
                        Data.TrnBank NewTrnBank = new Data.TrnBank();
                        SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                          DateTime.Now.Month, +
                                                                          DateTime.Now.Day, +
                                                                          DateTime.Now.Hour, +
                                                                          DateTime.Now.Minute, +
                                                                          DateTime.Now.Second));
                        NewTrnBank.ORId = ORId;
                        NewTrnBank.BankDate = Line.CheckDate;
                        NewTrnBank.BankId = Line.BankId.Value;
                        NewTrnBank.DebitAmount = Line.Amount;
                        NewTrnBank.CreditAmount = 0;
                        NewTrnBank.CheckNumber = Line.CheckNumber;
                        NewTrnBank.CheckDate = Line.CheckDate;
                        NewTrnBank.IsCleared = true;
                        NewTrnBank.DateCleared = Line.CheckDate;
                        NewTrnBank.Particulars = Line.Particulars;
                        NewTrnBank.CreatedById = secure.GetCurrentUser();
                        NewTrnBank.CreatedDateTime = SQLNow.Value;
                        NewTrnBank.UpdatedById = secure.GetCurrentUser();
                        NewTrnBank.UpdatedDateTime = SQLNow.Value;

                        db.TrnBanks.InsertOnSubmit(NewTrnBank);
                        db.SubmitChanges();
                    }
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool BankRecordJV(Int64 JVId)
        {
            try
            {
                this.FlushBankRecord("JV", JVId);

                var TrnJournalVoucherLines = from d in db.TrnJournalVoucherLines
                                             where d.JVId == JVId &&
                                                   (d.DebitAmount + d.CreditAmount) > 0 &&
                                                   d.ArticleId > 0 &&
                                                   d.TrnJournalVoucher.IsLocked == true
                                             select d;

                if (TrnJournalVoucherLines.Any())
                {
                    foreach (var Line in TrnJournalVoucherLines)
                    {
                        if (Line.MstArticle.MstArticleType.ArticleType == "Bank")
                        {
                            Data.TrnBank NewTrnBank = new Data.TrnBank();
                            SqlDateTime SQLNow = new SqlDateTime(new DateTime(DateTime.Now.Year, +
                                                                              DateTime.Now.Month, +
                                                                              DateTime.Now.Day, +
                                                                              DateTime.Now.Hour, +
                                                                              DateTime.Now.Minute, +
                                                                              DateTime.Now.Second));
                            NewTrnBank.JVId = JVId;
                            NewTrnBank.BankDate = Line.TrnJournalVoucher.JVDate;
                            NewTrnBank.BankId = Line.ArticleId.Value;
                            NewTrnBank.DebitAmount = Line.DebitAmount;
                            NewTrnBank.CreditAmount = Line.CreditAmount;
                            NewTrnBank.CheckNumber = "NA";
                            NewTrnBank.CheckDate = Line.TrnJournalVoucher.JVDate;
                            NewTrnBank.IsCleared = true;
                            NewTrnBank.DateCleared = Line.TrnJournalVoucher.JVDate;
                            NewTrnBank.Particulars = Line.Particulars;
                            NewTrnBank.CreatedById = secure.GetCurrentUser();
                            NewTrnBank.CreatedDateTime = SQLNow.Value;
                            NewTrnBank.UpdatedById = secure.GetCurrentUser();
                            NewTrnBank.UpdatedDateTime = SQLNow.Value;

                            db.TrnBanks.InsertOnSubmit(NewTrnBank);
                            db.SubmitChanges();
                        }
                    }
                }
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}