import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/SendReturnOTPServlet")
public class SendReturnOTPServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int transactionId = Integer.parseInt(request.getParameter("transaction_id"));
        String userEmail = "";

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_management_system", "root", "")) {

            PreparedStatement ps = con.prepareStatement(
                "SELECT u.email FROM transaction t " +
                "JOIN book_request br ON t.request_id = br.request_id " +
                "JOIN user u ON br.u_id = u.u_id WHERE t.transaction_id = ?");
            ps.setInt(1, transactionId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                userEmail = rs.getString("email");
            } else {
                response.getWriter().println("No user found for the transaction.");
                
                return;
            }

            // Generate OTP
            Random rand = new Random();
            int otp = 100000 + rand.nextInt(900000);

            // Store OTP & transactionId in session
            HttpSession session = request.getSession();
            session.setAttribute("returnOtp", otp);
            session.setAttribute("transactionId", transactionId);

            // Gmail SMTP details
            final String fromEmail = "aasimamansuri56@gmail.com"; // replace with your email
            final String password = "mnkc dvih ntpo jybl";     // App password, not normal password

            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
            message.setSubject("Book Return Verification OTP");
            message.setText("Your OTP to return the book is: " + otp);

            Transport.send(message);
            session.setAttribute("otpSent",true);
            response.sendRedirect("admin/VerifyReturnOTPServlet.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
