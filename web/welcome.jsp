<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DCS Library Welcome</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .left-panel {
            width: 50%;
            background: linear-gradient(135deg, #2c3e50, #2980b9);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            animation: slideInLeft 1s ease;
        }

        .left-panel h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }

        .left-panel p {
            font-size: 1.2rem;
            line-height: 1.6;
        }

        .right-panel {
            width: 50%;
            background-color: #f7f9fc;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            animation: slideInRight 1s ease;
        }

        .login-box {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 80%;
            max-width: 400px;
            text-align: center;
        }

        .login-box h2 {
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .role-buttons {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
        }

        .role-buttons a {
            padding: 10px 20px;
            border-radius: 20px;
            text-decoration: none;
            color: white;
            background-color: #3498db;
            transition: background 0.3s;
        }

        .role-buttons a:hover {
            background-color: #2c3e50;
        }

        .note {
            margin-top: 20px;
            font-size: 0.9rem;
            color: #777;
        }

        @keyframes slideInLeft {
            from { transform: translateX(-100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
    </style>
</head>
<body>

    <div class="left-panel">
        <h1>Welcome to DCS Library</h1>
        <p>
            Empower your academic journey with our digital library platform.<br>
            Access resources, manage books, and stay informed.
        </p>
    </div>

    <div class="right-panel">
        <div class="login-box">
            <h2>Login As</h2>
            <div class="role-buttons">
                <a href="dept/department_login.jsp">Department</a>
                <a href="admin/admin_login.jsp">Admin</a>
                <a href="index.jsp">Student/Faculty</a>
            </div>
            <div class="note">Select your role to continue</div>
        </div>
    </div>

</body>
</html>