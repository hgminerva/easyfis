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
    public class TrnCollectionLineController : ApiController
    {

        private Data.wfmisDataContext data = new Data.wfmisDataContext();

        private SysSecurity secure = new SysSecurity();

        // GET api/TrnCollection
        [HttpGet]
        public List<Models.TrnCollectionLine> Get()
        {
            var BranchId = Convert.ToInt32(((wfmis.Global)HttpContext.Current.ApplicationInstance).CurrentBranchId);

            var CollectionLines = from d in data.TrnCollectionLines
                                  where d.TrnCollection.MstBranch.MstUser.Id == secure.GetCurrentUser()
                                  select new Models.TrnCollectionLine
                                  {
                                      Id = d.Id
                                  };

            return CollectionLines.ToList();
        }
    }
}