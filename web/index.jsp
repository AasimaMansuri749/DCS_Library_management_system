<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
    <script>
        function sendOTP(event) {
    event.preventDefault();

    var email = document.getElementById("email").value;
    var sendBtn = document.getElementById("sendBtn");

    // Disable the button and visually indicate it
    sendBtn.disabled = true;
    sendBtn.style.backgroundColor = "#a0c4ff";
    sendBtn.style.cursor = "not-allowed";

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "SendOTPServlet", true);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        if (xhr.status === 200 && xhr.responseText.trim().startsWith("OTP Sent")) {
            // Show success message
            document.getElementById("otpMessage").innerText = xhr.responseText;
            document.getElementById("otpMessage").style.display = "block";

            // Show OTP input and Verify button
            document.getElementById("otpFields").style.display = "block";

            // Make email readonly
            document.getElementById("email").readOnly = true;

            // Remove the Send OTP button completely
            sendBtn.parentNode.removeChild(sendBtn);
        } else {
            alert("Error: " + xhr.responseText);

            // Re-enable the button in case of failure
            sendBtn.disabled = false;
            sendBtn.style.backgroundColor = "#1e6cfb";
            sendBtn.style.cursor = "pointer";
        }
    };

    xhr.send("email=" + encodeURIComponent(email));
}



        function validateOTP() {
            var otp = document.querySelector("input[name='otp']").value;
            if (otp.trim() === "") {
                alert("Please enter the OTP.");
                return false;
            }
            return true;
        }
    </script>

    <style>
      body {
    padding-top: 80px; /* Room for the navbar */
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background: linear-gradient(to right, #a1c4fd, #c2e9fb);
}

        .card {
            padding: 30px;
            border-radius: 15px;
            background: white;
            width: 400px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        input, button {
            width: 100%;
        }
        button {
            background-color: #1e6cfb;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 8px;
        }
        #otpMessage {
            color: green;
            text-align: center;
            display: none;
            margin-bottom: 10px;
        }
    </style>
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
                    <a class="btn btn-outline-light fw-semibold px-4" href="welcome.jsp">Home</a>
                </li>
            </ul>
        </div>
    </div>
</nav>



<div class="card">
    <h3 class="text-center mb-4">Sign in to DCS Library</h3>

    <!-- Message -->
    <p id="otpMessage"></p>

    <!-- Form -->
    <form action="VerifyOTPServlet" method="post" onsubmit="return validateOTP();">
        <!-- Email -->
        <div class="form-group">
            <label>Email</label>
            <input type="email" id="email" name="email" required placeholder="name@gmail.com">
        </div>

        <!-- Send OTP Button -->
        <div class="form-group">
            <button type="button" id="sendBtn" onclick="sendOTP(event)">Send OTP</button>
        </div>

        <!-- OTP Fields (initially hidden) -->
        <div id="otpFields" style="display: none;">
            <div class="form-group">
                <label>Enter OTP</label>
                <input type="text" name="otp" required placeholder="Enter OTP">
            </div>

            <div class="form-group">
                <button type="submit">Verify OTP</button>
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