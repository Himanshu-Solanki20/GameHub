using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI; // Required for Page

namespace myprj
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Add logic for "Remember Me" cookie on page load
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connectionString = ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString;
            string userHash = null;
            int userId = 0;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // IMPORTANT: Select the PasswordHash, not the plain password!
                // Also select the UserID to store in the session.
                string query = "SELECT UserID, PasswordHash FROM Users WHERE Username = @Username";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);

                try
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            userId = Convert.ToInt32(reader["UserID"]);
                            userHash = reader["PasswordHash"].ToString();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Log the exception (ex.ToString()) to a file or logging service
                    lblMessage.Text = "An error occurred. Please try again later.";
                    return; // Stop execution
                }
            }

            // Verify the password using BCrypt
            if (userHash != null && BCrypt.Net.BCrypt.Verify(password, userHash))
            {
                // Passwords match - Login Successful
                Session["UserID"] = userId; // Store UserID, it's safer than username
                Session["Username"] = username;

                // Handle "Remember Me" functionality with a cookie if needed

                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                // Passwords do not match or user not found
                lblMessage.Text = "Invalid username or password.";
            }
        }
    }
}