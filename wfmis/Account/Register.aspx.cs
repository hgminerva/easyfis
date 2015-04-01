using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Membership.OpenAuth;

namespace wfmis.Account
{
    public partial class Register : Page
    {
        private Data.wfmisDataContext db = new Data.wfmisDataContext();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.Session["CaptchaImageText"] = GenerateRandomCode();
            } 

            RegisterUser.ContinueDestinationPageUrl = Request.QueryString["ReturnUrl"];
        }
        private string GenerateRandomCode()
        {
            Random random = new Random((int)DateTime.Now.Ticks);
            string Alphabet = "abcdefghijklmnopqrstuvwyxzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            char[] chars = new char[6];
            for (int i=0; i < 6; i++)
            {
                chars[i] = Alphabet[random.Next(Alphabet.Length)];
            }
            return new string(chars);
        }
        protected void RegisterUser_CreatingUser(object sender, LoginCancelEventArgs e)
        {
            CreateUserWizardStep step = (CreateUserWizardStep)RegisterUser.FindControl("RegisterUserWizardStep"); 
            TextBox CodeNumberTextBox = (TextBox)step.ContentTemplateContainer.FindControl("CodeNumberTextBox");
            Label CustomErrorMessage = (Label)step.ContentTemplateContainer.FindControl("CustomErrorMessage");

            if (CodeNumberTextBox.Text != this.Session["CaptchaImageText"].ToString())
            {
                CodeNumberTextBox.Text = "";
                this.Session["CaptchaImageText"] = GenerateRandomCode();

                CustomErrorMessage.Text = "Invalid code!";
                e.Cancel = true;
            }
        }
        protected void RegisterUser_CreatedUser(object sender, EventArgs e)
        {
            // Cookie
            FormsAuthentication.SetAuthCookie(RegisterUser.UserName, createPersistentCookie: false);

            // Save to MstUser
            Data.MstUser NewUser = new Data.MstUser();

            var Users = from u in db.Users where u.UserName==RegisterUser.UserName select u;

            if (Users.Any()) {
                NewUser.MembershipUserId = Users.First().UserId;
                var UserAccountNumber = Convert.ToDouble(db.MstUsers.Max(n => n.UserAccountNumber)) + 10000000001;
                NewUser.UserAccountNumber = UserAccountNumber.ToString().Trim().Substring(1);
                NewUser.FullName = "na";
                NewUser.Address = "na";
                NewUser.ContactNumber = "na";
                NewUser.EmailAddress = "na";
                NewUser.IsTemplate = false;
                NewUser.Particulars = "na";
                NewUser.IsAutoInventory = false;
                NewUser.InventoryValuationMethod = "SPECIFIC";
                NewUser.IsLocked = true;

                db.MstUsers.InsertOnSubmit(NewUser);
                db.SubmitChanges();
            }

            Response.Redirect("~/");

            //Redirect
            //string continueUrl = RegisterUser.ContinueDestinationPageUrl;
            //if (!OpenAuth.IsLocalUrl(continueUrl))
            //{
            //    continueUrl = "~/";
            //}
            //Response.Redirect(continueUrl);
            
        }
    }
}