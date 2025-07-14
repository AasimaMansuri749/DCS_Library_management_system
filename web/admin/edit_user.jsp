<%@ page import="java.sql.*" %>
<%
    String uid = request.getParameter("u_id");
    String fname = "", lname = "", email = "", phone = "";
    int role = 0;
    String status = "";
    String roleDisplay = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");
        PreparedStatement ps = con.prepareStatement("SELECT * FROM user WHERE u_id = ?");
        ps.setString(1, uid);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            fname = rs.getString("fname");
            lname = rs.getString("lname");
            email = rs.getString("email");
            phone = rs.getString("phone_num");
            role = rs.getInt("role");
            status = String.valueOf(rs.getInt("status"));
            roleDisplay = (role == 1) ? "Faculty" : "Student";
        }

        con.close();
    } catch(Exception e) {
        out.println("<p style='color:red;'>"+e+"</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            margin-top: 50px;
        }
        .card {
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
        }
        .form-label {
            font-weight: 500;
        }
    </style>
</head>
<body>

<div class="container form-container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card border-0">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-pencil-square"></i> Edit User</h4>
                </div>
                <div class="card-body">
                    <form action="update_user.jsp" method="post">
                        <input type="hidden" name="u_id" value="<%= uid %>">

                        <div class="mb-3">
                            <label class="form-label">First Name</label>
                            <input type="text" name="fname" value="<%= fname %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Last Name</label>
                            <input type="text" name="lname" value="<%= lname %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" value="<%= email %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Phone Number</label>
                            <input type="text" name="phone" value="<%= phone %>" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Role</label>
                            <input type="text" class="form-control" value="<%= roleDisplay %>" disabled>
                            <input type="hidden" name="role" value="<%= role %>"> <!-- Still sends role as TINYINT -->
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select name="status" class="form-select">
                                <option value="0" <%= "0".equals(status) ? "selected" : "" %>>Inactive</option>
                                <option value="1" <%= "1".equals(status) ? "selected" : "" %>>Active</option>
                            </select>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="usermanagement.jsp" class="btn btn-secondary">
                                <i class="bi bi-arrow-left-circle"></i> Back
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> Update
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>