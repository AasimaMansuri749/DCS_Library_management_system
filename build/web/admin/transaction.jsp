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
        
    </head>

    <body>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <div class="container-xxl position-relative bg-white d-flex p-0">


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
                        <a href="admin_dashboard.jsp" class="nav-item nav-link">
                            <i class="bi bi-speedometer2 me-2"></i>Dashboard
                        </a>

                        <a href="transaction.jsp" class="nav-item nav-link active">
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
            <div class="content">
                <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0">
                    <a href="#" class="sidebar-toggler flex-shrink-0">
                        <i class="fa fa-bars"></i>
                    </a>
                    <div class="navbar-nav align-items-center ms-auto">
                        <form action="logout.jsp" method="post">
                            <button class="btn btn-outline-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#filterPanel" aria-controls="filterPanel">
                                Filter  <i class="bi bi-funnel-fill"></i>
                            </button>
                            <button type="submit" class="btn btn-outline-primary m-4">Logout<i class="bi bi-box-arrow-right ms-2"></i></button>
                        </form>
                    </div>
                </nav>


                <div class="card my-2">
                    <%
                        String status = request.getParameter("status");
                        String memberType = request.getParameter("memberType");

                        String bookTitle = request.getParameter("bookTitle");
                        String isbn = request.getParameter("isbn");
                        String memberName = request.getParameter("memberName");
                        String classificationNo = request.getParameter("classificationNo");
                    %>



                    <div class="card mb-3 shadow-sm border-0 bg-light">
                        <div class="card-body py-3 px-3">
                            <h6 class="card-title mb-3 text-primary">
                                <i class="bi bi-funnel-fill me-2"></i>Applied Filters
                            </h6>

                            <div class="row g-2">
                                <% if (status != null && !status.isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-info-circle me-1"></i><strong>Status:</strong></small></div>
                                        <span class="badge bg-info text-dark" style="font-size: 0.75rem;"><%= status%></span>
                                    </div>
                                </div>
                                <% } %>

                                <% if (memberType != null && !memberType.isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-person-badge me-1"></i><strong>Member Type:</strong></small></div>
                                        <span class="badge bg-success" style="font-size: 0.75rem;">
                                            <%= "0".equals(memberType) ? "Student" : ("1".equals(memberType) ? "Faculty" : "")%>
                                        </span>                    </div>
                                </div>
                                <% } %>

                                <% if (bookTitle != null && !bookTitle.isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-book me-1"></i><strong>Book Title:</strong></small></div>
                                        <span class="badge bg-dark" style="font-size: 0.75rem;"><%= bookTitle%></span>
                                    </div>
                                </div>
                                <% } %>

                                <% if (isbn != null && !isbn.isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-upc-scan me-1"></i><strong>ISBN:</strong></small></div>
                                        <span class="badge bg-warning text-dark" style="font-size: 0.75rem;"><%= isbn%></span>
                                    </div>
                                </div>
                                <% } %>

                                <% if (memberName != null && !memberName.isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-person me-1"></i><strong>Member Name:</strong></small></div>
                                        <span class="badge bg-primary" style="font-size: 0.75rem;"><%= memberName%></span>
                                    </div>
                                </div>
                                <% } %>

                                <% if (classificationNo != null && !classificationNo.isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-list-ol me-1"></i><strong>Classification No:</strong></small></div>
                                        <span class="badge bg-secondary" style="font-size: 0.75rem;"><%= classificationNo%></span>
                                    </div>
                                </div>
                                <% }%>
                            </div>
                        </div>
                    </div>

                    <div class="offcanvas offcanvas-end" tabindex="-1" id="filterPanel" aria-labelledby="filterPanelLabel">
                        <div class="offcanvas-header">
                            <h5 class="offcanvas-title" id="filterPanelLabel">Filter Transactions</h5>
                            <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                        </div>
                        <div class="offcanvas-body">
                            <form id="transactionfilter" method="get" action="transaction.jsp">
                                <div class="mb-2">
                                    <label for="status" class="form-label">Status</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="" <%= (status == null || status.isEmpty()) ? "selected" : ""%>>-- Select Status --</option>
                                        <option value="issued" <%= "issued".equals(status) ? "selected" : ""%>>Issued</option>
                                        <option value="returned" <%= "returned".equals(status) ? "selected" : ""%>>Returned</option>
                                        <option value="overdue" <%= "overdue".equals(status) ? "selected" : ""%>>Overdue</option>
                                    </select>
                                </div>

                                <div class="mb-2">
                                    <label for="memberType" class="form-label">Member Type</label>
                                    <select class="form-select" id="memberType" name="memberType">
                                        <option value="" <%= (memberType == null || memberType.isEmpty()) ? "selected" : ""%>>-- Select Type --</option>
                                        <option value="0" <%= "0".equals(memberType) ? "selected" : ""%>>Student</option>
                                        <option value="1" <%= "1".equals(memberType) ? "selected" : ""%>>Faculty</option>
                                    </select>

                                </div>

                                <div class="mb-2">
                                    <label for="bookTitle" class="form-label">Book Title</label>
                                    <input type="text" class="form-control" id="bookTitle" name="bookTitle" placeholder="Enter book title"
                                           value="<%= bookTitle != null ? bookTitle : ""%>">
                                </div>

                                <div class="mb-2">
                                    <label for="isbn" class="form-label">ISBN</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" placeholder="Enter ISBN"
                                           value="<%= isbn != null ? isbn : ""%>">
                                </div>

                                <div class="mb-2">
                                    <label for="classificationNo" class="form-label">Library Classification No.</label>
                                    <input type="text" class="form-control" id="classificationNo" name="classificationNo" placeholder="Enter classification no"
                                           value="<%= classificationNo != null ? classificationNo : ""%>">
                                </div>

                                <div class="mb-2">
                                    <label for="memberName" class="form-label">Member Name</label>
                                    <input type="text" class="form-control" id="memberName" name="memberName" placeholder="Enter name"
                                           value="<%= memberName != null ? memberName : ""%>">
                                </div>

                                <button type="submit" class="btn btn-primary w-100 mt-3">Apply Filters</button>
                                <button type="button" id="clearFiltersButton" class="btn btn-outline-secondary w-100 mt-2"
                                        onclick="window.location.href = 'transaction.jsp'">Clear Filters</button>
                            </form>
                        </div>
                    </div>





                    <div class="card-header bg-primary text-white">
                        Issue/Return Logs
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Status</th>
                                        <th>Member Name</th>
                                        <th>Member Type</th>
                                        <th>Book Title</th>
                                        <th>ISBN</th>
                                        <th>Library Classification Number</th>
                                        <th>Issue Date</th>
                                        <th>Due Date</th>
                                        <th>Return Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        String url = "jdbc:mysql://localhost:3306/library_management_system";
                                        String username = "root";
                                        String password = "";

                                        Connection conn = null;
                                        PreparedStatement pst = null;
                                        ResultSet rs = null;

                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");
                                            conn = DriverManager.getConnection(url, username, password);

                                            StringBuilder sql = new StringBuilder();
                                            sql.append("SELECT t.transaction_id, t.issue_date, t.due_date, t.return_date, b.ISBN, ")
                                                    .append("bc.library_classification_number, br.request_status, ")
                                                    .append("u.role AS member_type, CONCAT(u.fname, ' ', u.lname) AS member_name, b.title AS book_title ")
                                                    .append("FROM transaction t ")
                                                    .append("JOIN book_request br ON t.request_id = br.request_id ")
                                                    .append("JOIN user u ON br.u_id = u.u_id ")
                                                    .append("JOIN book_copies bc ON br.copy_id = bc.copy_id ")
                                                    .append("JOIN book b ON bc.book_id = b.book_id ")
                                                    .append("WHERE 1=1 ");

                                            if (status != null && !status.isEmpty()) {
                                                switch (status.toLowerCase()) {
                                                    case "issued":
                                                        sql.append(" AND t.return_date IS NULL ");
                                                        break;
                                                    case "returned":
                                                        sql.append(" AND t.return_date IS NOT NULL ");
                                                        break;
                                                    case "overdue":
                                                        sql.append(" AND t.return_date IS NULL AND t.due_date < CURDATE() ");
                                                        break;
                                                }
                                            }

                                            if (memberType != null && !memberType.isEmpty()) {
                                                sql.append(" AND u.role = ? ");
                                            }
                                            if (bookTitle != null && !bookTitle.isEmpty()) {
                                                sql.append(" AND b.title LIKE ? ");
                                            }
                                            if (isbn != null && !isbn.isEmpty()) {
                                                sql.append(" AND b.ISBN = ? ");
                                            }
                                            if (memberName != null && !memberName.isEmpty()) {
                                                sql.append(" AND CONCAT(u.fname, ' ', u.lname) LIKE ? ");
                                            }
                                            if (classificationNo != null && !classificationNo.isEmpty()) {
                                                sql.append(" AND bc.library_classification_number = ? ");
                                            }

                                            pst = conn.prepareStatement(sql.toString());

                                            int paramIndex = 1;
                                            if (memberType != null && !memberType.isEmpty()) {
                                                pst.setString(paramIndex++, memberType);
                                            }
                                            if (bookTitle != null && !bookTitle.isEmpty()) {
                                                pst.setString(paramIndex++, "%" + bookTitle + "%");
                                            }
                                            if (isbn != null && !isbn.isEmpty()) {
                                                pst.setString(paramIndex++, isbn);
                                            }
                                            if (memberName != null && !memberName.isEmpty()) {
                                                pst.setString(paramIndex++, "%" + memberName + "%");
                                            }
                                            if (classificationNo != null && !classificationNo.isEmpty()) {
                                                pst.setString(paramIndex++, classificationNo);
                                            }

                                            rs = pst.executeQuery();

                                            boolean hasResults = false;

                                            while (rs.next()) {
                                                hasResults = true;

                                                Date dueDate = rs.getDate("due_date");
                                                Date returnDate = rs.getDate("return_date");

                                                String trStatus = (returnDate != null) ? "Returned"
                                                        : (dueDate != null && dueDate.before(new java.util.Date())) ? "Overdue"
                                                        : "Issued";
                                    %>
                                    <tr>
                                        <td><%= trStatus%></td>
                                        <td><%= rs.getString("member_name")%></td>
                                        <td><%= rs.getInt("member_type") == 0 ? "Student" : "Faculty"%></td>

                                        <td><%= rs.getString("book_title")%></td>
                                        <td><%= rs.getString("ISBN")%></td>
                                        <td><%= rs.getString("library_classification_number")%></td>
                                        <td><%= rs.getDate("issue_date")%></td>
                                        <td><%= rs.getDate("due_date")%></td>
                                        <td><%= (returnDate != null) ? returnDate.toString() : "-"%></td>
                                        <td>
                                            <% if (returnDate != null) { %>
                                            <span class="badge bg-success">Returned</span>
                                            <% } else {%>
                                            <form action="../SendReturnOTPServlet" method="get" style="display:inline;">
                                                <input type="hidden" name="transaction_id" value="<%= rs.getInt("transaction_id")%>">
                                                <button type="submit" class="btn btn-sm btn-outline-primary">Return</button>
                                            </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                        }

                                        if (!hasResults) {
                                    %>
                                    <tr>
                                        <td colspan="10" class="text-center text-danger">No records found matching the filters.</td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            out.println("<tr><td colspan='10' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                                        } finally {
                                            if (rs != null) try {
                                                rs.close();
                                            } catch (Exception e) {
                                            }
                                            if (pst != null) try {
                                                pst.close();
                                            } catch (Exception e) {
                                            }
                                            if (conn != null) try {
                                                conn.close();
                                            } catch (Exception e) {
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>





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

            <script>
                document.getElementById("clearFiltersButton").addEventListener("click", function () {
                    document.getElementById("transactionfilter").reset();
                    window.location.href = "transaction.jsp";
                });
            </script>
            <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="lib/chart/chart.min.js"></script>
            <script src="lib/easing/easing.min.js"></script>
            <script src="lib/waypoints/waypoints.min.js"></script>
            <script src="lib/owlcarousel/owl.carousel.min.js"></script>
            <script src="lib/tempusdominus/js/moment.min.js"></script>
            <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
            <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

            <script src="js/main.js"></script>
    </body>

</html>