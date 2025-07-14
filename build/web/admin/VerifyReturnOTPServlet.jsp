<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Verify Return OTP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
        }
        .otp-form-container {
            max-width: 500px;
            margin: 80px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

<div class="otp-form-container">
    <h3 class="text-center mb-4">Verify Return OTP</h3>

    <%-- Show OTP sent message from session --%>
    <%
        Boolean otpSent = (Boolean) session.getAttribute("otpSent");
        if (otpSent != null && otpSent) {
    %>
        <div class="alert alert-success text-center" role="alert">
            OTP sent successfully!
        </div>
    <%
            session.removeAttribute("otpSent"); // Clear flag after showing
        }
    %>

    <%-- Show other messages from request scope --%>
    <%
        String success = (String) request.getAttribute("success");
        String error = (String) request.getAttribute("error");
        if (success != null) {
    %>
        <div class="alert alert-success text-center" role="alert"><%= success %></div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger text-center" role="alert"><%= error %></div>
    <% } %>

    <form action="../VerifyReturnOTPServlet" method="post">
        <div class="mb-3">
            <label for="otp" class="form-label">Enter OTP</label>
            <input type="text" id="otp" name="otp" class="form-control text-center"
                   required pattern="\d{6}" maxlength="6" placeholder="6-digit OTP" />
        </div>
        <div class="d-grid">
            <button type="submit" class="btn btn-primary">Verify</button>
        </div>
    </form>
</div>

</body>
</html>
