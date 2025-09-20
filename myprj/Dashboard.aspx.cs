using System;

namespace myprj
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                string fullEmail = Session["Username"].ToString();

                // Take only the part before '@'
                string displayName = fullEmail.Split('@')[0];

                // Replace underscores and dots with spaces
                displayName = displayName.Replace("_", " ").Replace(".", " ");

                // Capitalize first letter if not empty
                if (!string.IsNullOrEmpty(displayName))
                {
                    displayName = char.ToUpper(displayName[0]) + displayName.Substring(1);
                }

                lblUser.Text = displayName;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
