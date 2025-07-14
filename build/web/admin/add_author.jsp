<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.*, jakarta.servlet.http.*" %>
<%
    String authorName = request.getParameter("new_author_name");

    if (authorName != null && !authorName.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

            
            // Check if author already exists (case-insensitive)
            String checkSql = "SELECT author_id FROM author WHERE LOWER(author_name) = LOWER(?)";
            ps = conn.prepareStatement(checkSql);
            ps.setString(1, authorName.trim());
            rs = ps.executeQuery();

            if (rs.next()) {
%>
                <script>
                    alert("Author already exists.");
                    window.location.href = "add_book.jsp";
                </script>
<%
            } else {
                rs.close();
                ps.close();
            
            // Insert query
            String sql = "INSERT INTO author (author_name) VALUES (?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, authorName);
            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
%>
                <script>
                    alert("Author added successfully!");
                    window.location.href = "add_book.jsp"; // Change this to the page you want to redirect to
                </script>
<%
            } else {
%>
                <script>
                    alert("Failed to add author. Please try again.");
                    history.back();
                </script>
<%
            }}
        } catch (Exception e) {
%>
            <script>
                alert("Error: <%= e.getMessage() %>");
                history.back();
            </script>
<%
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
%>
        <script>
            alert("Author name is required.");
            history.back();
        </script>
<%
    }
%>