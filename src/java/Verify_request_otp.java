
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import java.time.LocalDate;

public class Verify_request_otp extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int enteredOtp = Integer.parseInt(request.getParameter("otp"));
        HttpSession session = request.getSession();
        Integer requestId = (Integer) session.getAttribute("request_id");
        Integer copyId = (Integer) session.getAttribute("copy_id");
        Integer otpSession = (Integer) session.getAttribute("otp");

        if (requestId == null || copyId == null || otpSession == null) {
            response.setContentType("text/html");
            response.getWriter().write(
                    "<script type='text/javascript'>"
                    + "alert('Session expired or invalid. Please try again.');"
                    + "window.location='book_details.jsp';"
                    + "</script>"
            );
            return;
        }

        int rid = requestId.intValue();
        int cid = copyId.intValue();
        int otpFromSession = otpSession.intValue();

        if (enteredOtp == otpFromSession) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

                // Step 1: Update book_request status to 4 (collected)
                PreparedStatement ps1 = con.prepareStatement("UPDATE book_request SET request_status = 4 WHERE request_id = ?");
                ps1.setInt(1, rid);
                ps1.executeUpdate();

                // Step 2: Get user role from the request
                int role = 0; // default
                PreparedStatement psRole = con.prepareStatement(
                        "SELECT u.role FROM book_request br INNER JOIN user u ON br.u_id = u.u_id WHERE br.request_id = ?");
                psRole.setInt(1, rid);
                ResultSet rsRole = psRole.executeQuery();
                if (rsRole.next()) {
                    role = rsRole.getInt("role");
                }

                // Step 3: Calculate due date based on role
                LocalDate issueDate = LocalDate.now();
                LocalDate dueDate = (role == 1) ? issueDate.plusMonths(6) : issueDate.plusDays(15);

                // Step 4: Insert into transaction
                PreparedStatement ps3 = con.prepareStatement(
                        "INSERT INTO transaction(request_id, issue_date, due_date) VALUES (?, ?, ?)");
                ps3.setInt(1, rid);
                ps3.setDate(2, java.sql.Date.valueOf(issueDate));
                ps3.setDate(3, java.sql.Date.valueOf(dueDate));
                ps3.executeUpdate();

// ✅ Step 5: Update book_copies status to 2 (issued)
                PreparedStatement ps4 = con.prepareStatement(
                        "UPDATE book_copies SET book_reservation_status = 2 WHERE copy_id = ?");
                ps4.setInt(1, cid);
                ps4.executeUpdate();

                con.close();

                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<script type='text/javascript'>");
                out.println("alert('OTP Verified. Book Collected Successfully!');");
                out.println("window.location.href ='admin/admin_dashboard.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error: " + e.getMessage());
            }
        } else {
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('Invalid OTP. Please try again!');");
            out.println("window.location.href = 'admin/admin_dashboard.jsp';");
            out.println("</script>");
        }
    }
}
