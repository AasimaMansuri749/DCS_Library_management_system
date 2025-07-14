<%@ page import="java.sql.*" %>
<%
    String subjectId = request.getParameter("subjectId");
    String subjectName = request.getParameter("subjectName");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        PreparedStatement ps = con.prepareStatement("UPDATE subject SET subject_name = ? WHERE subject_id = ?");
        ps.setString(1, subjectName);
        ps.setString(2, subjectId);
        
        int i = ps.executeUpdate();
        con.close();

        if(i > 0) {
            response.sendRedirect("subject.jsp"); // or any page showing updated list
        } else {
            out.println("Update failed.");
        }
    } catch(Exception e) {
        out.println(e);
    }
%>