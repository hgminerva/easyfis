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

        private SysSecurity secure = new SysSecurity();

        // =================================
        // GET api/MstArticleItemUnit/5/Unit
        // =================================

        [HttpGet]
        [ActionName("Unit")]
        public Models.MstArticleItemUnit Get(Int64 Id)
        {
            var ItemUnits = (from d in data.MstArticleItemUnits
                              where d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                    d.Id == Id
                             select new Models.MstArticleItemUnit
                              {
                                  Id = d.Id,
                                  ArticleId = d.MstArticle.Id,
                                  UnitId = d.UnitId,
                                  Unit = d.MstUnit.Unit,
                                  Multiplier = d.Multiplier
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
                               where d.Id == value.ArticleId &&
                                     d.MstUser.Id == secure.GetCurrentUser()
                               select d;

                if (Articles.Any())
                {
                    // MstArticleItemUnit->ArticleId
                    NewMstArticleItemUnit.ArticleId = value.ArticleId;
                    // MstArticleItemUnit->UnitId
                    NewMstArticleItemUnit.UnitId = value.UnitId;
                    // MstArticleItemUnit->Multiplier
                    NewMstArticleItemUnit.Multiplier = value.Multiplier == null ? 1 : value.Multiplier;
                    // Save
                    data.MstArticleItemUnits.InsertOnSubmit(NewMstArticleItemUnit);
                    data.SubmitChanges();
                    return Get(data.MstArticleItemUnits.Where(d => d.ArticleId == value.ArticleId).First().Id);
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
                                            d.MstArticle.MstUser.Id == secure.GetCurrentUser()
                                      select d;

                if (ArticleItemUnit.Any())
                {
                    var UpdatedArticleItemUnit = ArticleItemUnit.FirstOrDefault();

                    UpdatedArticleItemUnit.UnitId = value.UnitId;
                    UpdatedArticleItemUnit.Multiplier = value.Multiplier == null ? 1 : value.Multiplier;

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
            var returnVariable = true;

            Data.MstArticleItemUnit DeleteArticleItemUnit = data.MstArticleItemUnits.Where(d => d.MstArticle.MstUser.Id == secure.GetCurrentUser() &&
                                                                                                d.Id == Id).First();

            if (DeleteArticleItemUnit != null)
            {
                data.MstArticleItemUnits.DeleteOnSubmit(DeleteArticleItemUnit);
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