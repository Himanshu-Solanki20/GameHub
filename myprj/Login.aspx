<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="myprj.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>GameHub | Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-dark-start: #0f2027;
            --bg-dark-mid: #203a43;
            --bg-dark-end: #2c5364;
            --text-dark: #f0f0f0;
            --primary-accent: #00c9a7;
            --primary-accent-hover: #00b09b;
            --form-bg-dark: rgba(0, 0, 0, 0.2);

            --bg-light-start: #e0eafc;
            --bg-light-end: #cfdef3;
            --text-light: #2c3e50;
            --form-bg-light: rgba(255, 255, 255, 0.5);
        }

        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, var(--bg-dark-start), var(--bg-dark-mid), var(--bg-dark-end));
            color: var(--text-dark);
            transition: background 0.5s ease, color 0.5s ease;
            overflow: hidden;
        }

        body.light-mode {
            background: linear-gradient(135deg, var(--bg-light-start), var(--bg-light-end));
            color: var(--text-light);
        }

        .login-container {
            display: flex;
            height: 100vh;
            width: 100vw;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            display: flex;
            width: 900px;
            max-width: 90vw;
            min-height: 550px;
            background: var(--form-bg-dark);
            border-radius: 20px;
            backdrop-filter: blur(15px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            animation: fadeIn 1s ease-out;
        }
        
        body.light-mode .login-card {
             background: var(--form-bg-light);
             box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }

        .login-branding {
            flex-basis: 50%;
            background: url('https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=2070') center center/cover;
            position: relative;
            display: flex;
            align-items: flex-end;
            padding: 40px;
        }
        .branding-text h1 {
            color: white;
            font-weight: 600;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.7);
        }

        .login-form {
            flex-basis: 50%;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-control, .form-control:focus {
            background-color: rgba(255, 255, 255, 0.1);
            color: var(--text-dark);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            padding: 12px 15px;
            box-shadow: none;
        }
        
        body.light-mode .form-control {
            background-color: rgba(255, 255, 255, 0.8);
            color: var(--text-light);
            border: 1px solid #ccc;
        }

        .input-group-text {
            background-color: transparent;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-right: none;
            color: var(--primary-accent);
        }
        
        body.light-mode .input-group-text {
            border: 1px solid #ccc;
            border-right: none;
        }

        .password-toggle {
            cursor: pointer;
            border-left: none;
        }

        .btn-login {
            background-color: var(--primary-accent);
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-weight: 600;
            transition: background 0.3s;
            width: 100%;
        }

        .btn-login:hover {
            background-color: var(--primary-accent-hover);
        }
        
        .divider {
            text-align: center;
            margin: 20px 0;
            color: rgba(255, 255, 255, 0.5);
        }
        
        body.light-mode .divider {
            color: #888;
        }
        
        .btn-social {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            font-size: 1.2rem;
            margin: 0 5px;
            opacity: 0.8;
            transition: opacity 0.3s;
        }
        .btn-social:hover { opacity: 1; }
        .btn-google { background-color: #DB4437; color: white; }
        .btn-steam { background-color: #1b2838; color: white; }
        .btn-twitch { background-color: #9146FF; color: white; }
        
        .toggle-theme {
            position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.5rem;
        }

        @keyframes fadeIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        
        @media (max-width: 768px) {
            .login-branding { display: none; }
            .login-form { flex-basis: 100%; }
            .login-card { width: 100%; height: 100vh; border-radius: 0; }
        }
    </style>
</head>
<body id="pageBody" class="light-mode">
    <div class="toggle-theme" onclick="toggleTheme()">
        <i id="themeIcon" class="fa-solid fa-sun"></i>
    </div>
    
    <form id="form1" runat="server" class="login-container">
        <div class="login-card">
            <div class="login-branding">
                <div class="branding-text">
                    <h1>GameHub</h1>
                    <p>Connect with gamers worldwide.</p>
                </div>
            </div>

            <div class="login-form">
                <h2 class="text-center mb-4"><i class="fa-solid fa-gamepad me-2"></i>Welcome Back!</h2>

                <div class="mb-3 input-group">
                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username" />
                </div>

                <div class="mb-3 input-group">
                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" />
                    <span class="input-group-text password-toggle" onclick="togglePasswordVisibility()"><i id="passIcon" class="fa-solid fa-eye"></i></span>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3">
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-login text-white" OnClick="btnLogin_Click" />
                <p class="text-center mt-4 small">
                    Don't have an account? <a href="Register.aspx">Sign Up</a>
                </p>

                <asp:Label ID="lblMessage" runat="server" CssClass="d-none"></asp:Label>
            </div>
        </div>
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function toggleTheme() {
            const body = document.getElementById("pageBody");
            const icon = document.getElementById("themeIcon");

            body.classList.toggle("light-mode");

            if (body.classList.contains("light-mode")) {
                icon.classList.remove("fa-moon");
                icon.classList.add("fa-sun");
            } else {
                icon.classList.remove("fa-sun");
                icon.classList.add("fa-moon");
            }
        }

        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('<%= txtPassword.ClientID %>');
            const passIcon = document.getElementById('passIcon');
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                passIcon.classList.remove('fa-eye');
                passIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                passIcon.classList.remove('fa-eye-slash');
                passIcon.classList.add('fa-eye');
            }
        }

        window.onload = function () {
            var lbl = document.getElementById('<%= lblMessage.ClientID %>');
            if (lbl && lbl.innerText.trim() !== "") {
                Swal.fire({
                    icon: 'error',
                    title: 'Login Failed',
                    text: lbl.innerText.trim(),
                    confirmButtonColor: '#3085d6'
                });
            }
        };
    </script>
</body>
</html>