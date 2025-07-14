import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AddToWishlistServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("u_id") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int u_id = (int) session.getAttribute("u_id");
        String bookIdStr = request.getParameter("book_id");

        if (bookIdStr == null) {
            session.setAttribute("wishlist_msg", "❌ Invalid book ID.");
            response.sendRedirect("wishlist.jsp");
            return;
        }

        int book_id = Integer.parseInt(bookIdStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_management_system", "root", "");

            // Try normal insert, and catch duplicate exception
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO wishlist (u_id, book_id) VALUES (?, ?)");
            ps.setInt(1, u_id);
            ps.setInt(2, book_id);

            ps.executeUpdate();
            session.setAttribute("wishlist_msg", " Book added to wishlist!");

            ps.close();
            conn.close();

        } catch (SQLIntegrityConstraintViolationException e) {
            // Duplicate book
            session.setAttribute("wishlist_msg", " This book is already in your wishlist.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("wishlist_msg", " Server error. Please try again.");
        }

        response.sendRedirect("wishlist.jsp");
    }
}