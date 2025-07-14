<%@ page import="java.sql.*" %>
<%
    String uid = request.getParameter("u_id");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        PreparedStatement ps = con.prepareStatement("UPDATE user SET status = 0 WHERE u_id = ?");
        ps.setString(1, uid);

        int i = ps.executeUpdate();
        if (i > 0) {
            response.sendRedirect("usermanagement.jsp?msg=User+deactivated+successfully");
        } else {
            out.println("Error updating user status.");
        }

        con.close();
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>