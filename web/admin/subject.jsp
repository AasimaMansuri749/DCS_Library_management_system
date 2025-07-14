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
                        <a href="admin_dashboard.jsp" class="nav-item nav-link ">
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

                        <a href="subject.jsp" class="nav-item nav-link active">
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
                    <a href="#" class="sidebar-toggler flex-shrink-0">
                        <i class="fa fa-bars"></i>
                    </a>

                    <div class="navbar-nav align-items-center ms-auto">
                        <form action="logout.jsp" method="post">
                            <button class="btn btn-outline-primary " type="button" data-bs-toggle="offcanvas" data-bs-target="#filterPanel" aria-controls="filterPanel">
                                Filter  <i class="bi bi-funnel-fill"></i> 
                            </button>
                            <button type="submit" class="btn btn-outline-primary m-4">Logout<i class="bi bi-box-arrow-right ms-2"></i></button>
                        </form>
                    </div>
                </nav>
                <!-- Navbar End -->


                <!--my content-->

                <!--  1. Issue/Return Logs -->
                <div class="card my-2">



                    <!-- Filter Summary -->
                    <!-- Applied Filters Summary -->
                    <div class="card mb-3 shadow-sm border-0 bg-light">
                        <div class="card-body py-3 px-3">
                            <h6 class="card-title mb-3 text-primary">
                                <i class="bi bi-funnel-fill me-2"></i>Applied Filters
                            </h6>
                            <%
                                String subjectParam = request.getParameter("subject_id");
                                String subjectId = "";
                                String subjectName = "All Subjects";

                                if (subjectParam != null && !subjectParam.isEmpty()) {
                                    String[] parts = subjectParam.split("\\|");
                                    subjectId = parts[0];
                                    subjectName = parts[1];
                                }
                            %>


                            <div class="row g-2">
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-info-circle me-1"></i><strong>Subject:</strong></small></div>
                                        <span class="badge bg-info text-dark" style="font-size: 0.75rem;" id="filterStatus"><%= subjectName != null ? subjectName : "--"%></span>
                                    </div>
                                </div>



                            </div>
                        </div>
                    </div>


                    <!--filter summary end-->


                    <!-- Offcanvas Filter Panel -->
                    <div class="offcanvas offcanvas-end" tabindex="-1" id="filterPanel" aria-labelledby="filterPanelLabel">
                        <div class="offcanvas-header">
                            <h5 class="offcanvas-title" id="filterPanelLabel">Filter Subjects</h5>
                            <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                        </div>
                        <div class="offcanvas-body">
                            <form method="get" action="subject.jsp">
                                <!-- Subject Dropdown -->
                                <div class="mb-2">
                                    <label for="subject" class="form-label">Select Subject</label>
                                    <select class="form-select" id="subject" name="subject_id">
                                        <option value="">All Subjects</option>
                                        <%
                                            try {
                                             Class.forName("com.mysql.cj.jdbc.Driver");


                                                Connection con =DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_management_system",
                    "root",
                    "");
                                                Statement st = con.createStatement();
                                                ResultSet rs = st.executeQuery("SELECT subject_id, subject_name FROM library_management_system.subject");
                                                while (rs.next()) {
                                        %>
                                        <option value="<%= rs.getInt("subject_id")%>|<%= rs.getString("subject_name")%>"><%= rs.getString("subject_name")%></option>
                                        <%
                                                }
                                                con.close();
                                            } catch (Exception e) {
                                                out.print(e);
                                            }
                                        %>
                                    </select>
                                </div>

                                <!-- Apply Filter Button -->
                                <button type="submit" class="btn btn-primary w-100 mt-3">Apply Filter</button>
                            </form>
                        </div>
                    </div>

                    <!--filters-->

                    
                    <div class="card-header bg-primary text-white">
                        Subject List
                    </div>
                    <div class="card-body">
                        <!-- Filters -->
                        



                        <!-- Table -->
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Subject Name</th>
                                    <th>Number of Books</th>
                                    <!--<th>Number of Books</th>-->
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                     Class.forName("com.mysql.cj.jdbc.Driver");

                                Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_management_system",
                    "root",
                    "");
                                        Statement st = con.createStatement();
                                        ResultSet rs = null;

                                        String query = "";

                                        if (subjectId != null && !subjectId.isEmpty()) {
                                            // If filter applied
                                            query = "SELECT s.subject_id, s.subject_name, COUNT(b.book_id) AS no_of_books "
                                                    + "FROM subject s "
                                                    + "LEFT JOIN book b ON s.subject_id = b.subject_id "
                                                    + "WHERE s.subject_id = " + subjectId + " "
                                                    + "GROUP BY s.subject_id, s.subject_name";
                                        } else {
                                            // If no filter, show all subjects
                                            query = "SELECT s.subject_id, s.subject_name, COUNT(b.book_id) AS no_of_books "
                                                    + "FROM subject s "
                                                    + "LEFT JOIN book b ON s.subject_id = b.subject_id "
                                                    + "GROUP BY s.subject_id, s.subject_name";
                                        }

                                        rs = st.executeQuery(query);

                                        while (rs.next()) {
                                            int subId = rs.getInt("subject_id");
                                %>
                                <tr>
                                    <td><%= rs.getString("subject_name")%></td>
                                    <td><%= rs.getString("no_of_books")%></td>
                                    
                                   <td>
    <a href="edit_subject.jsp?subjectId=<%= subId %>" class="btn btn-primary btn-sm">
        Edit
    </a>
</td>

                                </tr>
                                <%
                                        }
                                        con.close();
                                    } catch (Exception e) {
                                        out.print(e);
                                    }
                                %>

                            </tbody>
                        </table>

                    </div>
                </div>






                <!--my content-->



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