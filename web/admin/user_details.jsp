<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String uidParam = request.getParameter("u_id");
    if (uidParam == null) {
%>
        <div class="alert alert-danger m-4">User ID parameter is missing.</div>
<%
        return;
    }

    int uid = 0;
    try {
        uid = Integer.parseInt(uidParam);
    } catch (NumberFormatException e) {
%>
        <div class="alert alert-danger m-4">Invalid User ID.</div>
<%
        return;
    }

    String jdbcURL = "jdbc:mysql://localhost:3306/library_management_system";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement psUser = null;
    PreparedStatement psTxn = null;
    ResultSet rsUser = null;
    ResultSet rsTxn = null;

    String fname = "", lname = "", email = "", phone_num = "";
    int role = 0, status = 0;
    Timestamp create_date = null;
    List<Map<String, Object>> transactions = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        String sqlUser = "SELECT fname, lname, email, phone_num, role, status, create_date FROM user WHERE u_id = ?";
        psUser = conn.prepareStatement(sqlUser);
        psUser.setInt(1, uid);
        rsUser = psUser.executeQuery();

        if (!rsUser.next()) {
%>
            <div class="alert alert-warning m-4">No user found with ID <%= uid %></div>
<%
            return;
        }

        fname = rsUser.getString("fname");
        lname = rsUser.getString("lname");
        email = rsUser.getString("email");
        phone_num = rsUser.getString("phone_num");
        role = rsUser.getInt("role");
        status = rsUser.getInt("status");
        create_date = rsUser.getTimestamp("create_date");

        String sqlTxn = "SELECT t.transaction_id, b.title, b.ISBN, t.issue_date, t.due_date, t.return_date " +
                        "FROM transaction t " +
                        "JOIN book_request br ON t.request_id = br.request_id " +
                        "JOIN book_copies bc ON br.copy_id = bc.copy_id " +
                        "JOIN book b ON bc.book_id = b.book_id " +
                        "WHERE br.u_id = ?";
        psTxn = conn.prepareStatement(sqlTxn);
        psTxn.setInt(1, uid);
        rsTxn = psTxn.executeQuery();

        while (rsTxn.next()) {
            Map<String, Object> txn = new HashMap<>();
            txn.put("transaction_id", rsTxn.getInt("transaction_id"));
            txn.put("title", rsTxn.getString("title"));
            txn.put("isbn", rsTxn.getString("ISBN"));
            txn.put("issue_date", rsTxn.getDate("issue_date"));
            txn.put("due_date", rsTxn.getDate("due_date"));
            txn.put("return_date", rsTxn.getDate("return_date"));
            transactions.add(txn);
        }

    } catch (Exception e) {
%>
        <div class="alert alert-danger m-4"><%= e.getMessage() %></div>
<%
        return;
    } finally {
        try { if (rsUser != null) rsUser.close(); } catch (Exception e) {}
        try { if (rsTxn != null) rsTxn.close(); } catch (Exception e) {}
        try { if (psUser != null) psUser.close(); } catch (Exception e) {}
        try { if (psTxn != null) psTxn.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4">User Profile</h2>

    <div class="card mb-4 shadow-sm">
        <div class="card-body">
            <h5 class="card-title"><%= fname + " " + lname %></h5>
            <p class="card-text"><strong>Email:</strong> <%= email %></p>
            <p class="card-text"><strong>Phone:</strong> <%= phone_num %></p>
            <p class="card-text"><strong>Role:</strong>
                <span class="badge bg-info text-dark"><%= (role == 1) ? "Faculty" : "Student" %></span>
            </p>
            <p class="card-text"><strong>Status:</strong>
                <span class="badge <%= (status == 2) ? "bg-success" : "bg-secondary" %>">
                    <%= (status == 2) ? "Active" : "Inactive" %>
                </span>
            </p>
            <p class="card-text"><strong>Member Since:</strong> <%= create_date %></p>
        </div>
    </div>

    <h3>Transactions (<%= transactions.size() %>)</h3>

<%
    if (transactions.size() == 0) {
%>
        <div class="alert alert-info">No transactions found for this user.</div>
<%
    } else {
%>
        <div class="table-responsive">
            <table class="table table-bordered table-striped align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Book Title</th>
                        <th>ISBN</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Return Date</th>
                    </tr>
                </thead>
                <tbody>
<%
        for (Map<String, Object> txn : transactions) {
%>
                    <tr>
                        <td><%= txn.get("title") %></td>
                        <td><%= txn.get("isbn") %></td>
                        <td><%= txn.get("issue_date") %></td>
                        <td><%= txn.get("due_date") %></td>
                        <td>
                            <%= txn.get("return_date") != null ? txn.get("return_date") : "<span class='text-danger'>Not Returned</span>" %>
                        </td>
                    </tr>
<%
        }
%>
                </tbody>
            </table>
        </div>
<%
    }
%>
</div>

<!-- Bootstrap JS (optional for dropdowns etc.) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>