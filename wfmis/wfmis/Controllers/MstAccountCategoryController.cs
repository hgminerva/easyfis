using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstAccountCategoryController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private SysSecurity secure = new SysSecurity();

        // GET api/<controller>
        [HttpGet]
        public List<Models.MstAccountCategory> Get()
        {
            var AccountCategory = from d in data.MstAccountCategories
                                  where d.MstUser.Id == secure.GetCurrentUser()
                                  select new Models.MstAccountCategory {
                                      Id = d.Id,
                                      AccountCategoryCode = d.AccountCategoryCode,
                                      AccountCategory = d.AccountCategory
                                  };

            return AccountCategory.ToList();
        }

        // GET api/<controller>/5
        public string Get(Int64 id)
        {
            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody]string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(Int64 id, [FromBody]string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(Int64 id)
        {
        }
    }
}