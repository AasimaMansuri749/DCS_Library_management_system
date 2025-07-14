<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Signup</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
       body {
    padding-top: 80px; /* Room for the navbar */
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background: linear-gradient(to right, #a1c4fd, #c2e9fb);
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
    const sendBtn = document.getElementById("sendBtn");

    // Simple validation
    if (name === "" || email === "" || phone.length !== 10 || isNaN(phone)) {
        alert("Please fill all fields correctly before sending OTP.");
        return;
    }

    sendBtn.disabled = true;
    sendBtn.style.backgroundColor = "#cccccc";
    sendBtn.style.cursor = "not-allowed";

    const xhr = new XMLHttpRequest();
    xhr.open("POST", "/library_management_system/dept/SendDeptSignupOtpServlet", true);
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
            sendBtn.style.display = "none"; // Hide on success
        } else {
            alert("Error: " + response);
            sendBtn.disabled = false;
            sendBtn.style.backgroundColor = "#1e6cfb";
            sendBtn.style.cursor = "pointer";
        }
    };

    xhr.onerror = function () {
        alert("Failed to send OTP. Please try again.");
        sendBtn.disabled = false;
        sendBtn.style.backgroundColor = "#1e6cfb";
        sendBtn.style.cursor = "pointer";
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
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm mb-4 w-100 position-absolute top-0 start-0">
    <div class="container-fluid">
        <!-- Brand Name -->
        <a class="navbar-brand fw-bold fs-4" href="#">DCS Library</a>

        <!-- Toggler for mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" 
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar items -->
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <!-- Home button -->
                    <a class="btn btn-outline-light fw-semibold px-4" href="../welcome.jsp">Home</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="signup-box">
    <h3 class="text-center mb-3">Department Signup</h3>
    <div id="successMsg" class="success-msg">OTP Sent to your email.</div>

    <form action="/library_management_system/dept/VerifyDeptSignupOtpServlet" method="post">

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