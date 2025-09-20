using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myprj
{
    public partial class TicTacToe : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Username"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                if (Session["ScoreX"] == null) Session["ScoreX"] = 0;
                if (Session["ScoreO"] == null) Session["ScoreO"] = 0;

                lblWelcome.Text = "👋 Welcome, " + Session["Username"].ToString();

                InitializeGame();
            }
        }

        private void InitializeGame()
        {
            Session["Player"] = "X";
            Session["MoveCount"] = 0;

            foreach (Control c in form1.Controls)
            {
                if (c is Button btn && btn.ID.StartsWith("btn") && btn.ID != "btnRestart")
                {
                    btn.Text = "";
                    btn.Enabled = true;
                    // Reset CSS class to the base class
                    btn.CssClass = "btn-tile";
                }
            }

            lblStatus.Text = "Player X's turn";
            lblStatus.CssClass = "status-text player-x-turn";
            lblMoves.Text = "Moves: 0";
            UpdateScoreDisplay();
        }

        protected void Cell_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string currentPlayer = Session["Player"].ToString();
            int moveCount = Convert.ToInt32(Session["MoveCount"]);

            if (btn.Text == "")
            {
                btn.Text = currentPlayer;
                btn.Enabled = false;
                moveCount++;
                Session["MoveCount"] = moveCount;

                // Check if a player has won
                if (CheckWin(currentPlayer, out Button[] winningButtons))
                {
                    lblStatus.Text = $"🎉 Player {currentPlayer} wins!";
                    lblStatus.CssClass = "status-text win-message";
                    DisableAllButtons();

                    foreach (var button in winningButtons)
                    {
                        button.CssClass += " winner";
                    }

                    if (currentPlayer == "X")
                        Session["ScoreX"] = Convert.ToInt32(Session["ScoreX"]) + 1;
                    else
                        Session["ScoreO"] = Convert.ToInt32(Session["ScoreO"]) + 1;

                    UpdateScoreDisplay();
                    SaveGameResult(currentPlayer, moveCount);

                }
                // Check for a draw
                else if (moveCount == 9)
                {
                    lblStatus.Text = "🤝 It's a draw!";
                    lblStatus.CssClass = "status-text draw-message";
                    DisableAllButtons();
                    SaveGameResult("Draw", moveCount);
                }
                // Continue the game
                else
                {
                    string nextPlayer = (currentPlayer == "X") ? "O" : "X";
                    Session["Player"] = nextPlayer;
                    lblStatus.Text = $"Player {nextPlayer}'s turn";
                    lblStatus.CssClass = $"status-text player-{nextPlayer.ToLower()}-turn";
                }

                lblMoves.Text = $"Moves: {moveCount}";
            }
        }

        private bool CheckWin(string player, out Button[] winningButtons)
        {
            winningButtons = null;
            Button[,] buttons = new Button[3, 3];
            for (int row = 0; row < 3; row++)
            {
                for (int col = 0; col < 3; col++)
                {
                    buttons[row, col] = (Button)form1.FindControl($"btn{row}{col}");
                }
            }

            int[][,] winningCombos = new int[][,]
            {
                new int[,] {{0,0}, {0,1}, {0,2}},
                new int[,] {{1,0}, {1,1}, {1,2}},
                new int[,] {{2,0}, {2,1}, {2,2}},
                new int[,] {{0,0}, {1,0}, {2,0}},
                new int[,] {{0,1}, {1,1}, {2,1}},
                new int[,] {{0,2}, {1,2}, {2,2}},
                new int[,] {{0,0}, {1,1}, {2,2}},
                new int[,] {{0,2}, {1,1}, {2,0}}
            };

            foreach (var combo in winningCombos)
            {
                if (buttons[combo[0, 0], combo[0, 1]].Text == player &&
                    buttons[combo[1, 0], combo[1, 1]].Text == player &&
                    buttons[combo[2, 0], combo[2, 1]].Text == player)
                {
                    winningButtons = new Button[]
                    {
                        buttons[combo[0, 0], combo[0, 1]],
                        buttons[combo[1, 0], combo[1, 1]],
                        buttons[combo[2, 0], combo[2, 1]]
                    };
                    return true;
                }
            }

            return false;
        }

        private void DisableAllButtons()
        {
            foreach (Control c in form1.Controls)
            {
                if (c is Button btn && btn.ID.StartsWith("btn") && btn.ID != "btnRestart")
                    btn.Enabled = false;
            }
        }

        private void UpdateScoreDisplay()
        {
            lblScoreX.Text = $"{Session["ScoreX"]}";
            lblScoreO.Text = $"{Session["ScoreO"]}";
        }

        protected void btnRestart_Click(object sender, EventArgs e)
        {
            InitializeGame();
        }

        private void SaveGameResult(string winner, int moves)
        {
            string username = Session["Username"]?.ToString() ?? "Guest";
            string gameName = "Tic Tac Toe";
            int score = (winner == "Draw") ? 0 : 1;
            string extraInfo = $"Session Score - X: {Session["ScoreX"]}, O: {Session["ScoreO"]}";

            string connStr = System.Configuration.ConfigurationManager
                .ConnectionStrings["GameHubDBConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                        INSERT INTO GameHistory (Username, GameName, Winner, Moves, Score, ExtraInfo)
                        VALUES (@Username, @GameName, @Winner, @Moves, @Score, @ExtraInfo)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@GameName", gameName);
                        cmd.Parameters.AddWithValue("@Winner", winner);
                        cmd.Parameters.AddWithValue("@Moves", moves);
                        cmd.Parameters.AddWithValue("@Score", score);
                        cmd.Parameters.AddWithValue("@ExtraInfo", extraInfo);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error saving game result: {ex.Message}");
            }
        }
    }
}