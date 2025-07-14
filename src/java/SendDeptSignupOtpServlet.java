import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.sql.*;

@WebServlet("/SendDeptSignupOtpServlet")
public class SendDeptSignupOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        String otp = String.format("%06d", new Random().nextInt(999999));

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                response.getWriter().write("Database connection error.");
                return;
            }

            // Check if email or phone already exists
            PreparedStatement check = con.prepareStatement("SELECT * FROM department WHERE email = ? OR phone_num = ?");
            check.setString(1, email);
            check.setString(2, phone);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                response.getWriter().write("Email or phone number already exists.");
                
                return;
            }

            // Send OTP
            String from = "khushishah07022005@gmail.com";
            String pass = "orot bpvh tooc zxhr";

            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, pass);
                }
            });

            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
            msg.setSubject("Your Admin Signup OTP");
            msg.setText("Hello " + name + ",\n\nYour OTP for Department signup is: " + otp + "\n\nThis OTP is valid for one-time use.");

            Transport.send(msg);

            // Store values in session
            HttpSession session = request.getSession();
            session.setAttribute("signup_otp", otp);
            session.setAttribute("signup_name", name);
            session.setAttribute("signup_email", email);
            session.setAttribute("signup_phone", phone);

            response.getWriter().write("OTP Sent to your email.");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Failed to send OTP.");
        }
    }
}