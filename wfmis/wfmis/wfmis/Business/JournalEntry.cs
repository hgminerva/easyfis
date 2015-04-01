using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using wfmis.Data;
using wfmis.Models;

namespace wfmis.Business
{
    public class JournalEntry
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        public bool JournalizedJV(Int64 JVId) {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.JVId == JVId);
                if (DeleteJournalEntries.Any())
                {
                    foreach(Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries) {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // Add journal entries
                var TrnJournalVoucherLines = from l in db.TrnJournalVoucherLines
                                             where l.TrnJournalVoucher.Id == JVId
                                             select l;

                if (TrnJournalVoucherLines.Any())
                {
                    foreach(Data.TrnJournalVoucherLine Line in TrnJournalVoucherLines) {
                        var NewJournalEntry = new Data.TrnJournal();

                        NewJournalEntry.JVId = JVId;
                        NewJournalEntry.JournalDate = Line.TrnJournalVoucher.JVDate;
                        NewJournalEntry.PeriodId = Line.TrnJournalVoucher.PeriodId;
                        NewJournalEntry.BranchId = Line.TrnJournalVoucher.BranchId;
                        NewJournalEntry.AccountId = Line.AccountId;
                        if (Line.ArticleId != null) NewJournalEntry.ArticleId = Line.ArticleId.Value;
                        NewJournalEntry.Particulars = Line.Particulars;
                        NewJournalEntry.DebitAmount = Line.DebitAmount;
                        NewJournalEntry.CreditAmount = Line.CreditAmount;

                        db.TrnJournals.InsertOnSubmit(NewJournalEntry);
                        db.SubmitChanges();
                    }
                }

                return true;

            } catch {
                return false;
            }
        }

    }
}