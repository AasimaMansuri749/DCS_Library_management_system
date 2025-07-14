import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class BookDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("book_id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

            String sql = "SELECT b.*, s.name AS subject_name, p.name AS publisher_name " +
                         "FROM book b " +
                         "JOIN subject s ON b.subject_id = s.subject_id " +
                         "JOIN publisher p ON b.publisher_id = p.publisher_id " +
                         "WHERE b.book_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("isbn", rs.getString("ISBN"));
                request.setAttribute("edition", rs.getInt("edition"));
                request.setAttribute("subject", rs.getString("subject_name"));
                request.setAttribute("publisher", rs.getString("publisher_name"));
                request.setAttribute("total_copies", rs.getInt("total_copies"));
                request.setAttribute("page_count", rs.getInt("page_count"));
                request.setAttribute("book_cover_image", rs.getString("book_cover_image"));
                request.setAttribute("added_date", rs.getString("added_date"));
            }

            RequestDispatcher rd = request.getRequestDispatcher("book_details.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}