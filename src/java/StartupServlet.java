import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import java.util.Timer;
import java.util.TimerTask;

@WebServlet(value = "/StartupServlet", loadOnStartup = 1)
public class StartupServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        Timer timer = new Timer();
        timer.scheduleAtFixedRate(new NotifyTask(), 0, 5 * 60 * 1000); // Every 5 minutes
    }
}
