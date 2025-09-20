using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.UI;

namespace myprj
{
    public partial class CatchGame : System.Web.UI.Page
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
                // Set the username in a literal control for display on the page
                lblUsername.Text = Session["username"].ToString();
            }
        }

        [WebMethod]
        public static void SaveScore(int score, int misses, int time)
        {
            string username = HttpContext.Current.Session["username"]?.ToString();

            // Safety check: this should be handled by Page_Load, but it's good practice.
            if (string.IsNullOrEmpty(username))
            {
                // You could log an error or return a specific status code here.
                return;
            }

            string gameName = "Catch the Falling Objects";
            string extraInfo = $"Time: {time}s, Misses: {misses}";

            string cs = ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                // Note: The Moves column can store the score, and ExtraInfo can store misses/time.
                string sql = @"INSERT INTO GameHistory (Username, GameName, Score, Moves, ExtraInfo, PlayedOn)
                               VALUES (@u, @g, @s, @m, @e, GETDATE());";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.Add("@u", SqlDbType.NVarChar, 100).Value = username;
                    cmd.Parameters.Add("@g", SqlDbType.NVarChar, 50).Value = gameName;
                    cmd.Parameters.Add("@s", SqlDbType.Int).Value = score;       // WPM stored in Score
                    cmd.Parameters.Add("@m", SqlDbType.Int).Value = score;       // You can duplicate score in moves for this game
                    cmd.Parameters.Add("@e", SqlDbType.NVarChar, 100).Value = extraInfo;

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}