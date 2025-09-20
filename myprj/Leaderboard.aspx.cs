using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myprj
{
    public partial class Leaderboard : Page
    {
        private readonly string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateGameFilter();
                LoadLeaderboard();
            }
        }

        private void PopulateGameFilter()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Query to get a distinct list of games that have been played
                string query = "SELECT DISTINCT GameName FROM GameHistory ORDER BY GameName ASC";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlGameFilter.DataSource = dt;
                ddlGameFilter.DataTextField = "GameName";
                ddlGameFilter.DataValueField = "GameName";
                ddlGameFilter.DataBind();

                // Add an item to show all games
                ddlGameFilter.Items.Insert(0, new ListItem("All Games", "All"));
            }
        }

        private void LoadLeaderboard()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Base query with ranking. We order by Score descending to get the highest scores first.
                string query = @"
                    SELECT 
                        ROW_NUMBER() OVER (ORDER BY Score DESC) as Rank,
                        Username, 
                        GameName, 
                        Score, 
                        Moves, 
                        Winner, 
                        ExtraInfo, 
                        PlayedOn 
                    FROM GameHistory";

                // Apply filter if a specific game is selected
                string selectedGame = ddlGameFilter.SelectedValue;
                if (selectedGame != "All" && !string.IsNullOrEmpty(selectedGame))
                {
                    query += " WHERE GameName = @GameName";
                }

                query += " ORDER BY Score DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);

                // Add parameter for the game name to prevent SQL injection
                if (selectedGame != "All" && !string.IsNullOrEmpty(selectedGame))
                {
                    da.SelectCommand.Parameters.AddWithValue("@GameName", selectedGame);
                }

                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    pnlNoResults.Visible = false;

                    // Take the top 3 players for the special display cards
                    var topPlayersQuery = dt.AsEnumerable().Take(3);
                    if (topPlayersQuery.Any())
                    {
                        rptTopPlayers.DataSource = topPlayersQuery.CopyToDataTable();
                        rptTopPlayers.DataBind();
                    }

                    // Skip the top 3 players for the main list and take the next 17 (for a total of 20)
                    var remainingPlayersQuery = dt.AsEnumerable().Skip(3).Take(17);
                    if (remainingPlayersQuery.Any())
                    {
                        rptLeaderboard.DataSource = remainingPlayersQuery.CopyToDataTable();
                        rptLeaderboard.DataBind();
                    }
                    else
                    {
                        // If there are 3 or fewer players, there will be no remaining players.
                        rptLeaderboard.DataSource = null;
                        rptLeaderboard.DataBind();
                    }
                }
                else
                {
                    // If no data, hide the repeaters and show a message
                    pnlNoResults.Visible = true;
                    rptTopPlayers.DataSource = null;
                    rptTopPlayers.DataBind();
                    rptLeaderboard.DataSource = null;
                    rptLeaderboard.DataBind();
                }
            }
        }

        protected void ddlGameFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Reload the leaderboard data when the filter changes
            LoadLeaderboard();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }
    }
}
