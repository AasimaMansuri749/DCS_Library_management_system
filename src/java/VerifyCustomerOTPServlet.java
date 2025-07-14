import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/VerifyCustomerOTPServlet")
public class VerifyCustomerOTPServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String storedOTP = (String) session.getAttribute("otp");
        String enteredOTP = request.getParameter("otp");

        if (storedOTP != null && storedOTP.equals(enteredOTP)) {
            try {
                // Get session attributes
                String regno = (String) session.getAttribute("regno");
                String fname = (String) session.getAttribute("fname");
                String lname = (String) session.getAttribute("lname");
                String email = (String) session.getAttribute("email");
                String phone = (String) session.getAttribute("phone");
                String role = (String) session.getAttribute("role");

                // Check for null values
                if (regno == null || fname == null || lname == null || email == null || phone == null || role == null) {
                    response.getWriter().write("One or more session values are missing.");
                    return;
                }

                // Convert role to integer
                int roleValue = -1;
                if ("Student".equalsIgnoreCase(role)) {
                    roleValue = 0;
                } else if ("Faculty".equalsIgnoreCase(role)) {
                    roleValue = 1;
                } 

                // Get DB connection
                Connection con = DBConnection.getConnection();
                if (con == null) {
                    response.getWriter().write("Database connection failed.");
                    return;
                }

                // Prepare SQL insert
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO user (registration_no, fname, lname, email, phone_num, role, status, create_date, update_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 2, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP())"
                );

                ps.setString(1, regno);
                ps.setString(2, fname);
                ps.setString(3, lname);
                ps.setString(4, email);
                ps.setString(5, phone);
                ps.setInt(6, roleValue);

                // Execute insert
                int result = ps.executeUpdate();

                if (result > 0) {
                    // ✅ Clear session attributes to refresh form next time
                    session.removeAttribute("otp");
                    session.removeAttribute("regno");
                    session.removeAttribute("fname");
                    session.removeAttribute("lname");
                    session.removeAttribute("email");
                    session.removeAttribute("phone");
                    session.removeAttribute("role");

                    session.invalidate(); // Optional: clears everything
                    response.sendRedirect("usermanagement.jsp"); // Redirect to login or home page
                } else {
                    response.getWriter().write("Signup failed. Please try again.");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("SQL Exception: " + e.getMessage());
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("General Exception: " + e.getMessage());
            }

        } else {
session.setAttribute("otpError", "true");

    // Clear all session data to reset the signup process
    session.removeAttribute("otp");
    session.removeAttribute("regno");
    session.removeAttribute("fname");
    session.removeAttribute("lname");
    session.removeAttribute("email");
    session.removeAttribute("phone");
    session.removeAttribute("role");

    response.sendRedirect("customer_signup.jsp"); // Go back to start      }
    }
}
}