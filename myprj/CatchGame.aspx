<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CatchGame.aspx.cs" Inherits="myprj.CatchGame" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>GameHub | Catch the Falling Objects</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        /* Base Light Theme */
        body {
            background: #f0f2f5;
            color: #212529; /* Darker text for contrast */
            font-family: 'Segoe UI', sans-serif;
            padding-top: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            flex-direction: column;
            transition: background-color 0.5s ease;
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
            gap: 15px;
        }

        /* Updated button styles for a more "real world" feel */
        .header-icons .btn {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease;
            border-radius: 50px; /* Fully rounded buttons */
            padding: 10px 18px; /* Larger padding for a bigger feel */
            min-width: unset; /* Override default button style */
        }

        .header-icons .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
        }

        .header-icons .btn-outline-secondary {
            background-color: rgba(255, 255, 255, 0.8);
            color: #212529;
            border: 1px solid #ddd;
        }

        .header-icons .btn-outline-secondary:hover {
            background-color: #fff;
            color: #212529;
        }

        .game-wrap {
            max-width: 780px;
            width: 100%;
            margin: auto;
        }

        .cardish {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, .1);
            transition: background-color 0.5s ease, box-shadow 0.5s ease;
        }

        .status {
            gap: 14px;
        }

        .badge-soft {
            background: #e2e6ea;
            border: 1px solid #c5c8cb;
            color: #212529;
            transition: background-color 0.5s ease, color 0.5s ease;
        }

        #gameCanvas {
            background: #f9f9f9;
            border-radius: 12px;
            box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.1);
            display: block;
            width: 100%;
            touch-action: none;
        }

        .controls .btn {
            min-width: 150px;
        }

        .game-over-message {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            font-size: 2rem;
            color: #212529;
            text-shadow: 2px 2px 4px rgba(255, 255, 255, 0.5);
            z-index: 10;
        }

        /* Dark Theme Styles */
        body.dark-theme {
            background: #121212;
            color: #e0e0e0;
        }

        body.dark-theme .cardish {
            background: #1e1e1e;
            box-shadow: 0 10px 30px rgba(0, 0, 0, .5);
        }

        body.dark-theme .badge-soft {
            background: #333333;
            border: 1px solid #444444;
            color: #e0e0e0;
        }

        /* Dark theme button styles */
        body.dark-theme .header-icons .btn-outline-secondary {
            background-color: rgba(60, 60, 60, 0.8);
            color: #ddd;
            border: 1px solid #444;
        }

        body.dark-theme .header-icons .btn-outline-secondary:hover {
            background-color: #3e3e3e;
            color: #fff;
        }

        body.dark-theme .game-over-message {
            color: #e0e0e0;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }

        body.dark-theme #gameCanvas {
            background: #252526;
            box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.5);
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
                <button type="button" class="btn btn-outline-secondary rounded-circle" id="themeToggleBtn">
                    <i id="themeIcon" class="fa-solid fa-moon"></i>
                </button>
                <a href="Dashboard.aspx" class="btn btn-outline-secondary rounded-circle">
                    <i class="fa-solid fa-gauge"></i>
                </a>
            </div>
        </header>

        <div class="game-wrap">
            <div class="d-flex justify-content-center align-items-center mb-3">
                <h2 class="m-0"><i class="fa-solid fa-basket-shopping me-2"></i>Catch the Falling Objects</h2>
            </div>

            <div class="cardish position-relative">
                <div class="d-flex flex-wrap status mb-3">
                    <span class="badge rounded-pill badge-soft px-3 py-2">
                        ⭐ Score: <strong id="scoreTxt" class="ms-1">0</strong>
                    </span>
                    <span class="badge rounded-pill badge-soft px-3 py-2">
                        ⏱ Time: <strong id="timerTxt" class="ms-1">00:00</strong>
                    </span>
                    <span class="badge rounded-pill badge-soft px-3 py-2">
                        ❌ Misses: <strong id="missesTxt" class="ms-1">0/5</strong>
                    </span>
                </div>

                <canvas id="gameCanvas"></canvas>
                <div id="gameOverMessage" class="game-over-message d-none">
                    Game Over! Your Score: <span id="finalScore">0</span>
                    <br><small class="d-block mt-2">Saving score...</small>
                </div>

                <div class="controls d-flex gap-2 mt-3">
                    <button type="button" class="btn btn-warning" id="btnStart">
                        <i class="fa-solid fa-play me-1"></i> Start
                    </button>
                    <button type="button" class="btn btn-outline-secondary" id="btnRestart" disabled>
                        <i class="fa-solid fa-rotate me-1"></i> Restart
                    </button>
                </div>
            </div>
        </div>

        <div class="toast-container position-fixed bottom-0 end-0 p-3">
            <div id="saveToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <strong class="me-auto">GameHub</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body bg-success text-white">
                    Score saved successfully! Redirecting...
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {

            // --- Game State & Configuration ---
            const gameState = {
                score: 0,
                misses: 0,
                isGameRunning: false,
                lastUpdateTime: 0,
                timerInterval: null,
                gameTime: 0,
                objectsToCatch: [],
                player: { x: 0, width: 100, height: 20 },
                maxMisses: 5,
                spawnObjectInterval: null
            };

            // An array of fruit emojis to randomly select from
            const FRUITS = ['🍎', '🍊', '🍌', '🍇', '🍓', '🍍', '🍉', '🍑', '🍒', '🥝'];

            // --- UI Elements ---
            const ui = {
                canvas: document.getElementById('gameCanvas'),
                scoreTxt: document.getElementById('scoreTxt'),
                timerTxt: document.getElementById('timerTxt'),
                missesTxt: document.getElementById('missesTxt'),
                btnStart: document.getElementById('btnStart'),
                btnRestart: document.getElementById('btnRestart'),
                gameOverMessage: document.getElementById('gameOverMessage'),
                finalScore: document.getElementById('finalScore'),
                themeToggleBtn: document.getElementById('themeToggleBtn'),
                themeIcon: document.getElementById('themeIcon')
            };
            const ctx = ui.canvas.getContext('2d');

            // --- Utility Functions ---
            function getRandomInt(min, max) {
                return Math.floor(Math.random() * (max - min + 1)) + min;
            }

            function isCollision(rect1, rect2) {
                return rect1.x < rect2.x + rect2.width &&
                    rect1.x + rect1.width > rect2.x &&
                    rect1.y < rect2.y + rect2.height &&
                    rect1.y + rect1.height > rect2.y;
            }

            // --- Theme Toggling ---
            const theme = {
                init: () => {
                    const savedTheme = localStorage.getItem('theme');
                    if (savedTheme === 'dark') {
                        document.body.classList.add('dark-theme');
                        ui.themeIcon.classList.remove('fa-sun');
                        ui.themeIcon.classList.add('fa-moon');
                    } else {
                        document.body.classList.remove('dark-theme');
                        ui.themeIcon.classList.remove('fa-moon');
                        ui.themeIcon.classList.add('fa-sun');
                    }
                },
                toggle: () => {
                    document.body.classList.toggle('dark-theme');
                    if (document.body.classList.contains('dark-theme')) {
                        localStorage.setItem('theme', 'dark');
                        ui.themeIcon.classList.remove('fa-sun');
                        ui.themeIcon.classList.add('fa-moon');
                    } else {
                        localStorage.setItem('theme', 'light');
                        ui.themeIcon.classList.remove('fa-moon');
                        ui.themeIcon.classList.add('fa-sun');
                    }
                }
            };

            // --- Game Logic ---
            const game = {
                init: () => {
                    // Set canvas dimensions dynamically
                    ui.canvas.width = ui.canvas.parentElement.clientWidth;
                    ui.canvas.height = Math.round(ui.canvas.width * 0.7);

                    gameState.player.x = (ui.canvas.width - gameState.player.width) / 2;
                    game.updateUI();
                    game.draw();

                    // Event Listeners
                    ui.btnStart.addEventListener('click', game.start);
                    ui.btnRestart.addEventListener('click', game.restart);
                    window.addEventListener('resize', game.handleResize);
                    ui.canvas.addEventListener('mousemove', game.handleInput);
                    ui.canvas.addEventListener('touchmove', game.handleTouch, { passive: false });
                    ui.themeToggleBtn.addEventListener('click', theme.toggle);

                    // Initialize theme on page load
                    theme.init();
                },

                handleResize: () => {
                    ui.canvas.width = ui.canvas.parentElement.clientWidth;
                    ui.canvas.height = Math.round(ui.canvas.width * 0.7);
                    game.draw();
                },

                handleInput: (e) => {
                    if (!gameState.isGameRunning) return;
                    const rect = ui.canvas.getBoundingClientRect();
                    const mouseX = e.clientX - rect.left;
                    // Keep the player within the canvas bounds
                    gameState.player.x = mouseX - gameState.player.width / 2;
                    gameState.player.x = Math.max(0, Math.min(ui.canvas.width - gameState.player.width, gameState.player.x));
                },

                handleTouch: (e) => {
                    if (!gameState.isGameRunning) return;
                    e.preventDefault(); // Prevent scrolling
                    const rect = ui.canvas.getBoundingClientRect();
                    const touchX = e.touches[0].clientX - rect.left;
                    gameState.player.x = touchX - gameState.player.width / 2;
                    gameState.player.x = Math.max(0, Math.min(ui.canvas.width - gameState.player.width, gameState.player.x));
                },

                start: () => {
                    if (gameState.isGameRunning) return;
                    gameState.isGameRunning = true;
                    gameState.score = 0;
                    gameState.misses = 0;
                    gameState.gameTime = 0;
                    gameState.objectsToCatch = [];
                    ui.gameOverMessage.classList.add('d-none');
                    ui.btnStart.disabled = true;
                    ui.btnRestart.disabled = false;
                    game.updateUI();
                    game.startTimer();
                    requestAnimationFrame(game.loop);
                    gameState.spawnObjectInterval = setInterval(game.spawnObject, 1000); // Spawn an object every second
                },

                restart: () => {
                    game.end();
                    game.start();
                },

                end: () => {
                    if (!gameState.isGameRunning) return; // Prevent multiple calls
                    gameState.isGameRunning = false;
                    ui.btnStart.disabled = false;
                    ui.btnRestart.disabled = false;
                    clearInterval(gameState.timerInterval);
                    clearInterval(gameState.spawnObjectInterval);
                    ui.gameOverMessage.classList.remove('d-none');
                    ui.finalScore.textContent = gameState.score;

                    game.saveScoreToServer();
                },

                // New function to save score to the server
                saveScoreToServer: async () => {
                    const data = {
                        score: gameState.score,
                        misses: gameState.misses,
                        time: gameState.gameTime
                    };

                    try {
                        const response = await fetch('CatchGame.aspx/SaveScore', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify(data)
                        });

                        if (response.ok) {
                            // Show a success toast and then redirect
                            const toast = new bootstrap.Toast(document.getElementById('saveToast'));
                            toast.show();
                            setTimeout(() => {
                                window.location.href = 'Leaderboard.aspx';
                            }, 3000); // Redirect after 3 seconds
                        } else {
                            console.error('Failed to save score.');
                            ui.gameOverMessage.innerHTML += '<br><small>Error saving score. Please try again.</small>';
                        }
                    } catch (error) {
                        console.error('An error occurred:', error);
                        ui.gameOverMessage.innerHTML += '<br><small>Connection error. Could not save score.</small>';
                    }
                },

                startTimer: () => {
                    gameState.timerInterval = setInterval(() => {
                        gameState.gameTime++;
                        game.updateUI();
                    }, 1000);
                },

                spawnObject: () => {
                    const randomFruit = FRUITS[Math.floor(Math.random() * FRUITS.length)];
                    let object = {
                        x: getRandomInt(20, ui.canvas.width - 20),
                        y: -20,
                        size: 40,
                        speed: getRandomInt(2, 5),
                        fruit: randomFruit
                    };
                    gameState.objectsToCatch.push(object);
                },

                loop: (timestamp) => {
                    const deltaTime = timestamp - (gameState.lastUpdateTime || timestamp);
                    gameState.lastUpdateTime = timestamp;

                    game.update(deltaTime);
                    game.draw();

                    if (gameState.isGameRunning) {
                        requestAnimationFrame(game.loop);
                    }
                },

                update: (deltaTime) => {
                    // Update object positions
                    gameState.objectsToCatch.forEach(object => {
                        object.y += object.speed;
                    });

                    // Check for collisions and misses
                    const playerRect = {
                        x: gameState.player.x,
                        y: ui.canvas.height - gameState.player.height,
                        width: gameState.player.width,
                        height: gameState.player.height
                    };

                    for (let i = gameState.objectsToCatch.length - 1; i >= 0; i--) {
                        const object = gameState.objectsToCatch[i];
                        const objectRect = {
                            x: object.x - object.size / 2,
                            y: object.y - object.size / 2,
                            width: object.size,
                            height: object.size
                        };

                        if (isCollision(playerRect, objectRect)) {
                            gameState.score++;
                            gameState.objectsToCatch.splice(i, 1);
                        } else if (object.y > ui.canvas.height + object.size) {
                            gameState.misses++;
                            gameState.objectsToCatch.splice(i, 1);
                        }
                    }

                    game.updateUI();

                    if (gameState.misses >= gameState.maxMisses) {
                        game.end();
                    }
                },

                draw: () => {
                    ctx.clearRect(0, 0, ui.canvas.width, ui.canvas.height);

                    // Draw the player (basket)
                    ctx.fillStyle = document.body.classList.contains('dark-theme') ? '#555' : '#495057';
                    ctx.fillRect(gameState.player.x, ui.canvas.height - gameState.player.height, gameState.player.width, gameState.player.height);

                    // Draw falling objects as emojis
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    gameState.objectsToCatch.forEach(object => {
                        ctx.font = `${object.size}px serif`;
                        ctx.fillText(object.fruit, object.x, object.y);
                    });
                },

                updateUI: () => {
                    ui.scoreTxt.textContent = gameState.score;
                    ui.missesTxt.textContent = `${gameState.misses}/${gameState.maxMisses}`;
                    const minutes = Math.floor(gameState.gameTime / 60).toString().padStart(2, '0');
                    const seconds = (gameState.gameTime % 60).toString().padStart(2, '0');
                    ui.timerTxt.textContent = `${minutes}:${seconds}`;
                }
            };

            game.init();
        });
    </script>
</body>
</html>