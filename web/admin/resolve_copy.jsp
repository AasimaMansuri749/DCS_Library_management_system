<%@ page import="java.sql.*, java.time.LocalDate" %>
<%
    String copyIdStr = request.getParameter("copy_id");
    String bookIdStr = request.getParameter("book_id");

    int copyId = Integer.parseInt(copyIdStr);
    int bookId = Integer.parseInt(bookIdStr);

    Connection con = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        //  1. Update book_copies
        String updateCopySql = "UPDATE book_copies SET book_condition_status = 1 WHERE copy_id = ?";
        ps1 = con.prepareStatement(updateCopySql);
        ps1.setInt(1, copyId);
        int update1 = ps1.executeUpdate();

        //  2. Update grievances
        String updateGrievanceSql = "UPDATE grievances SET resolved_status = 1, resolved_date = NOW() WHERE copy_id = ?";
        ps2 = con.prepareStatement(updateGrievanceSql);
        ps2.setInt(1, copyId);
        int update2 = ps2.executeUpdate();

        if (update1 > 0 || update2 > 0) {
            out.println("<script>alert('Copy reactivated and grievance resolved successfully.'); window.location='book_all_details.jsp?book_id=" + bookId + "';</script>");
        } else {
            out.println("<script>alert('Update failed.'); window.location='book_all_details.jsp?book_id=" + bookId + "';</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (ps1 != null) ps1.close();
        if (ps2 != null) ps2.close();
        if (con != null) con.close();
    }
%>