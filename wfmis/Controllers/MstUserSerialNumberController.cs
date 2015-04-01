using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace wfmis.Controllers
{
    public class MstUserSerialNumberController : ApiController
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();

        // ===========================
        // GET api/MstUserSerialNumber
        // ===========================

        public string Get()
        {
            NameValueCollection parameters = HttpUtility.ParseQueryString(Request.RequestUri.Query);

            String SerialNumber = Convert.ToString(parameters["SerialNumber"]);

            var MstUserSerialNumbers = from d in db.MstUserSerialNumbers
                                       where d.SerialNumber == SerialNumber
                                       select d;

            if (MstUserSerialNumbers.Any())
            {
                return MstUserSerialNumbers.First().LicenseCode;
            }
            else
            {
                return "NA";
            }
        }
    }
}