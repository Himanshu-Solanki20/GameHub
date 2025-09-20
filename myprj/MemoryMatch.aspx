<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemoryMatch.aspx.cs" Inherits="myprj.MemoryMatch" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>GameHub | Memory Match</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --light-bg: #f0f2f5; --light-text: #212529; --light-card: #ffffff; --light-card-front: #e9ecef;
            --dark-bg: #121212;  --dark-text: #e0e0e0;  --dark-card: #1e1e1e;  --dark-card-front: #343a40;
            --primary-color: #0d6efd;
        }
        body { font-family: 'Segoe UI', sans-serif; transition: background-color 0.3s, color 0.3s; padding-top: 80px; }
        body.light-mode { background-color: var(--light-bg); color: var(--light-text); }
        body.dark-mode { background-color: var(--dark-bg); color: var(--dark-text); }
        
        .top-bar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 1.5rem;
            background-color: #343a40; /* A neutral dark color for the bar */
            z-index: 1000;
        }
        .top-bar i { color: white; font-size: 22px; cursor: pointer; margin-left: 15px; }
        .game-board { max-width: 600px; margin: auto; }
        .game-header {
            display: flex; justify-content: space-between; align-items: center;
            padding: 1rem; border-radius: 10px; margin-bottom: 20px;
        }
        .light-mode .game-header { background-color: rgba(0,0,0,0.05); }
        .dark-mode .game-header { background-color: rgba(255,255,255,0.05); }
        .card-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }
        .memory-card {
            aspect-ratio: 1 / 1;
            perspective: 1000px;
            cursor: pointer;
        }
        .memory-card-inner {
            position: relative; width: 100%; height: 100%;
            transition: transform 0.6s;
            transform-style: preserve-3d;
            border-radius: 10px;
        }
        .memory-card.flip .memory-card-inner { transform: rotateY(180deg); }
        .card-face {
            position: absolute; width: 100%; height: 100%;
            backface-visibility: hidden;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: clamp(2rem, 8vw, 3rem);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .card-front { background-color: var(--light-card-front); color: var(--primary-color); }
        .dark-mode .card-front { background-color: var(--dark-card-front); }
        .card-back { background-color: #ffc107; color: #333; transform: rotateY(180deg); }
        .modal-content { border-radius: 15px; }
        .light-mode .modal-content { background-color: var(--light-card); }
        .dark-mode .modal-content { background-color: var(--dark-card); }
    </style>
</head>
<body class="light-mode">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
        
        <div class="top-bar">
            <div>
                <i class="fa-solid fa-user"></i>
                <asp:Label ID="lblWelcome" runat="server" CssClass="text-white ms-2 fs-6"></asp:Label>
            </div>
            <div>
                <i id="themeToggle" class="fa-solid fa-moon"></i>
                <a href="Dashboard.aspx"><i class="fa-solid fa-house"></i></a>
            </div>
        </div>

        <div class="container">
            <div class="game-board">
                <h2 class="text-center mb-4"><i class="fas fa-brain"></i> Memory Match</h2>
                <div class="game-header">
                    <h4><i class="fa-solid fa-arrows-spin"></i> Moves: <span id="moveCount">0</span></h4>
                    <h4><i class="fa-solid fa-clock"></i> Time: <span id="timer">00:00</span></h4>
                </div>
                <div class="card-grid" id="cardGrid">
                    </div>
            </div>
        </div>

        <div class="modal fade" id="gameOverModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body text-center p-5">
                        <h1 class="display-4">🎉 Well Done!</h1>
                        <p class="lead">You matched all the pairs.</p>
                        <div class="d-flex justify-content-around my-4">
                            <div>
                                <h5>Moves</h5>
                                <p id="finalMoves" class="fs-3 fw-bold">0</p>
                            </div>
                            <div>
                                <h5>Time</h5>
                                <p id="finalTime" class="fs-3 fw-bold">00:00</p>
                            </div>
                        </div>
                        <p class="text-success"><i class="fa-solid fa-check-circle"></i> Your score has been saved automatically!</p>
                        <div class="d-grid gap-2 d-sm-flex justify-content-sm-center mt-4">
                            <button type="button" class="btn btn-warning btn-lg" onclick="restartGame()">Play Again</button>
                            <a href="Dashboard.aspx" class="btn btn-secondary btn-lg">Dashboard</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const emojis = ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'];
        let flippedCards = [], matchedPairs = 0, moves = 0;
        let timerInterval, totalSeconds = 0;
        let gameOverModal;

        function shuffle(array) {
            return [...array, ...array].sort(() => Math.random() - 0.5);
        }

        function initGame() {
            gameOverModal = new bootstrap.Modal(document.getElementById('gameOverModal'));
            const cardGrid = document.getElementById('cardGrid');
            cardGrid.innerHTML = '';
            shuffle(emojis).forEach(emoji => {
                const card = document.createElement('div');
                card.className = 'memory-card';
                card.dataset.emoji = emoji;
                card.innerHTML = `
                    <div class="memory-card-inner">
                        <div class="card-face card-front"><i class="fa-solid fa-question"></i></div>
                        <div class="card-face card-back">${emoji}</div>
                    </div>`;
                card.addEventListener('click', handleCardClick);
                cardGrid.appendChild(card);
            });
            resetGameStats();
            startTimer();
        }

        function resetGameStats() {
            moves = 0;
            matchedPairs = 0;
            totalSeconds = 0;
            flippedCards = [];
            document.getElementById('moveCount').textContent = '0';
            document.getElementById('timer').textContent = '00:00';
            stopTimer();
        }

        function startTimer() {
            timerInterval = setInterval(() => {
                totalSeconds++;
                const min = String(Math.floor(totalSeconds / 60)).padStart(2, '0');
                const sec = String(totalSeconds % 60).padStart(2, '0');
                document.getElementById('timer').textContent = `${min}:${sec}`;
            }, 1000);
        }

        function stopTimer() {
            clearInterval(timerInterval);
        }

        function handleCardClick(e) {
            const clickedCard = e.currentTarget;
            if (clickedCard.classList.contains('flip') || flippedCards.length === 2) {
                return;
            }
            clickedCard.classList.add('flip');
            flippedCards.push(clickedCard);
            if (flippedCards.length === 2) {
                processMove();
            }
        }

        function processMove() {
            moves++;
            document.getElementById('moveCount').textContent = moves;
            const [card1, card2] = flippedCards;

            if (card1.dataset.emoji === card2.dataset.emoji) {
                matchedPairs++;
                flippedCards = [];
                if (matchedPairs === emojis.length) {
                    endGame();
                }
            } else {
                setTimeout(() => {
                    card1.classList.remove('flip');
                    card2.classList.remove('flip');
                    flippedCards = [];
                }, 1000);
            }
        }

        function endGame() {
            stopTimer();
            const finalTime = document.getElementById('timer').textContent;

            // Call server-side C# method to save the score
            PageMethods.SaveGameResult(moves, finalTime, onSaveSuccess, onSaveFailure);

            // Update and show the modal
            document.getElementById('finalMoves').textContent = moves;
            document.getElementById('finalTime').textContent = finalTime;
        }

        // Callback functions for the server call
        function onSaveSuccess(response) {
            console.log("Score saved successfully!");
            gameOverModal.show();
        }
        function onSaveFailure(error) {
            console.error("Failed to save score: ", error);
            alert("Could not save your score. Please check your connection.");
            gameOverModal.show(); // Still show modal, but maybe with an error message
        }

        function restartGame() {
            gameOverModal.hide();
            initGame();
        }

        // Theme Toggle
        const themeToggle = document.getElementById("themeToggle");
        themeToggle.addEventListener("click", () => {
            document.body.classList.toggle("dark-mode");
            document.body.classList.toggle("light-mode");
            themeToggle.classList.toggle("fa-sun");
            themeToggle.classList.toggle("fa-moon");
        });

        // Initialize game on page load
        window.onload = initGame;
    </script>
</body>
</html>