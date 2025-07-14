<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 80px; /* Room for fixed navbar */
            background: linear-gradient(to right, #a1c4fd, #c2e9fb);
            min-height: 100vh;
        }
    </style>
</head>

<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="#">DCS Library</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
      <div class="dropdown">
        <button class="btn btn-outline-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
          Manage
        </button>
        <ul class="dropdown-menu dropdown-menu-end">
          <li><a class="dropdown-item" href="signup.jsp">Add Admin</a></li>
          <li><a class="dropdown-item" href="dept_signup.jsp">Add Department Member</a></li>
          <li><hr class="dropdown-divider"></li>
          <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
        </ul>
      </div>
    </div>
  </div>
</nav>

<!-- Main Content -->
<div class="container mt-5">
    <h2 class="mb-4 text-center">Admin List</h2>

    <table class="table table-bordered table-hover table-striped align-middle">
        <thead class="table-dark">
            <tr>
                <th>ID</th><th>Name</th><th>Email</th><th>Phone</th>
                <th>Joining Date</th><th>Resignation Date</th><th>Status</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                String jdbcURL = "jdbc:mysql://localhost:3306/library_management_system";
                String dbUser = "root";
                String dbPass = "";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

                    String sql = "SELECT * FROM admin";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                    while (rs.next()) {
                        int id = rs.getInt("a_id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone_num");
                        Timestamp joiningDate = rs.getTimestamp("joining_date");
                        Timestamp resignationDate = rs.getTimestamp("resignation_date");
                        int status = rs.getInt("status");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= (name != null && !name.trim().isEmpty()) ? name : "-" %></td>
                <td><%= (email != null && !email.trim().isEmpty()) ? email : "-" %></td>
                <td><%= (phone != null && !phone.trim().isEmpty()) ? phone : "-" %></td>
                <td><%= (joiningDate != null) ? sdf.format(joiningDate) : "-" %></td>
                <td><%= (resignationDate != null) ? sdf.format(resignationDate) : "-" %></td>
                <td>
                    <span class="badge <%= (status == 1 ? "bg-success" : "bg-danger") %>">
                        <%= (status == 1 ? "Active" : "Inactive") %>
                    </span>
                </td>
                <td>
                    <a href="edit_admin.jsp?id=<%= id %>" class="btn btn-sm btn-primary">Edit</a>
                    <% if (status == 1) { %>
                        <a href="delete_admin.jsp?id=<%= id %>" class="btn btn-sm btn-danger"
                           onclick="return confirm('Are you sure you want to deactivate this admin?');">Inactive</a>
                    <% } else { %>
                        <button class="btn btn-sm btn-outline-secondary" disabled>Inactive</button>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>
</div>

        
        
        
        <!--_-->
        
        <div class="container mt-5">
    <h2 class="mb-4 text-center">Department Member List</h2>

    <table class="table table-bordered table-hover table-striped align-middle">
        <thead class="table-dark">
            <tr>
                <th>ID</th><th>Name</th><th>Email</th><th>Phone</th>
                <th>Joining Date</th><th>Resignation Date</th><th>Status</th>
            </tr>
        </thead>
        <tbody>
            <%
                 conn = null;
                 ps = null;
                 rs = null;

                 jdbcURL = "jdbc:mysql://localhost:3306/library_management_system";
                 dbUser = "root";
                 dbPass = "";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

                    String sql = "SELECT * FROM department";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();

                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                    while (rs.next()) {
                        int id = rs.getInt("d_id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone_num");
                        Timestamp joiningDate = rs.getTimestamp("joining_date");
                        Timestamp resignationDate = rs.getTimestamp("resignation_date");
                        int status = rs.getInt("status");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= (name != null && !name.trim().isEmpty()) ? name : "-" %></td>
                <td><%= (email != null && !email.trim().isEmpty()) ? email : "-" %></td>
                <td><%= (phone != null && !phone.trim().isEmpty()) ? phone : "-" %></td>
                <td><%= (joiningDate != null) ? sdf.format(joiningDate) : "-" %></td>
                <td><%= (resignationDate != null) ? sdf.format(resignationDate) : "-" %></td>
                <td>
                    <span class="badge <%= (status == 1 ? "bg-success" : "bg-danger") %>">
                        <%= (status == 1 ? "Active" : "Inactive") %>
                    </span>
                </td>
                
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 