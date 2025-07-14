<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Signup</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background:linear-gradient(to right, #a1c4fd, #c2e9fb);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .signup-box {
            background-color: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 400px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        button {
            background-color: #1e6cfb;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 8px;
            width: 100%;
        }
        .success-msg {
            color: green;
            text-align: center;
            margin-bottom: 10px;
            display: none;
        }
    </style>
    <script>
        function sendOTP(event) {
            event.preventDefault();

            const name = document.getElementById("name").value.trim();
            const email = document.getElementById("email").value.trim();
            const phone = document.getElementById("phone").value.trim();

            // Simple validation
            if (name === "" || email === "" || phone.length !== 10 || isNaN(phone)) {
                alert("Please fill all fields correctly before sending OTP.");
                return;
            }

            const xhr = new XMLHttpRequest();
xhr.open("POST", "/library_management_system/dept/SendSignupOTPServlet", true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

            xhr.onload = function () {
                const response = xhr.responseText.trim();
                console.log("Server Response:", response);

                if (xhr.status === 200 && response.includes("OTP Sent")) {
                    document.getElementById("successMsg").style.display = "block";
                    document.getElementById("otpFields").style.display = "block";

                    document.getElementById("name").readOnly = true;
                    document.getElementById("email").readOnly = true;
                    document.getElementById("phone").readOnly = true;
                    document.getElementById("sendBtn").style.display = "none";
                } else {
                    alert("Error: " + response);
                }
            };

            xhr.send("name=" + encodeURIComponent(name) +
                     "&email=" + encodeURIComponent(email) +
                     "&phone=" + encodeURIComponent(phone));
        }

        function restrictPhoneLength(input) {
            if (input.value.length > 10) {
                input.value = input.value.slice(0, 10);
            }
        }
    </script>
</head>
<body>

<div class="signup-box">
    <h3 class="text-center mb-3">Admin Signup</h3>
    <div id="successMsg" class="success-msg">OTP Sent to your email.</div>

<form action="/library_management_system/dept/VerifySignupOTPServlet" method="post">

        <div class="form-group">
            <label>Name</label>
            <input type="text" id="name" name="name" class="form-control" required placeholder="Full Name">
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" id="email" name="email" class="form-control" required placeholder="example@gmail.com">
        </div>

        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" id="phone" name="phone" class="form-control" required placeholder="10-digit number" maxlength="10" oninput="restrictPhoneLength(this)">
        </div>

        <div class="form-group">
            <button type="button" id="sendBtn" onclick="sendOTP(event)">Send OTP</button>
        </div>

        <!-- OTP input, hidden initially -->
        <div id="otpFields" style="display: none;">
            <div class="form-group">
                <label>Enter OTP</label>
                <input type="text" name="otp" class="form-control" required placeholder="Enter OTP">
            </div>

            <div class="form-group">
                <button type="submit">Verify & Signup</button>
            </div>
        </div>

    </form>
</div>
<%
    String otpError = (String) session.getAttribute("otpError");
    if ("true".equals(otpError)) {
%>
<script>
    alert("Invalid OTP. Please try again.");
</script>
<%
        session.removeAttribute("otpError"); // Clear the flag after showing
    }
%>
</body>
</html>
