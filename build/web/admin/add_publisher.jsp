<%@ page import="java.sql.*" %>
<%
    String newPublisherName = request.getParameter("new_publisher_name");
    if (newPublisherName == null || newPublisherName.trim().isEmpty()) {
        out.println("<div class='alert alert-danger'>Publisher name cannot be empty.</div>");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Get DB connection - adjust your connection method
        con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_management_system",
                "root",
                "");

        // Check if publisher already exists
        ps = con.prepareStatement("SELECT publisher_id FROM publisher WHERE publisher_name = ?");
        ps.setString(1, newPublisherName.trim());
        rs = ps.executeQuery();

        if (rs.next()) {
            // Publisher exists
%>
<script>
    alert("publisher Already exist.");
    window.location.href = "add_book.jsp";
</script>
<%
} else {
    rs.close();
    ps.close();

    // Insert new publisher
    ps = con.prepareStatement("INSERT INTO publisher (publisher_name) VALUES (?)");
    ps.setString(1, newPublisherName.trim());
    int rows = ps.executeUpdate();

    if (rows > 0) {
%>
<script>
    alert("Publisher added succesfully.");
    window.location.href = "add_book.jsp";
</script>
<% } else {
%>
<script>
    alert("failed to add publisher.");
    window.location.href = "add_book.jsp";
</script>
<%  }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        response.setHeader("Refresh", "5; URL=add_book.jsp");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception e) {
        }
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception e) {
        }
        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception e) {
        }
    }
%>