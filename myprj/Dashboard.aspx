<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="myprj.Dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>GameHub | Dashboard</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🎮</text></svg>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /*
        * ------------------------
        * THEME VARIABLES
        * ------------------------
        */
        :root {
            --bg-main-dark: #121212;
            --bg-secondary-dark: #1e1e1e;
            --card-bg-dark: #282828;
            --text-primary-dark: #e0e0e0;
            --text-secondary-dark: #b0b0b0;
            --accent-dark: #00e676;
            --hover-dark: #00c853;
            --border-dark: #444;

            --bg-main-light: #f0f2f5;
            --bg-secondary-light: #ffffff;
            --card-bg-light: #e9ecef;
            --text-primary-light: #212529;
            --text-secondary-light: #6c757d;
            --accent-light: #007bff;
            --hover-light: #0056b3;
            --border-light: #dee2e6;
        }

        /*
        * ------------------------
        * GLOBAL STYLES
        * ------------------------
        */
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--bg-main-dark);
            color: var(--text-primary-dark);
            transition: background-color 0.3s, color 0.3s;
            overflow-x: hidden;
        }

        .light-mode {
            background-color: var(--bg-main-light);
            color: var(--text-primary-light);
        }

        .light-mode .navbar, .light-mode .card, .light-mode .form-control {
            background-color: var(--bg-secondary-light) !important;
            border-color: var(--border-light) !important;
        }
        
        .light-mode .navbar-brand, .light-mode .nav-link, .light-mode h1, .light-mode h5 {
            color: var(--text-primary-light) !important;
        }

        .light-mode .text-muted {
            color: var(--text-secondary-light) !important;
        }

        .light-mode .btn-outline-secondary {
            color: var(--text-primary-light);
            border-color: var(--border-light);
        }
        
        .light-mode .btn-outline-secondary:hover {
            background-color: var(--accent-light);
            color: #fff;
        }

        .light-mode a {
            color: var(--text-primary-light);
        }

        a {
            text-decoration: none;
            color: var(--text-primary-dark);
        }

        /*
        * ------------------------
        * NAVBAR STYLES
        * ------------------------
        */
        .navbar {
            background-color: var(--bg-secondary-dark);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s;
        }
        
        .navbar-brand {
            font-weight: bold;
            color: var(--accent-dark);
            transition: color 0.3s;
        }

        .nav-link {
            font-weight: 500;
            color: var(--text-primary-dark);
            transition: color 0.3s;
        }

        .nav-link:hover {
            color: var(--accent-dark);
        }

        .btn-outline-secondary {
            color: var(--text-primary-dark);
            border-color: var(--text-primary-dark);
            transition: all 0.3s;
        }

        .btn-outline-secondary:hover {
            background-color: var(--accent-dark);
            color: var(--bg-secondary-dark);
            border-color: var(--accent-dark);
        }
        
        /*
        * ------------------------
        * DASHBOARD CONTENT
        * ------------------------
        */
        .dashboard-header {
            margin-top: 50px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .welcome-title {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--accent-dark);
            animation: fadeInDown 1.2s ease;
        }

        .welcome-subtitle {
            font-size: 1.2rem;
            color: var(--text-secondary-dark);
            animation: fadeIn 2s ease-in;
        }
        
        .game-card {
            background-color: var(--card-bg-dark);
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            animation: cardFloat 0.6s ease forwards;
            overflow: hidden;
        }

        .game-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 16px 40px rgba(0, 230, 118, 0.4);
        }

        .card-img-top {
            height: 180px;
            object-fit: cover;
            border-bottom: 1px solid var(--border-dark);
        }
        
        .light-mode .card-img-top {
            border-bottom: 1px solid var(--border-light);
        }
        
        .card-body h5 {
            font-weight: bold;
            color: var(--text-primary-dark);
            transition: color 0.3s;
        }

        .card-body p {
            font-size: 0.9rem;
            color: var(--text-secondary-dark);
            transition: color 0.3s;
        }

        .play-btn {
            background-color: var(--accent-dark);
            color: var(--bg-main-dark);
            border: none;
            font-weight: bold;
            padding: 10px 20px;
            border-radius: 50px;
            transition: background-color 0.3s, transform 0.3s;
        }

        .play-btn:hover {
            background-color: var(--hover-dark);
            transform: translateY(-2px);
        }

        .light-mode .play-btn {
            background-color: var(--accent-light);
            color: #fff;
        }
        
        .light-mode .play-btn:hover {
            background-color: var(--hover-light);
        }

        /*
        * ------------------------
        * THEME TOGGLE
        * ------------------------
        */
        .theme-toggle {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: var(--card-bg-dark);
            border: 1px solid var(--border-dark);
            border-radius: 50%;
            padding: 12px;
            font-size: 1.2rem;
            cursor: pointer;
            color: var(--text-primary-dark);
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            z-index: 100;
        }
        
        .theme-toggle:hover {
            transform: scale(1.1) rotate(20deg);
        }

        .light-mode .theme-toggle {
            background: var(--card-bg-light);
            color: var(--text-primary-light);
            border: 1px solid var(--border-light);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        /*
        * ------------------------
        * ANIMATIONS
        * ------------------------
        */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes cardFloat {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar navbar-expand-lg">
            <div class="container-fluid px-4">
                <a class="navbar-brand" href="#">
                    <i class="fas fa-gamepad me-2"></i>GameHub
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="#"><i class="fas fa-home me-1"></i>Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="Leaderboard.aspx"><i class="fas fa-trophy me-1"></i>Leaderboard</a>
                        </li>
                    </ul>
                    <div class="d-flex align-items-center">
                        <span class="me-3 d-none d-lg-block">Welcome, <asp:Label ID="lblUser" runat="server" CssClass="fw-bold" /></span>
                        <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-secondary me-2" OnClick="btnLogout_Click" />
                    </div>
                </div>
            </div>
        </nav>

        <div class="dashboard-header text-center">
            <h1 class="welcome-title">Welcome Back, <asp:Label ID="lblUserHeader" runat="server" /></h1>
            <p class="welcome-subtitle">Explore our collection of fun games and challenge your skills!</p>
        </div>

        <div class="container my-5">
            <div class="row g-4 justify-content-center">

                <div class="col-lg-4 col-md-6 col-sm-10">
                    <a href="TicTacToe.aspx">
                        <div class="card game-card">
                            <img src="Images/tic-tac-toe.png" class="card-img-top" alt="Tic Tac Toe">
                            <div class="card-body text-center">
                                <h5 class="card-title">Tic Tac Toe</h5>
                                <p class="card-text text-muted">A simple classic game for two players.</p>
                                <button type="button" class="btn play-btn">Play Now</button>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 col-sm-10">
                    <a href="SnakeGame.aspx">
                        <div class="card game-card">
                            <img src="Images/snackgame.png" class="card-img-top" alt="Snake Game">
                            <div class="card-body text-center">
                                <h5 class="card-title">Snake Game</h5>
                                <p class="card-text text-muted">Grow your snake by eating food and avoiding walls.</p>
                                <button type="button" class="btn play-btn">Play Now</button>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 col-sm-10">
                    <a href="MathQuiz.aspx">
                        <div class="card game-card">
                            <img src="Images/mathquiz.jpg" class="card-img-top" alt="Math Quiz">
                            <div class="card-body text-center">
                                <h5 class="card-title">Math Quiz</h5>
                                <p class="card-text text-muted">Test your math skills with this quick quiz.</p>
                                <button type="button" class="btn play-btn">Play Now</button>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 col-sm-10">
                    <a href="MemoryMatch.aspx">
                        <div class="card game-card">
                            <img src="Images/memory-match.jpg" class="card-img-top" alt="Memory Match">
                            <div class="card-body text-center">
                                <h5 class="card-title">Memory Match</h5>
                                <p class="card-text text-muted">Challenge your memory by finding matching pairs.</p>
                                <button type="button" class="btn play-btn">Play Now</button>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 col-sm-10">
                    <a href="TypingSpeed.aspx">
                        <div class="card game-card">
                            <img src="Images/typingspeed.jpg" class="card-img-top" alt="Typing Speed">
                            <div class="card-body text-center">
                                <h5 class="card-title">Typing Speed</h5>
                                <p class="card-text text-muted">Practice and improve your typing speed.</p>
                                <button type="button" class="btn play-btn">Play Now</button>
                            </div>
                        </div>
                    </a>
                </div>

                  <div class="col-lg-4 col-md-6 col-sm-10">
                    <a href="CatchGame.aspx">
                        <div class="card game-card">
                            <img src="Images/catch_object.png" class="card-img-top" alt="Typing Speed">
                            <div class="card-body text-center">
                                <h5 class="card-title">Catch The Object</h5>
                                <p class="card-text text-muted">Practice and improve your typing speed.</p>
                                <button type="button" class="btn play-btn">Play Now</button>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 col-sm-10">
                    <a href="Leaderboard.aspx">
                        <div class="card game-card">
                            <img src="Images/leaderboard.png" class="card-img-top" alt="Leaderboard">
                            <div class="card-body text-center">
                                <h5 class="card-title">Leaderboard</h5>
                                <p class="card-text text-muted">Check your rank and see who's at the top.</p>
                                <button type="button" class="btn play-btn">View Rankings</button>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </form>
    
    <button type="button" class="theme-toggle" id="themeToggle" aria-label="Toggle Theme">
        <i id="themeIcon" class="fas fa-sun"></i>
    </button>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const toggleButton = document.getElementById('themeToggle');
        const icon = document.getElementById('themeIcon');
        const body = document.body;

        // Load theme from localStorage
        const currentTheme = localStorage.getItem('theme');
        if (currentTheme) {
            body.classList.add(currentTheme + '-mode');
            icon.classList.remove('fa-sun', 'fa-moon');
            icon.classList.add(currentTheme === 'light' ? 'fa-moon' : 'fa-sun');
        }

        toggleButton.addEventListener('click', () => {
            const isLight = body.classList.contains('light-mode');

            // Toggle classes on the body
            body.classList.toggle('light-mode', !isLight);
            body.classList.toggle('dark-mode', isLight);

            // Toggle classes on the icon
            icon.classList.toggle('fa-sun', isLight);
            icon.classList.toggle('fa-moon', !isLight);

            // Save preference to localStorage
            localStorage.setItem('theme', isLight ? 'dark' : 'light');
        });
    </script>
</body>
</html>