<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    // Check if OTP was sent
    Boolean otpSent = (Boolean) session.getAttribute("otpSent");
    if (otpSent == null) otpSent = false;
    session.removeAttribute("otpSent"); // clear after displaying
%>
<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-container {
            background: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        .form-container h3 {
            margin-bottom: 20px;
        }
        .form-container input[type="number"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form-container button {
            padding: 10px 20px;
            background-color: #007BFF;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-container button:hover {
            background-color: #0056b3;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <% if (otpSent) { %>
            <div class="success-message">OTP sent successfully!</div>
        <% } %>
        <form action="../Verify_request_otp" method="post">
            <h3>Enter OTP</h3>
            <input type="number" name="otp" required placeholder="Enter your OTP">
            <button type="submit">Verify</button>
        </form>
    </div>
</body>
</html>