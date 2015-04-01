using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstArticleItemUnitController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private Business.Security secure = new Business.Security();

        // =================================
        // GET api/MstArticleItemUnit/5/Unit
        // =================================

        [HttpGet]
        [ActionName("Unit")]
        public Models.MstArticleItemUnit Get(Int64 Id)
        {
            var ItemUnits = (from d in data.MstArticleItemUnits
                             where d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                   d.Id == Id
                             select new Models.MstArticleItemUnit
                             {
                                  Line2Id = d.Id,
                                  Line2ArticleId = d.MstArticle.Id,
                                  Line2UnitId = d.UnitId,
                                  Line2Unit = d.MstUnit.Unit,
                                  Line2Multiplier = d.Multiplier
                             });

            if (ItemUnits.Any())
            {
                return ItemUnits.First();
            }
            else
            {
                return new Models.MstArticleItemUnit();
            }
        }

        // ===========================
        // POST api/MstArticleItemUnit
        // ===========================

        [HttpPost]
        public Models.MstArticleItemUnit Post(Models.MstArticleItemUnit value)
        {
            try
            {
                Data.MstArticleItemUnit NewMstArticleItemUnit = new Data.MstArticleItemUnit();

                var Articles = from d in data.MstArticles
                               where d.Id == value.Line2ArticleId &&
                                     d.MstUser.Id == secure.GetCurrentSubscriberUser()
                               select d;

                if (Articles.Any())
                {

                    NewMstArticleItemUnit.ArticleId = value.Line2ArticleId;
                    NewMstArticleItemUnit.UnitId = value.Line2UnitId;
                    NewMstArticleItemUnit.Multiplier = value.Line2Multiplier;

                    data.MstArticleItemUnits.InsertOnSubmit(NewMstArticleItemUnit);
                    data.SubmitChanges();

                    return Get(NewMstArticleItemUnit.Id);
                }
                else
                {
                    return new Models.MstArticleItemUnit();
                }
            }
            catch
            {
                return new Models.MstArticleItemUnit();
            }
        }

        // ============================
        // PUT api/MstArticleItemUnit/5
        // ============================

        [HttpPut]
        public HttpResponseMessage Put(Int64 id, Models.MstArticleItemUnit value)
        {
            try
            {
                var ArticleItemUnit = from d in data.MstArticleItemUnits
                                      where d.Id == id &&
                                            d.MstArticle.UserId == secure.GetCurrentSubscriberUser()
                                      select d;

                if (ArticleItemUnit.Any())
                {
                    var UpdatedArticleItemUnit = ArticleItemUnit.FirstOrDefault();

                    UpdatedArticleItemUnit.UnitId = value.Line2UnitId;
                    UpdatedArticleItemUnit.Multiplier = value.Line2Multiplier == null ? 1 : value.Line2Multiplier;

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

        // ===============================
        // DELETE api/MstArticleItemUnit/5
        // ===============================

        [HttpDelete]
        public Boolean Delete(Int64 Id)
        {
            Data.MstArticleItemUnit DeleteArticleItemUnit = data.MstArticleItemUnits.Where(d => d.MstArticle.UserId == secure.GetCurrentSubscriberUser() &&
                                                                                                d.Id == Id).First();

            if (DeleteArticleItemUnit != null)
            {
                data.MstArticleItemUnits.DeleteOnSubmit(DeleteArticleItemUnit);
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