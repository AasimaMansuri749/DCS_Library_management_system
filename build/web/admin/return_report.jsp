<%@page import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String fromDate = request.getParameter("startDate");
    String toDate = request.getParameter("endDate");

    if (fromDate == null || !fromDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
        fromDate = "";
    }
    if (toDate == null || !toDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
        toDate = "";
    }
%>
<html>
<head>
    <title>Book Return Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    
        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
        }
        
        .back-to-top {
    position: fixed;
    display: none;
    right: 45px;
    bottom: 45px;
    z-index: 99;
}
    </style>
</head>
<body style="background: linear-gradient(135deg, #f2f2f2, #e6e6e6);">
<div class="container mt-5">
    <h2 class="text-center mb-4">Book Return Report</h2>

    <div class="row g-3 align-items-end mb-4 no-print">
        <div class="col-md-5">
            <label class="form-label">Start Date:</label>
            <input type="date" class="form-control" value="<%= fromDate %>" disabled>
        </div>
        <div class="col-md-5">
            <label class="form-label">End Date:</label>
            <input type="date" class="form-control" value="<%= toDate %>" disabled>
        </div>
        <div class="col-md-2 d-grid">
            <a href="report.jsp" class="btn btn-primary w-100">Back</a>
        </div>
    </div>

    <!-- PDF Download Button -->
    <!-- PDF Download Button Centered -->
<div class="text-center mb-3 no-print">
    <button class="btn btn-danger" onclick="window.print()">
        <i class="bi bi-file-earmark-pdf-fill"></i> Download PDF
    </button>
</div>


<%
    if (!fromDate.isEmpty() && !toDate.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

            String sql = "SELECT " +
                         "t.transaction_id, u.registration_no, " +
                         "CONCAT(u.fname, ' ', u.lname) AS username, " +
                         "t.issue_date, t.due_date, t.return_date, " +
                         "b.book_id, b.title AS book_title, b.ISBN, b.edition, " +
                         "c.copy_id, c.library_classification_number, c.cupboard_no, c.rack_no " +
                         "FROM transaction t " +
                         "JOIN book_request r ON t.request_id = r.request_id " +
                         "JOIN user u ON r.u_id = u.u_id " +
                         "JOIN book_copies c ON r.copy_id = c.copy_id " +
                         "JOIN book b ON c.book_id = b.book_id " +
                         "WHERE t.return_date IS NOT NULL AND t.return_date BETWEEN ? AND ?";

            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, fromDate);
            pst.setString(2, toDate);
            ResultSet rs = pst.executeQuery();

            if (rs.isBeforeFirst()) {
%>
    <div class="table-responsive mt-4">
        <table class="table table-bordered table-hover table-striped">
            <thead class="table-dark">
                <tr>
<!--                    <th>Transaction ID</th>-->
                    <th>ISBN</th>
                    <th>Title</th>
                    <th>library classification number</th>
                    <th>Registration No</th>
                    <th>Username</th>
                    <th>Issue Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
<%
    while (rs.next()) {
        java.sql.Date dueDate = rs.getDate("due_date");
        java.sql.Date returnDate = rs.getDate("return_date");
%>
                <tr>
<!--                    <td><%= rs.getInt("transaction_id") %></td>-->
                    <td><%= rs.getString("ISBN") %></td>
                    <td><%= rs.getString("book_title") %></td>
                    <td><%= rs.getString("library_classification_number") %></td>
                    <td><%= rs.getString("registration_no") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getDate("issue_date") %></td>
                    <td><%= dueDate %></td>
                    <td><%= returnDate %></td>
                    <td>
                        <% if (returnDate.after(dueDate)) { %>
                            <span class="badge rounded-pill bg-danger">Overdue</span>
                        <% } else { %>
                            <span class="badge rounded-pill bg-success">Not Overdue</span>
                        <% } %>
                    </td>
                </tr>
<%
    }
%>
            </tbody>
        </table>
    </div>
<%
        } else {
%>
    <div class="alert alert-warning mt-4 text-center">No overdue books found in the selected date range.</div>
<%
        }
        rs.close();
        pst.close();
        con.close();
    } catch (Exception e) {
%>
    <div class="alert alert-danger mt-4 text-center">Error: <%= e.getMessage() %></div>
<%
    }
} else {
%>
    <div class="alert alert-info mt-4 text-center">Please select a valid start and end date.</div>
<%
}
%>
</div>


<a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i> kjgigfk</a>

<!-- Optional: Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</body>
</html>