<%@ page import="java.sql.*" %>
<%
    String uid = request.getParameter("u_id");
    String fname = request.getParameter("fname");
    String lname = request.getParameter("lname");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String status = request.getParameter("status");

    if (uid == null || uid.trim().isEmpty()) {
        out.println("<p style='color:red;'>User ID is missing.</p>");
        return;
    }

    try {
        int intStatus = Integer.parseInt(status); // Convert status to int

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");
        PreparedStatement ps = con.prepareStatement(
            "UPDATE user SET fname=?, lname=?, email=?, phone_num=?, status=?, update_date=NOW() WHERE u_id=?"
        );

        ps.setString(1, fname);
        ps.setString(2, lname);
        ps.setString(3, email);
        ps.setString(4, phone);
        ps.setInt(5, intStatus);
        ps.setString(6, uid);

        int i = ps.executeUpdate();
        ps.close();
        con.close();

        if(i > 0) {
            response.sendRedirect("usermanagement.jsp");
        } else {
            out.println("<p style='color:red;'>Failed to update user.</p>");
        }
    } catch(NumberFormatException e) {
        out.println("<p style='color:red;'>Invalid status value: " + status + "</p>");
    } catch(Exception e) {
        out.println("<p style='color:red;'>"+e+"</p>");
    }
%>