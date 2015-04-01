using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstArticleItemComponentController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // ===========================================
        // GET api/MstArticleItemComponent/5/Component
        // ===========================================

        [HttpGet]
        [ActionName("Component")]
        public Models.MstArticleItemComponent Get(Int64 Id)
        {
            var ItemComponents = (from d in data.MstArticleItemComponents
                                  where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                        d.MstArticle.MstArticleType.ArticleType == "Item" &&
                                        d.Id == Id
                                  select new Models.MstArticleItemComponent
                                  {
                                      Line3Id = d.Id,
                                      Line3ArticleId = d.MstArticle.Id,
                                      Line3ComponentArticleId = d.MstArticle1.Id,
                                      Line3ComponentArticle = d.MstArticle1.Article,
                                      Line3UnitId = d.UnitId,
                                      Line3Unit = d.MstUnit.Unit,
                                      Line3Quantity = d.Quantity
                                  });

            if (ItemComponents.Any())
            {
                return ItemComponents.First();
            }
            else
            {
                return new Models.MstArticleItemComponent();
            }
        }

        // ===============================================================
        // GET api/MstArticleItemComponent/5/ItemDefaultComponentByArticle
        // ===============================================================

        [HttpGet]
        [ActionName("ItemDefaultComponentByArticle")]
        public Models.MstArticleItemComponent ItemDefaultComponentByArticle(Int64 Id)
        {
            var ItemComponents = (from d in data.MstArticleItemComponents
                                  where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                        d.MstArticle.MstArticleType.ArticleType == "Item" &&
                                        d.ArticleId == Id
                                  select new Models.MstArticleItemComponent
                                  {
                                      Line3Id = d.Id,
                                      Line3ArticleId = d.MstArticle.Id,
                                      Line3ComponentArticleId = d.MstArticle1.Id,
                                      Line3ComponentArticle = d.MstArticle1.Article,
                                      Line3UnitId = d.UnitId,
                                      Line3Unit = d.MstUnit.Unit,
                                      Line3Quantity = d.Quantity
                                  });

            if (ItemComponents.Any())
            {
                return ItemComponents.First();
            }
            else
            {
                return new Models.MstArticleItemComponent();
            }
        }

        // ================================
        // POST api/MstArticleItemComponent
        // ================================

        [HttpPost]
        public Models.MstArticleItemComponent Post(Models.MstArticleItemComponent value)
        {
            try
            {
                Data.MstArticleItemComponent NewMstArticleItemComponent = new Data.MstArticleItemComponent();

                var Articles = from d in data.MstArticles
                               where d.Id == value.Line3ArticleId &&
                                     d.UserId == secure.GetCurrentSubscriberUser()
                               select d;

                if (Articles.Any())
                {

                    NewMstArticleItemComponent.ArticleId = value.Line3ArticleId;
                    NewMstArticleItemComponent.ComponentArticleId = value.Line3ComponentArticleId;
                    NewMstArticleItemComponent.UnitId = value.Line3UnitId;
                    NewMstArticleItemComponent.Quantity = value.Line3Quantity;

                    data.MstArticleItemComponents.InsertOnSubmit(NewMstArticleItemComponent);
                    data.SubmitChanges();

                    return Get(NewMstArticleItemComponent.Id);
                }
                else
                {
                    return new Models.MstArticleItemComponent();
                }
            }
            catch
            {
                return new Models.MstArticleItemComponent();
            }
        }

        // =================================
        // PUT api/MstArticleItemComponent/5
        // =================================

        [HttpPut]
        public HttpResponseMessage Put(Int64 Id, Models.MstArticleItemComponent value)
        {
            try
            {
                var ArticleItemComponent = from d in data.MstArticleItemComponents
                                           where d.Id == Id &&
                                                 d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                                           select d;

                if (ArticleItemComponent.Any())
                {
                    var UpdatedArticleItemComponent = ArticleItemComponent.FirstOrDefault();

                    UpdatedArticleItemComponent.ComponentArticleId = value.Line3ComponentArticleId;
                    UpdatedArticleItemComponent.UnitId = value.Line3UnitId;
                    UpdatedArticleItemComponent.Quantity = value.Line3Quantity;

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

        // ====================================
        // DELETE api/MstArticleItemComponent/5
        // ====================================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstArticleItemComponent DeleteArticleItemComponent = data.MstArticleItemComponents.Where(d => d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                                                                                          d.Id == Id).First();
            if (DeleteArticleItemComponent != null)
            {
                data.MstArticleItemComponents.DeleteOnSubmit(DeleteArticleItemComponent);
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