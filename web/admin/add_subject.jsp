<%@ page import="java.sql.*" %>
<%
    String newSubjectName = request.getParameter("new_subject_name");

    if (newSubjectName != null && !newSubjectName.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            // Establish DB connection (replace with your actual connection code)
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", ""); // Update credentials

            // Check for duplicate subject
            ps = con.prepareStatement("SELECT * FROM subject WHERE subject_name = ?");
            ps.setString(1, newSubjectName.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                %>
    <script>
        alert("Subject already exists.");
        window.location.href = "add_book.jsp";
    </script>
<%
            } else {
                // Insert new subject
                ps = con.prepareStatement("INSERT INTO subject (subject_name) VALUES (?)");
                ps.setString(1, newSubjectName.trim());
                int rows = ps.executeUpdate();

                if (rows > 0) {
                   %>
    <script>
        alert("Subject added successfully.");
        window.location.href = "add_book.jsp";
    </script>
    <%
        } else {
                    %>
    <script>
        alert("Failed to add subject.");
        window.location.href = "add_book.jsp";
    </script>
<%
                }
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
%>
    <script>
        alert(e.getMessage());
        window.location.href = "add_book.jsp";
    </script>
<%
        }
    } else {
%>
    <script>
        alert("Subject name cannot be empty.");
        window.location.href = "add_book.jsp";
    </script>
<%
    }
%>
<a href="your_main_form_page.jsp" class="btn btn-secondary mt-3">Back</a>