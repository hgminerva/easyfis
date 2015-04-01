using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class SysReportController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        // =================
        // GET api/SysReport
        // =================

        public HttpResponseMessage Get()
        {
            NameValueCollection nvc = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            string Report = nvc["Report"].ToString();
            Int64 Id = Convert.ToInt64(nvc["Id"]);
            var response = new HttpResponseMessage(HttpStatusCode.OK);

            switch (Report)
            {
                case "PurchaseOrder":
                    response.Content = new StreamContent(this.PurchaseOrder(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "PurchaseInvoice":
                    response.Content = new StreamContent(this.PurchaseInvoice(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "Disbursement":
                    response.Content = new StreamContent(this.Disbursement(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "SalesOrder":
                    response.Content = new StreamContent(this.SalesOrder(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "SalesInvoice":
                    response.Content = new StreamContent(this.SalesInvoice(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "Collection":
                    response.Content = new StreamContent(this.Collection(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "JournalVoucher":
                    response.Content = new StreamContent(this.JournalVoucher(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "StockIn":
                    response.Content = new StreamContent(this.StockIn(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "StockOut":
                    response.Content = new StreamContent(this.StockOut(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break;
                case "StockTransfer":
                    response.Content = new StreamContent(this.StockTransfer(Id));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break; 
                case "StatementOfAccount":
                    DateTime AsOfDate = Convert.ToDateTime(nvc["AsOfDate"]);

                    response.Content = new StreamContent(this.StatementOfAccount(Id, AsOfDate));
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    break; 
            }

            return response;
        }
        
        // ====================
        // PDF Report Utilities
        // ====================

        private PdfPCell CreateRightAlignedCell(string text, Font font, int span) {
            PdfPCell cell = new PdfPCell(new Phrase(text, font)) { HorizontalAlignment = PdfPCell.ALIGN_RIGHT };
            cell.Colspan = span;
            return cell;
        }
        private PdfPCell CreateLeftAlignedCell(string text, Font font, int span)
        {
            PdfPCell cell = new PdfPCell(new Phrase(text, font)) { HorizontalAlignment = PdfPCell.ALIGN_LEFT };
            cell.Colspan = span;
            return cell;
        }
        private PdfPCell CreateCenterAlignedCell(string text, Font font, int span)
        {
            PdfPCell cell = new PdfPCell(new Phrase(text, font)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER };
            cell.Colspan = span;
            return cell;
        }

        // ==============
        // Purchase Order
        // ==============

        private MemoryStream PurchaseOrder(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Purchase Order");

                var PurchaseOrders = from d in db.TrnPurchaseOrders where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(PurchaseOrders.First().MstBranch.MstCompany.Company + "\\" + PurchaseOrders.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(PurchaseOrders.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(PurchaseOrders.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("PO Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseOrders.First().PONumber, BodyFont));
                HeaderTable.AddCell(new Phrase("PO Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseOrders.First().PODate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Supplier:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseOrders.First().MstArticle.Article, BodyFont));
                HeaderTable.AddCell(new Phrase("Term:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseOrders.First().MstTerm.Term, BodyFont));
                HeaderTable.AddCell(new Phrase("Request Reference:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseOrders.First().RequestNumber, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(6);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 2, 6, 3, 3, 3 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Qty", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Unit", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Item", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Cost", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (PurchaseOrders.First().TrnPurchaseOrderLines.Any())
                {
                    foreach (var Line in PurchaseOrders.First().TrnPurchaseOrderLines)
                    {
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Quantity.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(new Phrase(Line.MstUnit.Unit, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Cost.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 5));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(PurchaseOrders.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(PurchaseOrders.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(PurchaseOrders.First().MstUser3.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ================
        // Purchase Invoice
        // ================
        
        private MemoryStream PurchaseInvoice(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Purchase Invoice");

                var PurchaseInvoices = from d in db.TrnPurchaseInvoices where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(PurchaseInvoices.First().MstBranch.MstCompany.Company + "\\" + PurchaseInvoices.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(PurchaseInvoices.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(PurchaseInvoices.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("PI Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseInvoices.First().PINumber, BodyFont));
                HeaderTable.AddCell(new Phrase("PI Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseInvoices.First().PIDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Supplier:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseInvoices.First().MstArticle.Article, BodyFont));
                HeaderTable.AddCell(new Phrase("Term:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseInvoices.First().MstTerm.Term, BodyFont));
                HeaderTable.AddCell(new Phrase("Document Reference:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(PurchaseInvoices.First().DocumentReference, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(7);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 2, 6, 3, 3, 3, 3 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Qty", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Unit", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Item", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Cost", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Tax", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (PurchaseInvoices.First().TrnPurchaseInvoiceLines.Any())
                {
                    foreach (var Line in PurchaseInvoices.First().TrnPurchaseInvoiceLines) 
                    {
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Quantity.ToString("#,##0.#0"), BodyFont,1));
                        DetailTable.AddCell(new Phrase(Line.MstUnit.Unit, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Cost.ToString("#,##0.#0"), BodyFont,1));
                        DetailTable.AddCell(new Phrase(Line.MstTax.TaxCode, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont,1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 6));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(PurchaseInvoices.First().MstUser.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(PurchaseInvoices.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(PurchaseInvoices.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ============
        // Disbursement
        // ============

        private MemoryStream Disbursement(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Disbursement Voucher");

                var Disbursements = from d in db.TrnDisbursements where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(Disbursements.First().MstBranch.MstCompany.Company + "\\" + Disbursements.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(Disbursements.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(Disbursements.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("CV Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Disbursements.First().CVNumber, BodyFont));
                HeaderTable.AddCell(new Phrase("CV Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Disbursements.First().CVDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Pay Type:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Disbursements.First().MstPayType.PayType, BodyFont));
                HeaderTable.AddCell(new Phrase("Check Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Disbursements.First().CheckNumber, BodyFont));
                HeaderTable.AddCell(new Phrase("Check Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Disbursements.First().CheckDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Check Payee:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Disbursements.First().CheckPayee, BodyFont));
                HeaderTable.AddCell(new Phrase("Bank:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Disbursements.First().MstArticle1.Article, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(4);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 4, 2, 6, 2 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Account", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("PINumber", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (Disbursements.First().TrnDisbursementLines.Any())
                {
                    foreach (var Line in Disbursements.First().TrnDisbursementLines)
                    {
                        DetailTable.AddCell(new Phrase(Line.MstAccount.Account, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.PIId == null ? "" : Line.TrnPurchaseInvoice.PINumber, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 3));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(Disbursements.First().MstUser.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(Disbursements.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(Disbursements.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ===========
        // Sales Order
        // ===========

        private MemoryStream SalesOrder(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Sales Order");

                var SalesOrders = from d in db.TrnSalesOrders where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(SalesOrders.First().MstBranch.MstCompany.Company + "\\" + SalesOrders.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(SalesOrders.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(SalesOrders.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("SO Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesOrders.First().SONumber, BodyFont));
                HeaderTable.AddCell(new Phrase("SO Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesOrders.First().SODate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Customer:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesOrders.First().MstArticle.Article, BodyFont));
                HeaderTable.AddCell(new Phrase("Term:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesOrders.First().MstTerm.Term, BodyFont));
                HeaderTable.AddCell(new Phrase("Reference Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesOrders.First().OrderNumber, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(6);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 2, 6, 3, 3, 3 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Qty", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Unit", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Item", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Price", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (SalesOrders.First().TrnSalesOrderLines.Any())
                {
                    foreach (var Line in SalesOrders.First().TrnSalesOrderLines)
                    {
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Quantity.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(new Phrase(Line.MstUnit.Unit, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Price.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 5));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(SalesOrders.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(SalesOrders.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(SalesOrders.First().MstUser3.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // =============
        // Sales Invoice
        // =============

        private MemoryStream SalesInvoice(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Sales Invoice");

                var SalesInvoices = from d in db.TrnSalesInvoices where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(SalesInvoices.First().MstBranch.MstCompany.Company + "\\" + SalesInvoices.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(SalesInvoices.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(SalesInvoices.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("SI Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesInvoices.First().SINumber, BodyFont));
                HeaderTable.AddCell(new Phrase("SI Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesInvoices.First().SIDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Customer:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesInvoices.First().MstArticle.Article, BodyFont));
                HeaderTable.AddCell(new Phrase("Term:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesInvoices.First().MstTerm.Term, BodyFont));
                HeaderTable.AddCell(new Phrase("Reference Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(SalesInvoices.First().DocumentReference, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(8);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 2, 6, 3, 2, 2, 2, 3 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Qty", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Unit", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Item", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Price", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Discount", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Net Price", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (SalesInvoices.First().TrnSalesInvoiceLines.Any())
                {
                    foreach (var Line in SalesInvoices.First().TrnSalesInvoiceLines)
                    {
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Quantity.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(new Phrase(Line.MstUnit.Unit, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Price.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.DiscountAmount.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.NetPrice.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 7));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(SalesInvoices.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(SalesInvoices.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(SalesInvoices.First().MstUser3.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ==========
        // Collection
        // ==========

        private MemoryStream Collection(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Official Receipt");

                var Collections = from d in db.TrnCollections where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(Collections.First().MstBranch.MstCompany.Company + "\\" + Collections.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(Collections.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(Collections.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("OR Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Collections.First().ORNumber, BodyFont));
                HeaderTable.AddCell(new Phrase("OR Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Collections.First().ORDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Customer:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Collections.First().MstArticle.Article, BodyFont));
                HeaderTable.AddCell(new Phrase("Particulars:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(Collections.First().Particulars, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(8);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 4, 2, 4, 2, 2, 2, 3, 2 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Account", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("SI Number", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Pay Type", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Check No.", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Check Date", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Check Bank", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (Collections.First().TrnCollectionLines.Any())
                {
                    foreach (var Line in Collections.First().TrnCollectionLines)
                    {
                        DetailTable.AddCell(new Phrase(Line.MstAccount.Account, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.TrnSalesInvoice.SINumber, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstPayType.PayType, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.CheckNumber, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.CheckDate.ToShortDateString(), BodyFont));
                        DetailTable.AddCell(new Phrase(Line.CheckBank, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 7));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(Collections.First().MstUser.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(Collections.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(Collections.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ===============
        // Journal Voucher
        // ===============

        private MemoryStream JournalVoucher(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Journal Voucher");

                var JournalVouchers = from d in db.TrnJournalVouchers where d.Id == Id && d.IsLocked == true select d;

                doc.Open();

                doc.Add(new Paragraph(JournalVouchers.First().MstBranch.MstCompany.Company + "\\" + JournalVouchers.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(JournalVouchers.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(JournalVouchers.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("JV Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(JournalVouchers.First().JVNumber, BodyFont));
                HeaderTable.AddCell(new Phrase("JV Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(JournalVouchers.First().JVDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Particulars:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(JournalVouchers.First().Particulars, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(6);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 4, 4, 4, 2, 2 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Branch", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Account", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Subsidiary", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Debit Amount", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Credit Amount", TableHeaderFont, 1));

                decimal TotalDebitAmount = 0;
                decimal TotalCreditAmount = 0;
                if (JournalVouchers.First().TrnJournalVoucherLines.Any())
                {
                    foreach (var Line in JournalVouchers.First().TrnJournalVoucherLines)
                    {
                        DetailTable.AddCell(new Phrase(Line.MstBranch.Branch, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstAccount.Account, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.ArticleId == null ? "" : Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.DebitAmount.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.CreditAmount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalDebitAmount = TotalDebitAmount + Line.DebitAmount;
                        TotalCreditAmount = TotalCreditAmount + Line.CreditAmount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 4));
                DetailTable.AddCell(CreateRightAlignedCell(TotalDebitAmount.ToString("#,##0.#0"), TableHeaderFont, 1));
                DetailTable.AddCell(CreateRightAlignedCell(TotalCreditAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(JournalVouchers.First().MstUser.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(JournalVouchers.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(JournalVouchers.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ========
        // Stock In
        // ========

        private MemoryStream StockIn(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Stock In");

                var StockIns = from d in db.TrnStockIns where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(StockIns.First().MstBranch.MstCompany.Company + "\\" + StockIns.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(StockIns.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(StockIns.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("IN Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockIns.First().INNumber, BodyFont));
                HeaderTable.AddCell(new Phrase("IN Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockIns.First().INDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Account:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockIns.First().MstAccount.Account, BodyFont));
                HeaderTable.AddCell(new Phrase("Particulars:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockIns.First().Particulars, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(7);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 2, 6, 3, 3, 3, 3 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Qty", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Unit", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Item", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Inventory No", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Cost", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (StockIns.First().TrnStockInLines.Any())
                {
                    foreach (var Line in StockIns.First().TrnStockInLines)
                    {
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Quantity.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(new Phrase(Line.MstUnit.Unit, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.ItemInventoryId == null ? "-" : Line.MstArticleItemInventory.InventoryNumber, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Cost.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 6));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(StockIns.First().MstUser.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(StockIns.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(StockIns.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // =========
        // Stock Out
        // =========

        private MemoryStream StockOut(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Stock Out");

                var StockOuts = from d in db.TrnStockOuts where d.Id == Id select d;

                doc.Open();

                doc.Add(new Paragraph(StockOuts.First().MstBranch.MstCompany.Company + "\\" + StockOuts.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(StockOuts.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(StockOuts.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("OUT Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockOuts.First().OTNumber, BodyFont));
                HeaderTable.AddCell(new Phrase("OUT Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockOuts.First().OTDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Account:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockOuts.First().MstAccount.Account, BodyFont));
                HeaderTable.AddCell(new Phrase("Particulars:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockOuts.First().Particulars, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(7);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 2, 6, 3, 3, 3, 3 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Qty", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Unit", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Item", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Inventory No", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Cost", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (StockOuts.First().TrnStockOutLines.Any())
                {
                    foreach (var Line in StockOuts.First().TrnStockOutLines)
                    {
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Quantity.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(new Phrase(Line.MstUnit.Unit, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.ItemInventoryId == null ? "-" : Line.MstArticleItemInventory.InventoryNumber, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Cost.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 6));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(StockOuts.First().MstUser.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(StockOuts.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(StockOuts.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ==============
        // Stock Transfer
        // ==============

        private MemoryStream StockTransfer(Int64 Id)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Stock Transfer");

                var StockTransfers = from d in db.TrnStockTransfers where d.Id == Id && d.IsLocked == true select d;

                doc.Open();

                doc.Add(new Paragraph(StockTransfers.First().MstBranch.MstCompany.Company + "\\" + StockTransfers.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(StockTransfers.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(StockTransfers.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                HeaderTable.AddCell(new Phrase("Transfer Number:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockTransfers.First().STNumber, BodyFont));
                HeaderTable.AddCell(new Phrase("Transfer Date:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockTransfers.First().STDate.ToShortDateString(), BodyFont));
                HeaderTable.AddCell(new Phrase("Transfered To:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockTransfers.First().MstBranch1.Branch, BodyFont));
                HeaderTable.AddCell(new Phrase("Particulars:", TableHeaderFont));
                HeaderTable.AddCell(new Phrase(StockTransfers.First().Particulars, BodyFont));

                doc.Add(HeaderTable);

                var DetailTable = new PdfPTable(7);
                DetailTable.HorizontalAlignment = 0;
                DetailTable.SpacingAfter = 10;
                DetailTable.DefaultCell.Border = 0;
                DetailTable.SetWidths(new int[] { 2, 2, 6, 3, 3, 3, 3 });
                DetailTable.WidthPercentage = 100;
                DetailTable.DefaultCell.Border = Rectangle.BOX;

                DetailTable.AddCell(CreateCenterAlignedCell("Qty", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Unit", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Item", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Inventory No", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Particulars", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Cost", TableHeaderFont, 1));
                DetailTable.AddCell(CreateCenterAlignedCell("Amount", TableHeaderFont, 1));

                decimal TotalAmount = 0;
                if (StockTransfers.First().TrnStockTransferLines.Any())
                {
                    foreach (var Line in StockTransfers.First().TrnStockTransferLines)
                    {
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Quantity.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(new Phrase(Line.MstUnit.Unit, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.MstArticle.Article, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.ItemInventoryId == null ? "-" : Line.MstArticleItemInventory.InventoryNumber, BodyFont));
                        DetailTable.AddCell(new Phrase(Line.Particulars, BodyFont));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Cost.ToString("#,##0.#0"), BodyFont, 1));
                        DetailTable.AddCell(CreateRightAlignedCell(Line.Amount.ToString("#,##0.#0"), BodyFont, 1));

                        TotalAmount = TotalAmount + Line.Amount;
                    }
                }

                DetailTable.AddCell(CreateCenterAlignedCell("TOTAL", TableHeaderFont, 6));
                DetailTable.AddCell(CreateRightAlignedCell(TotalAmount.ToString("#,##0.#0"), TableHeaderFont, 1));

                doc.Add(DetailTable);

                var SignatureTable = new PdfPTable(3);
                SignatureTable.HorizontalAlignment = 0;
                SignatureTable.SpacingBefore = 10;
                SignatureTable.SpacingAfter = 10;
                SignatureTable.SetWidths(new int[] { 6, 6, 6 });
                SignatureTable.WidthPercentage = 100;
                SignatureTable.DefaultCell.Border = Rectangle.BOX;

                SignatureTable.AddCell(CreateLeftAlignedCell("Prepared By:", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Checked By: ", TableHeaderFont, 1));
                SignatureTable.AddCell(CreateLeftAlignedCell("Approved By:", TableHeaderFont, 1));

                PdfPCell cell1 = new PdfPCell(new Phrase(StockTransfers.First().MstUser.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell2 = new PdfPCell(new Phrase(StockTransfers.First().MstUser1.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };
                PdfPCell cell3 = new PdfPCell(new Phrase(StockTransfers.First().MstUser2.FullName, BodyFont)) { HorizontalAlignment = PdfPCell.ALIGN_CENTER, VerticalAlignment = PdfPCell.ALIGN_BOTTOM };

                cell1.FixedHeight = 50f;
                cell2.FixedHeight = 50f;
                cell3.FixedHeight = 50f;

                SignatureTable.AddCell(cell1);
                SignatureTable.AddCell(cell2);
                SignatureTable.AddCell(cell3);

                doc.Add(SignatureTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ====================
        // Statement of Account
        // ====================

        private MemoryStream StatementOfAccount(Int64 Id, DateTime AsOfDate)
        {
            var doc = new Document(PageSize.LETTER, 50, 50, 25, 25);
            var stream = new MemoryStream();

            try
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font SubTitleFont = new Font(BaseFontTimesRoman, 14, Font.BOLD);
                Font TableHeaderFont = new Font(BaseFontTimesRoman, 10, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                PdfWriter writer = PdfWriter.GetInstance(doc, stream);

                writer.PageEvent = new PDFHeaderFooter("Statement of Account");

                var SalesInvoices = from d in db.TrnSalesInvoices where d.IsLocked == true select d;

                doc.Open();

                doc.Add(new Paragraph(SalesInvoices.First().MstBranch.MstCompany.Company + "\\" + SalesInvoices.First().MstBranch.Branch, TableHeaderFont));
                doc.Add(new Paragraph(SalesInvoices.First().MstBranch.MstCompany.Address, BodyFont));
                doc.Add(new Paragraph(SalesInvoices.First().MstBranch.MstCompany.ContactNumber, BodyFont));

                var HeaderTable = new PdfPTable(2);
                HeaderTable.HorizontalAlignment = 0;
                HeaderTable.SpacingBefore = 20;
                HeaderTable.SpacingAfter = 10;
                HeaderTable.DefaultCell.Border = 0;
                HeaderTable.SetWidths(new int[] { 2, 6 });

                doc.Add(HeaderTable);

                doc.Close();
            }
            catch { }

            byte[] file = stream.ToArray();
            MemoryStream output = new MemoryStream();
            output.Write(file, 0, file.Length);
            output.Position = 0;

            return output;
        }

        // ========================
        // PDF REport Header/Footer
        // ========================
        
        public class PDFHeaderFooter : PdfPageEventHelper
        {
            public string DocumentTitle;
            public PDFHeaderFooter(string DocumentTitle)
            {
                this.DocumentTitle = DocumentTitle;
            }
            // write on top of document
            public override void OnOpenDocument(PdfWriter writer, Document document)
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font TitleFont = new Font(BaseFontTimesRoman, 18, Font.BOLD);
                Font BodyFont = new Font(BaseFontTimesRoman, 10, Font.NORMAL);

                base.OnOpenDocument(writer, document);

                document.Add(new Paragraph(DocumentTitle, TitleFont));

                Image image = Image.GetInstance(HttpContext.Current.Server.MapPath("/Images/logo/innosoft_logo.jpg"));
                image.ScaleToFit(140f, 58f);
                image.SetAbsolutePosition(430, 710);
                document.Add(image);

                PdfContentByte cb = writer.DirectContent;

                cb.MoveTo(0, 690);
                cb.LineTo(document.PageSize.Width, 690);
                cb.Stroke();
            }

            // write on start of each page
            public override void OnStartPage(PdfWriter writer, Document document)
            {
                base.OnStartPage(writer, document);
            }

            // write on end of each page
            public override void OnEndPage(PdfWriter writer, Document document)
            {
                BaseFont BaseFontTimesRoman = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
                Font EndingMessageFont = new Font(BaseFontTimesRoman, 10, Font.ITALIC);

                base.OnEndPage(writer, document);

                PdfPTable FooterTable = new PdfPTable(1);
                FooterTable.TotalWidth = 200f;
                FooterTable.LockedWidth = true;

                PdfPCell PageCell = new PdfPCell(new Phrase("Page " + writer.PageNumber.ToString(), EndingMessageFont));
                PageCell.Border = 0;

                FooterTable.AddCell(PageCell);

                FooterTable.WriteSelectedRows(0, -1, 500, 40, writer.DirectContent);

                PdfContentByte cb = writer.DirectContent;

                cb.MoveTo(0, 50);
                cb.LineTo(document.PageSize.Width, 50);
                cb.Stroke();
            }

            //write on close of document
            public override void OnCloseDocument(PdfWriter writer, Document document)
            {
                base.OnCloseDocument(writer, document);
            }
        }             
    }
}