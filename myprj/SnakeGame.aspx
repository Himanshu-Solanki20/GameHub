<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SnakeGame.aspx.cs" Inherits="myprj.SnakeGame" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>GameHub | Snake Game</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <!-- Phosphor Icons -->
    <script src="https://unpkg.com/phosphor-icons"></script>

    <style>
        body { font-family: 'Segoe UI', sans-serif; transition: background 0.3s, color 0.3s; }
        .dark { background: #111827; color: #f9fafb; }
        .game-wrapper { max-width: 600px; margin: auto; margin-top: 100px; padding: 2rem; border-radius: 1.5rem; background: white; box-shadow: 0 8px 20px rgba(0,0,0,0.15); }
        .dark .game-wrapper { background: #1f2937; }
        canvas { display: block; background: #fefefe; margin: auto; border: 3px solid #374151; border-radius: 0.75rem; }
        .dark canvas { background: #111; border-color: #f3f4f6; }
    </style>
</head>
<body class="light">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

        <!-- Welcome -->
        <div class="fixed top-4 left-4 flex items-center space-x-2 z-20 bg-white/20 dark:bg-black/30 px-3 py-2 rounded-full shadow-md">
            <i class="fa-solid fa-user text-lg"></i>
            <asp:Label ID="lblWelcome" runat="server" CssClass="font-semibold"></asp:Label>
        </div>

        <!-- Theme + Dashboard -->
        <div class="fixed top-4 right-4 flex items-center space-x-2 z-20">
            <button id="themeToggleBtn" type="button" class="bg-gray-300 dark:bg-gray-700 text-gray-800 dark:text-gray-200 px-3 py-2 rounded-full shadow-lg transition-colors hover:bg-gray-400 dark:hover:bg-gray-600 focus:outline-none">
                <i id="themeIcon" class="ph-moon-fill text-xl button-icon"></i>
            </button>
            <a href="Dashboard.aspx" class="bg-yellow-400 hover:bg-yellow-500 text-gray-900 font-semibold px-3 py-2 rounded-full shadow-lg transition-colors">
                <i class="fa-solid fa-house"></i>
            </a>
        </div>

        <!-- Game Wrapper -->
        <div class="game-wrapper text-center">
            <h1 class="mb-2 text-2xl font-bold"><i class="fa-solid fa-gamepad"></i> Snake Game</h1>
            <p class="mb-4 text-gray-600 dark:text-gray-300">Use arrow keys to move the snake</p>
            <canvas id="gameCanvas" width="400" height="400"></canvas>

            <div class="mt-4 flex justify-between items-center">
                <div class="text-lg font-semibold">Score: <span id="score">0</span></div>
                <button id="startBtn" type="button" class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg shadow-md transition">
                    <i class="fa-solid fa-play"></i> Start Game
                </button>
            </div>
        </div>
    </form>

    <script>
        // Theme toggle
        const body = document.body;
        const themeToggleBtn = document.getElementById("themeToggleBtn");
        const themeIcon = document.getElementById("themeIcon");
        themeToggleBtn.addEventListener("click", () => {
            body.classList.toggle("dark");
            themeIcon.classList.toggle("ph-moon-fill");
            themeIcon.classList.toggle("ph-sun-fill");
        });

        // Snake Game
        const canvas = document.getElementById("gameCanvas");
        const ctx = canvas.getContext("2d");
        const box = 20;
        let snake, direction, food, score, gameInterval, snakeSpeed, gameOver;

        function startGame() {
            clearInterval(gameInterval); // clear old interval
            snake = [{ x: 9 * box, y: 10 * box }];
            direction = null;
            food = generateFood();
            score = 0;
            snakeSpeed = 120;
            gameOver = false;
            document.getElementById("score").textContent = score;
            gameInterval = setInterval(draw, snakeSpeed);
        }

        document.getElementById("startBtn").addEventListener("click", startGame);

        document.addEventListener("keydown", (e) => {
            if (e.key === "ArrowLeft" && direction !== "RIGHT") direction = "LEFT";
            if (e.key === "ArrowUp" && direction !== "DOWN") direction = "UP";
            if (e.key === "ArrowRight" && direction !== "LEFT") direction = "RIGHT";
            if (e.key === "ArrowDown" && direction !== "UP") direction = "DOWN";
        });

        function generateFood() {
            return {
                x: Math.floor(Math.random() * (canvas.width / box)) * box,
                y: Math.floor(Math.random() * (canvas.height / box)) * box
            };
        }

        function endGame() {
            clearInterval(gameInterval);
            gameOver = true;
            alert("Game Over! Your score: " + score);
            saveScore(score);
        }

        function draw() {
            if (gameOver) return;

            ctx.fillStyle = body.classList.contains("dark") ? "#111827" : "#f9fafb";
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            let headX = snake[0].x;
            let headY = snake[0].y;
            if (direction === "LEFT") headX -= box;
            if (direction === "UP") headY -= box;
            if (direction === "RIGHT") headX += box;
            if (direction === "DOWN") headY += box;

            // Border collision
            if (headX < 0 || headY < 0 || headX >= canvas.width || headY >= canvas.height) {
                endGame();
                return;
            }

            // Food eaten
            if (headX === food.x && headY === food.y) {
                score++;
                document.getElementById("score").textContent = score;
                food = generateFood();
                if (snakeSpeed > 50) {
                    snakeSpeed -= 5;
                    clearInterval(gameInterval);
                    gameInterval = setInterval(draw, snakeSpeed);
                }
            } else {
                snake.pop();
            }

            let newHead = { x: headX, y: headY };
            if (snake.some(seg => seg.x === newHead.x && seg.y === newHead.y)) {
                endGame();
                return;
            }

            snake.unshift(newHead);

            // Draw snake
            ctx.fillStyle = body.classList.contains("dark") ? "#34d399" : "#065f46";
            snake.forEach(seg => ctx.fillRect(seg.x, seg.y, box, box));

            // Draw food
            ctx.fillStyle = body.classList.contains("dark") ? "#f87171" : "#dc2626";
            ctx.fillRect(food.x, food.y, box, box);
        }

        function saveScore(finalScore) {
            if (typeof PageMethods !== "undefined" && PageMethods.SaveScore) {
                PageMethods.SaveScore(finalScore,
                    () => console.log("Score saved!"),
                    (err) => console.warn("Error saving score:", err)
                );
            }
        }
    </script>
</body>
</html>
