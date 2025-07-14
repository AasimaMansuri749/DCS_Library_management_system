<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Admin - DCS library</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">

        <!-- Icon Font Stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
    </head>
    <%
        int totalUsers = 0;
        int studentUsers = 0;
        int facultyUsers = 0;
        int totalCopies = 0;
        int issuedBooks = 0;
        int reservedBooks = 0;
        int overdueBooks = 0;
        int notifyRequests = 0;
        int booksDueSoon = 0;

    %>

    <body>
        <!--// script--> 
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <div class="container-xxl position-relative bg-white d-flex p-0">

            <!-- Sidebar Start -->
            <div class="sidebar pe-4 pb-3">
                <nav class="navbar bg-light navbar-light">
                    <a href="admin_dashboard.jsp" class="navbar-brand mx-4 mb-3">
                        <h3 class="text-primary">ADMIN <BR>DASHBOARD</h3>
                    </a>

                    <!--session display start-->
                    <%@ page session="true" %>
                    <%                        String userName = (String) session.getAttribute("admin_name");
//                        if (userName == null || userName.isEmpty()) {
//                            response.sendRedirect("admin_login.jsp");
//                            return;
//                        }
%>

                    <div class="d-flex align-items-center ms-4 mb-4">
                        <div class="position-relative border-2">
                        </div>
                        <div class="ms-3">
                            <h6 class="mb-0">
                                <%= (userName != null && !userName.isEmpty()) ? userName : "Welcome Admin"%>
                            </h6>
                            <span><%= "admin"%></span>
                        </div>
                    </div>
                    <!--session display end-->


                    <div class="navbar-nav w-100">
                        <a href="admin_dashboard.jsp" class="nav-item nav-link active">
                            <i class="bi bi-speedometer2 me-2"></i>Dashboard
                        </a>

                        <a href="transaction.jsp" class="nav-item nav-link">
                            <i class="bi bi-arrow-left-right me-2"></i>Transactions
                        </a>

                        <a href="usermanagement.jsp" class="nav-item nav-link">
                            <i class="bi bi-people-fill me-2"></i>Users
                        </a>

                        <a href="books.jsp" class="nav-item nav-link">
                            <i class="bi bi-book me-2"></i>Books
                        </a>

                        <a href="subject.jsp" class="nav-item nav-link">
                            <i class="bi bi-collection me-2"></i>Subjects
                        </a>

                        <a href="report.jsp" class="nav-item nav-link">
                            <i class="bi bi-bar-chart-fill me-2"></i>Reports
                        </a>
                        <!--                        <a href="book_suggestion.jsp" class="nav-item nav-link">
                                                    <i class="bi bi-journal-plus me-2"></i>Book Suggestion
                                                </a>-->
                    </div>


                </nav>
            </div>
            <!-- Sidebar End -->


            <!-- Content Start -->

            <div class="content">
                <!-- Navbar Start -->
                <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0">
                    <!-- <a href="index.html" class="navbar-brand d-flex d-lg-none me-4">
                        <h2 class="text-primary mb-0"><i class="fa fa-hashtag"></i>hii,jdfhikudfsgkiujsgfkj</h2>
                    </a> -->
                    <a href="#" class="sidebar-toggler flex-shrink-0">
                        <i class="fa fa-bars"></i>
                    </a>
                    <!-- <form class="d-none d-md-flex ms-4">
                        <input class="form-control border-0" type="search" placeholder="Search">
                    </form> -->

                    <div class="navbar-nav align-items-center ms-auto">
                        <form action="logout.jsp" method="post">
                            <!--                            <button class="btn btn-outline-primary " type="button" data-bs-toggle="offcanvas" data-bs-target="#filterPanel" aria-controls="filterPanel">
                                                            Filter  <i class="bi bi-funnel-fill"></i> 
                                                        </button>-->
                            <button type="submit" class="btn btn-outline-primary m-4">Logout<i class="bi bi-box-arrow-right ms-2"></i></button>
                        </form>
                    </div>
                </nav>
                <!-- Navbar End -->


                <!-- Sale & Revenue Start -->
                <div class="container-fluid pt-4 px-4">
                    <div class="row g-4">
                        <div class="col-12 col-md-8 mx-auto">
                            <div class="bg-light rounded shadow p-4">
                                <div class="d-flex justify-content-center align-items-center mb-3">
                                    <!--<i class="fa fa-chart-line fa-3x text-primary"></i>-->
                                    <i class="bi bi-people fa-3x text-primary mx-2"></i>
                                    <h5 class="mb-0">User Statistics</h5>
                                </div>





                                <div class="row text-center">

                                    <%
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            Connection con = DriverManager.getConnection(
                                                    "jdbc:mysql://localhost:3306/library_management_system",
                                                    "root",
                                                    "");

                                            CallableStatement cs = con.prepareCall("{CALL getSummary(?, ?, ?,?,?,?,?,?,? )}");
                                            cs.registerOutParameter(1, java.sql.Types.INTEGER); // total
                                            cs.registerOutParameter(2, java.sql.Types.INTEGER); // students
                                            cs.registerOutParameter(3, java.sql.Types.INTEGER); // faculty
                                            cs.registerOutParameter(4, java.sql.Types.INTEGER); // total books
                                            cs.registerOutParameter(5, java.sql.Types.INTEGER); // issued books
                                            cs.registerOutParameter(6, java.sql.Types.INTEGER); // reserved books
                                            cs.registerOutParameter(7, java.sql.Types.INTEGER); // overdue books
                                            cs.registerOutParameter(8, java.sql.Types.INTEGER); // notify books
                                            cs.registerOutParameter(9, java.sql.Types.INTEGER); //booksDueSoon
                                            cs.execute();

                                            totalUsers = cs.getInt(1);
                                            studentUsers = cs.getInt(2);
                                            facultyUsers = cs.getInt(3);
                                            totalCopies = cs.getInt(4);
                                            issuedBooks = cs.getInt(5);
                                            reservedBooks = cs.getInt(6);
                                            overdueBooks = cs.getInt(7);
                                            notifyRequests = cs.getInt(8);
                                            booksDueSoon = cs.getInt(9);

                                            cs.close();
                                            con.close();
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                    <div class="col-4 border-end">
                                        <p class="mb-1 text-muted">Total Users</p>
                                        <h6 class="mb-0 text-dark">
                                            <%= totalUsers%>
                                        </h6>
                                    </div>


                                    <div class="col-4 border-end">
                                        <p class="mb-1 text-muted">Student Users</p>
                                        <h6 class="mb-0 text-dark">
                                            <%= studentUsers%>
                                        </h6>
                                    </div>
                                    <div class="col-4">
                                        <p class="mb-1 text-muted">Faculty Users</p>
                                        <h6 class="mb-0 text-dark">
                                            <%= facultyUsers%>
                                        </h6>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6 col-xl-4">
                            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                <!--<i class="fa fa-chart-bar fa-3x text-primary"></i>-->
                                <i class="bi bi-book fa-3x text-primary"></i>
                                <div class="ms-3">
                                    <p class="mb-2">Total Books(copies)</p>
                                    <h6 class="mb-0"><%= totalCopies%></h6>

                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                <!--<i class="fa fa-chart-area fa-3x text-primary"></i>-->
                                <i class="bi bi-journal-check fa-3x text-primary"></i>

                                <div class="ms-3">
                                    <p class="mb-2">Issued books</p>
                                    <h6 class="mb-0"><%= issuedBooks%></h6>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                <i class="bi bi-bell-fill fa-3x text-primary"></i>
                                <div class="ms-3">
                                    <p class="mb-2">Notify Me Requests</p>
                                    <h6 class="mb-0"><%= notifyRequests%></h6>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6 col-xl-3">
                            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                <!--<i class="fa fa-chart-area fa-3x text-primary"></i>-->
                                <i class="bi bi-alarm fa-3x text-primary"></i>

                                <div class="ms-3">
                                    <p class="mb-2">Overdue books</p>
                                    <h6 class="mb-0"><%= overdueBooks%></h6>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-6 col-xl-3">
                            <div class="bg-light rounded d-flex align-items-center justify-content-between p-4">
                                <i class="bi bi-bookmark-check fa-3x text-primary"></i>
                                <div class="ms-3">
                                    <p class="mb-2">Reserved books</p>
                                    <h6 class="mb-0"><%= reservedBooks%></h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Sale & Revenue End -->


                <!-- Sales Chart Start -->
                <div class="container-fluid pt-4 px-4">
                    <div class="row g-4">
                        <!--                    <div class="col-sm-12 col-xl-6">
                                                <div class="bg-light text-center rounded p-4">
                                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                                        <h6 class="mb-0">Worldwide Sales</h6>
                                                        <a href="">Show All</a>
                                                    </div>
                                                    <canvas id="worldwide-sales"></canvas>
                                                </div>
                                            </div>-->


                        <div class="col-sm-12 col-xl-6">
                            <div class="bg-light text-center rounded p-4">
                                <div class="d-flex align-items-center justify-content-between mb-4">
                                    <h6 class="mb-0"> Book Status Overview</h6>
                                    <!--<a href="">Show All</a>-->
                                </div>
                                <canvas id="bookStatusChart"  width="200" height="200"></canvas>
                            </div>
                        </div>

                        <!--chart new-->

                        <!--chart new end-->
                        <%
                            // DB connection details (update as per your config)
                            String dbUrl = "jdbc:mysql://localhost:3306/library_management_system";
                            String dbUser = "root";
                            String dbPass = "";

                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;

                            int availableCount = 0;
                            int reservedCount = 0;
                            int issuedCount = 0;
                            int lostCount = 0;

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

                                // Query to get counts grouped by book_condition_status and book_reservation_status
                                String sql = "SELECT book_condition_status, book_reservation_status, COUNT(*) AS count "
                                        + "FROM book_copies "
                                        + "GROUP BY book_condition_status, book_reservation_status";

                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                                    int conditionStatus = rs.getInt("book_condition_status");
                                    int reservationStatus = rs.getInt("book_reservation_status");
                                    int count = rs.getInt("count");

                                    if (conditionStatus == 1) {
                                        switch (reservationStatus) {
                                            case 0:
                                                availableCount = count;
                                                break;
                                            case 1:
                                                reservedCount = count;
                                                break;
                                            case 2:
                                                issuedCount = count;
                                                break;
                                        }
                                    } else if (conditionStatus == 0) {
                                        lostCount += count;
                                    }
                                }

                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) {
                                        rs.close();
                                    }
                                } catch (Exception e) {
                                }
                                try {
                                    if (ps != null) {
                                        ps.close();
                                    }
                                } catch (Exception e) {
                                }
                                try {
                                    if (conn != null) {
                                        conn.close();
                                    }
                                } catch (Exception e) {
                                }
                            }
                        %>

                        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                        <script>
                            var labels = ["Available", "Issued", "Reserved", "Lost"];
                            var data = [<%= availableCount%>, <%= issuedCount%>, <%= reservedCount%>, <%= lostCount%>];

                            var ctx = document.getElementById('bookStatusChart').getContext('2d');
                            var bookChart = new Chart(ctx, {
                                type: 'doughnut',
                                data: {
                                    labels: labels,
                                    datasets: [{
                                            label: 'Book Status',
                                            data: data,
                                            backgroundColor: [
                                                'rgba(75, 192, 192, 0.6)', // Available - Green
                                                'rgba(255, 99, 132, 0.6)', // Issued - Red
                                                'rgba(255, 206, 86, 0.6)', // Reserved - Yellow
                                                'rgba(153, 102, 255, 0.6)'   // Lost - Purple
                                            ],
                                            borderColor: [
                                                'rgba(75, 192, 192, 1)',
                                                'rgba(255, 99, 132, 1)',
                                                'rgba(255, 206, 86, 1)',
                                                'rgba(153, 102, 255, 1)'
                                            ],
                                            borderWidth: 1
                                        }]
                                },
                                options: {
                                    responsive: true,
                                    plugins: {
                                        legend: {position: 'bottom'}
                                    }
                                }
                            });
                        </script>
                        <div class="col-sm-12 col-xl-6">
                            <div class="bg-light text-center rounded p-4">
                                <div class="d-flex align-items-center justify-content-between mb-4">
                                    <h6> Books Issued Per Month</h6>
                                    <!--<a href="">Show All</a>-->
                                </div>
                                <!--<canvas id="salse-revenue"></canvas>-->
                                <canvas id="bookIssuanceChart"></canvas>

                            </div>
                        </div>
                        <%
                            // Initialize an array for 12 months (Jan to Dec)
                            int[] issuedBooks2 = new int[12];

                            try {
                                Class.forName("com.mysql.jdbc.Driver");  // or your driver
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

                                String sql = "SELECT MONTH(issue_date) AS month, COUNT(*) AS issued_count "
                                        + "FROM transaction "
                                        + "GROUP BY MONTH(issue_date)";

                                ps = con.prepareStatement(sql);
                                rs = ps.executeQuery();

                                // Fill issuedBooks2 array with counts, default 0 if no data for month
                                while (rs.next()) {
                                    int month = rs.getInt("month");
                                    int count = rs.getInt("issued_count");
                                    issuedBooks2[month - 1] = count;  // month 1 = Jan = index 0
                                }

                                rs.close();
                                ps.close();
                                con.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                        <script>
                            var labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

                            // Convert issuedBooks int array to JS array
                            var data = [
                            <% for (int i = 0; i < issuedBooks2.length; i++) {%>
                            "<%= issuedBooks2[i]%>"<%= (i < issuedBooks2.length - 1) ? "," : ""%>
                            <% } %>
                            ];

                            var ctx = document.getElementById('bookIssuanceChart').getContext('2d');
                            var bookChart = new Chart(ctx, {
                                type: 'bar',
                                data: {
                                    labels: labels,
                                    datasets: [{
                                            label: 'Books Issued',
                                            data: data,
                                            backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                            borderColor: 'rgba(54, 162, 235, 1)',
                                            borderWidth: 1
                                        }]
                                },
                                options: {
                                    responsive: true,
                                    scales: {
                                        y: {
                                            beginAtZero: true,
                                            ticks: {
                                                stepSize: 1, // Forces step to 1 unit
                                                callback: function (value) {
                                                    if (Number.isInteger(value))
                                                        return value;
                                                    return ''; // Skip non-integers
                                                }
                                            },
                                            title: {
                                                display: true,
                                                text: 'Books Count'
                                            }
                                        },
                                        x: {
                                            title: {
                                                display: true,
                                                text: 'Month'
                                            }
                                        }
                                    }
                                }
                            });
                        </script>

                    </div>
                </div>
                <!-- Sales Chart End -->




                <hr>
                <%
                    int rowCount1 = 0;
                %>
                <!--my alerts and notification-->
                <div class="my-5">
                    <button class="btn btn-danger mb-3" data-bs-toggle="collapse" data-bs-target="#overdueDetails">
                        View Overdue Book Details
                    </button>

                    <a href="../SendNotificationsServlet" class="btn btn-danger mb-3  <%= (overdueBooks == 0 ? "disabled" : "")%>">Send Notification</a>
                    <%--<%= overdueBooks%>--%>

                    <div class="collapse" id="overdueDetails">
                        <div class="card card-body">
                            <table class="table table-bordered">
                                <thead class="table-danger">
                                    <tr>
                                        <th>User</th>
                                        <th>Book Title</th>
                                        <th>Library Classification Number</th>
                                        <th>Due Date</th>
                                        <th>Days Overdue</th>
                                        <th>Phone Number</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        // DB connection code (adjust your own method/package)
                                        Connection con = null;
                                        Statement st = null;
                                        rs = null;
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            con = DriverManager.getConnection(
                                                    "jdbc:mysql://localhost:3306/library_management_system",
                                                    "root",
                                                    "");
                                            st = con.createStatement();

                                            rs = st.executeQuery(
                                                    "SELECT CONCAT(u.fname, ' ', u.lname) AS user_name, "
                                                    + "u.phone_num AS phone_number, "
                                                    + "bc.library_classification_number AS LC, "
                                                    + "b.title AS book_title, "
                                                    + "t.due_date, "
                                                    + "DATEDIFF(CURDATE(), t.due_date) AS days_overdue, "
                                                    + "t.transaction_id "
                                                    + "FROM transaction t "
                                                    + "INNER JOIN book_request br ON t.request_id = br.request_id "
                                                    + "INNER JOIN user u ON br.u_id = u.u_id "
                                                    + "INNER JOIN book_copies bc ON br.copy_id = bc.copy_id "
                                                    + "INNER JOIN book b ON bc.book_id = b.book_id "
                                                    + "WHERE t.return_date IS NULL AND t.due_date < CURDATE()");
                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td><%= rs.getString("user_name")%></td>
                                        <td><%= rs.getString("book_title")%></td>
                                        <td><%= rs.getString("LC")%></td>
                                        <td><%= rs.getDate("due_date")%></td>
                                        <td><%= rs.getInt("days_overdue")%></td>
                                        <td><%= rs.getString("phone_number")%></td>
                                        <td>
                                            <form action="../SendReturnOTPServlet" method="get" style="display:inline;">
                                                <input type="hidden" name="transaction_id" value="<%= rs.getInt("transaction_id")%>">
                                                <button type="submit" class="btn btn-sm btn-outline-primary">Return</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='5' class='text-center'>Error fetching data: " + e.getMessage() + "</td></tr>");
                                        } finally {
                                            if (rs != null) {
                                                rs.close();
                                            }
                                            if (st != null) {
                                                st.close();
                                            }
                                            if (con != null) {
                                                con.close();
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <hr>
                <!--my alerts and notification-->


                <!--  ALERT: Books Nearing Return Deadline -->

                <div class="my-5">
                    <button class="btn btn-warning mb-3" data-bs-toggle="collapse" data-bs-target="#upcomingDue">
                        View Books Nearing Return Deadline
                    </button>

                    <a href="../SendNotificationsServlet" class="btn btn-danger mb-3 <%= (booksDueSoon == 0 ? "disabled" : "")%>">Send Notification</a>
                    <%--<%= booksDueSoon%>--%>
                    <div class="collapse" id="upcomingDue">
                        <div class="card card-body">
                            <table class="table table-bordered">
                                <thead class="table-warning">
                                    <tr>
                                        <th>User</th>
                                        <th>Book Title</th>
                                        <th>Library Classification Number</th>
                                        <th>Due Date</th>
                                        <th>Days Left</th>
                                        <th>Phone Number</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");

                                            con = DriverManager.getConnection(
                                                    "jdbc:mysql://localhost:3306/library_management_system",
                                                    "root",
                                                    "");
                                            st = con.createStatement();
                                            rs = st.executeQuery("SELECT CONCAT(u.fname, ' ', u.lname) AS user_name, b.title AS book_title, t.due_date,"
                                                    + " DATEDIFF(t.due_date, CURDATE()) AS days_left,u.phone_num AS phone_number,"
                                                    + "bc.library_classification_number AS LC, t.transaction_id FROM transaction t"
                                                    + " INNER JOIN book_request br ON t.request_id = br.request_id "
                                                    + "INNER JOIN user u ON br.u_id = u.u_id "
                                                    + "INNER JOIN book_copies bc ON br.copy_id = bc.copy_id"
                                                    + " INNER JOIN book b ON bc.book_id = b.book_id"
                                                    + " WHERE t.return_date IS NULL AND DATEDIFF(t.due_date, CURDATE()) BETWEEN 0 AND 5");

                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td><%= rs.getString("user_name")%></td>
                                        <td><%= rs.getString("book_title")%></td>
                                        <td><%= rs.getString("LC")%></td>
                                        <td><%= rs.getDate("due_date")%></td>
                                        <td><%= rs.getInt("days_left")%></td>
                                        <td><%= rs.getString("phone_number")%></td>
                                        <td>
                                            <form action="../SendReturnOTPServlet" method="get" style="display:inline;">
                                                <input type="hidden" name="transaction_id" value="<%= rs.getInt("transaction_id")%>">
                                                <button type="submit" class="btn btn-sm btn-outline-primary">Return</button>
                                            </form>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='5' class='text-center'>Error: " + e.getMessage() + "</td></tr>");
                                        } finally {
                                            if (rs != null) {
                                                rs.close();
                                            }
                                            if (st != null) {
                                                st.close();
                                            }
                                            if (con != null) {
                                                con.close();
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!--  ALERT: Books Nearing Return Deadline -->
                <!--  ALERT: Books Nearing Return Deadline -->

                <hr>

                <!--  ALERT: Reservations Ready -->
                <div class="my-5">
                    <button class="btn btn-success mb-3" data-bs-toggle="collapse" data-bs-target="#reservationReady">
                        View Reservations Ready for Pickup
                    </button>

                    <div class="collapse" id="reservationReady">
                        <div class="card card-body">
                            <table class="table table-bordered">
                                <thead class="table-warning">
                                    <tr>
                                        <th>User</th>
                                        <th>Email</th>
                                        <th>role</th>
                                        <th>Book Title</th>
                                        <th>ISBN</th>
                                        <th>Library Classification No.</th>
                                        <th>Cupboard No.</th>
                                        <th>Rack No.</th>
                                        <th>Request Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            con = DriverManager.getConnection(
                                                    "jdbc:mysql://localhost:3306/library_management_system",
                                                    "root",
                                                    "");
                                            st = con.createStatement();

                                            rs = st.executeQuery("SELECT br.request_id, CONCAT(u.fname, ' ', u.lname) AS user_name,u.role, u.email, b.title AS book_title,b.ISBN AS b_ISBN,bc.copy_id, br.request_date, bc.library_classification_number, bc.cupboard_no, bc.rack_no "
                                                    + "FROM book_request br "
                                                    + "JOIN user u ON br.u_id = u.u_id "
                                                    + "JOIN book_copies bc ON br.copy_id = bc.copy_id "
                                                    + "JOIN book b ON bc.book_id = b.book_id "
                                                    + "LEFT JOIN transaction t ON br.request_id = t.request_id "
                                                    + "WHERE br.request_status = 2 ");

                                            while (rs.next()) {
                                    %>
                                    <tr>
                                        <td><%= rs.getString("user_name")%></td>
                                        <td><%= rs.getString("email")%></td>
                                        <td><%= rs.getInt("role") == 0 ? "Student" : "Faculty"%></td>
                                        <td><%= rs.getString("book_title")%></td>
                                        <td><%= rs.getString("b_ISBN")%></td>
                                        <td><%= rs.getString("library_classification_number")%></td>
                                        <td><%= rs.getString("cupboard_no")%></td>
                                        <td><%= rs.getString("rack_no")%></td>
                                        <td><%= rs.getDate("request_date")%></td>
                                        <td>
                                            <form action="../SendRequestOTPServlet" method="post">
                                                <input type="hidden" name="request_id" value="<%= rs.getInt("request_id")%>">
                                                <input type="hidden" name="email" value="<%= rs.getString("email")%>"> 
                                                <input type="hidden" name="copy_id" value="<%= rs.getInt("copy_id")%>">
                                                <button type="submit" class="btn btn-sm btn-primary">COLLECT</button>
                                            </form>

                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='9' class='text-center'>Error: " + e.getMessage() + "</td></tr>");
                                        } finally {
                                            if (rs != null) {
                                                rs.close();
                                            }
                                            if (st != null) {
                                                st.close();
                                            }
                                            if (con != null) {
                                                con.close();
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>                        </div>
                    </div>

                </div>
                <!--  ALERT: Reservations Ready -->
                <hr>
                <!--Quick Action Cards-->

                <div class="row g-4 mt-4">
                    <!-- Add Book Card -->
                    <div class="col-md-6">
                        <div class="card shadow-lg border-0 h-100">
                            <div class="card-body text-center">
                                <i class="bi bi-journal-plus display-4 text-primary mb-3"></i>
                                <h5 class="card-title">Add New Book</h5>
                                <p class="card-text text-muted">Quickly add a new book to the library database.</p>
                                <a href="add_book.jsp" class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-1"></i> Add Book
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Add User Card -->
                    <div class="col-md-6">
                        <div class="card shadow-lg border-0 h-100">
                            <div class="card-body text-center">
                                <i class="bi bi-person-plus-fill display-4 text-success mb-3"></i>
                                <h5 class="card-title">Register User</h5>
                                <p class="card-text text-muted">Create a new student or faculty user account.</p>
                                <a href="customer_signup.jsp" class="btn btn-success">
                                    <i class="bi bi-person-plus me-1"></i> Add User
                                </a>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- Quick Action Cards-->

                <hr> 


                <!-- Content end -->





                <!-- Footer Start -->
                <div class="container-fluid pt-4 px-4">
                    <div class="bg-light rounded-top p-4">
                        <div class="row">
                            <div class="col-12 col-sm-6 text-center text-sm-start">
                                <!--<a href="#">Library Management System</a>-->
                            </div>
                            <div class="col-12 col-sm-6 text-center text-sm-end">
                                Developed with love by <a href="#">DCS Student</a>
                                </br>
                                Keeping Knowledge Accessible for Everyone
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Footer End -->

            </div>
            <!-- Content End -->

            <!-- Back to Top -->
            <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
        </div>


        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/chart/chart.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
    </body>

</html>