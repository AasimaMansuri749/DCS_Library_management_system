import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;


@WebServlet("/SendDeptLoginOtpServlet")
public class SendDeptLoginOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
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
            PreparedStatement checkAdmin = con.prepareStatement("SELECT * FROM department WHERE email = ?");
            checkAdmin.setString(1, email);
            ResultSet rs = checkAdmin.executeQuery();

                        

            if (!rs.next()) {
                response.getWriter().write("Unauthorized Email.\n Not registered as admin.");
                return;
            }
int status = rs.getInt("status");
int d_id = rs.getInt("d_id");
if (status == 0) {
    response.getWriter().write("Your account is inactive. Please contact the administrator.");
    return;
}

            // Step 3: Send OTP via email
            String from = "khushishah07022005@gmail.com";
            String pass = "orot bpvh tooc zxhr"; // App password

            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, pass);
                }
            });

            Message msg = new MimeMessage(mailSession);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
            msg.setSubject("Your OTP Code");
            msg.setText("Your OTP is: " + otp);
            Transport.send(msg);

            // Step 4: Save OTP & email in session for verification
            HttpSession userSession = request.getSession();
            userSession.setMaxInactiveInterval(21600);
            userSession.setAttribute("otp", otp);
            userSession.setAttribute("email", email);
            userSession.setAttribute("admin_name", email);
            userSession.setAttribute("d_id",d_id);

            response.getWriter().write("OTP Sent Successfully");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error Sending OTP: " + e.getMessage());
        }
    }
}