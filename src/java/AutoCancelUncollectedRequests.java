
import java.util.*;
import java.sql.*;
import javax.mail.*;
import javax.mail.internet.*;

public class AutoCancelUncollectedRequests extends TimerTask {

    @Override
    public void run() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

//            String query = "SELECT br.request_id, br.copy_id, u.email, CONCAT(u.fname, ' ', u.lname) AS full_name, " +
//                           "b.title, b.ISBN, bc.library_classification_number " +
//                           "FROM book_request br " +
//                           "JOIN user u ON br.u_id = u.u_id " +
//                           "JOIN book_copies bc ON br.copy_id = bc.copy_id " +
//                           "JOIN book b ON bc.book_id = b.book_id " +
//                           "WHERE br.request_status = 2 AND TIMESTAMPDIFF(HOUR, br.updated_at, NOW()) >= 24";
            String query
                    = "SELECT br.request_id, br.copy_id, u.email, CONCAT(u.fname, ' ', u.lname) AS full_name, "
                    + "b.title, b.ISBN, bc.library_classification_number "
                    + "FROM book_request br "
                    + "JOIN user u ON br.u_id = u.u_id "
                    + "JOIN book_copies bc ON br.copy_id = bc.copy_id "
                    + "JOIN book b ON bc.book_id = b.book_id "
                    + "WHERE br.request_status = 2 "
                    + "  AND TIMESTAMPDIFF(HOUR, br.approved_at, NOW()) >= 24";

            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;

                int requestId = rs.getInt("request_id");
                int copyId = rs.getInt("copy_id");
                String email = rs.getString("email");
                String fullName = rs.getString("full_name");
                String title = rs.getString("title");
                String isbn = rs.getString("ISBN");
                String lc = rs.getString("library_classification_number");

                // Cancel request
                PreparedStatement ps1 = con.prepareStatement("UPDATE book_request SET request_status = 0 WHERE request_id = ?");
                ps1.setInt(1, requestId);
                ps1.executeUpdate();

                // Set copy available
                PreparedStatement ps2 = con.prepareStatement("UPDATE book_copies SET book_reservation_status = 0 WHERE copy_id = ?");
                ps2.setInt(1, copyId);
                ps2.executeUpdate();

                // Email user
                sendEmail(email, fullName, title, isbn, lc);
            }

            System.out.println("✅ Auto-cancelled " + count + " uncollected request(s).");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void sendEmail(String to, String userName, String bookTitle, String isbn, String lcNo) {
        String from = "aasimamansuri56@gmail.com";
        String password = "mnkc dvih ntpo jybl"; // Gmail App Password

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Library Request Cancelled Due to Timeout");

            String content = "Dear " + userName + ",\n\n"
                    + "Your book request has been cancelled as you did not collect the book within 24 hours.\n\n"
                    + "📘 Book Title: " + bookTitle + "\n"
                    + "🔖 ISBN: " + isbn + "\n"
                    + "📂 Library Classification No: " + lcNo + "\n\n"
                    + "You may request it again if needed.\n\nRegards,\nLibrary Management";

            message.setText(content);
            Transport.send(message);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
