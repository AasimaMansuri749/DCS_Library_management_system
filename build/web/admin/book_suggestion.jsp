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

                        <a href="subject.jsp" class="nav-item nav-link">
                            <i class="bi bi-collection me-2"></i>Subjects
                        </a>

                        <a href="report.jsp" class="nav-item nav-link">
                            <i class="bi bi-bar-chart-fill me-2"></i>Reports
                        </a>
                        <a href="Book Suggestions.jsp" class="nav-item nav-link active">
                            <i class="bi bi-journal-plus me-2"></i>Book Suggestion

                        </a>
                    </div>


                </nav>
            </div>
            <!-- Sidebar End -->


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

                <!--table--> 


                <div class="container-fluid pt-4 px-4">
                    <div class="bg-light rounded p-4">
                        <h4 class="mb-4"><i class="bi bi-journal-plus me-2"></i>Suggested Books</h4>
                        <div class="table-responsive">
                            <table class="table table-bordered table-striped align-middle">
                                <thead class="table-primary">
                                    <tr>
                                        <th>#</th>
                                        <th>Title</th>
                                        <th>Author</th>
                                        <th>Edition</th>
                                        <th>ISBN</th>
                                        <th>Publisher</th>
                                        <th>Status</th>
                                        <th>Suggested Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            Connection con = DriverManager.getConnection(
                                                    "jdbc:mysql://localhost:3306/library_management_system", "root", "");
                                            String sql = "SELECT * FROM book_suggestions ORDER BY suggested_date DESC";
                                            PreparedStatement pst = con.prepareStatement(sql);
                                            ResultSet rs = pst.executeQuery();
                                            int count = 1;
                                            while (rs.next()) {
                                                String title = rs.getString("title");
                                                String author = rs.getString("author");
                                                String edition = rs.getString("edition");
                                                String isbn = rs.getString("isbn");
                                                String publisher = rs.getString("publisher");
                                                int status = rs.getInt("status");
                                                String suggestedDate = rs.getString("suggested_date");
                                                String statusText = "Unknown";
                                                switch (status) {
                                                    case 0:
                                                        statusText = "Pending";
                                                        break;
                                                    case 1:
                                                        statusText = "Reviewed";
                                                        break;
                                                    case 2:
                                                        statusText = "Added";
                                                        break;
                                                    case 3:
                                                        statusText = "Rejected";
                                                        break;
                                                }

                                    %>
                                    <tr>
                                        <td><%= count++%></td>
                                        <td><%= title%></td>
                                        <td><%= author%></td>
                                        <td><%= (edition != null && !edition.isEmpty()) ? edition : "-"%></td>
                                        <td><%= (isbn != null && !isbn.isEmpty()) ? isbn : "-"%></td>
                                        <td><%= (publisher != null && !publisher.isEmpty()) ? publisher : "-"%></td>
                                        <td><span class="badge bg-secondary"><%= statusText%></span></td>
                                        <td><%= suggestedDate%></td>
                                        <td>
                                            <%if(status==0){ %>
                                            
                                            <form action="../HandleSuggestionServlet" method="post" style="display:inline-block;">
                                                <input type="hidden" name="suggestion_id" value="<%= rs.getInt("id")%>">

                                                <button type="submit" name="action" value="add" class="btn btn-success btn-sm">Add Book</button>
                                            </form>
                                            <form action="../HandleSuggestionServlet" method="post" style="display:inline-block;">
                                                <input type="hidden" name="suggestion_id" value="<%= rs.getInt("id")%>">

                                                <button type="submit" name="action" value="reject" class="btn btn-danger btn-sm">Reject</button>
                                            </form>
                                                 <% }%>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        con.close();
                                    } catch (Exception e) {
                                    %>
                                    <tr>
                                        <td colspan="8" class="text-danger">Error: <%= e.getMessage()%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!--table end-->

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