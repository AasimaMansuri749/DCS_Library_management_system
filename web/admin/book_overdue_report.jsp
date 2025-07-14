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
    <title>Book Overdue Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/bootstrap.min.css" rel="stylesheet">
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
    <h2 class="text-center mb-4">Overdue Report</h2>

    <!-- Date Filter Display -->
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

    <!-- Download PDF Button -->
    <div class="text-center mb-3 no-print">
        <button class="btn btn-danger" onclick="window.print()">
            <i class="bi bi-file-earmark-pdf-fill"></i> Download PDF
        </button>
    </div>

    <%
        if (!fromDate.isEmpty() && !toDate.isEmpty()) {
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

//                String sql = "SELECT br.request_id, CONCAT(u.fname, ' ', u.lname) AS user_name, u.role, u.email, " +
//                             "b.title AS book_title, b.ISBN AS b_ISBN, bc.copy_id, br.request_date, " +
//                             "bc.library_classification_number, bc.cupboard_no, bc.rack_no, " +
//                             "t.return_date, t.due_date " +
//                             "FROM book_request br " +
//                             "JOIN user u ON br.u_id = u.u_id " +
//                             "JOIN book_copies bc ON br.copy_id = bc.copy_id " +
//                             "JOIN book b ON bc.book_id = b.book_id " +
//                             "JOIN transaction t ON br.request_id = t.request_id " +
//                             "WHERE br.request_status = 2 AND t.return_date IS NOT NULL " +
//                             "AND t.return_date BETWEEN ? AND ? " +
//                             "AND t.return_date > t.due_date";


String sql = "SELECT br.request_id, CONCAT(u.fname, ' ', u.lname) AS user_name, u.role, u.email, " +
             "b.title AS book_title, b.ISBN AS b_ISBN, bc.copy_id, br.request_date, " +
             "bc.library_classification_number, bc.cupboard_no, bc.rack_no, " +
             "t.return_date, t.due_date " +
             "FROM book_request br " +
             "JOIN user u ON br.u_id = u.u_id " +
             "JOIN book_copies bc ON br.copy_id = bc.copy_id " +
             "JOIN book b ON bc.book_id = b.book_id " +
             "LEFT JOIN transaction t ON br.request_id = t.request_id " +
             "WHERE br.request_status = 4 " +// Approved requests
              "AND t.due_date BETWEEN ? AND ? " + 
             "AND t.due_date < NOW() " +       // Overdue
             "AND (t.return_date IS NULL OR t.return_date > t.due_date)";

                pst = con.prepareStatement(sql);
                pst.setString(1, fromDate);
                pst.setString(2, toDate);
                rs = pst.executeQuery();

                if (rs.isBeforeFirst()) {
    %>
    <div class="table-responsive mt-4">
        <table class="table table-bordered table-hover table-striped">
            <thead class="table-dark">
                <tr>
                    <th>User</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Book Title</th>
                    <th>ISBN</th>
                    <th>Library Classification No.</th>
                    <th>Cupboard No.</th>
                    <th>Rack No.</th>
                    <th>Request Date</th>
                    <th>Due Date</th>
                    <th>Return Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("user_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getInt("role") == 0 ? "Student" : "Faculty" %></td>
                    <td><%= rs.getString("book_title") %></td>
                    <td><%= rs.getString("b_ISBN") %></td>
                    <td><%= rs.getString("library_classification_number") %></td>
                    <td><%= rs.getString("cupboard_no") %></td>
                    <td><%= rs.getString("rack_no") %></td>
                    <td><%= rs.getDate("request_date") %></td>
                    <td><%= rs.getDate("due_date") %></td>
                    <!--<td><% // rs.getDate("return_date") %></td>-->
                    <!--<td><span class="badge bg-danger">Returned Late</span></td>-->
                    <%
    Date returnDate = rs.getDate("return_date");
%>
<td><%= returnDate != null ? returnDate : "Not Returned" %></td>
<td>
    <span class="badge bg-danger">
        <%= returnDate != null ? "Returned Late" : "Overdue" %>
    </span>
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
    <div class="alert alert-warning mt-4 text-center">
        No overdue found in the selected date range.
    </div>
    <%
                }
            } catch (Exception e) {
    %>
    <div class="alert alert-danger mt-4 text-center">
        Error: <%= e.getMessage() %>
    </div>
    <%
            } finally {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            }
        } else {
    %>
    <div class="alert alert-info mt-4 text-center">
        Please select a valid start and end date.
    </div>
    <%
        }
    %>
</div>

<a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top">
    <i class="bi bi-arrow-up"></i>
</a>
</body>
</html>
