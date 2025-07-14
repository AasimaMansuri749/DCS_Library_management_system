<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Admin - User Management - DCS library</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <link href="img/favicon.ico" rel="icon">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

        <link href="css/bootstrap.min.css" rel="stylesheet">

        <link href="css/style.css" rel="stylesheet">
        <style>
            canvas {
                max-height: 400px;
            }

        </style>
    </head>
    <body>
        <script>
  window.addEventListener('DOMContentLoaded', () => {
    const today = new Date();
    const oneMonthAgo = new Date();
    oneMonthAgo.setMonth(today.getMonth() - 6);

    const formatDate = (date) => date.toISOString().split('T')[0];

    const dateFields = document.querySelectorAll('.date-field');

    dateFields.forEach(field => {
      if (field.name === 'startDate') {
        field.value = formatDate(oneMonthAgo);
      } else if (field.name === 'endDate') {
        field.value = formatDate(today);
      }else if (field.name === 'from') {
        field.value = formatDate(oneMonthAgo);
      } else if (field.name === 'to') {
        field.value = formatDate(today);
      }
    });
  });
</script>

        <div class="container-xxl position-relative bg-white d-flex p-0">
            <div class="sidebar pe-4 pb-3">
                <nav class="navbar bg-light navbar-light">
                    <a href="admin_dashboard.jsp" class="navbar-brand mx-4 mb-3"> <h3 class="text-primary">ADMIN <BR>DASHBOARD</h3>
                    </a>
                    <!--session display start-->
                    <%@ page session="true" %>
                    <%
                        String userName = (String) session.getAttribute("admin_name");
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
                        <a href="admin_dashboard.jsp" class="nav-item nav-link"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
                        <a href="transaction.jsp" class="nav-item nav-link"><i class="bi bi-arrow-left-right me-2"></i>Transactions</a>
                        <a href="usermanagement.jsp" class="nav-item nav-link "><i class="bi bi-people-fill me-2"></i>Users</a>
                        <a href="books.jsp" class="nav-item nav-link"><i class="bi bi-book me-2"></i>Books</a> 
                        <a href="subject.jsp" class="nav-item nav-link"><i class="bi bi-collection me-2"></i>Subjects</a> 
                        <a href="report.jsp" class="nav-item nav-link active"><i class="bi bi-bar-chart-fill me-2"></i>Reports</a> </div>
                </nav>
            </div>
            <div class="content">
                <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0 ">
                    <a href="#" class="sidebar-toggler flex-shrink-0">
                        <i class="fa fa-bars"></i>
                    </a>
                    <div class="navbar-nav align-items-center ms-auto">
                        <form action="logout.jsp" method="post">
                            <!--                            <button class="btn btn-outline-primary" style="z-index: 1050;" type="button" data-bs-toggle="offcanvas" data-bs-target="#userFilterPanel" aria-controls="userFilterPanel">
                                                            <i class="bi bi-funnel-fill"></i> Filter
                                                        </button>-->
                            <button type="submit" class="btn btn-outline-primary m-4">Logout<i class="bi bi-box-arrow-right ms-2"></i></button>
                        </form>
                    </div>
                </nav>

                <div class="container p-4">
                    <div class="tab-content mt-3" id="usersTabContent">
                        <div class="tab-pane fade show active" id="usersListPane" role="tabpanel">


                            <!--report-->
                            <div class="row">
                                <!-- Book Issue Report -->
                                <div class="col-md-4">
                                    <div class="card shadow-sm rounded p-3 mb-4">
                                        <h5 class="card-title">Book Issue Report</h5>
                                        <p class="card-text">View all issued books with user details and issue dates.</p>

                                        <form action="issue_report.jsp" method="post">
                                            <div class="form-group">
                                                <label for="from_date">Start Date:</label>
                                                <input type="date" name="from_date" class="form-control date-field" required>
                                            </div>
                                            <div class="form-group mt-2">
                                                <label for="to_date">End Date:</label>
                                                <input type="date" id="to_date" name="to_date" class="form-control date-field" required>
                                            </div>

                                            <button type="submit" class="btn btn-primary mt-3 w-100">
                                                <i class="bi bi-file-earmark-check"></i> View Report
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                <!-- Script to set default end date as today -->
                                <script>
                                    window.addEventListener('DOMContentLoaded', () => {
                                        const today = new Date();
                                        const oneMonthAgo = new Date();
                                        oneMonthAgo.setMonth(today.getMonth() - 6);

                                        const formatDate = (date) => date.toISOString().split('T')[0];

                                        document.querySelector('input[name="from_date"]').value = formatDate(oneMonthAgo);
                                        document.querySelector('input[name="to_date"]').value = formatDate(today);
                                        
                                        document.querySelector('input[name="startDate"]').value = formatDate(oneMonthAgo);
                                        document.querySelector('input[name="endDate"]').value = formatDate(today);
                                    });
                                </script>

                                <!-- End Book Issue Report -->


                                <div class="col-md-4">
                                    <div class="card shadow-sm rounded p-3 mb-4">
                                        <h5 class="card-title">Return Report</h5>
                                        <p class="card-text">Check all book returns.</p>

                                        <form action="return_report.jsp" method="get">
                                            <div class="form-group">
                                                <label for="fromDate">Start Date:</label>
                                                <input type="date" name="startDate" class="form-control date-field" required >
                                            </div>
                                            <div class="form-group mt-2">
                                                <label for="toDate">End Date:</label>
                                                <input type="date" name="endDate" class="form-control date-field" required>
                                            </div>
                                            <button type="submit" class="btn btn-primary mt-3 w-100">
                                                <i class="bi bi-file-earmark-check"></i> View Report
                                            </button>
                                        </form>
                                    </div>
                                </div>


                                <!-- Overdue Report -->

                                    <div class="col-md-4">
                                    <div class="card shadow-sm rounded p-3 mb-4">
                                        <h5 class="card-title">Books Overdue Report</h5>
                                        <p class="card-text">Check all Overdue books still not Returned .</p>

                                        <form action="book_overdue_report.jsp" method="get">
                                            <div class="form-group">
                                                <label for="fromDate">Start Date:</label>
                                                <input type="date" name="startDate" class="form-control date-field" required >
                                            </div>
                                            <div class="form-group mt-2">
                                                <label for="toDate">End Date:</label>
                                                <input type="date" name="endDate" class="form-control date-field" required >
                                            </div>
                                            <button type="submit" class="btn btn-primary mt-3 w-100">
                                                <i class="bi bi-file-earmark-check"></i> View Report
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                
                                <!-- Overdue Report -->
                             
                                
                                
                                <!--User Activity Report-->
                                <!--User Activity Report-->
                                <%
                                    // Generate current and 6 months ago dates
                                    java.util.Calendar cal = java.util.Calendar.getInstance();
                                    java.sql.Date currentDate = new java.sql.Date(cal.getTimeInMillis());

                                    cal.add(java.util.Calendar.MONTH, -6);
                                    java.sql.Date sixMonthsAgo = new java.sql.Date(cal.getTimeInMillis());
                                %>

                                <div class="col-md-4">
                                    <div class="card shadow-sm rounded p-3 mb-4">
                                        <h5 class="card-title">Inactive User Report</h5>
                                        <p class="card-text">Track users who are inactive.</p>

                                        <form action="user_activity_report.jsp" method="get">
                                            <div class="mb-2">
                                                <label for="fromDate" class="form-label">From (6 Months Ago)</label>
                                                <input type="date" class="form-control date-field" id="fromDate" name="from" >
                                            </div>
                                            <div class="mb-3">
                                                <label for="toDate" class="form-label">To (Today)</label>
                                                <input type="date" class="form-control date-field" id="toDate" name="to">
                                            </div>
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="bi bi-people-fill"></i> View Report
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                <!--User Activity Report-->
                                <!--User Activity Report-->

                                <!--Reservation Status Report-->

                                <div class="col-md-4">
                                    <div class="card shadow-sm rounded p-3 mb-4">
                                        <h5 class="card-title">Reservation Status Report</h5>
                                        <p class="card-text">View all reserved books and user details.</p>

                                        <form action="reservation_status_report.jsp" method="get">
                                            <div class="form-group">
                                                <label for="fromDate">Start Date:</label>
                                                <input type="date" name="startDate" class="form-control date-field" required value="2024-01-01">
                                            </div>
                                            <div class="form-group mt-2">
                                                <label for="toDate">End Date:</label>
                                                <input type="date" name="endDate" class="form-control date-field" required value="2025-06-30">
                                            </div>
                                            <button type="submit" class="btn btn-primary mt-3 w-100">
                                                <i class="bi bi-file-earmark-check"></i> View Report
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <!--Reservation Status Report-->

                                <!--Book Inventory Report-->

                                <div class="col-md-4">
                                    <div class="card shadow-sm rounded p-3 mb-4">
                                        <h5 class="card-title">Book Inventory Report</h5>
                                        <p class="card-text">View all books with full details.</p>

                                        <form action="book_inventory_report.jsp" method="get">
                                            <div class="form-group">
                                                <label for="fromDate">Start Date:</label>
                                                <input type="date" name="startDate" class="form-control date-field" required value="2024-01-01">
                                            </div>
                                            <div class="form-group mt-2">
                                                <label for="toDate">End Date:</label>
                                                <input type="date" name="endDate" class="form-control date-field" required value="2025-06-30">
                                            </div>
                                            <button type="submit" class="btn btn-primary mt-3 w-100">
                                                <i class="bi bi-file-earmark-check"></i> View Report
                                            </button>
                                        </form>
                                    </div>
                                </div>
                                <!--Book Inventory Report-->

                                
                                <!-- book grievance report -->
<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4 ">
    <h5 class="card-title">Book Grievance Report</h5>
    <p class="card-text">List of books that have grievances reported.</p>

    <!-- IMPORTANT: Change action to correct JSP page -->
    <form action="grievance_report.jsp" method="get">
      <div class="form-group">
        <label for="fromDate">Start Date:</label>
        <input type="date" name="startDate" id="fromDate" class="form-control date-field" required >
      </div>
      <div class="form-group mt-2">
        <label for="toDate">End Date:</label>
        <input type="date" name="endDate" id="toDate" class="form-control date-field" required >
      </div>
      <button type="submit" class="btn btn-primary mt-3 w-100">
        <i class="bi bi-file-earmark-check"></i> View Report
      </button>
    </form>
  </div>
</div>
<!-- end book grievance report -->

                                <!-- recommendation from users for book  -->
<div class="col-md-4">
  <div class="card shadow-sm rounded p-3 mb-4 ">
    <h5 class="card-title">Recommendations for Books</h5>
    <p class="card-text">list of books recommended by users.</p>

    <!-- IMPORTANT: Change action to correct JSP page -->
    <form action="recommendation_report.jsp" method="get">
      <div class="form-group">
        <label for="fromDate">Start Date:</label>
        <input type="date" name="startDate" id="fromDate" class="form-control date-field" required >
      </div>
      <div class="form-group mt-2">
        <label for="toDate">End Date:</label>
        <input type="date" name="endDate" id="toDate" class="form-control date-field" required >
      </div>
      <button type="submit" class="btn btn-primary mt-3 w-100">
        <i class="bi bi-file-earmark-check"></i> View Report
      </button>
    </form>
  </div>
</div>
                                <!-- recommendation from users for book  -->


                            </div>

                            <!--report-->


                        </div> 
                    </div> 
                </div>
                <!-- Chart Section -->
                <div class="row">
                    <!-- Pie Chart -->
                    <div class="col-sm-12 col-md-6">
                        <div class="bg-light rounded h-100 p-4">
                            <h6 class="mb-4">Issued Books: Students vs Faculty</h6>
                            <canvas id="pie-chart"></canvas>
                            <!-- (Existing JSP + Script remains same here) -->
                        </div>
                    </div>

                    <!-- Multi Line Chart -->
                    <div class="col-sm-12 col-md-6">
                        <div class="bg-light rounded h-100 p-4">
                            <h6 class="mb-4">Monthly Book Trends (Line Chart)</h6>
                            <canvas id="salse-revenue"></canvas>
                        </div>
                    </div>

                </div>


                <div class="row my-3"> 
                    <div class="col-sm-12 col-xl-6">
                        <div class="bg-light rounded h-100 p-4">
                            <h6 class="mb-4">Overdue Books (Student vs Faculty)</h6>
                            <canvas id="overdueChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Chart Section ends-->

                <!-- Pie Chart starts -->
                <%
                    int studentCount = 0;
                    int facultyCount = 0;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", ""); // adjust credentials
                        Statement stmt = conn.createStatement();

                        String query = "SELECT u.role, COUNT(*) AS total_issued "
                                + "FROM transaction t "
                                + "INNER JOIN book_request br ON t.request_id = br.request_id "
                                + "INNER JOIN user u ON br.u_id = u.u_id "
                                + "GROUP BY u.role";

                        ResultSet rs = stmt.executeQuery(query);
                        while (rs.next()) {
                            int role = rs.getInt("role"); // 0 = student, 1 = faculty
                            if (role == 0) {
                                studentCount = rs.getInt("total_issued");
                            } else if (role == 1) {
                                facultyCount = rs.getInt("total_issued");
                            }
                        }

                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>

                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                                    const ctx = document.getElementById('pie-chart').getContext('2d');
                                    new Chart(ctx, {
                                        type: 'pie',
                                        data: {
                                            labels: ['Student', 'Faculty'],
                                            datasets: [{
                                                    label: 'Issued Books',
                                                    data: [<%= studentCount%>, <%= facultyCount%>],
                                                    backgroundColor: ['#4e73df', '#1cc88a'],
                                                    borderWidth: 1
                                                }]
                                        },
                                        options: {
                                            responsive: true,
                                            plugins: {
                                                legend: {
                                                    position: 'bottom',
                                                }
                                            }
                                        }
                                    });
                </script>

                <!--pie chart end-->

                <!--pie chart for overdue-->
                <%
                    int[] studentOverdue = new int[12];
                    int[] facultyOverdue = new int[12];

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

                        String sql = "SELECT MONTH(t.due_date) AS m, u.role, COUNT(*) AS c "
                                + "FROM transaction t "
                                + "JOIN book_request br ON t.request_id = br.request_id "
                                + "JOIN user u ON br.u_id = u.u_id "
                                + "WHERE (t.return_date > t.due_date) OR (t.return_date IS NULL AND t.due_date < CURDATE()) "
                                + "GROUP BY MONTH(t.due_date), u.role";

                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            int month = rs.getInt("m") - 1;
                            int role = rs.getInt("role");
                            int count = rs.getInt("c");

                            if (role == 0) {
                                studentOverdue[month] = count;
                            } else if (role == 1) {
                                facultyOverdue[month] = count;
                            }
                        }

                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    String studentOverdueData = String.join(",", Arrays.stream(studentOverdue).mapToObj(String::valueOf).toArray(String[]::new));
                    String facultyOverdueData = String.join(",", Arrays.stream(facultyOverdue).mapToObj(String::valueOf).toArray(String[]::new));
                %>


                <script>
                    const ctxOverdue = document.getElementById('overdueChart').getContext('2d');

                    new Chart(ctxOverdue, {
                        type: 'line',
                        data: {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                            datasets: [
                                {
                                    label: 'Student Overdue',
                                    data: [<%= studentOverdueData%>],
                                    borderColor: 'rgba(255, 99, 132, 1)',
                                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                                    fill: false,
                                    tension: 0.3
                                },
                                {
                                    label: 'Faculty Overdue',
                                    data: [<%= facultyOverdueData%>],
                                    borderColor: 'rgba(54, 162, 235, 1)',
                                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                    fill: false,
                                    tension: 0.3
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {position: 'bottom'},
                                title: {
                                    display: true,
                                    text: 'Monthly Overdue Books by Role'
                                }
                            },
                            scales: {
                                y: {
        beginAtZero: true,
        ticks: {
            stepSize: 1, // Forces step to 1 unit
            callback: function(value) {
                if (Number.isInteger(value)) return value;
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


                <!--pie chart for overdue ends-->


                <!--multi line chart-->
                <%
                    int[] issued = new int[12];
                    int[] returned = new int[12];
                    int[] overdue = new int[12];

                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

                        // Issued books per month
                        ps = conn.prepareStatement("SELECT MONTH(issue_date) AS m, COUNT(*) AS c FROM transaction WHERE issue_date IS NOT NULL GROUP BY MONTH(issue_date)");
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            issued[rs.getInt("m") - 1] = rs.getInt("c");
                        }
                        rs.close();
                        ps.close();

                        // Returned books per month
                        ps = conn.prepareStatement("SELECT MONTH(return_date) AS m, COUNT(*) AS c FROM transaction WHERE return_date IS NOT NULL GROUP BY MONTH(return_date)");
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            returned[rs.getInt("m") - 1] = rs.getInt("c");
                        }
                        rs.close();
                        ps.close();

                        // Overdue books per month
                        ps = conn.prepareStatement(
                                "SELECT MONTH(due_date) AS m, COUNT(*) AS c FROM transaction "
                                + "WHERE (return_date > due_date) OR (return_date IS NULL AND due_date < CURDATE()) "
                                + "GROUP BY MONTH(due_date)");
                        rs = ps.executeQuery();
                        while (rs.next()) {
                            overdue[rs.getInt("m") - 1] = rs.getInt("c");
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

                    String issuedData = String.join(",", Arrays.stream(issued).mapToObj(String::valueOf).toArray(String[]::new));
                    String returnedData = String.join(",", Arrays.stream(returned).mapToObj(String::valueOf).toArray(String[]::new));
                    String overdueData = String.join(",", Arrays.stream(overdue).mapToObj(String::valueOf).toArray(String[]::new));
                %>


                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    const ctxLine = document.getElementById('salse-revenue').getContext('2d');

                    const salseRevenueChart = new Chart(ctxLine, {
                        type: 'line',
                        data: {
                            labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                            datasets: [
                                {
                                    label: 'Issued Books',
                                    data: [<%= issuedData%>],
                                    borderColor: 'rgba(54, 162, 235, 1)',
                                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                    fill: false,
                                    tension: 0.3
                                },
                                {
                                    label: 'Returned Books',
                                    data: [<%= returnedData%>],
                                    borderColor: 'rgba(75, 192, 75, 1)',
                                    backgroundColor: 'rgba(75, 192, 75, 0.2)',
                                    fill: false,
                                    tension: 0.3
                                },
                                {
                                    label: 'Overdue Books',
                                    data: [<%= overdueData%>],
                                    borderColor: 'rgba(255, 99, 71, 1)',
                                    backgroundColor: 'rgba(255, 99, 71, 0.2)',
                                    fill: false,
                                    tension: 0.3
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            plugins: {
                                legend: {position: 'bottom'},
                                title: {
                                    display: true,
                                    text: 'Monthly Book Transactions'
                                }
                            },
                            scales: {
                                y: {
    beginAtZero: true,
    ticks: {
        stepSize: 1,
        callback: function(value) {
            if (Number.isInteger(value)) return value;
            return '';
        }
    },
    title: {
        display: true,
        text: 'Number of Books'
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

                <!--multi line chart ends -->


                <div class="container-fluid pt-4 px-4">
                    <div class="bg-light rounded-top p-4">
                        <div class="row">
                            <div class="col-12 col-sm-6 text-center text-sm-start">
                            </div>
                            <div class="col-12 col-sm-6 text-center text-sm-end">
                                Developed with love by <a href="#">DCS Student</a>
                                </br>
                                Keeping Knowledge Accessible for Everyone
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
        </div> 

        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <!--        <script src="lib/easing/easing.min.js"></script>
                <script src="lib/waypoints/waypoints.min.js"></script>
                <script src="lib/owlcarousel/owl.carousel.min.js"></script>
                <script src="lib/tempusdominus/js/moment.min.js"></script>
                <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>-->
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

        <script src="js/main.js"></script>

        <script>
                    function updateUserFilterDisplay() {
                        const params = new URLSearchParams(window.location.search);
                        let filtersAreSet = false;

                        const userName = params.get("name");
                        const regNo = params.get("regNo");
                        const email = params.get("email");
                        const phone = params.get("phone");
                        const userStatus = params.get("status");

                        const filterNameContainer = document.getElementById("filterNameContainer");
                        const filterRegNoContainer = document.getElementById("filterRegNoContainer");
                        const filterEmailContainer = document.getElementById("filterEmailContainer");
                        const filterPhoneContainer = document.getElementById("filterPhoneContainer");
                        const filterUserStatusContainer = document.getElementById("filterUserStatusContainer");
                        const noFiltersMessage = document.getElementById("noFiltersMessage");
                        const userTableContainer = document.getElementById("userTableContainer");

                        if (userName) {
                            document.getElementById("filterUserName").innerText = userName;
                            filterNameContainer.style.display = "flex";
                            filtersAreSet = true;
                        } else {
                            filterNameContainer.style.display = "none";
                        }

                        if (regNo) {
                            document.getElementById("filterRegNo").innerText = regNo;
                            filterRegNoContainer.style.display = "flex";
                            filtersAreSet = true;
                        } else {
                            filterRegNoContainer.style.display = "none";
                        }

                        if (email) {
                            document.getElementById("filterEmail").innerText = email;
                            filterEmailContainer.style.display = "flex";
                            filtersAreSet = true;
                        } else {
                            filterEmailContainer.style.display = "none";
                        }

                        if (phone) {
                            document.getElementById("filterPhone").innerText = phone;
                            filterPhoneContainer.style.display = "flex";
                            filtersAreSet = true;
                        } else {
                            filterPhoneContainer.style.display = "none";
                        }

                        if (userStatus) {
                            const statusLabel = userStatus.charAt(0).toUpperCase() + userStatus.slice(1);
                            document.getElementById("filterUserStatus").innerText = statusLabel;
                            filterUserStatusContainer.style.display = "flex";
                            filtersAreSet = true;
                        } else {
                            filterUserStatusContainer.style.display = "none";
                        }

                        if (filtersAreSet) {
                            noFiltersMessage.style.display = "none";
                            userTableContainer.style.display = "block";
                        } else {
                            noFiltersMessage.style.display = "block";
                            userTableContainer.style.display = "none";
                        }
                    }

                    document.getElementById("userFilterForm").addEventListener("submit", function (e) {
                        e.preventDefault();
                        const params = new URLSearchParams();
                        const userName = document.getElementById("userName").value.trim();
                        const regNo = document.getElementById("regNo").value.trim();
                        const email = document.getElementById("email").value.trim();
                        const phone = document.getElementById("phone").value.trim();
                        const userStatus = document.getElementById("userStatus").value;

                        if (userName)
                            params.append("name", userName);
                        if (regNo)
                            params.append("regNo", regNo);
                        if (email)
                            params.append("email", email);
                        if (phone)
                            params.append("phone", phone);
                        if (userStatus)
                            params.append("status", userStatus);

                        window.location.search = params.toString();
                    });

                    document.getElementById("clearFiltersButton").addEventListener("click", function () {
                        document.getElementById("userFilterForm").reset();
                        window.location.href = window.location.pathname;
                    });

                    window.addEventListener("DOMContentLoaded", updateUserFilterDisplay);
        </script>

    </body>
</html>