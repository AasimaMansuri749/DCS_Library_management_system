import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SendNotificationsServlet")
public class SendNotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Email credentials & SMTP config (use your own)
    private static final String FROM_EMAIL = "aasimamansuri56@gmail.com";
    private static final String FROM_PASSWORD = "mnkc dvih ntpo jybl";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        String sql = "SELECT CONCAT(u.fname, ' ', u.lname) AS user_name, " +
                     "b.title AS book_title, t.due_date, DATEDIFF(t.due_date, CURDATE()) AS days_left, " +
                     "u.email AS email " +
                     "FROM transaction t " +
                     "INNER JOIN book_request br ON t.request_id = br.request_id " +
                     "INNER JOIN user u ON br.u_id = u.u_id " +
                     "INNER JOIN book_copies bc ON br.copy_id = bc.copy_id " +
                     "INNER JOIN book b ON bc.book_id = b.book_id " +
                     "WHERE t.return_date IS NULL " +
                     "AND DATEDIFF(t.due_date, CURDATE()) <= 5";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_management_system", "root", "");

            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            int count = 0;
            while (rs.next()) {
                String email = rs.getString("email");
                String userName = rs.getString("user_name");
                String bookTitle = rs.getString("book_title");
                int daysLeft = rs.getInt("days_left");
                Date dueDate = rs.getDate("due_date");

               String subject;
String message;

if (daysLeft < 0) {
    int overdueDays = Math.abs(daysLeft);
    subject = "📚 Overdue Book Return Notice";

    message = "Dear " + userName + ",\n\n" +
              "This is a reminder that the following book issued to you is overdue by " + overdueDays + " day(s):\n\n" +
              "• Title: " + bookTitle + "\n" +
              "• Due Date: " + dueDate + "\n\n" +
              "Please return the book as soon as possible to avoid any further penalties.\n\n" +
             
              "From,\n DCS Library ";
} else {
    subject = "📚 Book Return Due in " + daysLeft + " Day(s)";

    message = "Dear " + userName + ",\n\n" +
              "This is a friendly reminder that the following book is due for return in " + daysLeft + " day(s):\n\n" +
              "• Title: " + bookTitle + "\n" +
              "• Due Date: " + dueDate + "\n\n" +
              "Kindly ensure timely return .\n\n" +
              "From,\n DCSLibrary ";
}

                sendEmail(email, subject, message);
                count++;
            }

            request.setAttribute("message", count + " notifications sent successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error sending notifications: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pst != null) pst.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        
    response.sendRedirect("admin/transaction.jsp");
    }

    private void sendEmail(String toEmail, String subject, String body) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587"); // or 465 for SSL
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(FROM_EMAIL));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        msg.setSubject(subject);
        msg.setText(body);

        Transport.send(msg);
    }
}
