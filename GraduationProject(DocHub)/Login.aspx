<%@ Page Language="VB" AutoEventWireup="true" 
    CodeBehind="Login.aspx.vb" 
    Inherits="GraduationProject_DocHub_.Login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>DocHub — Login</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: row;
        }

        .login-left {
           flex: 1;
           background-image: url('Images/IT_College.jpg');
           background-size: cover;
           background-position: center;
           position: relative;
        }

        .login-left::after {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(10, 35, 66, 0.45);
        }

        .login-right {
            width: 420px;
            min-height: 100vh;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            box-shadow: -8px 0 32px rgba(0,0,0,0.15);
        }

        .login-box { width: 100%; }

        .login-logo { text-align: center; margin-bottom: 28px; margin-top: -50px; }
        .login-logo .logo-text { font-size: 36px; font-weight: 700; color: #0a2342; }
        .login-logo .logo-sub { font-size: 12px; color: #94a3b8; margin-top: 10px; margin-bottom: 20px; }
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 12.5px; font-weight: 600; color: #334155; margin-bottom: 5px; }
        .form-control {
            width: 100%; padding: 9px 13px;
            border-radius: 8px; border: 1.5px solid #e2e8f0;
            font-size: 13.5px; font-family: 'DM Sans', sans-serif;
            color: #0f172a; outline: none; transition: border 0.15s;
        }
        .form-control:focus {
            border-color: #2589d6;
            box-shadow: 0 0 0 3px rgba(37,137,214,0.1);
        }
        .remember-row {
            display: flex; align-items: center;
            justify-content: space-between;
            margin-bottom: 20px; font-size: 12.5px;
        }
        .remember-row label { display: flex; align-items: center; gap: 6px; color: #64748b; cursor: pointer; }
        .btn-login {
            width: 100%; padding: 11px;
            background: #1f6fb2; color: #fff;
            border: none; border-radius: 8px;
            font-size: 14px; font-family: 'DM Sans', sans-serif;
            font-weight: 600; cursor: pointer; transition: background 0.15s;
        }
        .btn-login:hover { background: #1a5a94; }
        .error-msg {
            background: #fef2f2; border: 1px solid #fca5a5;
            color: #dc2626; border-radius: 8px;
            padding: 9px 13px; font-size: 13px;
            margin-bottom: 14px;
        }
        .footer-note { text-align: center; font-size: 11.5px; color: #94a3b8; margin-top: 16px; }
    </style>
</head>
<body>
    <div class="login-left"></div>
    <form id="LoginForm" runat="server">
   
    <div class="login-right">
        <div class="login-box">
            <div class="login-logo">
                <div class="logo-text">DocHub</div>
                <div class="logo-sub">King Abdullah II School of Information Technology</div>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <div class="error-msg">
                    <asp:Label ID="lblError" runat="server"/>
                </div>
            </asp:Panel>

            <div class="form-group">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control"
                    TextMode="Email"
                    placeholder="your@university.edu.jo"/>
            </div>

            <div class="form-group">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server"
                    CssClass="form-control"
                    TextMode="Password"
                    placeholder="••••••••"/>
            </div>

            <div class="remember-row">
                <label>
                    <asp:CheckBox ID="chkRemember" runat="server"/>
                    Remember me
                </label>
            </div>

            <asp:Button ID="btnLogin" runat="server"
                CssClass="btn-login"
                Text="Sign In"
                OnClick="btnLogin_Click"/>

            <p class="footer-note">Having trouble? Contact your system administrator.</p>
        </div>
    </div>

</form>
</body>
</html>