<%@ page import="java.sql.*" %>
<%
    String copyId = request.getParameter("copy_id");
    String bookId = request.getParameter("book_id_h");
    String categoryId = request.getParameter("category_id");
    String lcn = request.getParameter("lcn");
    String cupboardNo = request.getParameter("cupboard_no");
    String rackNo = request.getParameter("rack_no");
    String condition = request.getParameter("condition");
    String grievance = request.getParameter("grievance");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/library_management_system", "root", ""
        );

        // Step 1: Update the book copy details
        String sql = "UPDATE book_copies SET category_id=?, library_classification_number=?, cupboard_no=?, rack_no=?, book_condition_status=? WHERE copy_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, categoryId);
        ps.setString(2, lcn);
        ps.setString(3, cupboardNo);
        ps.setString(4, rackNo);
        ps.setString(5, condition);
        ps.setString(6, copyId);
        int rowsUpdated = ps.executeUpdate();

        // Step 2: Insert grievance only if condition is inactive and grievance is filled
        if ("0".equals(condition) && grievance != null && !grievance.trim().isEmpty()) {
            String grievanceSql = "INSERT INTO grievances (copy_id, grievance_reason) VALUES (?, ?)";
            PreparedStatement grievancePs = con.prepareStatement(grievanceSql);
            grievancePs.setString(1, copyId);
            grievancePs.setString(2, grievance);
            grievancePs.executeUpdate();
        }

        if (rowsUpdated > 0) {
            response.sendRedirect("book_all_details.jsp?book_id=" + bookId);
        } else {
            out.println("<div class='alert alert-danger'>Failed to update book copy.</div>");
        }

        con.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    }
%>