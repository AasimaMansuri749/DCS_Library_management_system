<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Admin - Book Management - DCS library</title>
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
    <%
        String subjectId = "";
        String subjectName = "All Subjects";
        String isbn = "";
        String title = "";
    %>
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
                            <!-- <img class="rounded-circle" src="img/my_profile_photo.png" alt="" style="width: 40px; height: 40px;"> -->
                            <!-- <div class="bg-success rounded-circle border border-2 border-white position-absolute end-0 bottom-0 p-1"></div> -->
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

                        <a href="transaction.jsp" class="nav-item nav-link ">
                            <i class="bi bi-arrow-left-right me-2"></i>Transactions
                        </a>

                        <a href="usermanagement.jsp" class="nav-item nav-link">
                            <i class="bi bi-people-fill me-2"></i>Users
                        </a>

                        <a href="books.jsp" class="nav-item nav-link active">
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
                            <button class="btn btn-outline-primary " type="button" data-bs-toggle="offcanvas" data-bs-target="#filterPanel" aria-controls="filterPanel">
                                <i class="bi bi-funnel-fill"></i> Filter
                            </button>
                            <button type="submit" class="btn btn-outline-primary m-4">Logout<i class="bi bi-box-arrow-right ms-2"></i></button>
                        </form>
                    </div>
                </nav>

                <div class="card my-2 p-4">

                    <div class="card mb-3 shadow-sm border-0 bg-light"> 
                        <div class="card-body py-3 px-3">
                            <h6 class="card-title mb-3 text-primary">
                                <i class="bi bi-funnel-fill me-2"></i>Applied Filters
                            </h6>

                            <%
                                String subjectParam = request.getParameter("subject_id");

//
//                                if ((subjectParam != null && !subjectParam.isEmpty())) {
//                                    subjectName = "All Subjects";
//                                } else {
                                if (subjectParam != null && !subjectParam.isEmpty() && !subjectParam.equals("All_Subjects")) {
                                    String[] parts = subjectParam.split("\\|");
                                    subjectId = parts[0];
                                    if (parts.length > 1) {
                                        subjectName = parts[1];
                                    }
                                }

                                isbn = request.getParameter("isbn");
                                title = request.getParameter("title");
//                                }
                            %>

                            <div class="row g-2">
                                <%-- Subject Filter --%>
                                <% if (!subjectName.isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-book me-1"></i><strong>Subject:</strong></small></div>
                                        <span class="badge bg-info text-dark" style="font-size: 0.75rem;"><%= subjectName%></span>
                                    </div>
                                </div>
                                <% } %>


                                <%-- ISBN Filter --%>
                                <% if (isbn != null && !isbn.trim().isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-upc me-1"></i><strong>ISBN:</strong></small></div>
                                        <span class="badge bg-warning text-dark" style="font-size: 0.75rem;"><%= isbn%></span>
                                    </div>
                                </div>
                                <% } %>

                                <%-- Title Filter --%>
                                <% if (title != null && !title.trim().isEmpty()) {%>
                                <div class="col-md-4">
                                    <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                        <div><small><i class="bi bi-journal-text me-1"></i><strong>Title:</strong></small></div>
                                        <span class="badge bg-success text-white" style="font-size: 0.75rem;"><%= title%></span>
                                    </div>
                                </div>
                                <% } %>

                                <%-- Show "No filters applied" if nothing is selected --%>
                                <% if ((subjectName.isEmpty()) && (isbn == null || isbn.trim().isEmpty()) && (title == null || title.trim().isEmpty())) { %>
                                <div class="col-12">
                                    <p class="text-muted mb-0"> Apply filters to see users and details.</p>
                                </div>

                                <% }%>
                            </div>
                        </div>
                    </div>


                    <div class="offcanvas offcanvas-end" tabindex="-1" id="filterPanel" aria-labelledby="filterPanelLabel">
                        <div class="offcanvas-header">
                            <h5 class="offcanvas-title" id="filterPanelLabel">Filter Books</h5>
                            <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                        </div>
                        <div class="offcanvas-body">
                            <form id ="booksfilterform" method="get" action="books.jsp">
                                <div class="mb-2">
                                    <label for="isbn">ISBN</label>
                                    <input type="text" class="form-control" name="isbn" id="isbn"
                                           value="<%= request.getParameter("isbn") != null ? request.getParameter("isbn") : ""%>">
                                </div>

                                <div class="mb-2">
                                    <label for="title">Title</label>
                                    <input type="text" class="form-control" name="title" id="title"
                                           value="<%= request.getParameter("title") != null ? request.getParameter("title") : ""%>">
                                </div>


                                <!-- Subject Dropdown -->
                                <div class="mb-2">
                                    <label for="subject" class="form-label">Select Subject</label>
                                    <select class="form-select" id="subject" name="subject_id">
                                        <option value="">All Subjects</option>
                                        <%
                                            try {
                                                Class.forName("com.mysql.cj.jdbc.Driver");
                                                Connection con = DriverManager.getConnection(
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


                                <button type="submit" class="btn btn-primary w-100 mt-3">Apply Filter</button>
                                <button type="button" id="clearFiltersButton" class="btn btn-outline-secondary w-100 mt-2">Clear Filters</button>

                            </form>

                        </div>
                    </div>

                    <div class="card-header bg-primary text-white">
                        Book List
                    </div>
                    <div class="card-body">
                        <%
 //    String isbn = request.getParameter("isbn");
 //    String title = request.getParameter("title");
 //    String subjectParam = request.getParameter("subject_id");
 //
 //    String subjectId = "";
                            boolean filterBySubject = false;

                            if (subjectParam != null && !subjectParam.isEmpty() && !subjectParam.equals("All_Subjects")) {
                                String[] parts = subjectParam.split("\\|");
                                subjectId = parts[0];
                                filterBySubject = true;
                            }

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");

                                // Create connection
                                Connection con = DriverManager.getConnection(
                                        "jdbc:mysql://localhost:3306/library_management_system",
                                        "root",
                                        "");
                                StringBuilder query = new StringBuilder(
                                        "SELECT b.book_id, b.ISBN, b.title, b.edition, s.subject_name, b.total_copies, b.added_date, b.page_count, b.book_cover_image "
                                        + "FROM library_management_system.book b "
                                        + "JOIN library_management_system.subject s ON b.subject_id = s.subject_id WHERE 1=1"
                                );

                                // Append conditions based on filters
                                if (isbn != null && !isbn.trim().isEmpty()) {
                                    query.append(" AND b.ISBN = ?");
                                }
                                if (title != null && !title.trim().isEmpty()) {
                                    query.append(" AND b.title LIKE ?");
                                }
                                if (filterBySubject) {
                                    query.append(" AND b.subject_id = ?");
                                }

                                PreparedStatement pst = con.prepareStatement(query.toString());

                                int paramIndex = 1;
                                if (isbn != null && !isbn.trim().isEmpty()) {
                                    pst.setString(paramIndex++, isbn.trim());
                                }
                                if (title != null && !title.trim().isEmpty()) {
                                    pst.setString(paramIndex++, "%" + title.trim() + "%");
                                }
                                if (filterBySubject) {
                                    pst.setInt(paramIndex++, Integer.parseInt(subjectId));
                                }

                                ResultSet rs = pst.executeQuery();
                        %>

                        <a href="add_book.jsp" class="btn btn-sm btn-info my-3"> + add Book</a>

                        <table class="table table-bordered mt-3">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>ISBN</th>
                                    <th>Title</th>
                                    <th>Edition</th>
                                    <th>Subject</th>

                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int count = 1;
                                    while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= count++%></td>
                                    <td><%= rs.getString("ISBN")%></td>
                                    <td><%= rs.getString("title")%></td>
                                    <td><%= rs.getInt("edition")%></td>
                                    <td><%= rs.getString("subject_name")%></td>

                                    <td>
                                        <a href="book_all_details.jsp?book_id=<%= rs.getInt("book_id")%>" class="btn btn-sm btn-info">Details</a>
                                        <a href="edit_book.jsp?book_id=<%= rs.getInt("book_id")%>" class="btn btn-sm btn-warning">Edit</a>
<!--                                        <a href="delete_book.jsp?book_id=<%= rs.getInt("book_id")%>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this book?');">Delete</a>-->
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <%
                                con.close();
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                            }
                        %>

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


        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/main.js"></script>

        <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const searchForm = document.getElementById("bookSearchForm");
                        const searchTermInput = document.getElementById("searchTerm");
                        const clearSearchButton = document.getElementById("clearSearchButton");
                        const filterPanel = document.getElementById("filterPanel");
                        const subjectFilterSelect = document.getElementById("subject");
                        const filterSubjectContainer = document.getElementById("filterSubjectContainer");
                        const filterSubjectDisplay = document.getElementById("filterStatus");
                        const filterSearchTermContainer = document.getElementById("filterSearchTermContainer");
                        const filterSearchTermDisplay = document.getElementById("filterSearchTerm");
                        const noFiltersMessage = document.getElementById("noFiltersMessage");

                        function updateFiltersDisplay() {
                            const subjectParam = new URLSearchParams(window.location.search).get("subject_id");
                            const searchTerm = new URLSearchParams(window.location.search).get("searchTerm");

                            if (subjectParam && subjectParam !== "") {
                                filterSubjectContainer.style.display = "flex";
                                const parts = subjectParam.split("|");
                                filterSubjectDisplay.innerText = parts[1];
                            } else {
                                filterSubjectContainer.style.display = "none";
                            }

                            if (searchTerm && searchTerm.trim() !== "") {
                                filterSearchTermContainer.style.display = "flex";
                                filterSearchTermDisplay.innerText = searchTerm;
                            } else {
                                filterSearchTermContainer.style.display = "none";
                            }

                            if ((subjectParam && subjectParam !== "") || (searchTerm && searchTerm.trim() !== "")) {
                                noFiltersMessage.style.display = "none";
                            } else {
                                noFiltersMessage.style.display = "block";
                            }
                        }

                        updateFiltersDisplay();

                        searchForm.addEventListener("submit", function (e) {
                            const searchTermValue = searchTermInput.value.trim();
                            const subjectIdValue = new URLSearchParams(window.location.search).get("subject_id");
                            const params = new URLSearchParams();
                            if (searchTermValue) {
                                params.append("searchTerm", searchTermValue);
                            }
                            if (subjectIdValue && subjectIdValue !== "") {
                                params.append("subject_id", subjectIdValue);
                            }
                            window.location.search = params.toString();
                        });

                        clearSearchButton.addEventListener("click", function () {
                            const subjectIdValue = new URLSearchParams(window.location.search).get("subject_id");
                            const params = new URLSearchParams();
                            if (subjectIdValue && subjectIdValue !== "") {
                                params.append("subject_id", subjectIdValue);
                            }
                            window.location.search = params.toString();
                        });

                        filterPanel.addEventListener('hidden.bs.offcanvas', function () {
                            updateFiltersDisplay();
                        });
                    });


                    document.getElementById("clearFiltersButton").addEventListener("click", function () {
                        document.getElementById("booksfilterform").reset();
                        window.location.href = window.location.pathname;
                    });

        </script>
    </body>

</html>