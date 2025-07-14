
import javax.mail.*;
import javax.mail.internet.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Properties;
import java.util.Random;

public class SendRequestOTPServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userEmail = request.getParameter("email"); // From request or DB
        String requestIdStr = request.getParameter("request_id");
        String copyIdStr = request.getParameter("copy_id"); 
        
        if (requestIdStr == null || copyIdStr == null || requestIdStr.isEmpty() || copyIdStr.isEmpty()) {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("Missing request_id or copy_id parameter");
            return;
        }

        int requestId = Integer.parseInt(requestIdStr);
        int copyId = Integer.parseInt(copyIdStr);

        // Generate OTP
        Random rand = new Random();
        int otp = 100000 + rand.nextInt(900000);

        // Store in session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("request_id", requestId);
        session.setAttribute("copy_id", copyId);

        // Send OTP via Gmail
        final String fromEmail = "aasimamansuri56@gmail.com";
        final String password = "mnkc dvih ntpo jybl"; // Use App Password

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

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
            message.setSubject("Your OTP for Book Collection");
            message.setText("Your OTP is: " + otp);
            Transport.send(message);
             session.setAttribute("otpSent",true);
            response.sendRedirect("admin/verify_request_otp.jsp");
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}
