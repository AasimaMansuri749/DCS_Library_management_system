<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));

    String jdbcURL = "jdbc:mysql://localhost:3306/library_management_system";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String name = "", email = "", phone = "";
    int status = 1;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        ps = conn.prepareStatement("SELECT * FROM admin WHERE a_id = ?");
        ps.setInt(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone_num");
            status = rs.getInt("status");
            // Don't pre-fill resignation date
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-card {
            max-width: 600px;
            margin: auto;
            background-color: #ffffff;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="form-card">
        <h2 class="mb-4 text-center text-primary">Edit Admin Details</h2>

        <form method="post" action="update_admin.jsp">
            <input type="hidden" name="id" value="<%= id %>">

            <div class="mb-3">
                <label class="form-label">Name</label>
                <input type="text" name="name" class="form-control" value="<%= name %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="<%= email %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="text" name="phone" class="form-control" value="<%= phone %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Status</label>
                <select name="status" class="form-select" required>
                    <option value="1" <%= (status == 1 ? "selected" : "") %>>Active</option>
                    <option value="0" <%= (status == 0 ? "selected" : "") %>>Inactive</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Resignation Date</label>
                <input type="date" name="resignation_date" class="form-control" value="">
            </div>

            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-success">Update</button>
                <a href="success.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
