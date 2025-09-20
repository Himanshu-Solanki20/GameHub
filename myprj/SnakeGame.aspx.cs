using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;

namespace myprj
{
    public partial class SnakeGame : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Require login
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else if (!IsPostBack)
            {
                string fullEmail = Session["Username"].ToString();

                // Take only the part before '@'
                string displayName = fullEmail.Split('@')[0];

                // Capitalize first letter
                if (!string.IsNullOrEmpty(displayName))
                {
                    displayName = char.ToUpper(displayName[0]) + displayName.Substring(1);
                }

                lblWelcome.Text = "Welcome, " + displayName + "!";
            }
        }

        /// <summary>
        /// Saves the final score into GameHistory.
        /// Uses EnableSession=true so we can read Session in a static WebMethod.
        /// </summary>
        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static void SaveScore(int score)
        {
            if (HttpContext.Current == null || HttpContext.Current.Session == null || HttpContext.Current.Session["Username"] == null)
            {
                throw new Exception("User session not found. Please log in.");
            }

            string username = HttpContext.Current.Session["Username"].ToString();
            string gameName = "Snake";
            string winner = username; // Snake is single-player
            int moves = score; // optional: treat score as "moves"
            string extraInfo = "Snake game completed";

            string cs = ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString;

            const string sql = @"
                INSERT INTO GameHistory (Username, GameName, Winner, Moves, Score, ExtraInfo)
                VALUES (@Username, @GameName, @Winner, @Moves, @Score, @ExtraInfo);";

            try
            {
                using (var con = new SqlConnection(cs))
                using (var cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@GameName", gameName);
                    cmd.Parameters.AddWithValue("@Winner", winner);
                    cmd.Parameters.AddWithValue("@Moves", moves);
                    cmd.Parameters.AddWithValue("@Score", score);
                    cmd.Parameters.AddWithValue("@ExtraInfo", extraInfo ?? (object)DBNull.Value);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("SaveScore error: " + ex);
                throw new Exception("Error saving score to database. " + ex.Message);
            }
        }
    }
}
