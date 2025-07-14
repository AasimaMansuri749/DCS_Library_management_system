<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String edition = request.getParameter("edition");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        int status = 0; // pending

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_management_system", "root", "");

            String sql = "INSERT INTO book_suggestions (title, author, edition, isbn, publisher, status, suggested_date) VALUES (?, ?, ?, ?, ?, ?, NOW())";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, title);
            pst.setString(2, author);
            pst.setString(3, edition);
            pst.setString(4, isbn);
            pst.setString(5, publisher);
            pst.setInt(6, status);

            int rows = pst.executeUpdate();
            con.close();

            if (rows > 0) {
%>
                <script>
                    alert("Suggestion submitted successfully!");
                    window.location.href = "user_dashboard.jsp";
                </script>
<%
            } else {
%>
                <div class="alert alert-danger">Failed to submit suggestion.</div>
<%
            }
        } catch (Exception e) {
%>
            <div class="alert alert-danger">Error: <%= e.getMessage() %></div>
<%
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Suggest a Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function validateForm() {
            const isbn = document.forms["suggestForm"]["isbn"].value.trim();
            if (isbn !== "" && !/^\d{10}(\d{3})?$/.test(isbn)) {
                alert("ISBN must be 10 or 13 digits.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body class="container mt-5">
    <h2>Suggest a Book for the Library</h2>
    <form name="suggestForm" method="post" class="mt-4 needs-validation" onsubmit="return validateForm()" novalidate>
        <div class="mb-3">
            <label class="form-label">Book Title:</label>
            <input type="text" name="title" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Author:</label>
            <input type="text" name="author" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Edition (Optional):</label>
            <input type="text" name="edition" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">ISBN (Optional):</label>
            <input type="text" name="isbn" class="form-control" pattern="\d{10}|\d{13}" title="Enter 10 or 13 digit ISBN">
        </div>
        <div class="mb-3">
            <label class="form-label">Publisher (Optional):</label>
            <input type="text" name="publisher" class="form-control">
        </div>
        <button type="submit" class="btn btn-primary">Submit Suggestion</button>
    </form>
</body>
</html>
