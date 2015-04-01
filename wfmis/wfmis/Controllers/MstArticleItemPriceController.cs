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

        private SysSecurity secure = new SysSecurity();

        // ===================================
        // GET api/MstArticleItemPrice/5/Price
        // ===================================

        [HttpGet]
        [ActionName("Price")]
        public Models.MstArticleItemPrice Get(Int64 Id)
        {
            var ItemPrices = (from d in data.MstArticleItemPrices
                              where d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                    d.MstArticle.MstArticleType.ArticleType == "Item" &&
                                    d.Id == Id
                              select new Models.MstArticleItemPrice
                              {
                                Id = d.Id,
                                ArticleId = d.MstArticle.Id,
                                PriceDescription = d.PriceDescription,
                                Price = d.Price
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
                               where d.Id==value.ArticleId && 
                                     d.MstUser.Id==secure.GetCurrentUser()
                               select d;

                if (Articles.Any()) {
                    // MstArticleItemPrice->ArticleId
                    NewMstArticleItemPrice.ArticleId = value.ArticleId;
                    // MstArticleItemPrice->PriceDescription
                    NewMstArticleItemPrice.PriceDescription = value.PriceDescription == null ? "" : value.PriceDescription;
                    // MstArticleItemPrice->Price
                    NewMstArticleItemPrice.Price = value.Price;
                    // Save
                    data.MstArticleItemPrices.InsertOnSubmit(NewMstArticleItemPrice);
                    data.SubmitChanges();
                    return Get(data.MstArticleItemPrices.Where(d => d.ArticleId == value.ArticleId).First().Id);
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
        public HttpResponseMessage Put(Int64 id, Models.MstArticleItemPrice value)
        {
            try
            {
                var ArticleItemPrice = from d in data.MstArticleItemPrices
                                       where d.Id == id &&
                                             d.MstArticle.MstUser.Id == secure.GetCurrentUser()
                                       select d;

                if (ArticleItemPrice.Any())
                {
                    var UpdatedArticleItemPrice = ArticleItemPrice.FirstOrDefault();

                    UpdatedArticleItemPrice.PriceDescription = value.PriceDescription == null ? "NA" : value.PriceDescription;
                    UpdatedArticleItemPrice.Price = value.Price == null ? 0: value.Price;

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
            var returnVariable = true;

            Data.MstArticleItemPrice DeleteArticleItemPrice = data.MstArticleItemPrices.Where(d => d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                                                                                   d.Id == Id).First();

            if (DeleteArticleItemPrice != null)
            {
                data.MstArticleItemPrices.DeleteOnSubmit(DeleteArticleItemPrice);
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