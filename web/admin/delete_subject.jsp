<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Fetch subjectId from request parameter
    String subjectIdParam = request.getParameter("subjectId");

    if(subjectIdParam != null && !subjectIdParam.isEmpty()) {
        try {
            int subjectId = Integer.parseInt(subjectIdParam);

            // Establish DB connection
              Class.forName("com.mysql.cj.jdbc.Driver");

            // Create connection
            
            Connection con =  DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_management_system",
                    "root",
                    "");

            // Optional: Check if there are any books under this subject first (prevent deletion if needed)
            PreparedStatement checkBooks = con.prepareStatement("SELECT COUNT(*) FROM book WHERE subject_id = ?");
            checkBooks.setInt(1, subjectId);
            ResultSet rs = checkBooks.executeQuery();
            rs.next();
            int bookCount = rs.getInt(1);

            if(bookCount > 0) {
                // If subject has books, block deletion
                response.sendRedirect("subject.jsp?msg=Subject contains books. Cannot delete.");
            } else {
                // Delete subject
                PreparedStatement pst = con.prepareStatement("DELETE FROM subject WHERE subject_id = ?");
                pst.setInt(1, subjectId);
                int rowsAffected = pst.executeUpdate();

                if(rowsAffected > 0) {
                    response.sendRedirect("subject.jsp?msg=Subject deleted successfully.");
                } else {
                    response.sendRedirect("subject.jsp?msg=Failed to delete subject.");
                }
            }

            con.close();

        } catch(Exception e) {
            out.print("Error: " + e.getMessage());
        }
    } else {
        response.sendRedirect("subject.jsp?msg=Invalid Subject ID.");
    }
%>