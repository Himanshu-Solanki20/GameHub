<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicTacToe.aspx.cs" Inherits="myprj.TicTacToe" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GameHub | Tic Tac Toe</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        :root {
            --bg-light: #fff7f5;
            --bg-dark: #1c1c1c;
            --card-bg-light: #ffffff;
            --card-bg-dark: #2e2e2e;
            --text-light: #2f3640;
            --text-dark: #f0f0f0;
            --score-x: #ff6b6b;
            --score-o: #6a89cc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-light);
            color: var(--text-light);
            transition: background 0.3s, color 0.3s;
        }

        .dark-mode {
            background: var(--bg-dark);
            color: var(--text-dark);
        }

        .game-wrapper {
            background: var(--card-bg-light);
            border-radius: 25px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 100%;
            max-width: 900px;
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            justify-content: center;
            align-items: flex-start;
            transition: background 0.3s, box-shadow 0.3s;
        }

        .dark-mode .game-wrapper {
            background: var(--card-bg-dark);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
        }

        /* Game Board */
        .board {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            width: fit-content;
        }

        .btn-tile {
            width: 100px;
            height: 100px;
            background-color: var(--card-bg-light);
            border-radius: 20px;
            border: 1px solid #ddd;
            font-size: 2.5rem;
            color: var(--text-light);
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.3s, color 0.3s;
        }

        .dark-mode .btn-tile {
            background-color: #3e3e3e;
            color: var(--text-dark);
            border-color: #555;
        }

        .btn-tile:hover:not(:disabled) {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

        .btn-tile:disabled {
            opacity: 0.8;
            cursor: not-allowed;
        }

        /* Info Panel */
        .info-panel {
            min-width: 220px;
            text-align: center;
        }

        h2 {
            font-weight: bold;
            margin-bottom: 20px;
            color: var(--text-light);
            transition: color 0.3s;
        }

        .dark-mode h2 { color: var(--text-dark); }

        .status-text {
            font-size: 1.2rem;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .player-x-turn { color: var(--score-x); }
        .player-o-turn { color: var(--score-o); }
        .win-message { color: #27ae60; }
        .draw-message { color: #f39c12; }

        .score-box {
            margin-top: 15px;
            background-color: #f5f6fa;
            border: 1px solid #eee;
            padding: 15px 20px;
            border-radius: 15px;
            box-shadow: inset 0 2px 5px rgba(0,0,0,0.05);
            transition: background-color 0.3s, border-color 0.3s;
        }

        .dark-mode .score-box {
            background-color: #333;
            border-color: #555;
        }

        .score-item {
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 8px;
        }

        .score-value { font-size: 1.5rem; font-weight: bold; }
        .score-value.x { color: var(--score-x); }
        .score-value.o { color: var(--score-o); }

        .btn-restart {
            margin-top: 20px;
            background: linear-gradient(to right, var(--score-x), #fad0c4);
            border: none;
            padding: 10px 25px;
            font-weight: 600;
            border-radius: 10px;
            color: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .btn-restart:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }

        /* Controls at top-right */
        .top-right-controls {
            position: absolute;
            top: 20px;
            right: 20px;
            display: flex;
            gap: 15px;
            z-index: 1000;
        }

        .icon-btn {
            background: none;
            border: none;
            font-size: 22px;
            color: #555;
            cursor: pointer;
            transition: color 0.3s, transform 0.2s;
        }

        .icon-btn:hover {
            color: #007bff;
            transform: scale(1.2);
        }

        .dark-mode .icon-btn { color: #ddd; }

        .rotated { transform: rotate(180deg); }

        /* Welcome label */
        .welcome-label {
            position: absolute;
            top: 25px;
            left: 20px;
            font-weight: 600;
            color: #555;
        }
        .dark-mode .welcome-label { color: #ddd; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Top-right controls -->
        <div class="top-right-controls">
            <!-- Theme toggle -->
            <button type="button" class="icon-btn" onclick="toggleTheme()">
                <i id="themeIcon" class="fas fa-moon"></i>
            </button>

            <!-- Dashboard -->
            <a href="Dashboard.aspx" class="icon-btn">
                <i class="fas fa-home"></i>
            </a>
        </div>

        <!-- Welcome text (top-left) -->
        <asp:Label ID="lblWelcome" runat="server" CssClass="welcome-label"></asp:Label>

        <div class="game-wrapper">
            <div class="board">
                <asp:Button ID="btn00" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn01" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn02" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn10" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn11" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn12" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn20" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn21" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
                <asp:Button ID="btn22" runat="server" CssClass="btn-tile" OnClick="Cell_Click" />
            </div>

            <div class="info-panel">
                <h2>Tic Tac Toe</h2>
                <asp:Label ID="lblStatus" runat="server" CssClass="status-text"></asp:Label><br />
                <asp:Label ID="lblMoves" runat="server" CssClass="text-muted"></asp:Label>

                <div class="score-box mt-3">
                    <div class="score-item">Player X: <asp:Label ID="lblScoreX" runat="server" CssClass="score-value x"></asp:Label></div>
                    <div class="score-item">Player O: <asp:Label ID="lblScoreO" runat="server" CssClass="score-value o"></asp:Label></div>
                </div>

                <asp:Button ID="btnRestart" runat="server" Text="Restart Game" CssClass="btn-restart" OnClick="btnRestart_Click" />
            </div>
        </div>
    </form>
    
    <script>
        function toggleTheme() {
            const body = document.body;
            const icon = document.getElementById('themeIcon');
            body.classList.toggle('dark-mode');

            const isDark = body.classList.contains('dark-mode');
            icon.classList.toggle('fa-moon', !isDark);
            icon.classList.toggle('fa-sun', isDark);
            icon.classList.toggle('rotated', isDark);

            localStorage.setItem('theme', isDark ? 'dark' : 'light');
        }

        window.onload = () => {
            let theme = localStorage.getItem('theme');
            if (!theme) {
                theme = 'light';
                localStorage.setItem('theme', 'light');
            }
            if (theme === 'dark') {
                document.body.classList.add('dark-mode');
                document.getElementById('themeIcon').classList.remove('fa-moon');
                document.getElementById('themeIcon').classList.add('fa-sun', 'rotated');
            }
        };
    </script>
</body>
</html>
