import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import java.sql.*;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@WebServlet("/SendCustomerOTPServlet")
public class SendCustomerOTPServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String regno = request.getParameter("regno");
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Check if email or phone already exists
            String checkQuery = "SELECT * FROM user WHERE email = ? OR phone_num = ?";
            pst = conn.prepareStatement(checkQuery);
            pst.setString(1, email);
            pst.setString(2, phone);
            rs = pst.executeQuery();

            if (rs.next()) {
                // User exists, show alert and redirect
                response.setContentType("text/html");
                response.getWriter().println("<script type=\"text/javascript\">");
                response.getWriter().println("alert('You are already registered. Please log in.');");
                response.getWriter().println("window.location.href = 'usermanagement.jsp';");
                response.getWriter().println("</script>");
                return;
            }

            // Generate 6-digit OTP
            String otp = String.valueOf(100000 + new Random().nextInt(900000));

            // Email credentials (replace with your actual email and app password)
            final String fromEmail = "khushishah07022005@gmail.com";
            final String appPassword = "orot bpvh tooc zxhr";

            // Email properties
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            // Mail session with authenticator
            Session mailSession = Session.getInstance(props, new javax.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, appPassword);
                }
            });

            // Create and send email
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Your OTP for Signup");
            message.setText("Dear " + fname + ",\n\nYour OTP is: " + otp + "\n\nThank you!");

            Transport.send(message);

            // Store data in session
            HttpSession session = request.getSession();
            session.setMaxInactiveInterval(21600); // 6 hours
            session.setAttribute("regno", regno);
            session.setAttribute("fname", fname);
            session.setAttribute("lname", lname);
            session.setAttribute("email", email);  // Use consistent key
            session.setAttribute("phone", phone);
            session.setAttribute("role", role);
            session.setAttribute("otp", otp);
            session.setAttribute("otpSent", "true");

            // Redirect to OTP entry page
            response.sendRedirect("customer_signup.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error checking user existence: " + e.getMessage());
        } catch (MessagingException e) {
            e.printStackTrace();
            response.getWriter().println("Error sending email: " + e.getMessage());
        } finally {
            // Clean up JDBC resources
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}