using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class TrnCollectionController : ApiController
    {

        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private SysSecurity secure = new SysSecurity();

        // GET api/TrnCollection
        [HttpGet]
        public List<Models.TrnCollection> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var Collections = from d in data.TrnCollections
                                  where d.MstBranch.Id == BranchId &&
                                        d.MstBranch.MstUser.Id == secure.GetCurrentUser()
                                  select new Models.TrnCollection
                                  {
                                      Id = d.Id
                                  };

            return Collections.ToList();
        }
    }
}