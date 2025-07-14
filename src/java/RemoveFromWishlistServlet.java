import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;
import java.sql.*;

public class RemoveFromWishlistServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("book_id"));
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("u_id");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

            PreparedStatement ps = conn.prepareStatement("DELETE FROM wishlist WHERE u_id = ? AND book_id = ?");
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            int rows = ps.executeUpdate();

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("wishlist.jsp");
    }
}