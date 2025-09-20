using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace myprj
{
    public partial class MathQuiz : Page
    {
        private const int TimePerQuestion = 30; // seconds

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            lblWelcome.Text = "Welcome, " + Session["Username"].ToString();

            if (!IsPostBack)
            {
                StartNewQuiz();
            }
        }

        private void StartNewQuiz()
        {
            // Use Session to store quiz state for the current user
            Session["QuizScore"] = 0;
            Session["QuestionIndex"] = 0;
            Session["QuizQuestions"] = RealWorldQuestion.GenerateQuestions();
            DisplayQuestion();
        }

        private void DisplayQuestion()
        {
            var questions = Session["QuizQuestions"] as List<RealWorldQuestion>;
            int questionIndex = (int)Session["QuestionIndex"];

            if (questions != null && questionIndex < questions.Count)
            {
                RealWorldQuestion currentQuestion = questions[questionIndex];
                lblQuestion.Text = currentQuestion.QuestionText;

                // Bind options to the RadioButtonList
                rblOptions.Items.Clear();
                foreach (var option in currentQuestion.Options)
                {
                    rblOptions.Items.Add(new ListItem(option.ToString(), option.ToString()));
                }

                // Update Progress Bar and Counter
                lblQuestionProgress.Text = $"Question {questionIndex + 1} of {questions.Count}";
                double progressPercentage = (double)(questionIndex) / questions.Count * 100;
                pnlProgressBar.Style["width"] = $"{progressPercentage}%";

                StartTimer();
            }
            else
            {
                EndQuiz();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            var questions = Session["QuizQuestions"] as List<RealWorldQuestion>;
            int questionIndex = (int)Session["QuestionIndex"];
            int score = (int)Session["QuizScore"];

            if (questions != null && questionIndex < questions.Count)
            {
                // Check if an answer was selected
                if (rblOptions.SelectedIndex != -1)
                {
                    int selectedAnswer = int.Parse(rblOptions.SelectedValue);
                    if (selectedAnswer == questions[questionIndex].CorrectAnswer)
                    {
                        score++;
                        Session["QuizScore"] = score; // Update score in session
                    }
                }

                // Move to the next question
                questionIndex++;
                Session["QuestionIndex"] = questionIndex;
                DisplayQuestion();
            }
        }

        private void StartTimer()
        {
            lblTimer.Text = $"⏳ {TimePerQuestion}s";
            // Injects JavaScript to run a countdown timer on the client-side
            string script = $@"
                var timeLeft = {TimePerQuestion};
                var lbl = document.getElementById('{lblTimer.ClientID}');
                clearInterval(window.quizTimer);
                window.quizTimer = setInterval(function() {{
                    timeLeft--;
                    lbl.innerText = '⏳ ' + timeLeft + 's';
                    if (timeLeft <= 0) {{
                        clearInterval(window.quizTimer);
                        __doPostBack('{btnSubmit.UniqueID}', ''); // Auto-submit when time is up
                    }}
                }}, 1000);";
            ScriptManager.RegisterStartupScript(this, GetType(), "StartTimer", script, true);
        }

        private void EndQuiz()
        {
            // Hide quiz panel and show result panel
            pnlQuiz.Visible = false;
            pnlResult.Visible = true;

            var questions = Session["QuizQuestions"] as List<RealWorldQuestion>;
            int finalScore = (int)Session["QuizScore"];
            lblResult.Text = $"Your Score: {finalScore} / {questions.Count}";

            // Stop the JavaScript timer
            ScriptManager.RegisterStartupScript(this, GetType(), "StopTimer", "clearInterval(window.quizTimer);", true);

            SaveScoreToDatabase(finalScore, questions.Count);
        }

        private void SaveScoreToDatabase(int score, int totalQuestions)
        {
            string cs = System.Configuration.ConfigurationManager.ConnectionStrings["GameHubDBConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"INSERT INTO GameHistory 
                                 (Username, GameName, Winner, Moves, Score, ExtraInfo) 
                                 VALUES 
                                 (@Username, @GameName, @Winner, @Moves, @Score, @ExtraInfo)";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Username", Session["Username"].ToString());
                    cmd.Parameters.AddWithValue("@GameName", "Real World Math Quiz");
                    cmd.Parameters.AddWithValue("@Winner", Session["Username"].ToString()); // Assuming single player
                    cmd.Parameters.AddWithValue("@Moves", totalQuestions);
                    cmd.Parameters.AddWithValue("@Score", score);
                    cmd.Parameters.AddWithValue("@ExtraInfo", "Quiz Completed");

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }

    public class RealWorldQuestion
    {
        public string QuestionText { get; set; }
        public List<int> Options { get; set; }
        public int CorrectAnswer { get; set; }

        public static List<RealWorldQuestion> GenerateQuestions()
        {
            var rand = new Random();
            var allQuestions = new List<RealWorldQuestion>
            {
                // Original 5 Questions
                new RealWorldQuestion { QuestionText = "You buy a shirt for ₹800 after a 20% discount. What was the original price?",
                    Options = new List<int> { 960, 1000, 1040, 1200 }, CorrectAnswer = 1000 },
                new RealWorldQuestion { QuestionText = "A car travels 150 km in 2 hours and 30 minutes. What is its average speed in km/h?",
                    Options = new List<int> { 50, 60, 75, 80 }, CorrectAnswer = 60 },
                new RealWorldQuestion { QuestionText = "If a pizza is cut into 8 slices and you eat 3, what whole number percentage of the pizza is left?",
                    Options = new List<int> { 37, 50, 62, 75 }, CorrectAnswer = 62 },
                new RealWorldQuestion { QuestionText = "You need to fence a square garden with a side length of 15 meters. How many meters of fence are required?",
                    Options = new List<int> { 30, 45, 60, 225 }, CorrectAnswer = 60 },
                new RealWorldQuestion { QuestionText = "A recipe calls for 250g of flour to make 10 cookies. How much flour is needed for 25 cookies?",
                    Options = new List<int> { 500, 575, 600, 625 }, CorrectAnswer = 625 },

                // New 10 Questions
                new RealWorldQuestion { QuestionText = "Your restaurant bill is ₹1500. If you want to leave a 10% tip, how much should you add?",
                    Options = new List<int> { 100, 120, 150, 200 }, CorrectAnswer = 150 },
                new RealWorldQuestion { QuestionText = "You have ₹5000 and spend ₹1250 on groceries and ₹800 on bills. How much money do you have left?",
                    Options = new List<int> { 2950, 3050, 3200, 3750 }, CorrectAnswer = 2950 },
                new RealWorldQuestion { QuestionText = "A car's fuel tank holds 40 liters. If it gives a mileage of 18 km per liter, how far can it travel on a full tank?",
                    Options = new List<int> { 640, 720, 780, 800 }, CorrectAnswer = 720 },
                new RealWorldQuestion { QuestionText = "If you deposit ₹10,000 in a bank account with a simple annual interest rate of 5%, how much interest will you earn in one year?",
                    Options = new List<int> { 250, 500, 750, 1000 }, CorrectAnswer = 500 },
                new RealWorldQuestion { QuestionText = "A student scores 85, 90, and 95 in three tests. What is their average score?",
                    Options = new List<int> { 88, 90, 92, 93 }, CorrectAnswer = 90 },
                new RealWorldQuestion { QuestionText = "You need to buy carpet for a room that is 5 meters long and 4 meters wide. How many square meters of carpet do you need?",
                    Options = new List<int> { 18, 20, 22, 25 }, CorrectAnswer = 20 },
                new RealWorldQuestion { QuestionText = "A movie starts at 7:15 PM and is 140 minutes long. What time does it end?",
                    Options = new List<int> { 2135, 2145, 2155, 2205 }, CorrectAnswer = 2135 }, // Note: Representing 9:35 PM as 2135 is tricky for int options. A better UI would handle time formats. This is a simplification. Let's change the question.
                // Better version of the time question:
                new RealWorldQuestion { QuestionText = "A train journey takes 4 hours and 30 minutes. If you start at 9:00 AM, at what time will you arrive?",
                    Options = new List<int> { 1300, 1330, 1400, 1430 }, CorrectAnswer = 1330 }, // 1:30 PM
                new RealWorldQuestion { QuestionText = "You buy a 2-liter bottle of juice. If you pour it into 250 ml glasses, how many glasses can you fill?",
                    Options = new List<int> { 6, 8, 10, 12 }, CorrectAnswer = 8 },
                new RealWorldQuestion { QuestionText = "If one person can paint a wall in 6 hours, how long will it take two people working at the same rate to paint it?",
                    Options = new List<int> { 2, 3, 4, 12 }, CorrectAnswer = 3 },
                new RealWorldQuestion { QuestionText = "A water tank is 3 meters long, 2 meters wide, and 2 meters deep. What is its volume in cubic meters?",
                    Options = new List<int> { 7, 10, 12, 14 }, CorrectAnswer = 12 }
            };

            // Shuffling ensures users get a different question order each time
            return allQuestions.OrderBy(q => rand.Next()).ToList();
        }
    }
}