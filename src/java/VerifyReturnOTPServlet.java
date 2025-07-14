import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/VerifyReturnOTPServlet")
public class VerifyReturnOTPServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("returnOtp") == null || session.getAttribute("transactionId") == null) {
            request.setAttribute("error", "Session expired or invalid. Please request OTP again.");
            request.getRequestDispatcher("VerifyReturnOTPServlet.jsp").forward(request, response);
            return;
        }

        String otpInput = request.getParameter("otp");
        String correctOtp = String.valueOf(session.getAttribute("returnOtp"));
        int transactionId = (int) session.getAttribute("transactionId");

        if (otpInput != null && otpInput.equals(correctOtp)) {
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "")) {
                // Fetch required info for updates and email
                PreparedStatement ps = con.prepareStatement(
                    "SELECT br.request_id, br.copy_id, bc.book_id, u.email, b.title FROM transaction t " +
                    "JOIN book_request br ON t.request_id = br.request_id " +
                    "JOIN book_copies bc ON br.copy_id = bc.copy_id " +
                    "JOIN book b ON bc.book_id = b.book_id " +
                    "JOIN user u ON br.u_id = u.u_id " +
                    "WHERE t.transaction_id = ?"
                );
                ps.setInt(1, transactionId);
                ResultSet rs = ps.executeQuery();

                int requestId = 0, copyId = 0, bookId = 0;
                String email = "", bookTitle = "";

                if (rs.next()) {
                    requestId = rs.getInt("request_id");
                    copyId = rs.getInt("copy_id");
                    bookId = rs.getInt("book_id");
                    email = rs.getString("email");
                    bookTitle = rs.getString("title");
                } else {
                    request.setAttribute("error", "Transaction details not found.");
                    request.getRequestDispatcher("VerifyReturnOTPServlet.jsp").forward(request, response);
                    return;
                }

                // Update return_date in transaction
                ps = con.prepareStatement("UPDATE transaction SET return_date = CURDATE() WHERE transaction_id = ?");
                ps.setInt(1, transactionId);
                ps.executeUpdate();

                // Update book_copies status to available
                ps = con.prepareStatement("UPDATE book_copies SET book_reservation_status = 0 WHERE copy_id = ?");
                ps.setInt(1, copyId);
                ps.executeUpdate();

                // Clear OTP session attributes
                session.removeAttribute("returnOtp");
                session.removeAttribute("transactionId");

                // Email setup
                final String fromEmail = "aasimamansuri56@gmail.com";
                final String password = "mnkc dvih ntpo jybl";

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

                // Send return confirmation email
                Message message = new MimeMessage(mailSession);
                message.setFrom(new InternetAddress(fromEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
                message.setSubject("Book Returned Successfully");
                message.setText("Thank you for returning the book.");
                Transport.send(message);

                // ✅ Check notify_me requests for this book
                ps = con.prepareStatement(
                    "SELECT nr.id, u.email FROM notify_requests nr " +
                    "JOIN user u ON nr.user_id = u.u_id " +
                    "WHERE nr.book_id = ? AND nr.notified = 0"
                );
                ps.setInt(1, bookId);
                ResultSet notifyRs = ps.executeQuery();

                while (notifyRs.next()) {
                    int notifyId = notifyRs.getInt("id");
                    String notifyEmail = notifyRs.getString("email");

                    Message notifyMsg = new MimeMessage(mailSession);
                    notifyMsg.setFrom(new InternetAddress(fromEmail));
                    notifyMsg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(notifyEmail));
                    notifyMsg.setSubject("Book Now Available: " + bookTitle);
                    notifyMsg.setText("Hello,\n\nThe book \"" + bookTitle + "\" you requested is now available.\nPlease visit or request it soon.");
                    Transport.send(notifyMsg);

                    PreparedStatement updateNotify = con.prepareStatement("UPDATE notify_requests SET notified = 1 WHERE id = ?");
                    updateNotify.setInt(1, notifyId);
                    updateNotify.executeUpdate();
                }

                request.setAttribute("success", "Book return verified, availability updated, and notifications sent.");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error during book return process: " + e.getMessage());
            }
        } else {
            request.setAttribute("error", "Invalid OTP. Please try again.");
        }

        response.sendRedirect("admin/transaction.jsp");
    }
}
