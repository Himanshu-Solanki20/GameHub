<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="myprj.Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <title>GameHub | Create Account</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* This CSS is nearly identical to the redesigned Login page for consistency */
        :root {
            --bg-dark-start: #0f2027; --bg-dark-mid: #203a43; --bg-dark-end: #2c5364;
            --text-dark: #f0f0f0; --primary-accent: #00c9a7; --primary-accent-hover: #00b09b;
            --form-bg-dark: rgba(0, 0, 0, 0.2); --bg-light-start: #e0eafc; --bg-light-end: #cfdef3;
            --text-light: #2c3e50; --form-bg-light: rgba(255, 255, 255, 0.5);
        }
        body { margin: 0; font-family: 'Poppins', sans-serif; background: linear-gradient(135deg, var(--bg-dark-start), var(--bg-dark-mid), var(--bg-dark-end)); color: var(--text-dark); transition: all 0.5s ease; overflow: hidden; }
        body.light-mode { background: linear-gradient(135deg, var(--bg-light-start), var(--bg-light-end)); color: var(--text-light); }
        .register-container { display: flex; height: 100vh; width: 100vw; align-items: center; justify-content: center; }
        .register-card { display: flex; width: 900px; max-width: 90vw; min-height: 600px; background: var(--form-bg-dark); border-radius: 20px; backdrop-filter: blur(15px); box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3); overflow: hidden; animation: fadeIn 1s ease-out; }
        body.light-mode .register-card { background: var(--form-bg-light); box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); }
        .register-branding { flex-basis: 50%; background: url('https://images.unsplash.com/photo-1580234811497-9df7fd2f357e?q=80&w=1964') center center/cover; position: relative; display: flex; align-items: flex-end; padding: 40px; }
        .branding-text h1 { color: white; font-weight: 600; text-shadow: 2px 2px 8px rgba(0,0,0,0.7); }
        .register-form { flex-basis: 50%; padding: 40px; display: flex; flex-direction: column; justify-content: center; }
        .form-control, .form-control:focus { background-color: rgba(255, 255, 255, 0.1); color: var(--text-dark); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 12px; padding: 12px 15px; box-shadow: none; }
        body.light-mode .form-control { background-color: rgba(255, 255, 255, 0.8); color: var(--text-light); border: 1px solid #ccc; }
        .btn-register { background-color: var(--primary-accent); border: none; border-radius: 12px; padding: 12px; font-weight: 600; transition: background 0.3s; width: 100%; }
        .btn-register:hover { background-color: var(--primary-accent-hover); }
        .toggle-theme { position: absolute; top: 20px; right: 20px; cursor: pointer; font-size: 1.5rem; }
        .validation-error { color: #ff7b7b; font-size: 0.8rem; height: 1rem; margin-top: -10px; margin-bottom: 10px; visibility: hidden; }
        @keyframes fadeIn { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
        @media (max-width: 768px) { .register-branding { display: none; } .register-form { flex-basis: 100%; } .register-card { width: 100%; height: 100vh; border-radius: 0; } }
    </style>
</head>
<body id="pageBody" class="light-mode">
    <div class="toggle-theme" onclick="toggleTheme()">
        <i id="themeIcon" class="fa-solid fa-sun"></i>
    </div>
    
    <form id="form1" runat="server" class="register-container" onsubmit="return validateForm();">
        <div class="register-card">
            <div class="register-branding">
                <div class="branding-text">
                    <h1>Join the Hub</h1>
                    <p>Create your account to get started.</p>
                </div>
            </div>

            <div class="register-form">
                <h2 class="text-center mb-4"><i class="fa-solid fa-user-plus me-2"></i>Create Account</h2>

                <div class="mb-3">
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username" />
                </div>
                
                <div class="mb-3">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Email Address" />
                    <div id="emailError" class="validation-error">Invalid email format.</div>
                </div>

                <div class="mb-3">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" />
                    <div id="passwordError" class="validation-error">Password must be at least 8 characters.</div>
                </div>
                
                <div class="mb-3">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Password" />
                    <div id="confirmPasswordError" class="validation-error">Passwords do not match.</div>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-register text-white" OnClick="btnRegister_Click" />

                <p class="text-center mt-4 small">
                    Already have an account? <a href="Login.aspx">Sign In</a>
                </p>

                <%-- These labels are used by the server to send messages to SweetAlert --%>
                <asp:Label ID="lblMessage" runat="server" CssClass="d-none"></asp:Label>
                <asp:Label ID="lblSuccess" runat="server" CssClass="d-none"></asp:Label>
            </div>
        </div>
    </form>
    
    <script>
        // Theme toggle function
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

        // Client-side form validation
        function validateForm() {
            const email = document.getElementById('<%= txtEmail.ClientID %>').value;
            const password = document.getElementById('<%= txtPassword.ClientID %>').value;
            const confirmPass = document.getElementById('<%= txtConfirmPassword.ClientID %>').value;

            let isValid = true;

            // Basic email regex
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                document.getElementById('emailError').style.visibility = 'visible';
                isValid = false;
            } else {
                document.getElementById('emailError').style.visibility = 'hidden';
            }

            // Password length
            if (password.length < 8) {
                document.getElementById('passwordError').style.visibility = 'visible';
                isValid = false;
            } else {
                document.getElementById('passwordError').style.visibility = 'hidden';
            }

            // Password match
            if (password !== confirmPass) {
                document.getElementById('confirmPasswordError').style.visibility = 'visible';
                isValid = false;
            } else {
                document.getElementById('confirmPasswordError').style.visibility = 'hidden';
            }

            return isValid;
        }

        // Show SweetAlert messages if set from server
        window.onload = function () {
            const err = document.getElementById('<%= lblMessage.ClientID %>').innerText;
            const success = document.getElementById('<%= lblSuccess.ClientID %>').innerText;

            if (err && err.trim()) {
                Swal.fire({ icon: 'error', title: 'Registration Failed', text: err });
            }

            if (success && success.trim()) {
                Swal.fire({
                    icon: 'success',
                    title: 'Registration Successful!',
                    text: success,
                    timer: 2000,
                    showConfirmButton: false
                }).then(() => {
                    window.location.href = 'Login.aspx'; // Redirect after success
                });
            }
        };
    </script>
</body>
</html>