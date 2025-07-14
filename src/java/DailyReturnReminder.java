import java.sql.*;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

public class DailyReturnReminder {

    public static void main(String[] args) {
        final String fromEmail = "aasimamansuri56@gmail.com";
        final String password = "mnkc dvih ntpo jybl";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "")) {

            // Overdue or nearing due books
            String sql = """
                SELECT u.email, CONCAT(u.fname, ' ', u.lname) AS user_name, b.title, t.due_date, 
                    DATEDIFF(CURDATE(), t.due_date) AS overdue_days, 
                    DATEDIFF(t.due_date, CURDATE()) AS days_left
                FROM transaction t
                JOIN book_request br ON t.request_id = br.request_id
                JOIN user u ON br.u_id = u.u_id
                JOIN book_copies bc ON br.copy_id = bc.copy_id
                JOIN book b ON bc.book_id = b.book_id
                WHERE t.return_date IS NULL
                    AND (DATEDIFF(CURDATE(), t.due_date) > 14 OR DATEDIFF(t.due_date, CURDATE()) BETWEEN 0 AND 5)
            """;

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String email = rs.getString("email");
                String name = rs.getString("user_name");
                String book = rs.getString("title");
                var dueDate = rs.getDate("due_date");
                int overdueDays = rs.getInt("overdue_days");
                int daysLeft = rs.getInt("days_left");

                String statusMsg = overdueDays > 14 ?
                        "This book is overdue by " + overdueDays + " days." :
                        "This book is due in " + daysLeft + " days.";

                String body = "Hello " + name + ",\n\n" +
                        "This is a reminder regarding your borrowed book:\n" +
                        "Book Title: " + book + "\n" +
                        "Due Date: " + dueDate + "\n" +
                        statusMsg + "\n\nPlease return or renew the book at the earliest.\n\nThank you!";

                Message msg = new MimeMessage(session);
                msg.setFrom(new InternetAddress(fromEmail));
                msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
                msg.setSubject("Library Book Return Reminder");
                msg.setText(body);

                Transport.send(msg);
            }

            System.out.println("Reminder emails sent successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
