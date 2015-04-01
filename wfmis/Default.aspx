<%@ Page Title="" Language="C#" MasterPageFile="~/Bootstrap.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="wfmis.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">

    <header id="heading">
        <div class="container">
            <div class="fullwidthbanner-container slider-main">
                <div class="fullwidthabnner">
                    <ul id="revolutionul" style="display:none;">   
	                    <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen1.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>                        
                            <div class="caption lft slide_title"
                                 data-x="100"
                                 data-y="50"
                                 data-speed="400"
                                 data-start="1500"
                                 data-easing="easeOutExpo">
                                <h4 class="is-prod-description"><img src="Images/eflogo.png" alt="eflogo"/></h4>
                                <p class="is-prod-description">
                                    Easy cloud accounting. 
                                </p>
                            </div>
                            <div class="caption lft start"
                                 data-x="650"
                                 data-y="50"
                                 data-speed="400"
                                 data-start="2000"
                                 data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image4.png" alt="Image 1" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen2.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">Sales</h4>
                                <p class="is-prod-description">
                                    1. Creates invoices and manages customer orders in the cloud.<br />
                                    2. Unlimited item with multiple prices and discounts.<br /> 
                                    3. Automated posting of Accounts Receivable and Inventory.<br /> 
                                    4. Automated journal entries on sales accounts.<br />
                                    5. In-line tax computation, e.g., VAT.<br /> 
                                </p>
                            </div>
                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image5.png" alt="Image 2" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen2.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">Purchases</h4>
                                <p class="is-prod-description">
                                    1. Creates purchase orders to suppliers in the cloud.<br /> 
                                    2. Automated posting of Accounts Payable and Inventory.<br /> 
                                    3. Automated posting of Inventory Cost.<br /> 
                                    4. In-line tax computation and discounts.<br /> 
                                    5. Recording of expenses and other disbursements.<br /> 
                                </p>
                            </div>
                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image12.png" alt="Image 2" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen2.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">Branch Warehouse Inventory</h4>
                                <p class="is-prod-description">
                                    1. Unlimited Inventory Branches/Warehouses.<br /> 
                                    2. Automated Stock-in upon purchase.<br /> 
                                    3. Automated Stock-out upon sales.<br /> 
                                    4. Transfers stocks from one warehouse to another.<br /> 
                                    5. Multiple units with unit conversions.<br />
                                    6. Item components for non-inventory items.<br />
                                </p>
                            </div>
                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image7.png" alt="Image 7" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen2.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">Bank Reconciliation</h4>
                                <p class="is-prod-description">
                                    1. Unlimited bank accounts.<br /> 
                                    2. Automated posting of deposit and withdrawal.<br /> 
                                    3. Perform check clearing operations.<br /> 
                                    4. Extensive book balance adjustment via journal voucher.<br />
                                    5. Real-time bank reconciliation report.<br /> 
                                </p>
                            </div>
                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image8.png" alt="Image 8" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen2.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">Financials</h4>
                                <p class="is-prod-description">
                                    1. Real-time Balance Sheet and Income Statement Reports.<br /> 
                                    2. Drill down reports upto transaction level.<br /> 
                                    3. Segregated books of accounts, e.g., sales, purchases, etc.<br />
                                    4. Unlimited subsidiary accounts.<br />
                                </p>
                            </div>
                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image14.png" alt="Image 14" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen2.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">User Security</h4>
                                <p class="is-prod-description">
                                    1. Unlimited user registration.<br /> 
                                    2. Activity-level security per transaction.<br /> 
                                    3. User transaction tagging on creation and updating.<br /> 
                                    4. Extensive audit trail.<br /> 
                                </p>
                            </div>
                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image15.png" alt="Image 15" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen3.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">Partners</h4>
                                <p class="is-prod-description">
                                    EasyFIS was developed by Innosoft Solutions under Microsoft <br />
                                    Bizspark program.  The entire solution is hosted in Windows<br />
                                    Azure.
                                </p>
                            </div>

                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image13.png" alt="Image 9" />
                            </div>
                        </li>
                        <li data-transition="fade" data-slotamount="8" data-masterspeed="700" data-delay="9400" data-thumb="Images/screenshots/screen3.png">
                            <%--<img src="/Images/revolution/bg10.jpg" alt="" />--%>
                            <div class="caption lft slide_title"
                                    data-x="100"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="1500"
                                    data-easing="easeOutExpo">
                                <h4 class="is-prod-description">What are you waiting for?</h4>
                                <p class="is-prod-description">
                                    Contact us now for a demo. +63 32 2663773 <br />
                                </p>
                            </div>

                            <div class="caption lft start"
                                    data-x="650"
                                    data-y="50"
                                    data-speed="400"
                                    data-start="2000"
                                    data-easing="easeOutBack">
                                <img src="Images/revolution/slides/image16.png" alt="Image 16" />
                            </div>
                        </li>
                    </ul>
  	                <div class="tp-bannertimer tp-bottom"></div>
                </div>
            </div>  
        </div>
    </header>

    <div id="main-content">

        <div class="container">

            <h2>Welcome!</h2>

            <div class="row">
                <div class="span8">
                    <p>The easiest way to manage your sales, purchases, disbursements, collections, warehouse inventories and financials in the cloud using any device.</p>
                    <p>EasyFIS.com is a multi-tenant cloud-based Software-as-a-Service (SaaS) business app that caters to micro, small and medium trading businesses.</p>  
                </div>
                <div class="span4">
                    <div><p><a class="btn btn-primary" href="/Account/Register.aspx">Register</a> an account for <strong>FREE!</strong></p></div>
                    <div class="alert alert-info">
                        <p><b>News:</b></p>
                        <p>We are still on testing phase.  For inquiries you can call directly Innosoft @ +63 32 2663773</p>
                        <p><a href="http://www.innosoft.ph">www.innosoft.ph</a></p>
                    </div>
                </div>
            </div>
       
                           
            <br />

        </div>

    </div>

</asp:Content>