import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class RequestverifyOtp extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userEnteredOtp = Integer.parseInt(request.getParameter("otp"));

        HttpSession session = request.getSession();
        int originalOtp = (int) session.getAttribute("otp");
        int requestId = (int) session.getAttribute("request_id");
       int copyId = (int) session.getAttribute("copy_id");
        if (userEnteredOtp == originalOtp) {
            try (Connection conn = DBConnection.getConnection()) {

                // Mark request as collected
                String updateStatus = "UPDATE book_request SET request_status = 4, collected_time = NOW() WHERE request_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateStatus)) {
                    ps.setInt(1, requestId);
                    ps.executeUpdate();
                }

                // Mark copy as issued
                markCopyAsAvailable(conn,copyId);

                response.getWriter().write("Book collected successfully.");
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("Error during verification.");
            }
        } else {
            response.getWriter().write("Invalid OTP.");
        }
    }

    private void markCopyAsAvailable(Connection conn, int copyId) throws SQLException {
        String checkSql = "SELECT 1 FROM book_request WHERE copy_id = ? AND request_status = 4";
        try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, copyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String updateSql = "UPDATE book_copies SET book_reservation_status = 0 WHERE copy_id = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, copyId);
                        updatePs.executeUpdate();
                    }
                }
            }
        }
    }
}
