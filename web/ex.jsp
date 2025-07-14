<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DCS Library - Welcome</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(to right, #89f7fe, #66a6ff);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
        }

        .navbar, .marquee-box {
            background-color: #000;
            color: #fff;
        }

        .marquee-box {
            font-weight: 500;
            font-size: 16px;
            padding: 8px 0;
            border-bottom: 1px solid #222;
        }

        .marquee-text {
            white-space: nowrap;
            overflow: hidden;
            display: block;
        }

        .marquee-text span {
            display: inline-block;
            padding-left: 100%;
            animation: scroll-left 15s linear infinite;
        }

        @keyframes scroll-left {
            0% { transform: translateX(0); }
            100% { transform: translateX(-100%); }
        }

        .welcome-section {
            min-height: calc(100vh - 112px); /* 56px navbar + 56px marquee */
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
        }

        .welcome-box {
            background-color: #ffffff;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            max-width: 600px;
            width: 90%;
        }

        .welcome-box h1 {
            font-weight: bold;
            margin-bottom: 30px;
            color: #333;
        }

        .btn-custom {
            font-size: 16px;
            padding: 12px 28px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-custom:hover {
            transform: translateY(-2px);
        }

        @media (max-width: 576px) {
            .btn-custom {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="#">DCS LIBRARY</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>
</nav>

<!-- Custom Marquee (Two slogans alternating) -->
<div class="marquee-box mt-5 pt-2 text-white text-center">
    <div class="marquee-text" id="sloganContainer">
        <span id="sloganText">📚 Welcome to the DCS Library Management System – Your Gateway to Knowledge! 📖</span>
    </div>
</div>

<!-- Welcome Section -->
<div class="welcome-section">
    <div class="welcome-box">
        <h1>Welcome to DCS Library</h1>
        <div class="d-flex flex-column flex-md-row justify-content-center gap-3">
            <a href="department_login.jsp" class="btn btn-outline-dark btn-custom">
                <i class="fas fa-building"></i> Department
            </a>
            <a href="admin_login.jsp" class="btn btn-outline-primary btn-custom">
                <i class="fas fa-user-shield"></i> Admin
            </a>
            <a href="student_login.jsp" class="btn btn-outline-success btn-custom">
                <i class="fas fa-user-graduate"></i> Student
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Slogan Switching Script -->
<script>
    const slogans = [
        "📚 Welcome to the DCS Library – Your Gateway to Knowledge! 📖",
        "💡 Access Books Anytime, Anywhere – Empowering Every Learner!"
    ];
    let index = 0;
    const sloganText = document.getElementById("sloganText");

    setInterval(() => {
        index = (index + 1) % slogans.length;
        sloganText.innerHTML = slogans[index];
    }, 15000); // switch every 15 seconds
</script>
</body>
</html>
