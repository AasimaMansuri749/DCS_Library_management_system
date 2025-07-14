import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/VerifySignupOTPServlet")
public class VerifySignupOTPServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        String correctOtp = (String) session.getAttribute("signup_otp");

        if (enteredOtp != null && enteredOtp.equals(correctOtp)) {
            String name = (String) session.getAttribute("signup_name");
            String email = (String) session.getAttribute("signup_email");
            String phone = (String) session.getAttribute("signup_phone");

            try {
                Connection con = DBConnection.getConnection();
                if (con == null) {
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('Database connection error.');");
                    out.println("window.location = 'signup.jsp';");
                    out.println("</script>");
                    return;
                }

                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO admin (name, email, phone_num, status) VALUES (?, ?, ?, 1)"
                );
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.executeUpdate();

                // Clear session data after successful signup
                session.removeAttribute("signup_otp");
                session.removeAttribute("signup_name");
                session.removeAttribute("signup_email");
                session.removeAttribute("signup_phone");

                // Show success alert and go back to signup page
                PrintWriter out = response.getWriter();
                out.println("<script>");
                out.println("alert('Signup successful! You can now log in.');");
                out.println("window.location = 'success.jsp';");
                out.println("</script>");

            } catch (Exception e) {
                e.printStackTrace();
                PrintWriter out = response.getWriter();
                out.println("<script>");
//                out.println("alert('Error creating account.');");
out.println("alert('Error creating account: " + e.getMessage().replace("'", "\\'") + "');");

                out.println("window.location = 'signup.jsp';");
                out.println("</script>");
            }
        } else {
            PrintWriter out = response.getWriter();
            out.println("<script>");
            out.println("alert('Invalid OTP. Please try again.');");
            out.println("window.location = 'signup.jsp';");
            out.println("</script>");
        }
    }
}