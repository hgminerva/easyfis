<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="wfmis.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <header id="heading">
      <div class="container text-center">
        <h1>EasyFIS</h1>
        <h4>Easy Financial Information System and ERP for everyone.</h4>
        <p><br /></p>
        <p><a href="#" class="btn btn-large btn-inverse">Product Features</a></p>
        <p><br /></p>
        <p>
            <button class="btn btn-primary"><i class="icon-large icon-facebook"></i> | Like us in Facebook</button>
            <button class="btn btn-info"><i class="icon-large icon-twitter"></i> | Follow us inTwitter</button>
        </p>
      </div>
    </header>

    <div id="main-content">
      <div class="container">
         <div class="row">
           <div class="span4">
             <h2>Learn</h2>
             <p>Learn more about EasyFIS.</p>
             <p class="text-center"><a class="btn" href="index.html">Learn</a></p>
           </div>
   
           <div class="span4">
             <h2>Register</h2>
             <p>Register an account for <strong>FREE!</strong></p>
             <p class="text-center"><a class="btn btn-primary" href="/Account/Register.aspx">Register</a></p>
           </div>
   
           <div class="span4">
             <h2>Contact Us</h2>
             <p>Contact <a href="http://innosoft.ph/">Innosoft Solutions</a></p>
             <p class="text-center"><a class="btn" href="index.html">Contact</a></p>
           </div>
        </div><!-- @end .row -->
        
        <hr />
        
        <h2>EasyFIS Screenshots</h2>

        <div class="alert alert-info">
          <strong>Note:</strong> The screenshots may differ from actual product.
        </div>
        
        <div class="row-fluid">
          <ul class="thumbnails">
            <li class="span4">
              <a href="#" class="thumbnail" target="_blank">
              <img src="Images/screenshots/screen4.png" alt="screen4" />
              </a>
            </li>
            <li class="span4">
              <a href="#" class="thumbnail" target="_blank">
              <img src="Images/screenshots/screen5.png" alt="screen5" />
              </a>
            </li>
            <li class="span4">
              <a href="#" class="thumbnail" target="_blank">
              <img src="Images/screenshots/screen3.png" alt="screen3" />
              </a>
            </li>
          </ul>
        </div><!-- @end .row-fluid -->

      </div><!-- @end .container -->

    </div><!-- @end #main-content -->

</asp:Content>