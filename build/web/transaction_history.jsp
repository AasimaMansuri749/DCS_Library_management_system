<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    // Session check
    Integer u_id = (Integer) session.getAttribute("u_id");
    if (u_id == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Transaction History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f9f9f9;
            padding: 20px;
        }
        h2 {
            text-align: center;
            margin: 20px 0;
        }
        table {
            width: 90%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: #fff;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #e0f0ff;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .no-data {
            text-align: center;
            margin-top: 50px;
            font-size: 1.2em;
            color: #777;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-dark navbar-dark">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4" href="#">DCS LIBRARY</a>
        <span class="navbar-text text-white ms-3">
            <%
                String fname = (String) session.getAttribute("fname");
                String lname = (String) session.getAttribute("lname");
                Integer uid = (Integer) session.getAttribute("u_id");
                if (fname != null && lname != null) {
                    out.print(fname + " " + lname);
                }
            %>
        </span>
        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle" type="button" id="profileDropdown" data-bs-toggle="dropdown">
                    Profile
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item" href="user_dashboard.jsp">search</a></li>
                    <li><a class="dropdown-item" href="wishlist.jsp">Wishlist</a></li>
                    <li><a class="dropdown-item" href="transaction_history.jsp">History</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<h2>Your Transaction History</h2>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean hasData = false;

    try {

        if (uid != null) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

          String sql = "SELECT t.transaction_id, b.title, t.issue_date, t.due_date, t.return_date " +
                         "FROM transaction t " +
                         "JOIN book_request br ON t.request_id = br.request_id " +
                         "JOIN book_copies bc ON br.copy_id = bc.copy_id " +
                         "JOIN book b ON bc.book_id = b.book_id " +
                         "WHERE br.u_id = ? ORDER BY t.issue_date DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, uid);
            rs = ps.executeQuery();

            if (rs.isBeforeFirst()) {
%>
<table>
    <tr>
        <th>Transaction ID</th>
        <th>Book Title</th>
        <th>Issue Date</th>
        <th>Due Date</th>
        <th>Return Date</th>
    </tr>
<%
                while (rs.next()) {
                    hasData = true;
%>
    <tr>
        <td><%= rs.getInt("transaction_id") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("issue_date") %></td>
        <td><%= rs.getString("due_date") %></td>
        <td><%= rs.getString("return_date") != null ? rs.getString("return_date") : "Not Returned" %></td>
    </tr>
<%
                }
%>
</table>
<%
            }
        }
    } catch (Exception e) {
%>
    <div class="alert alert-danger text-center">Error: <%= e.getMessage() %></div>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (ps != null) try { ps.close(); } catch (Exception ignored) {}
        if (con != null) try { con.close(); } catch (Exception ignored) {}
    }

    if (!hasData) {
%>
    <div class="no-data">No transactions found.</div>
<%
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>