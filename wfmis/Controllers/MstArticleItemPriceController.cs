using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstArticleItemPriceController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ===================================
        // GET api/MstArticleItemPrice/5/Price
        // ===================================

        [HttpGet]
        [ActionName("Price")]
        public Models.MstArticleItemPrice Get(Int64 Id)
        {
            var ItemPrices = (from d in data.MstArticleItemPrices
                              where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                    d.MstArticle.MstArticleType.ArticleType == "Item" &&
                                    d.Id == Id
                              select new Models.MstArticleItemPrice
                              {
                                Line1Id = d.Id,
                                Line1ArticleId = d.MstArticle.Id,
                                Line1PriceDescription = d.PriceDescription,
                                Line1Price = d.Price,
                                Line1MarkUpPercentage = d.MarkUpPercentage
                              });

            if (ItemPrices.Any())
            {
                return ItemPrices.First();
            }
            else
            {
                return new Models.MstArticleItemPrice();
            }
        }

        // ===================================
        // GET api/MstArticleItemPrice/5/Price
        // ===================================

        [HttpGet]
        [ActionName("ItemDefaultPriceByArticle")]
        public Models.MstArticleItemPrice ItemDefaultPriceByArticle(Int64 Id)
        {
            var ItemPrices = (from d in data.MstArticleItemPrices
                              where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                    d.MstArticle.MstArticleType.ArticleType == "Item" &&
                                    d.ArticleId == Id
                              select new Models.MstArticleItemPrice
                              {
                                  Line1Id = d.Id,
                                  Line1ArticleId = d.MstArticle.Id,
                                  Line1PriceDescription = d.PriceDescription,
                                  Line1Price = d.Price,
                                  Line1MarkUpPercentage = d.MarkUpPercentage
                              });

            if (ItemPrices.Any())
            {
                return ItemPrices.First();
            }
            else
            {
                return new Models.MstArticleItemPrice();
            }
        }

        // ============================
        // POST api/MstArticleItemPrice
        // ============================

        [HttpPost]
        public Models.MstArticleItemPrice Post(Models.MstArticleItemPrice value)
        {
            try
            {
                Data.MstArticleItemPrice NewMstArticleItemPrice = new Data.MstArticleItemPrice();

                var Articles = from d in data.MstArticles 
                               where d.Id == value.Line1ArticleId && 
                                     d.UserId == secure.GetCurrentSubscriberUser()
                               select d;

                if (Articles.Any()) {

                    NewMstArticleItemPrice.ArticleId = value.Line1ArticleId;
                    NewMstArticleItemPrice.PriceDescription = value.Line1PriceDescription == null ? "" : value.Line1PriceDescription;
                    NewMstArticleItemPrice.Price = value.Line1Price;
                    NewMstArticleItemPrice.MarkUpPercentage = value.Line1MarkUpPercentage;

                    data.MstArticleItemPrices.InsertOnSubmit(NewMstArticleItemPrice);
                    data.SubmitChanges();

                    return Get(NewMstArticleItemPrice.Id);
                } else {
                    return new Models.MstArticleItemPrice();
                }
            }
            catch
            {
                return new Models.MstArticleItemPrice();
            }
        }

        // =============================
        // PUT api/MstArticleItemPrice/5
        // =============================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstArticleItemPrice value)
        {
            try
            {
                var ArticleItemPrice = from d in data.MstArticleItemPrices
                                       where d.Id == Id &&
                                             d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                                       select d;

                if (ArticleItemPrice.Any())
                {
                    var UpdatedArticleItemPrice = ArticleItemPrice.FirstOrDefault();

                    UpdatedArticleItemPrice.PriceDescription = value.Line1PriceDescription == null ? "NA" : value.Line1PriceDescription;
                    UpdatedArticleItemPrice.Price = value.Line1Price;
                    UpdatedArticleItemPrice.MarkUpPercentage = value.Line1MarkUpPercentage;

                    data.SubmitChanges();

                    return Request.CreateResponse(HttpStatusCode.OK);
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

        // ================================
        // DELETE api/MstArticleItemPrice/5
        // ================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstArticleItemPrice DeleteArticleItemPrice = data.MstArticleItemPrices.Where(d => d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                                                                                   d.Id == Id).First();
            if (DeleteArticleItemPrice != null)
            {
                data.MstArticleItemPrices.DeleteOnSubmit(DeleteArticleItemPrice);
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