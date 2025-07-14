import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(21600);
        String storedOTP = (String) session.getAttribute("otp");
        String enteredOTP = request.getParameter("otp");
        String email = (String) session.getAttribute("email");

        if (storedOTP != null && storedOTP.equals(enteredOTP)) {
            session.removeAttribute("otp");

            try {
                Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT u_id, fname , lname FROM user WHERE email = ?");
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
    int u_id = rs.getInt("u_id");
    String fname = rs.getString("fname");
    String lname = rs.getString("lname");

    session.setAttribute("u_id", u_id);
    session.setAttribute("fname", fname);
    session.setAttribute("lname", lname);
    session.setAttribute("customer_login_status", "Login Successful");
    
    session.removeAttribute("regno");
//    session.removeAttribute("fname");
//    session.removeAttribute("lname");
    session.removeAttribute("email");
    session.removeAttribute("phone");
    session.removeAttribute("role");
    
    response.sendRedirect("user_dashboard.jsp");
}
else {
                    response.getWriter().write("user not found in database.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("Database error occurred.");
            }

        } else {
            session.setAttribute("otpError", "true");
    response.sendRedirect("user_dashboard.jsp");

        }
    }
}