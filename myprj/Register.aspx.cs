using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace myprj
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No action needed on page load for this form
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text; // No trim on password
            string confirmPassword = txtConfirmPassword.Text;

            // --- Server-Side Validation ---
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text = "All fields are required.";
                return;
            }
            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$", RegexOptions.IgnoreCase))
            {
                lblMessage.Text = "Please enter a valid email address.";
                return;
            }
            if (password.Length < 8)
            {
                lblMessage.Text = "Password must be at least 8 characters long.";
                return;
            }
            if (password != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match.";
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();

                    // Check if username or email already exists in one query
                    string checkUserQuery = "SELECT COUNT(1) FROM Users WHERE Username = @Username OR Email = @Email";
                    using (var checkCmd = new SqlCommand(checkUserQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Username", username);
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int userExists = (int)checkCmd.ExecuteScalar();

                        if (userExists > 0)
                        {
                            lblMessage.Text = "A user with that username or email already exists.";
                            return;
                        }
                    }

                    // --- Hash the Password using BCrypt ---
                    // The work factor of 12 is a good balance of security and performance.
                    string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password, 12);

                    // Insert the new user with the HASHED password
                    string insertQuery = "INSERT INTO Users (Username, Email, PasswordHash, DateCreated) VALUES (@Username, @Email, @PasswordHash, @DateCreated)";
                    using (var insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@Username", username);
                        insertCmd.Parameters.AddWithValue("@Email", email);
                        insertCmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                        insertCmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
                        insertCmd.ExecuteNonQuery();
                    }

                    // Set success message for SweetAlert to display
                    lblSuccess.Text = "You can now log in with your new account.";
                }
                catch (Exception ex)
                {
                    // In a real app, you should log this exception (ex.ToString())
                    lblMessage.Text = "An unexpected error occurred. Please try again later.";
                }
            }
        }
    }
}