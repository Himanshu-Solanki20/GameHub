using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

namespace myprj
{
    public partial class MemoryMatch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            lblWelcome.Text = "Welcome, " + Session["Username"].ToString();
        }

        [WebMethod]
        public static void SaveGameResult(int moves, string time)
        {
            // WebMethods are static, so we access Session through HttpContext
            if (HttpContext.Current.Session["Username"] == null)
            {
                // Can't save if the user is not logged in.
                // You could return an error message here if needed.
                return;
            }

            string username = HttpContext.Current.Session["Username"].ToString();
            // A lower move count is a better score
            int score = moves;
            string extraInfo = $"Time: {time}";

            string connStr = ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString; // Use your connection string name
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Note: The schema might be different. Adjust the query to your table columns.
                string query = @"INSERT INTO GameHistory 
                                 (Username, GameName, Winner, Moves, Score, ExtraInfo) 
                                 VALUES 
                                 (@Username, @GameName, @Winner, @Moves, @Score, @ExtraInfo)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@GameName", "Memory Match");
                    cmd.Parameters.AddWithValue("@Winner", username);
                    cmd.Parameters.AddWithValue("@Moves", moves);
                    cmd.Parameters.AddWithValue("@Score", score); // Storing moves as the primary score
                    cmd.Parameters.AddWithValue("@ExtraInfo", extraInfo);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}