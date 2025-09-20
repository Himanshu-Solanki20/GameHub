using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

namespace myprj
{
    public partial class TypingSpeed : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if a user is logged in
            if (Session["username"] == null)
            {
                // If not logged in, redirect to the login page
                Response.Redirect("Login.aspx");
            }
            else
            {
                // If logged in, display the username in the header
                lblUsername.Text = HttpContext.Current.Session["username"].ToString();
            }
        }

        [WebMethod]
        public static void SaveScore(int score)
        {
            // Get username from session. If session is null, redirecting will already be handled on Page_Load.
            // This is a safety fallback.
            string username = HttpContext.Current.Session["username"]?.ToString();
            if (string.IsNullOrEmpty(username))
            {
                // This scenario should not be hit due to the Page_Load check.
                // You could throw an error or handle it as needed.
                return;
            }

            int wpm = score;          // Words per minute
            int timePlayed = 60;      // Store as seconds instead of "60s"

            string cs = ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                // Adjusting the SQL command to match your table schema
                string sql = @"INSERT INTO GameHistory (Username, GameName, Score, ExtraInfo, PlayedOn)
                               VALUES (@u, @g, @s, @t, GETDATE());";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@u", SqlDbType.NVarChar, 100).Value = username;
                    cmd.Parameters.Add("@g", SqlDbType.NVarChar, 50).Value = "Typing Speed";
                    cmd.Parameters.Add("@s", SqlDbType.Int).Value = wpm;       // WPM stored in Score
                    cmd.Parameters.Add("@t", SqlDbType.NVarChar, 100).Value = timePlayed + "s"; // Store time as "60s" or "60 seconds" if you prefer

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}