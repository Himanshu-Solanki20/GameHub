# 🎮 GameHub – ASP.NET Web Forms Project

**GameHub** is a web-based platform where users can log in, play multiple mini-games, and track their performance. This project was built using **ASP.NET Web Forms (C\#)** and **SQL Server** for my BCA Semester 5 curriculum.

## 📌 Project Overview

**GameHub** is a one-stop portal for simple and fun web-based games. The core idea is to provide a seamless experience for users to register, play, and see their scores reflected on a central dashboard and leaderboard.

## 🎯 Features

  - 🔐 **Secure Authentication**: Login & Registration system with password hashing.
  - 📊 **Unified Dashboard**: A central hub to access all games and view personal stats.
  - 📝 **Game History**: Tracks scores, moves, and outcomes for every game played.
  - 🏆 **Competitive Leaderboard**: Ranks players based on their scores in various games.
  - 🎨 **Modern UI**: Uses SweetAlert2 for stylish, non-blocking popups.
  - 🌗 **Theme Support**: Includes a functional Dark/Light mode toggle for user comfort.

## 🎮 Games & Modules

| Module / Game | Description |
| :--- | :--- |
| 🕹️ **Catch Object** | A fast-paced game where you catch falling objects to score points. |
| 🧮 **Math Quiz** | A timed mathematics quiz with multiple difficulty levels and a dedicated leaderboard. |
| 🧠 **Memory Match** | The classic card-flipping game to test your memory, complete with a timer and score tracking. |
| 🐍 **Snake Game** | The retro snake game, rebuilt with sound effects and a high-score system. |
| ❌⭕ **Tic Tac Toe** | A two-player version of the classic game that keeps track of wins for each player. |
| ⌨️ **Typing Speed** | A practical tool to measure your typing speed (WPM) and accuracy. |
| 🔐 **User Module** | The core module handling secure login, registration, and session management. |
| 📊 **Dashboard** | The central page that ties everything together, displaying game options and user history. |

## 📂 Database Design

The primary table for tracking user activity is `GameHistory`.

**`GameHistory` Table Schema:**

  - `Id` (Primary Key, INT)
  - `Username` (VARCHAR)
  - `GameName` (VARCHAR)
  - `Winner` (VARCHAR)
  - `Moves` (INT)
  - `Score` (INT)
  - `ExtraInfo` (VARCHAR)

## 🚀 How to Run Locally

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/HimanshuSolanki20/GameHub.git
    ```
2.  **Open in Visual Studio:**
      - Launch Visual Studio.
      - Select "Open a project or solution" and navigate to the cloned directory.
3.  **Update Connection String:**
      - Open the `web.config` file.
      - Locate the `<connectionStrings>` section and update the `data source` to point to your SQL Server instance.
4.  **Run the Project:**
      - Press `F5` or click the "Run" button (with IIS Express selected) to build and launch the web application.

## 👤 Author

**Himanshu Solanki**

  - 🎓 BCA Semester 5 Student
  - 🌱 Exploring ASP.NET, SQL Server, and modern Web Development.
  - 💼 Open to internships and fresher opportunities in software development.

## ⭐ Support

If you like this project and found it helpful, please give it a ⭐ star\! Thank you\!

![Visitor Count](https://visitor-badge.laobi.icu/badge?page_id=HimanshuSolanki20.GameHub)
