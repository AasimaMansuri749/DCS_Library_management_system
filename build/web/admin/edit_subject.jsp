<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit Subject</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow-lg rounded-4">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">Edit Subject</h4>
            </div>
            <div class="card-body">
                <%
                    String subjectId = request.getParameter("subjectId");
                    String subjectName = "";

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/library_management_system", "root", "");

                        PreparedStatement ps = con.prepareStatement("SELECT subject_name FROM subject WHERE subject_id = ?");
                        ps.setString(1, subjectId);
                        ResultSet rs = ps.executeQuery();

                        if (rs.next()) {
                            subjectName = rs.getString("subject_name");
                        }

                        con.close();
                    } catch(Exception e) {
                        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                    }
                %>

                <form action="update_subject.jsp" method="post">
                    <input type="hidden" name="subjectId" value="<%= subjectId %>">

                    <div class="mb-3">
                        <label for="subjectName" class="form-label">Subject Name</label>
                        <input type="text" class="form-control" id="subjectName" name="subjectName" value="<%= subjectName %>" required>
                    </div>

                    <button type="submit" class="btn btn-primary">
    <i class="bi bi-check-circle"></i> Update Subject
</button>

                    <a href="subject.jsp" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>