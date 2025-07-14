<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    int status = Integer.parseInt(request.getParameter("status"));
    String resignationDateStr = request.getParameter("resignation_date");

    String jdbcURL = "jdbc:mysql://localhost:3306/library_management_system";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

        String sql = "UPDATE admin SET name = ?, email = ?, phone_num = ?, status = ?, resignation_date = ? WHERE a_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setInt(4, status);

        if (resignationDateStr != null && !resignationDateStr.trim().isEmpty()) {
            ps.setDate(5, java.sql.Date.valueOf(resignationDateStr));
        } else {
            ps.setNull(5, java.sql.Types.DATE);
        }

        ps.setInt(6, id);
        ps.executeUpdate();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

    response.sendRedirect("success.jsp");
%>
