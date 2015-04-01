using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstAccountController : ApiController
    {
        private Data.wfmisDataContext data = new Data.wfmisDataContext();
        private SysSecurity secure = new SysSecurity();

        // GET api/MstAcccount
        public List<Models.MstAccount> Get()
        {
            var Accounts = from d in data.MstAccounts
                           where d.MstUser.Id == secure.GetCurrentUser()
                           select new Models.MstAccount
                            {
                                Id = d.Id,
                                AccountCode = d.AccountCode,
                                Account = d.Account,
                                AccountType = d.MstAccountType.AccountType
                            };

            return Accounts.ToList();
        }

        // GET api/MstAccount/5
        public Models.MstAccount Get(Int64 id)
        {
            var Accounts = (from a in data.MstAccounts
                            where a.Id == id && a.MstUser.Id == secure.GetCurrentUser()
                            select new Models.MstAccount
                            {
                                Id = a.Id,
                                AccountCode = a.AccountCode,
                                Account = a.Account,
                                AccountType = a.MstAccountType.AccountType
                            });

            if (Accounts == null)
            {
                throw new HttpResponseException(new HttpResponseMessage(HttpStatusCode.NotFound));
            }

            return Accounts.First();
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