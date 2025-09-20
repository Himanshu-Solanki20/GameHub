<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Leaderboard.aspx.cs" Inherits="myprj.Leaderboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Leaderboard - GameHub</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Inter', sans-serif;
            color: #f8f9fa;
        }

        .leaderboard-container {
            max-width: 900px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 30px;
        }

        .leaderboard-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .leaderboard-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #fff;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .filter-section {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
        }

        .filter-section .form-select {
            max-width: 300px;
            background-color: rgba(255, 255, 255, 0.2);
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.5);
        }
        .filter-section .form-select option {
            color: #333;
        }


        /* Top 3 Players Styling */
        .top-players {
            display: flex;
            justify-content: center;
            align-items: flex-end;
            gap: 20px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }

        .player-card {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            width: 220px;
            position: relative;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .player-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.3);
        }

        .player-card .rank-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        .player-card.rank-1 .rank-icon { color: #FFD700; } /* Gold */
        .player-card.rank-2 .rank-icon { color: #C0C0C0; } /* Silver */
        .player-card.rank-3 .rank-icon { color: #CD7F32; } /* Bronze */

        .player-card.rank-1 { order: 2; transform: scale(1.1); }
        .player-card.rank-2 { order: 1; }
        .player-card.rank-3 { order: 3; }

        .player-name {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .player-score {
            font-size: 1.5rem;
            font-weight: 700;
            color: #fff;
        }
        .player-game {
            font-size: 0.9rem;
            color: #ddd;
        }

        /* Leaderboard List Styling */
        .leaderboard-list .list-group-item {
            background: rgba(0, 0, 0, 0.2);
            border: none;
            color: #f8f9fa;
            display: flex;
            align-items: center;
            padding: 15px 20px;
            margin-bottom: 10px;
            border-radius: 10px;
            transition: background-color 0.2s ease;
        }
        .leaderboard-list .list-group-item:hover {
            background: rgba(0, 0, 0, 0.4);
        }

        .rank {
            font-size: 1.2rem;
            font-weight: 700;
            min-width: 40px;
            text-align: center;
            margin-right: 15px;
        }
        .player-info {
            flex-grow: 1;
        }
        .player-info .name {
            font-weight: 600;
        }
        .player-info .game {
            font-size: 0.85rem;
            color: #ccc;
        }
        .score-info {
            text-align: right;
            min-width: 100px;
        }
        .score-info .score {
            font-size: 1.2rem;
            font-weight: 700;
        }
        .score-info .moves {
            font-size: 0.85rem;
            color: #ccc;
        }

        .btn-back {
            display: block;
            width: fit-content;
            margin: 30px auto 0 auto;
            background: #667eea;
            border: none;
            transition: background-color 0.3s ease;
        }
        .btn-back:hover {
            background: #764ba2;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="leaderboard-container">
            <div class="leaderboard-header">
                <div class="leaderboard-title">
                    <i class="fas fa-trophy me-2"></i>Leaderboard
                </div>
            </div>

            <!-- Game Filter Dropdown -->
            <div class="filter-section">
                 <label for="ddlGameFilter" class="form-label mb-0 me-2">Filter by Game:</label>
                <asp:DropDownList ID="ddlGameFilter" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlGameFilter_SelectedIndexChanged"></asp:DropDownList>
            </div>

            <!-- Top 3 Players -->
            <div class="top-players">
                <asp:Repeater ID="rptTopPlayers" runat="server">
                    <ItemTemplate>
                        <div class='player-card rank-<%# Eval("Rank") %>'>
                            <div class="rank-icon">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <div class="player-name" title='<%# Eval("Username") %>'><%# Eval("Username") %></div>
                            <div class="player-score"><%# Eval("Score", "{0:N0}") %> pts</div>
                            <div class="player-game"><%# Eval("GameName") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            
             <!-- Message for no results -->
            <asp:Panel ID="pnlNoResults" runat="server" Visible="false" CssClass="text-center my-5">
                <h4><i class="fas fa-ghost me-2"></i>No Results Found</h4>
                <p>There are no game records for the selected filter.</p>
            </asp:Panel>

            <!-- Rest of the Leaderboard -->
            <div class="leaderboard-list">
                <asp:Repeater ID="rptLeaderboard" runat="server">
                    <HeaderTemplate>
                        <ul class="list-group">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <li class="list-group-item">
                            <div class="rank">#<%# Eval("Rank") %></div>
                            <div class="player-info">
                                <div class="name"><%# Eval("Username") %></div>
                                <div class="game"><%# Eval("GameName") %> - <%# Eval("PlayedOn", "{0:dd MMM yyyy}") %></div>
                            </div>
                            <div class="score-info">
                                <div class="score"><%# Eval("Score", "{0:N0}") %></div>
                                <div class="moves"><%# Eval("Moves") %> moves</div>
                            </div>
                        </li>
                    </ItemTemplate>
                    <FooterTemplate>
                        </ul>
                    </FooterTemplate>
                </asp:Repeater>
            </div>

            <asp:Button ID="btnBack" runat="server" Text="🔙 Back to Dashboard" CssClass="btn btn-light btn-lg btn-back px-4 py-2" OnClick="btnBack_Click" />
        </div>
    </form>
</body>
</html>
