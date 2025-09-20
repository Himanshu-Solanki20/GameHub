<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TypingSpeed.aspx.cs" Inherits="myprj.TypingSpeed" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Typing Speed Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --bg-color: #f0f2f5;
            --text-color: #333;
            --card-bg: #ffffff;
            --card-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            --primary-color: #0d6efd;
            --correct-color: #28a745;
            --incorrect-color: #dc3545;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: background-color 0.3s, color 0.3s;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            flex-direction: column;
        }

        .dark-mode {
            --bg-color: #121212;
            --text-color: #e0e0e0;
            --card-bg: #1e1e1e;
            --card-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }
        
        header {
            width: 100%;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: absolute;
            top: 0;
            left: 0;
        }

        .welcome-user {
            font-size: 1.2rem;
            font-weight: 500;
        }
        
        .welcome-user span {
             font-weight: bold;
        }

        .header-icons {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .game-container {
            width: 100%;
            max-width: 700px;
            background-color: var(--card-bg);
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--card-shadow);
            text-align: center;
        }

        .stats {
            display: flex;
            justify-content: space-around;
            font-size: 1.5rem;
            margin-bottom: 30px;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .stat-item i {
            font-size: 1.2rem;
            margin-bottom: 5px;
            color: var(--primary-color);
        }

        .word-display {
            font-size: 2.5rem;
            letter-spacing: 3px;
            margin-bottom: 25px;
            user-select: none;
        }

        .word-display span.correct { color: var(--correct-color); }
        .word-display span.incorrect { color: var(--incorrect-color); background-color: #ff000020; }
        
        #input-field {
            font-size: 1.5rem;
            text-align: center;
        }
        
        #btn-restart, #btn-dashboard {
            font-size: 1rem;
            padding: 10px 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <header>
            <div class="welcome-user">
                Welcome, <asp:Literal ID="lblUsername" runat="server" />! 
            </div>
            <div class="header-icons">
                <button type="button" id="theme-toggle" class="btn btn-outline-secondary rounded-circle">
                    <i class="fas fa-moon"></i>
                </button>
                <a href="Dashboard.aspx" class="btn btn-outline-secondary rounded-circle">
                    <i class="fas fa-chart-line"></i>
                </a>
            </div>
        </header>

        <div class="game-container">
            <h2><i class="fas fa-keyboard text-primary"></i> Typing Speed Test</h2>
            <p class="text-muted">Type the word below. The test is 60 seconds long.</p>

            <div class="stats">
                <div class="stat-item">
                    <i class="fas fa-clock"></i>
                    <span id="time">60</span>s
                </div>
                <div class="stat-item">
                    <i class="fas fa-bullseye"></i>
                    <span id="score">0</span> WPM
                </div>
            </div>

            <div class="word-display" id="word-display">Click Start to Begin</div>
            
            <input type="text" class="form-control" id="input-field" placeholder="Start typing..." disabled />

            <div class="mt-4">
                <button type="button" id="btn-restart" class="btn btn-success">
                    <i class="fas fa-play"></i> Start
                </button>
            </div>
            <div id="saving-indicator" class="mt-3 text-muted" style="display:none;">
                Game Over! Saving your score...
            </div>
        </div>
    </form>

    <script>
        const words = ["ability", "achieve", "acquire", "analyze", "balance", "because", "believe", "benefit", "captain", "certain", "change", "clarity", "company", "compare", "compete", "concept", "confirm", "contact", "control", "develop", "digital", "discuss", "economy", "educate", "element", "empower", "engine", "enlarge", "enormous", "enquire", "example", "execute", "explain", "express", "finance", "foreign", "freedom", "further", "general", "generate", "genuine", "govern", "history", "however", "imagine", "improve", "include", "inspire", "involve", "journey", "justice", "justify", "kingdom", "knowledge", "language", "leadership", "liberty", "library", "machine", "magnify", "maintain", "major", "manage", "measure", "mention", "message", "million", "monitor", "morning", "mystery", "narrate", "natural", "neglect", "network", "nothing", "nuclear", "observe", "operate", "opinion", "organize", "outcome", "outline", "perfect", "perform", "picture", "popular", "prepare", "present", "prevent", "primary", "private", "problem", "proceed", "process", "produce", "program", "project", "promote", "protect", "provide", "publish", "quality", "question", "quickly", "realize", "receive", "reflect", "release", "require", "research", "resolve", "respect", "respond", "restore", "results", "revenue", "science", "section", "service", "several", "similar", "society", "special", "station", "success", "suggest", "support", "sustain", "teacher", "thought", "through", "tonight", "tradition", "transform", "trouble", "ultimate", "uncover", "uniform", "unique", "unusual", "valuable", "various", "vehicle", "venture", "version", "victory", "visual", "welcome", "whatever", "whereas", "willing", "without", "wonderful", "yourself"];

        // DOM Elements
        const wordDisplayEl = document.getElementById('word-display');
        const inputFieldEl = document.getElementById('input-field');
        const timeEl = document.getElementById('time');
        const scoreEl = document.getElementById('score');
        const restartBtn = document.getElementById('btn-restart');
        const savingIndicator = document.getElementById('saving-indicator');

        // Game State
        const GAME_TIME = 60;
        let score = 0;
        let timeLeft = GAME_TIME;
        let timer;
        let isPlaying = false;
        let currentWord = '';

        // --- Game Logic ---
        function startGame() {
            // Reset state
            score = 0;
            timeLeft = GAME_TIME;
            isPlaying = true;
            inputFieldEl.disabled = false;
            savingIndicator.style.display = 'none';

            // Update UI
            scoreEl.textContent = score;
            timeEl.textContent = timeLeft;
            restartBtn.innerHTML = '<i class="fas fa-redo"></i> Restart';

            // Start countdown
            clearInterval(timer);
            timer = setInterval(updateTimer, 1000);

            // Show first word
            showNewWord();
            inputFieldEl.focus();
        }

        function showNewWord() {
            const randIndex = Math.floor(Math.random() * words.length);
            currentWord = words[randIndex];

            wordDisplayEl.innerHTML = ''; // Clear previous word
            currentWord.split('').forEach(char => {
                const charSpan = document.createElement('span');
                charSpan.textContent = char;
                wordDisplayEl.appendChild(charSpan);
            });

            inputFieldEl.value = '';
        }

        function updateTimer() {
            if (timeLeft > 0) {
                timeLeft--;
                timeEl.textContent = timeLeft;
            } else {
                gameOver();
            }
        }

        function gameOver() {
            isPlaying = false;
            clearInterval(timer);
            inputFieldEl.disabled = true;
            wordDisplayEl.innerHTML = 'Time\'s Up!';
            restartBtn.innerHTML = '<i class="fas fa-play"></i> Start';
            savingIndicator.style.display = 'block';

            // Auto-save the score
            saveScoreToServer(score);
        }

        function handleInput() {
            if (!isPlaying) return;

            const typedValue = inputFieldEl.value;
            const letterSpans = wordDisplayEl.querySelectorAll('span');

            // Provide real-time feedback
            let allCorrect = true;
            letterSpans.forEach((charSpan, index) => {
                const typedChar = typedValue[index];
                if (typedChar == null) {
                    charSpan.classList.remove('correct', 'incorrect');
                    allCorrect = false;
                } else if (typedChar === charSpan.innerText) {
                    charSpan.classList.add('correct');
                    charSpan.classList.remove('incorrect');
                } else {
                    charSpan.classList.add('incorrect');
                    charSpan.classList.remove('correct');
                    allCorrect = false;
                }
            });

            // Check for word completion
            if (allCorrect && typedValue.length === currentWord.length) {
                score++;
                scoreEl.textContent = score;
                showNewWord();
            }
        }

        // --- Server Communication ---
        async function saveScoreToServer(finalScore) {
            try {
                const response = await fetch('TypingSpeed.aspx/SaveScore', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ score: finalScore })
                });

                if (response.ok) {
                    // Redirect after successful save
                    window.location.href = 'Leaderboard.aspx';
                } else {
                    console.error('Failed to save score.');
                    savingIndicator.textContent = 'Error saving score. Please try again.';
                }
            } catch (error) {
                console.error('An error occurred:', error);
                savingIndicator.textContent = 'Connection error. Could not save score.';
            }
        }


        // --- Event Listeners ---
        restartBtn.addEventListener('click', startGame);
        inputFieldEl.addEventListener('input', handleInput);


        // --- Theme Toggle ---
        const themeToggleBtn = document.getElementById('theme-toggle');
        themeToggleBtn.addEventListener('click', () => {
            document.body.classList.toggle('dark-mode');
            const isDarkMode = document.body.classList.contains('dark-mode');
            themeToggleBtn.innerHTML = isDarkMode ? '<i class="fas fa-sun"></i>' : '<i class="fas fa-moon"></i>';
        });
    </script>
</body>
</html>