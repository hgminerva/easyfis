using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstAccountTypeController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private SysSecurity secure = new SysSecurity();

        // GET api/MstAccountType
        public List<Models.MstAccountType> Get()
        {
            var AccountType = from d in data.MstAccountTypes
                              where d.MstUser.Id == secure.GetCurrentUser()
                                  select new Models.MstAccountType
                                  {
                                      Id = d.Id,
                                      AccountTypeCode = d.AccountTypeCode,
                                      AccountType = d.AccountType,
                                      AccountCategory = d.MstAccountCategory.AccountCategory
                                  };

            return AccountType.ToList();
        }

        // GET api/MstAccountType/5
        public string Get(Int64 id)
        {
            return "value";
        }

        // POST api/MstAccountType
        public void Post([FromBody]string value)
        {

        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(Int64 id)
        {
        }
    }
}