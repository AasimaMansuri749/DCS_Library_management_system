
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/HandleSuggestionServlet")
public class HandleSuggestionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int suggestionId = Integer.parseInt(request.getParameter("suggestion_id"));
        String action = request.getParameter("action");

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", ""); 
            PreparedStatement stmt = conn.prepareStatement("UPDATE book_suggestions SET status = ? WHERE id = ?")) {

            if ("reject".equals(action)) {
                stmt.setInt(1, 3); // status = 3
            } else if ("add".equals(action)) {
                stmt.setInt(1, 2); // status = 2
            }

            stmt.setInt(2, suggestionId); // suggestion_id for WHERE clause
            stmt.executeUpdate();
            stmt.executeUpdate();

// Redirect AFTER status has been updated
            if ("add".equals(action)) {
                response.sendRedirect("admin/add_book.jsp");
            } else {
                response.sendRedirect("Book Suggestions.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
