<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MathQuiz.aspx.cs" Inherits="myprj.MathQuiz" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>GameHub | Real World Math Quiz</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --light-bg: #f8f9fa; --light-text: #212529; --light-card: #ffffff;
            --dark-bg: #121212;  --dark-text: #f1f1f1;  --dark-card: #1e1e1e;
            --primary-color: #0d6efd; --success-color: #198754; --danger-color: #dc3545;
        }

        body { transition: background-color 0.3s, color 0.3s; }
        body.light-mode { background-color: var(--light-bg); color: var(--light-text); }
        body.dark-mode { background-color: var(--dark-bg); color: var(--dark-text); }

        .top-bar i { font-size: 22px; cursor: pointer; margin-left: 15px; }
        .quiz-wrapper { padding-top: 80px; }

        .quiz-card {
            border: none; border-radius: 15px;
            transition: background-color 0.3s, color 0.3s;
        }
        .light-mode .quiz-card { background-color: var(--light-card); color: var(--light-text); }
        .dark-mode .quiz-card { background-color: var(--dark-card); color: var(--dark-text); }

        /* Fix dimmed question + progress labels */
        .light-mode #lblQuestion,
        .light-mode #lblQuestionProgress { color: var(--light-text); }
        .dark-mode #lblQuestion,
        .dark-mode #lblQuestionProgress { color: var(--dark-text) !important; }

        .dark-mode .list-group-item { background-color: #2a2a2a; border-color: #333; }

        /* Custom Radio Button Styling */
        .rbl-options label {
            display: block; width: 100%;
            padding: 15px; margin-bottom: 10px;
            border: 2px solid #ddd; border-radius: 8px;
            cursor: pointer; transition: all 0.2s ease-in-out;
            color: inherit; /* 👈 inherit text color */
        }
        .light-mode .rbl-options label { border-color: #eee; }
        .dark-mode .rbl-options label { border-color: #555; color: #f1f1f1; }

        .rbl-options input[type="radio"] { display: none; }
        .rbl-options input[type="radio"]:checked + label {
            border-color: var(--primary-color);
            background-color: var(--primary-color);
            color: #fff !important; font-weight: bold;
        }
        .rbl-options label:hover {
            border-color: var(--primary-color);
            transform: translateY(-2px);
        }

        /* Timer */
        .timer { font-size: 1.2rem; }
        body.dark-mode .timer { color: #ff6666 !important; }

        /* Icon buttons */
        .icon-btn {
            color: #000; /* Default black */
            font-size: 1.3rem;
            cursor: pointer;
            transition: color 0.3s ease;
            text-decoration: none;
        }
        .icon-btn:hover { color: #555; }
        body.dark-mode .icon-btn { color: #fff; }
    </style>
</head>
<body class="light-mode">
    <form id="form1" runat="server">
        <!-- Top Bar -->
        <div class="top-bar d-flex justify-content-between align-items-center px-3 py-2"
             style="position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background: transparent;">

            <div class="d-flex align-items-center">
                <i class="fa-solid fa-user icon-btn me-2"></i>
                <asp:Label ID="lblWelcome" runat="server" Text="Welcome, "></asp:Label>
                <asp:Label ID="lblUsername" runat="server"></asp:Label>
            </div>

            <div>
                <i id="themeToggle" class="fa-solid fa-moon icon-btn me-3"></i>
                <a href="Dashboard.aspx" class="icon-btn">
                    <i class="fa-solid fa-house"></i>
                </a>
            </div>
        </div>

        <!-- Quiz Content -->
        <div class="container quiz-wrapper">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <asp:Panel ID="pnlQuiz" runat="server">
                        <div class="card shadow-lg p-4 quiz-card">
                            <h3 class="text-center mb-3">🧮 Real World Math Quiz</h3>
                            <hr />
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <asp:Label ID="lblQuestionProgress" runat="server" CssClass="fw-bold"></asp:Label>
                                <asp:Label ID="lblTimer" runat="server" CssClass="fw-bold text-danger timer"></asp:Label>
                            </div>
                            <div class="progress mb-4" style="height: 10px;">
                                <asp:Panel ID="pnlProgressBar" runat="server" CssClass="progress-bar" role="progressbar"></asp:Panel>
                            </div>
                            <asp:Label ID="lblQuestion" runat="server" CssClass="h5 mb-4"></asp:Label>
                            <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="rbl-options" RepeatLayout="Flow" />
                            <asp:Button ID="btnSubmit" runat="server" Text="Submit Answer"
                                        OnClick="btnSubmit_Click"
                                        CssClass="btn btn-success w-100 mt-3 p-2" />
                        </div>
                    </asp:Panel>

                    <!-- Result Panel -->
                    <asp:Panel ID="pnlResult" runat="server" Visible="false">
                        <div class="card shadow-lg p-5 text-center quiz-card">
                            <h2 class="mb-3">🎉 Quiz Complete!</h2>
                            <p class="fs-5">You've successfully completed the math challenge.</p>
                            <asp:Label ID="lblResult" runat="server" CssClass="display-5 fw-bold my-4"></asp:Label>
                            <a href="Dashboard.aspx" class="btn btn-primary w-50 mx-auto">Back to Dashboard</a>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Theme Toggle
        const themeToggle = document.getElementById("themeToggle");
        themeToggle.addEventListener("click", function () {
            document.body.classList.toggle("dark-mode");
            document.body.classList.toggle("light-mode");
            this.classList.toggle("fa-sun");
            this.classList.toggle("fa-moon");
        });
    </script>
</body>
</html>
