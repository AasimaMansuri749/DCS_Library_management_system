<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String fromDate = request.getParameter("from_date");
    String toDate = request.getParameter("to_date");

    if (fromDate == null || !fromDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
        fromDate = "";
    }
    if (toDate == null || !toDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
        toDate = "";
    }
%>
<html>
    <head>
        <title>Issue Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            @media print {
                .no-print {
                    display: none !important;
                }
            }
        </style>
    </head>

    <body style="background: linear-gradient(135deg, #f2f2f2, #e6e6e6);">
        <div class="container mt-5">
            <h2 class="text-center mb-4">Book Issue Report</h2>

            <!-- Date Inputs & Back Button (hidden when printing) -->
            <div class="row g-3 align-items-end mb-4 no-print">
                <div class="col-md-5">
                    <label for="from_date" class="form-label">Start Date:</label>
                    <input type="date" id="from_date" value="<%= fromDate%>" class="form-control" disabled>
                </div>
                <div class="col-md-5">
                    <label for="to_date" class="form-label">End Date:</label>
                    <input type="date" id="to_date" value="<%= toDate%>" class="form-control" disabled>
                </div>
                <div class="col-md-2 d-grid">
                    <a href="report.jsp" class="btn btn-primary w-100">Back</a>
                </div>
            </div>

            <!-- PDF Button (hidden when printing) -->
            <div class="text-center mb-4 no-print">
                <button class="btn btn-danger" onclick="window.print()">
                    <i class="bi bi-file-earmark-pdf-fill"></i> Download PDF
                </button>
            </div>

            <%
                if (!fromDate.isEmpty() && !toDate.isEmpty()) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/library_management_system", "root", "");

                        String sql = "SELECT " +
                                     "t.transaction_id, " +
                                     "u.registration_no, " +
                                     "CONCAT(u.fname, ' ', u.lname) AS username, " +
                                     "t.issue_date, " +
                                     "t.due_date, " +
                                     "t.return_date, " +
                                     "b.book_id, " +
                                     "b.title AS book_title, " +
                                     "b.ISBN, " +
                                     "b.edition, " +
                                     "c.copy_id, " +
                                     "c.library_classification_number, " +
                                     "c.cupboard_no, " +
                                     "c.rack_no, " +
                                     "r.request_date " +
                                     "FROM transaction t " +
                                     "JOIN book_request r ON t.request_id = r.request_id " +
                                     "JOIN user u ON r.u_id = u.u_id " +
                                     "JOIN book_copies c ON r.copy_id = c.copy_id " +
                                     "JOIN book b ON c.book_id = b.book_id " +
                                     "WHERE t.issue_date BETWEEN ? AND ?";

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
<!--                            <th>Transaction ID</th>-->
                            <th>Registration number</th>
                            <th>Username</th>
                            <th>Issue date</th>
                            <th>Due date</th>
<!--                            <th>Book ID</th>-->
                            <th>Title</th>
<!--                            <th>Copy ID</th>-->
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            while (rs.next()) {
                        %>
                        <tr>
<!--                            <td><%= rs.getString("transaction_id")%></td>-->
                            <td><%= rs.getString("registration_no")%></td>
                            <td><%= rs.getString("username")%></td>
                            <td><%= rs.getString("issue_date")%></td>
                            <td><%= rs.getDate("due_date")%></td>
<!--                            <td><%= rs.getInt("book_id")%></td>-->
                            <td><%= rs.getString("book_title")%></td>
<!--                            <td><%= rs.getString("copy_id")%></td>-->
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
                No records found in the selected date range.
            </div>
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
    </body>
</html>