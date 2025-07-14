<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Invalidate session
    session.invalidate();

    // Redirect to index.jsp after 3 seconds
    response.setHeader("Refresh", "1; URL=index.jsp");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <div class="container text-center mt-5">
        <div class="alert alert-info shadow-sm">
            <h4 class="mb-2">You have been logged out successfully.</h4>
            <p>Redirecting to the home page...</p>
        </div>
    </div>
</body>
</html>