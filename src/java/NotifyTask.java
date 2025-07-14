import java.sql.*;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;

public class NotifyTask extends TimerTask {
    @Override
    public void run() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

          String sql = "SELECT nr.id, nr.user_id, nr.book_id, u.email, CONCAT(u.fname, ' ', u.lname) AS full_name, b.title " +
             "FROM notify_requests nr " +
             "JOIN user u ON nr.user_id = u.user_id " +
             "JOIN book b ON nr.book_id = b.book_id " +
             "WHERE nr.notified = FALSE";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int notifyId = rs.getInt("id");
                int bookId = rs.getInt("book_id");
                String email = rs.getString("email");
                String title = rs.getString("title");
                String userName = rs.getString("full_name");


                PreparedStatement countQuery = con.prepareStatement(
                    "SELECT COUNT(*) FROM book_copies WHERE book_id = ? AND book_reservation_status = 0"
                );
                countQuery.setInt(1, bookId);
                ResultSet countResult = countQuery.executeQuery();
                countResult.next();
                int available = countResult.getInt(1);

                if (available > 0) {
                String subject = "📚 Good News, " + userName + "! The Book \"" + title + "\" is Available!";
                    String messageText = "Dear " + userName + ",\n\n"
                            + "We're excited to let you know that the book you were waiting for is now available in the library:\n\n"
                            + "📖 *" + title + "*\n\n"
                            + "You can visit the library or request it now through your dashboard.\n\n"
                            + "Happy Reading!\n"
                            + "📘 DCS Library Management System";

                    sendEmail(email, subject, messageText); 
                    PreparedStatement update = con.prepareStatement("UPDATE notify_requests SET notified = TRUE WHERE id = ?");
                    update.setInt(1, notifyId);
                    update.executeUpdate();
                }
            }
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void sendEmail(String toEmail, String subject, String messageText) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("aasimamansuri56@gmail.com", "mnkc dvih ntpo jybl");
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress("aasimamansuri56@gmail.com"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setText(messageText);
        Transport.send(message);
    }
}
