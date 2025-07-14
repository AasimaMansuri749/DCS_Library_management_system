import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/SendOTPServlet")
public class SendOTPServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");

        String otp = String.format("%06d", new Random().nextInt(999999));
        response.setContentType("text/plain");

        try {
            // Step 1: Connect to the database
            Connection con = DBConnection.getConnection();
            if (con == null) {
                response.getWriter().write("Database connection failed.");
                return;
            }

            // Step 2: Check if email exists in admin table
            PreparedStatement checkAdmin = con.prepareStatement("SELECT * FROM user WHERE email = ?");
            checkAdmin.setString(1, email);
            ResultSet rs = checkAdmin.executeQuery();

            if (!rs.next()) {
                response.getWriter().write("Unauthorized Email. Not registered as user.");
                return;
            }
int status = rs.getInt("status");
int u_id = rs.getInt("u_id");
if (status == 0) {
    response.getWriter().write("Your account is inactive. Please contact the administrator.");
    return;
}

            // Gmail credentials
            final String fromEmail = "aasimamansuri56@gmail.com"; // ✅ Replace with your Gmail
            final String appPassword = "mnkc dvih ntpo jybl";  // ✅ Replace with your App Password
            
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, appPassword);
                }
            });

            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
            msg.setSubject("Your OTP Code");
            msg.setText("Your OTP is: " + otp);
            Transport.send(msg);

            // Step 4: Save OTP & email in session for verification
            HttpSession userSession = request.getSession();
            
            userSession.setAttribute("otp", otp);
            userSession.setAttribute("email", email);
            userSession.setAttribute("fname", fname);
            userSession.setAttribute("lname", lname);
            userSession.setAttribute("u_id", u_id);

            

            response.getWriter().write("OTP Sent Successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error Sending OTP: " + e.getMessage());
        }
    }
}