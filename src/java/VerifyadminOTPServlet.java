import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/VerifyadminOTPServlet")
public class VerifyadminOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
//         session.setMaxInactiveInterval(21600);
        String storedOTP = (String) session.getAttribute("otp");
        String enteredOTP = request.getParameter("otp");
        String email = (String) session.getAttribute("email");

        if (storedOTP != null && storedOTP.equals(enteredOTP)) {
            session.removeAttribute("otp");

            try {
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT name FROM admin WHERE email = ?");
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String adminName = rs.getString("name");
                    session.setAttribute("admin_name", adminName);
                    session.setAttribute("admin_login_status", "Login Successful");
                    response.sendRedirect("admin_dashboard.jsp");
                } else {
                    response.getWriter().write("Admin not found in database.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("Database error occurred.");
            }

        } else {
session.setAttribute("otpError", "true");
    response.sendRedirect("admin_login.jsp");        }
    }
}