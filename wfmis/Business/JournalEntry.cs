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

                // Create journal entries
                var TrnJournalVoucherLines = from l in db.TrnJournalVoucherLines
                                             where l.TrnJournalVoucher.Id == JVId && 
                                                   l.TrnJournalVoucher.IsLocked == true
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

        public bool JournalizedPI(Int64 PIId)
        {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.PIId == PIId);
                if (DeleteJournalEntries.Any())
                {
                    foreach (Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries)
                    {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // ================================================
                // Purchase Invoice: Create journal entries
                // Account          Debit Credit
                // ---------------- ----- ------
                // Expense          xxxxx
                // Tax Payable      xxxxx        
                // Accounts Payable       xxxxxx   SUB: Supplier
                // ================================================

                // -----------
                // DB: Expense
                // -----------
                var TrnPurchaseInvoiceLines = from d in db.TrnPurchaseInvoiceLines
                                              where d.PIId == PIId && d.TrnPurchaseInvoice.IsLocked == true
                                              group d by new
                                              {
                                                  PIId = d.TrnPurchaseInvoice.Id,
                                                  JournalDate = d.TrnPurchaseInvoice.PIDate,
                                                  PeriodId = d.TrnPurchaseInvoice.PeriodId,
                                                  BranchId = d.TrnPurchaseInvoice.BranchId,
                                                  AccountId = d.MstArticle.MstArticleItems.First().PurchaseAccountId,
                                                  Particulars = d.TrnPurchaseInvoice.Particulars
                                              } into g
                                              select new
                                              {
                                                  PIId = g.Key.PIId,
                                                  JournalDate = g.Key.JournalDate,
                                                  PeriodId = g.Key.PeriodId,
                                                  BranchId = g.Key.BranchId,
                                                  AccountId = g.Key.AccountId,
                                                  Particulars = g.Key.Particulars,
                                                  DebitAmount = g.Sum(a=>(a.Amount-a.TaxAmount))
                                              };
                if (TrnPurchaseInvoiceLines.Any())
                {
                    foreach (var Line in TrnPurchaseInvoiceLines)
                    {
                        if (Line.AccountId.Value > 0)
                        {
                            var NewLineJournalEntry = new Data.TrnJournal();

                            NewLineJournalEntry.PIId = PIId;
                            NewLineJournalEntry.JournalDate = Line.JournalDate;
                            NewLineJournalEntry.PeriodId = Line.PeriodId;
                            NewLineJournalEntry.BranchId = Line.BranchId;
                            NewLineJournalEntry.AccountId = Line.AccountId.Value;
                            NewLineJournalEntry.Particulars = Line.Particulars;
                            NewLineJournalEntry.DebitAmount = Line.DebitAmount;
                            NewLineJournalEntry.CreditAmount = 0;

                            db.TrnJournals.InsertOnSubmit(NewLineJournalEntry);
                            db.SubmitChanges();
                        }
                    }
                }
                // --------------------------
                // DB: Tax Payable, e.g., VAT
                // --------------------------
                var TrnPurchaseInvoiceTaxLines = from d in db.TrnPurchaseInvoiceLines
                                                 where d.PIId == PIId && d.TrnPurchaseInvoice.IsLocked == true
                                                 group d by new
                                                 {
                                                      PIId = d.TrnPurchaseInvoice.Id,
                                                      JournalDate = d.TrnPurchaseInvoice.PIDate,
                                                      PeriodId = d.TrnPurchaseInvoice.PeriodId,
                                                      BranchId = d.TrnPurchaseInvoice.BranchId,
                                                      AccountId = d.MstTax.AccountId,
                                                      Particulars = d.TrnPurchaseInvoice.Particulars
                                                 } into g
                                                 select new
                                                 {
                                                      PIId = g.Key.PIId,
                                                      JournalDate = g.Key.JournalDate,
                                                      PeriodId = g.Key.PeriodId,
                                                      BranchId = g.Key.BranchId,
                                                      AccountId = g.Key.AccountId,
                                                      Particulars = g.Key.Particulars,
                                                      DebitAmount = g.Sum(a => (a.TaxAmount))
                                                 };
                if (TrnPurchaseInvoiceTaxLines.Any())
                {
                    foreach (var Line in TrnPurchaseInvoiceTaxLines)
                    {
                        var NewLineTaxJournalEntry = new Data.TrnJournal();

                        NewLineTaxJournalEntry.PIId = PIId;
                        NewLineTaxJournalEntry.JournalDate = Line.JournalDate;
                        NewLineTaxJournalEntry.PeriodId = Line.PeriodId;
                        NewLineTaxJournalEntry.BranchId = Line.BranchId;
                        NewLineTaxJournalEntry.AccountId = Line.AccountId;
                        NewLineTaxJournalEntry.Particulars = Line.Particulars;
                        NewLineTaxJournalEntry.DebitAmount = Line.DebitAmount;
                        NewLineTaxJournalEntry.CreditAmount = 0;

                        db.TrnJournals.InsertOnSubmit(NewLineTaxJournalEntry);
                        db.SubmitChanges();
                    }
                }
                // --------------------
                // CR: Accounts Payable
                // --------------------
                var PurchaseInvoice = (from d in db.TrnPurchaseInvoices
                                       where d.Id == PIId && d.IsLocked == true
                                       select new
                                       {
                                          PIId = d.Id,
                                          JournalDate = d.PIDate,
                                          PeriodId = d.PeriodId,
                                          BranchId = d.BranchId,
                                          AccountId = d.MstArticle.AccountId,
                                          ArticleId = d.SupplierId,
                                          Particulars = d.Particulars,
                                          CreditAmount = d.TotalAmount
                                       }).First();

                var NewHeaderJournalEntry = new Data.TrnJournal();

                NewHeaderJournalEntry.PIId = PurchaseInvoice.PIId;
                NewHeaderJournalEntry.JournalDate = PurchaseInvoice.JournalDate;
                NewHeaderJournalEntry.PeriodId = PurchaseInvoice.PeriodId;
                NewHeaderJournalEntry.BranchId = PurchaseInvoice.BranchId;
                NewHeaderJournalEntry.AccountId = PurchaseInvoice.AccountId;
                NewHeaderJournalEntry.ArticleId = PurchaseInvoice.ArticleId;
                NewHeaderJournalEntry.Particulars = PurchaseInvoice.Particulars;
                NewHeaderJournalEntry.DebitAmount = 0;
                NewHeaderJournalEntry.CreditAmount = PurchaseInvoice.CreditAmount;

                db.TrnJournals.InsertOnSubmit(NewHeaderJournalEntry);
                db.SubmitChanges();

                return true;
            } catch
            {
                return false;
            }
        }

        public bool JournalizedCV(Int64 CVId)
        {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.CVId == CVId);
                if (DeleteJournalEntries.Any())
                {
                    foreach (Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries)
                    {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }
                
                // ================================================
                // Disbursement: Create journal entries
                // Account           Debit Credit
                // ----------------  ----- ------
                // Accounts Payable  xxxxx         SUB: Supplier (Optional/if has PI Number)
                // Cash-in-Bank            xxxxxx  SUB: Bank
                // ================================================

                // ----------------------------------------------
                // DB: Accounts Payable  SUB: Supplier (Optional)
                // ----------------------------------------------
                var TrnDisbursementLines = from d in db.TrnDisbursementLines
                                              where d.CVId == CVId && d.TrnDisbursement.IsLocked == true
                                              group d by new
                                              {
                                                  CVId = d.CVId,
                                                  JournalDate = d.TrnDisbursement.CVDate,
                                                  PeriodId = d.TrnDisbursement.PeriodId,
                                                  BranchId = d.BranchId,
                                                  AccountId = d.AccountId,
                                                  ArticleId = d.PIId == null ? 0 : d.TrnPurchaseInvoice.SupplierId,
                                                  Particulars = d.Particulars
                                              } into g
                                              select new
                                              {
                                                  CVId = g.Key.CVId,
                                                  JournalDate = g.Key.JournalDate,
                                                  PeriodId = g.Key.PeriodId,
                                                  BranchId = g.Key.BranchId,
                                                  AccountId = g.Key.AccountId,
                                                  ArticleId = g.Key.ArticleId,
                                                  Particulars = g.Key.Particulars,
                                                  DebitAmount = g.Sum(a => (a.Amount))
                                              };
                if (TrnDisbursementLines.Any())
                {
                    foreach (var Line in TrnDisbursementLines)
                    {
                        var NewLineJournalEntry = new Data.TrnJournal();

                        NewLineJournalEntry.CVId = CVId;
                        NewLineJournalEntry.JournalDate = Line.JournalDate;
                        NewLineJournalEntry.PeriodId = Line.PeriodId;
                        NewLineJournalEntry.BranchId = Line.BranchId;
                        NewLineJournalEntry.AccountId = Line.AccountId;
                        if (Line.ArticleId > 0) NewLineJournalEntry.ArticleId = Line.ArticleId;
                        NewLineJournalEntry.Particulars = Line.Particulars;
                        NewLineJournalEntry.DebitAmount = Line.DebitAmount;
                        NewLineJournalEntry.CreditAmount = 0;

                        db.TrnJournals.InsertOnSubmit(NewLineJournalEntry);
                        db.SubmitChanges();
                    }
                }
                // ---------------------------
                // CR: Cash-in-Bank  SUB: Bank
                // ---------------------------
                var Disbursement = (from d in db.TrnDisbursements
                                    where d.Id == CVId && d.IsLocked == true
                                       select new
                                       {
                                           CVId = d.Id,
                                           JournalDate = d.CVDate,
                                           PeriodId = d.PeriodId,
                                           BranchId = d.BranchId,
                                           AccountId = d.MstArticle1.AccountId, 
                                           ArticleId = d.MstArticle1.Id,         
                                           Particulars = d.Particulars,
                                           CreditAmount = d.TotalAmount
                                       }).First();

                var NewHeaderJournalEntry = new Data.TrnJournal();

                NewHeaderJournalEntry.CVId = Disbursement.CVId;
                NewHeaderJournalEntry.JournalDate = Disbursement.JournalDate;
                NewHeaderJournalEntry.PeriodId = Disbursement.PeriodId;
                NewHeaderJournalEntry.BranchId = Disbursement.BranchId;
                NewHeaderJournalEntry.AccountId = Disbursement.AccountId;
                NewHeaderJournalEntry.ArticleId = Disbursement.ArticleId;
                NewHeaderJournalEntry.Particulars = Disbursement.Particulars;
                NewHeaderJournalEntry.DebitAmount = 0;
                NewHeaderJournalEntry.CreditAmount = Disbursement.CreditAmount;

                db.TrnJournals.InsertOnSubmit(NewHeaderJournalEntry);
                db.SubmitChanges();

                return true;
            } catch
            {
                return false;
            }
        }

        public bool JournalizedSI(Int64 SIId)
        {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.SIId == SIId);
                if (DeleteJournalEntries.Any())
                {
                    foreach (Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries)
                    {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // ================================================
                // Sales Invoice: Create journal entries
                // Account              Debit Credit
                // -------------------- ----- ------
                // Accounts Receivable  xxxxx           SUB: Customer
                // Sales                      xxxxxx
                // Tax Payable                xxxxxx
                // ================================================

                // -----------------------
                // DB: Accounts Receivable
                // -----------------------
                var SalesInvoice = (from d in db.TrnSalesInvoices
                                    where d.Id == SIId && d.IsLocked == true
                                    select new
                                       {
                                           SIId = d.Id,
                                           JournalDate = d.SIDate,
                                           PeriodId = d.PeriodId,
                                           BranchId = d.BranchId,
                                           AccountId = d.MstArticle.AccountId,
                                           ArticleId = d.CustomerId,
                                           Particulars = d.Particulars,
                                           DebitAmount = d.TotalAmount
                                    }).First();

                var NewHeaderJournalEntry = new Data.TrnJournal();

                NewHeaderJournalEntry.SIId = SalesInvoice.SIId;
                NewHeaderJournalEntry.JournalDate = SalesInvoice.JournalDate;
                NewHeaderJournalEntry.PeriodId = SalesInvoice.PeriodId;
                NewHeaderJournalEntry.BranchId = SalesInvoice.BranchId;
                NewHeaderJournalEntry.AccountId = SalesInvoice.AccountId;
                NewHeaderJournalEntry.ArticleId = SalesInvoice.ArticleId;
                NewHeaderJournalEntry.Particulars = SalesInvoice.Particulars;
                NewHeaderJournalEntry.DebitAmount = SalesInvoice.DebitAmount;
                NewHeaderJournalEntry.CreditAmount = 0;

                db.TrnJournals.InsertOnSubmit(NewHeaderJournalEntry);
                db.SubmitChanges();

                // ---------
                // CR: Sales
                // ---------
                var TrnSalesnvoiceLines = from d in db.TrnSalesInvoiceLines
                                          where d.SIId == SIId && d.TrnSalesInvoice.IsLocked == true
                                          group d by new
                                          {
                                            SIId = d.SIId,
                                            JournalDate = d.TrnSalesInvoice.SIDate,
                                            PeriodId = d.TrnSalesInvoice.PeriodId,
                                            BranchId = d.TrnSalesInvoice.BranchId,
                                            AccountId = d.MstArticle.MstArticleItems.First().SalesAccountId,
                                            Particulars = d.TrnSalesInvoice.Particulars
                                          } into g
                                          select new
                                          {
                                            SIId = g.Key.SIId,
                                            JournalDate = g.Key.JournalDate,
                                            PeriodId = g.Key.PeriodId,
                                            BranchId = g.Key.BranchId,
                                            AccountId = g.Key.AccountId,
                                            Particulars = g.Key.Particulars,
                                            CreditAmount = g.Sum(a => (a.Amount - a.TaxAmount))
                                          };
                if (TrnSalesnvoiceLines.Any())
                {
                    foreach (var Line in TrnSalesnvoiceLines)
                    {
                        var NewLineJournalEntry = new Data.TrnJournal();

                        NewLineJournalEntry.SIId = SIId;
                        NewLineJournalEntry.JournalDate = Line.JournalDate;
                        NewLineJournalEntry.PeriodId = Line.PeriodId;
                        NewLineJournalEntry.BranchId = Line.BranchId;
                        NewLineJournalEntry.AccountId = Line.AccountId.Value;
                        NewLineJournalEntry.Particulars = Line.Particulars;
                        NewLineJournalEntry.DebitAmount = 0;
                        NewLineJournalEntry.CreditAmount = Line.CreditAmount;

                        db.TrnJournals.InsertOnSubmit(NewLineJournalEntry);
                        db.SubmitChanges();
                    }
                }
                // --------------------------
                // CR: Tax Payable, e.g., VAT
                // --------------------------
                var TrnSalesInvoiceTaxLines = from d in db.TrnSalesInvoiceLines
                                              where d.SIId == SIId && d.TrnSalesInvoice.IsLocked == true
                                              group d by new
                                              {
                                                SIId = d.SIId,
                                                JournalDate = d.TrnSalesInvoice.SIDate,
                                                PeriodId = d.TrnSalesInvoice.PeriodId,
                                                BranchId = d.TrnSalesInvoice.BranchId,
                                                AccountId = d.MstTax.MstAccount.Id,
                                                Particulars = d.TrnSalesInvoice.Particulars
                                              } into g
                                              select new
                                              {
                                                SIId = g.Key.SIId,
                                                JournalDate = g.Key.JournalDate,
                                                PeriodId = g.Key.PeriodId,
                                                BranchId = g.Key.BranchId,
                                                AccountId = g.Key.AccountId,
                                                Particulars = g.Key.Particulars,
                                                CreditAmount = g.Sum(a => a.TaxAmount)
                                              };
                if (TrnSalesInvoiceTaxLines.Any())
                {
                    foreach (var Line in TrnSalesInvoiceTaxLines)
                    {
                        var NewLineTaxJournalEntry = new Data.TrnJournal();

                        NewLineTaxJournalEntry.SIId = SIId;
                        NewLineTaxJournalEntry.JournalDate = Line.JournalDate;
                        NewLineTaxJournalEntry.PeriodId = Line.PeriodId;
                        NewLineTaxJournalEntry.BranchId = Line.BranchId;
                        NewLineTaxJournalEntry.AccountId = Line.AccountId;
                        NewLineTaxJournalEntry.Particulars = Line.Particulars;
                        NewLineTaxJournalEntry.DebitAmount = 0;
                        NewLineTaxJournalEntry.CreditAmount = Line.CreditAmount;

                        db.TrnJournals.InsertOnSubmit(NewLineTaxJournalEntry);
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

        public bool JournalizedOR(Int64 ORId)
        {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.ORId == ORId);
                if (DeleteJournalEntries.Any())
                {
                    foreach (Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries)
                    {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // ================================================
                // Collection: Create journal entries
                // Account              Debit Credit
                // -------------------- ----- ------
                // Cash in Bank         xxxxx           SUB: (To be reconciled yet)
                // Accounts Receivable        xxxxxx    SUB: Customer
                // ================================================

                // ----------------
                // DB: Cash in Bank
                // ----------------
                var TrnCollectionLines1 = from d in db.TrnCollectionLines
                                          where d.ORId == ORId && d.TrnCollection.IsLocked == true
                                          group d by new
                                          {
                                              ORId = d.ORId,
                                              JournalDate = d.TrnCollection.ORDate,
                                              PeriodId = d.TrnCollection.PeriodId,
                                              BranchId = d.TrnCollection.BranchId,
                                              AccountId = d.MstPayType.AccountId,
                                              Particulars = d.TrnCollection.Particulars
                                          } into g
                                          select new
                                          {
                                              ORId = g.Key.ORId,
                                              JournalDate = g.Key.JournalDate,
                                              PeriodId = g.Key.PeriodId,
                                              BranchId = g.Key.BranchId,
                                              AccountId = g.Key.AccountId,
                                              Particulars = g.Key.Particulars,
                                              DebitAmount = g.Sum(a => a.Amount)
                                          };
                if (TrnCollectionLines1.Any())
                {
                    foreach (var Line in TrnCollectionLines1)
                    {
                        var NewLinePayTypeJournalEntry = new Data.TrnJournal();

                        NewLinePayTypeJournalEntry.ORId = ORId;
                        NewLinePayTypeJournalEntry.JournalDate = Line.JournalDate;
                        NewLinePayTypeJournalEntry.PeriodId = Line.PeriodId;
                        NewLinePayTypeJournalEntry.BranchId = Line.BranchId;
                        NewLinePayTypeJournalEntry.AccountId = Line.AccountId;
                        NewLinePayTypeJournalEntry.Particulars = Line.Particulars;
                        NewLinePayTypeJournalEntry.DebitAmount = Line.DebitAmount;
                        NewLinePayTypeJournalEntry.CreditAmount = 0;

                        db.TrnJournals.InsertOnSubmit(NewLinePayTypeJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // -----------------------
                // CR: Accounts Receivable
                // -----------------------
                var TrnCollectionLines2 = from d in db.TrnCollectionLines
                                          where d.ORId == ORId && d.AccountId > 0 && d.TrnCollection.IsLocked == true
                                          group d by new
                                          {
                                              ORId = d.ORId,
                                              JournalDate = d.TrnCollection.ORDate,
                                              PeriodId = d.TrnCollection.PeriodId,
                                              BranchId = d.TrnCollection.BranchId,
                                              AccountId = d.AccountId,
                                              Particulars = d.TrnCollection.Particulars
                                          } into g
                                          select new
                                          {
                                              ORId = g.Key.ORId,
                                              JournalDate = g.Key.JournalDate,
                                              PeriodId = g.Key.PeriodId,
                                              BranchId = g.Key.BranchId,
                                              AccountId = g.Key.AccountId,
                                              Particulars = g.Key.Particulars,
                                              CreditAmount = g.Sum(a => a.Amount)
                                          };
                if (TrnCollectionLines2.Any())
                {
                    foreach (var Line in TrnCollectionLines2)
                    {
                        var NewLineARJournalEntry = new Data.TrnJournal();

                        NewLineARJournalEntry.ORId = ORId;
                        NewLineARJournalEntry.JournalDate = Line.JournalDate;
                        NewLineARJournalEntry.PeriodId = Line.PeriodId;
                        NewLineARJournalEntry.BranchId = Line.BranchId;
                        NewLineARJournalEntry.AccountId = Line.AccountId;
                        NewLineARJournalEntry.Particulars = Line.Particulars;
                        NewLineARJournalEntry.DebitAmount = 0;
                        NewLineARJournalEntry.CreditAmount = Line.CreditAmount;

                        db.TrnJournals.InsertOnSubmit(NewLineARJournalEntry);
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

        public bool JournalizedIN(Int64 INId)
        {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.INId == INId);
                if (DeleteJournalEntries.Any())
                {
                    foreach (Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries)
                    {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // ================================================
                // Stock-in: Create journal entries
                // Account          Debit Credit
                // ---------------- ----- ------
                // Inventory        xxxxx 
                // Expense                xxxxxx   
                // ================================================

                // -------------
                // DB: Inventory
                // -------------
                var TrnStockInLines = from d in db.TrnStockInLines
                                      where d.INId == INId  && d.TrnStockIn.IsLocked == true
                                      group d by new
                                      {
                                            INId = d.TrnStockIn.Id,
                                            JournalDate = d.TrnStockIn.INDate,
                                            PeriodId = d.TrnStockIn.PeriodId,
                                            BranchId = d.TrnStockIn.BranchId,
                                            AccountId = d.MstArticle.AccountId,
                                            Particulars = d.TrnStockIn.Particulars
                                      } into g
                                      select new
                                      {
                                            INId = g.Key.INId,
                                            JournalDate = g.Key.JournalDate,
                                            PeriodId = g.Key.PeriodId,
                                            BranchId = g.Key.BranchId,
                                            AccountId = g.Key.AccountId,
                                            Particulars = g.Key.Particulars,
                                            DebitAmount = g.Sum(a => a.Amount)
                                      };
                if (TrnStockInLines.Any())
                {
                    foreach (var Line in TrnStockInLines)
                    {
                        if (Line.AccountId > 0)
                        {
                            var NewLineJournalEntry = new Data.TrnJournal();

                            NewLineJournalEntry.INId = INId;
                            NewLineJournalEntry.JournalDate = Line.JournalDate;
                            NewLineJournalEntry.PeriodId = Line.PeriodId;
                            NewLineJournalEntry.BranchId = Line.BranchId;
                            NewLineJournalEntry.AccountId = Line.AccountId;
                            NewLineJournalEntry.Particulars = Line.Particulars;
                            NewLineJournalEntry.DebitAmount = Line.DebitAmount;
                            NewLineJournalEntry.CreditAmount = 0;

                            db.TrnJournals.InsertOnSubmit(NewLineJournalEntry);
                            db.SubmitChanges();
                        }
                    }
                }

                // ----------------
                // CR: Expenses/WIP
                // ----------------
                var TrnStockInExpensesLines = from d in db.TrnStockInLines
                                              where d.INId == INId && d.TrnStockIn.IsLocked == true
                                              group d by new
                                              {
                                                  INId = d.TrnStockIn.Id,
                                                  JournalDate = d.TrnStockIn.INDate,
                                                  PeriodId = d.TrnStockIn.PeriodId,
                                                  BranchId = d.TrnStockIn.BranchId,
                                                  AccountId = d.TrnStockIn.AccountId,
                                                  Particulars = d.TrnStockIn.Particulars
                                              } into g
                                              select new
                                              {
                                                  INId = g.Key.INId,
                                                  JournalDate = g.Key.JournalDate,
                                                  PeriodId = g.Key.PeriodId,
                                                  BranchId = g.Key.BranchId,
                                                  AccountId = g.Key.AccountId,
                                                  Particulars = g.Key.Particulars,
                                                  CreditAmount = g.Sum(a => a.Amount)
                                              };
                if (TrnStockInExpensesLines.Any())
                {
                    foreach (var Line in TrnStockInExpensesLines)
                    {
                        var NewLineTaxJournalEntry = new Data.TrnJournal();

                        NewLineTaxJournalEntry.INId = INId;
                        NewLineTaxJournalEntry.JournalDate = Line.JournalDate;
                        NewLineTaxJournalEntry.PeriodId = Line.PeriodId;
                        NewLineTaxJournalEntry.BranchId = Line.BranchId;
                        NewLineTaxJournalEntry.AccountId = Line.AccountId;
                        NewLineTaxJournalEntry.Particulars = Line.Particulars;
                        NewLineTaxJournalEntry.DebitAmount = 0;
                        NewLineTaxJournalEntry.CreditAmount = Line.CreditAmount;

                        db.TrnJournals.InsertOnSubmit(NewLineTaxJournalEntry);
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

        public bool JournalizedOT(Int64 OTId)
        {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.OTId == OTId);
                if (DeleteJournalEntries.Any())
                {
                    foreach (Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries)
                    {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // ================================================
                // Stock-out: Create journal entries
                // Account          Debit Credit
                // ---------------- ----- ------
                // Cost of Sales    xxxxx 
                // Inventory              xxxxxx   
                // ================================================

                // ---------------------
                // DB: Cost of Sales/WIP
                // ---------------------
                long WIPAccountId = db.TrnStockOuts.Where(o=>o.Id==OTId).First().INId == null ? 0 : db.TrnStockOuts.Where(o=>o.Id==OTId).First().TrnStockIn.AccountId;

                var CostTrnStockOutLines = from d in db.TrnStockOutLines
                                           where d.OTId == OTId && d.TrnStockOut.IsLocked == true
                                           group d by new
                                           {
                                                OTId = d.TrnStockOut.Id,
                                                INId = d.TrnStockOut.INId == null ? 0 : d.TrnStockOut.INId,
                                                JournalDate = d.TrnStockOut.OTDate,
                                                PeriodId = d.TrnStockOut.PeriodId,
                                                BranchId = d.TrnStockOut.BranchId,
                                                AccountId = WIPAccountId == 0 ? d.MstArticle.MstArticleItems.First().CostAccountId : WIPAccountId,
                                                Particulars = d.TrnStockOut.Particulars
                                            } into g
                                            select new
                                            {
                                                OTId = g.Key.OTId,
                                                INId = g.Key.INId,
                                                JournalDate = g.Key.JournalDate,
                                                PeriodId = g.Key.PeriodId,
                                                BranchId = g.Key.BranchId,
                                                AccountId = g.Key.AccountId,
                                                Particulars = g.Key.Particulars,
                                                DebitAmount = g.Sum(a => a.Amount)
                                            };

                if (CostTrnStockOutLines.Any())
                {

                    foreach (var Line in CostTrnStockOutLines)
                    {
                        var NewLineJournalEntry = new Data.TrnJournal();

                        NewLineJournalEntry.OTId = OTId;
                        NewLineJournalEntry.JournalDate = Line.JournalDate;
                        NewLineJournalEntry.PeriodId = Line.PeriodId;
                        NewLineJournalEntry.BranchId = Line.BranchId;
                        NewLineJournalEntry.AccountId = Line.AccountId.Value;
                        NewLineJournalEntry.Particulars = Line.Particulars;
                        NewLineJournalEntry.DebitAmount = Line.DebitAmount;
                        NewLineJournalEntry.CreditAmount = 0;

                        db.TrnJournals.InsertOnSubmit(NewLineJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // -------------
                // CR: Inventory
                // -------------
                var InventoryTrnStockOutLines = from d in db.TrnStockOutLines
                                                where d.OTId == OTId && d.TrnStockOut.IsLocked == true
                                                group d by new
                                                {
                                                     OTId = d.TrnStockOut.Id,
                                                     JournalDate = d.TrnStockOut.OTDate,
                                                     PeriodId = d.TrnStockOut.PeriodId,
                                                     BranchId = d.TrnStockOut.BranchId,
                                                     AccountId = d.MstArticle.AccountId,
                                                     Particulars = d.TrnStockOut.Particulars
                                                } into g
                                                select new
                                                {
                                                     OTId = g.Key.OTId,
                                                     JournalDate = g.Key.JournalDate,
                                                     PeriodId = g.Key.PeriodId,
                                                     BranchId = g.Key.BranchId,
                                                     AccountId = g.Key.AccountId,
                                                     Particulars = g.Key.Particulars,
                                                     CreditAmount = g.Sum(a => a.Amount)
                                                };
                if (InventoryTrnStockOutLines.Any())
                {
                    foreach (var Line in InventoryTrnStockOutLines)
                    {
                        var NewLineJournalEntry = new Data.TrnJournal();

                        NewLineJournalEntry.OTId = OTId;
                        NewLineJournalEntry.JournalDate = Line.JournalDate;
                        NewLineJournalEntry.PeriodId = Line.PeriodId;
                        NewLineJournalEntry.BranchId = Line.BranchId;
                        NewLineJournalEntry.AccountId = Line.AccountId;
                        NewLineJournalEntry.Particulars = Line.Particulars;
                        NewLineJournalEntry.DebitAmount = 0;
                        NewLineJournalEntry.CreditAmount = Line.CreditAmount;

                        db.TrnJournals.InsertOnSubmit(NewLineJournalEntry);
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

        public bool JournalizedST(Int64 STId)
        {
            try
            {
                // Delete existing journal entries
                var DeleteJournalEntries = db.TrnJournals.Where(j => j.STId == STId);
                if (DeleteJournalEntries.Any())
                {
                    foreach (Data.TrnJournal DeleteJournalEntry in DeleteJournalEntries)
                    {
                        db.TrnJournals.DeleteOnSubmit(DeleteJournalEntry);
                        db.SubmitChanges();
                    }
                }

                // ================================================
                // Stock transfer: Create journal entries
                // Account          Debit Credit
                // ---------------- ----- ------
                // Inventory        xxxxx         
                // Inventory              xxxxxx   
                // ================================================

                // ----------------
                // DB/CR: Inventory
                // ----------------
                var TrnStockTransferLines = from d in db.TrnStockTransferLines
                                            where d.STId == STId && d.TrnStockTransfer.IsLocked == true
                                            group d by new
                                            {
                                                STId = d.TrnStockTransfer.Id,
                                                JournalDate = d.TrnStockTransfer.STDate,
                                                PeriodId = d.TrnStockTransfer.PeriodId,
                                                FromBranchId = d.TrnStockTransfer.BranchId,
                                                ToBranchId = d.TrnStockTransfer.ToBranchId,
                                                AccountId = d.MstArticle.MstArticleItems.First().AssetAccountId,
                                                Particulars = d.TrnStockTransfer.Particulars
                                            } into g
                                            select new
                                            {
                                               STId = g.Key.STId,
                                               JournalDate = g.Key.JournalDate,
                                               PeriodId = g.Key.PeriodId,
                                               FromBranchId = g.Key.FromBranchId,
                                               ToBranchId = g.Key.ToBranchId,
                                               AccountId = g.Key.AccountId,
                                               Particulars = g.Key.Particulars,
                                               DebitAmount = g.Sum(a => a.Amount),
                                               CreditAmount = g.Sum(a => a.Amount)
                                            };
                if (TrnStockTransferLines.Any())
                {
                    foreach (var Line in TrnStockTransferLines)
                    {
                        var NewLineJournalEntryFrom = new Data.TrnJournal();

                        NewLineJournalEntryFrom.STId = STId;
                        NewLineJournalEntryFrom.JournalDate = Line.JournalDate;
                        NewLineJournalEntryFrom.PeriodId = Line.PeriodId;
                        NewLineJournalEntryFrom.BranchId = Line.FromBranchId;
                        NewLineJournalEntryFrom.AccountId = Line.AccountId.Value;
                        NewLineJournalEntryFrom.Particulars = Line.Particulars;
                        NewLineJournalEntryFrom.DebitAmount = 0;
                        NewLineJournalEntryFrom.CreditAmount = Line.CreditAmount;

                        db.TrnJournals.InsertOnSubmit(NewLineJournalEntryFrom);
                        db.SubmitChanges();

                        var NewLineJournalEntryTo = new Data.TrnJournal();

                        NewLineJournalEntryTo.STId = STId;
                        NewLineJournalEntryTo.JournalDate = Line.JournalDate;
                        NewLineJournalEntryTo.PeriodId = Line.PeriodId;
                        NewLineJournalEntryTo.BranchId = Line.ToBranchId;
                        NewLineJournalEntryTo.AccountId = Line.AccountId.Value;
                        NewLineJournalEntryTo.Particulars = Line.Particulars;
                        NewLineJournalEntryTo.DebitAmount = Line.DebitAmount;
                        NewLineJournalEntryTo.CreditAmount = 0;

                        db.TrnJournals.InsertOnSubmit(NewLineJournalEntryTo);
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
    }
}