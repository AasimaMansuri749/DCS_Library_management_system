import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class NotifyMeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookIdStr = request.getParameter("book_id");
        String userIdStr = request.getParameter("user_id");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (bookIdStr == null || userIdStr == null || bookIdStr.equals("null") || userIdStr.equals("null")) {
            out.println("<script type='text/javascript'>");
            out.println("alert('Missing or invalid book_id or user_id.');");
            out.println("window.location='book_details.jsp';");
            out.println("</script>");
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);
        int userId = Integer.parseInt(userIdStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_management_system", "root", "");

            // Check if already requested
            PreparedStatement check = con.prepareStatement(
                "SELECT * FROM notify_requests WHERE user_id = ? AND book_id = ? AND notified = FALSE");
            check.setInt(1, userId);
            check.setInt(2, bookId);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                out.println("<script type='text/javascript'>");
                out.println("alert('You have already requested notification for this book.');");
                out.println("window.location.href = 'book_details.jsp?book_id=" + bookId + "';");
                out.println("</script>");
            } else {
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO notify_requests (user_id, book_id) VALUES (?, ?)");
                ps.setInt(1, userId);
                ps.setInt(2, bookId);
                ps.executeUpdate();

                out.println("<script type='text/javascript'>");
                out.println("alert('You will be notified when the book is available.');");
                out.println("window.location.href = 'book_details.jsp?book_id=" + bookId + "';");
                out.println("</script>");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script type='text/javascript'>");
            out.println("alert('An error occurred: " + e.getMessage().replace("'", "") + "');");
            out.println("window.location.href = 'book_details.jsp?book_id=" + bookIdStr + "';");
            out.println("</script>");
        }
    }
}
