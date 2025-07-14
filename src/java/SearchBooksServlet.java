import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

public class SearchBooksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Load the JDBC Driver First
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Error loading MySQL JDBC Driver: " + e.getMessage());
            return; // Stop execution if driver not found
        }

        // Get search parameters
        String isbn = request.getParameter("isbn");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        String subject = request.getParameter("subject");
        

        List<String> conditions = new ArrayList<>();
        List<String> values = new ArrayList<>();

        if (isbn != null && !isbn.trim().isEmpty()) {
            conditions.add("b.ISBN LIKE ?");
            values.add("%" + isbn.trim() + "%");
        }
        if (title != null && !title.trim().isEmpty()) {
            conditions.add("b.title LIKE ?");
            values.add("%" + title.trim() + "%");
        }
        if (author != null && !author.trim().isEmpty()) {
            conditions.add("a.author_name LIKE ?");
            values.add("%" + author.trim() + "%");
        }
        if (publisher != null && !publisher.trim().isEmpty()) {
            conditions.add("p.publisher_name LIKE ?");
            values.add("%" + publisher.trim() + "%");
        }
        if (subject != null && !subject.trim().isEmpty()) {
            conditions.add("s.subject_name LIKE ?");
            values.add("%" + subject.trim() + "%");
        }

       String sql = "SELECT b.book_id, b.ISBN, b.title, b.book_cover_image, b.edition, b.page_count, " +
             "IFNULL(GROUP_CONCAT(DISTINCT a.author_name SEPARATOR ', '), 'N/A') AS author_name, " +
             "IFNULL(p.publisher_name, 'N/A') AS publisher_name, " +
             "IFNULL(s.subject_name, 'N/A') AS subject_name " +
             "FROM book b " +
             "LEFT JOIN book_author ba ON b.book_id = ba.book_id " +
             "LEFT JOIN author a ON ba.author_id = a.author_id " +
             "LEFT JOIN publisher p ON b.publisher_id = p.publisher_id " +
             "LEFT JOIN subject s ON b.subject_id = s.subject_id";

if (!conditions.isEmpty()) {
    sql += " WHERE " + String.join(" AND ", conditions);
}

sql += " GROUP BY b.book_id";


        try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_management_system", "root", "");
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameter values dynamically
            for (int i = 0; i < values.size(); i++) {
                ps.setString(i + 1, values.get(i));
            }

            ResultSet rs = ps.executeQuery();
            List<Map<String, String>> bookList = new ArrayList<>();

            while (rs.next()) {
                Map<String, String> book = new HashMap<>();
                book.put("book_id", rs.getString("book_id"));
                book.put("ISBN", rs.getString("ISBN"));
                book.put("title", rs.getString("title"));
                book.put("author", rs.getString("author_name"));
                book.put("publisher", rs.getString("publisher_name"));
                book.put("subject", rs.getString("subject_name"));
                book.put("book_cover_image", rs.getString("book_cover_image"));
                book.put("edition", rs.getString("edition"));
                book.put("page_count", rs.getString("page_count"));

                bookList.add(book);
            }

            request.setAttribute("bookList", bookList);
            RequestDispatcher rd = request.getRequestDispatcher("search_results.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}