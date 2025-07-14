<%@page import="java.util.ArrayList"%>
<%@page import="java.util.*, java.sql.*"%>
<%@ page session="true" %>
<%
    // Session check
    Integer u_id = (Integer) session.getAttribute("u_id");
    if (u_id == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String subject = request.getParameter("subject");
    String selectedSubject = subject;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>DCS Library - Student Search</title>
        <meta name="viewport" content="width=device-width, initial-scale=1"> <!-- Important for mobile responsiveness -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body{
                background:linear-gradient(to right, #a1c4fd, #c2e9fb);
            }

            /*            .image_card{
                            width: 100px;
                            height: 200px;
                            display: block;
                        }*/
            .row-cols-md-3>* {
                flex: 0 0 auto;
                width: 300px;
            }

            .k_img{
                width: 200px;
                height: 300px;
                object-fit: contain;
                margin: 0 0;
            }
        </style>
    </head>
    <body>
        <%//  out.println("DEBUG: fname=" + session.getAttribute("fname") + ", lname=" + session.getAttribute("lname")); 
        %>

        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg bg-dark navbar-dark">
            <div class="container">
                <!--      <a class="navbar-brand fw-bold fs-4" href="#">DCS LIBRARY</a>
                      <span class="text-white ms-3">
                <%--<%= // session.getAttribute("fname") != null ? session.getAttribute("fname") : "" %>--%>
                <%--<%= session.getAttribute("lname") != null ? session.getAttribute("lname") : "" %>--%>
              </span>-->

                <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="#">
                    DCS LIBRARY
                </a>
                <span class="navbar-text text-white ms-3">
                    <%      String fname = (String) session.getAttribute("fname");
                        String lname = (String) session.getAttribute("lname");
                        if (fname != null && lname != null) {
                    %>
                    <%= fname%> <%= lname%>
                    <%
                        }
                    %>
                </span>


                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">


                    <div class="dropdown">
                        <button class="btn btn-light dropdown-toggle" type="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            Profile
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                            <li><a class="dropdown-item" href="wishlist.jsp">Wishlist</a></li>
                            <li><a class="dropdown-item" href="transaction_history.jsp">History</a></li>
                            <li><a class="dropdown-item" href="book_suggestion_form.jsp">Suggest Book</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                            <!--            <li><a class="dropdown-item text-primary" href="admin/index.jsp">Admin</a></li>-->
                        </ul>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Search Form Section -->
        <div class="container my-3">
            <div class="row">
                <div class="col-12 col-lg-4">
                    <div class="card shadow-lg rounded-4 " style="max-width: 400px;">
                        <div class="card-body p-4 p-md-5">
                            <h2 class="card-title text-center mb-4">Search for a Book</h2>
                            <form action="" method="get" id="searchForm">
                                <!--<form action="SearchBooksServlet" method="get">-->


                                <!--changes--> 
                                <div class="mb-4">
                                    <label for="subject" class="form-label">Subject</label>
                                    <select class="form-select" id="subject" name="subject">
                                        <!--<option value="">-- Select Subject --</option>-->
                                        <%
                                            // DB connection variables
                                            String url = "jdbc:mysql://localhost:3306/library_management_system";
                                            String username = "root";
                                            String password = "";

                                            try {
                                                Class.forName("com.mysql.cj.jdbc.Driver");
                                                conn = DriverManager.getConnection(url, username, password);
                                                String sql = "SELECT subject_name FROM subject ORDER BY subject_name";
                                                ps = conn.prepareStatement(sql);
                                                rs = ps.executeQuery();
                                                boolean first = true;
                                                while (rs.next()) {
                                                    String subj = rs.getString("subject_name");

                                                    if (first && (selectedSubject == null || selectedSubject.isEmpty())) {
                                                        selectedSubject = subj;  //  fallback to first subject if not set
                                                    }

                                                    boolean isSelected = subj.equals(selectedSubject);  //  match selected
%>
                                        <option value="<%= subj%>" <%= isSelected ? "selected" : ""%>><%= subj%></option>


                                        <%

                                                    //        if(first && (selectedSubject == null || selectedSubject.isEmpty())){
                                                    //            selectedSubject = subj;
                                                    //    } 
                                                    //    
                                                    first = false;
                                                }
                                            } catch (Exception e) {
                                                out.println("<option disabled>Error loading subjects</option>");
                                                out.println(e);
                                            } finally {
                                                if (rs != null) try {
                                                    rs.close();
                                                } catch (SQLException ignored) {
                                                }
                                                if (ps != null) try {
                                                    ps.close();
                                                } catch (SQLException ignored) {
                                                }
                                                if (conn != null) try {
                                                    conn.close();
                                                } catch (SQLException ignored) {
                                                }
                                            }
                                        %>
                                    </select>
                                </div>            <!--changes--> 




                                <!--          <div class="mb-3">
                                            <label for="title" class="form-label">Book Title</label>
                                            <input type="text" class="form-control" id="title" name="title" placeholder="Enter book title" autocomplete="off">
                                          </div>-->

                                <%
                                    try {
                                        Class.forName("com.mysql.cj.jdbc.Driver");
                                        conn = DriverManager.getConnection(url, username, password);

                                        // If subject is null or empty, fetch the first subject
                                        if (subject == null || subject.trim().isEmpty()) {
                                            String firstSubjectQuery = "SELECT subject_name FROM subject ORDER BY subject_name LIMIT 1";
                                            ps = conn.prepareStatement(firstSubjectQuery);
                                            rs = ps.executeQuery();
                                            if (rs.next()) {
                                                selectedSubject = rs.getString("subject_name");
                                            }
                                            rs.close();
                                            ps.close();
                                        }

                                        // Now fetch books of the selected subject
                                        String booksQuery = "SELECT title FROM book WHERE subject_id = (SELECT subject_id FROM subject WHERE subject_name = ?)  ORDER BY title ASC";
                                        ps = conn.prepareStatement(booksQuery);
                                        ps.setString(1, selectedSubject);
                                        rs = ps.executeQuery();
                                %>

                                <div class="mb-3">
                                    <label for="title" class="form-label">Book Title</label>
                                    <input list="bookTitles" class="form-control" id="title" name="title" placeholder="Enter book title" autocomplete="off">
                                    <datalist id="bookTitles">

                                        <% while (rs.next()) {%>
                                        <option value="<%= rs.getString("title")%>">
                                            <% } %>
                                    </datalist>
                                </div>

                                <%
                                    } catch (Exception e) {
                                        out.println("<p>Error: " + e.getMessage() + "</p>");
                                    } finally {
                                        if (rs != null) try {
                                            rs.close();
                                        } catch (SQLException ignored) {
                                        }
                                        if (ps != null) try {
                                            ps.close();
                                        } catch (SQLException ignored) {
                                        }
                                        if (conn != null) try {
                                            conn.close();
                                        } catch (SQLException ignored) {
                                        }
                                    }
                                %>


                                <div class="mb-3">
                                    <label for="author" class="form-label">Author</label>
                                    <input type="text" class="form-control" id="author" name="author" placeholder="Enter author name" autocomplete="off">
                                </div>
                                <div class="mb-3">
                                    <label for="publisher" class="form-label">Publisher</label>
                                    <input type="text" class="form-control" id="publisher" name="publisher" placeholder="Enter publisher" autocomplete="off">
                                </div>
                                <div class="mb-3">
                                    <label for="isbn" class="form-label">ISBN</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" placeholder="Enter ISBN" autocomplete="off">
                                </div>


                                <div class="d-flex gap-3 justify-content-center">
                                    <!--<button type="submit" class="btn btn-primary btn-lg">Search</button>-->
                                    <button type="submit" class="btn btn-primary btn-lg" onclick="setFormAction()">Search</button>

                                    <button type="button" class="btn btn-secondary btn-lg" onclick="clearForm()">Clear</button>
                                </div>

                            </form>
                        </div>
                    </div>
                </div> 

                <div class="col-12 col-lg-8">
                    <!--cards-->


                    <p class="h1">Books you might like in "<%= selectedSubject%>"</p>
                    <div class="row row-cols-1 row-cols-lg-4 g-2">


                        <%
                            if (selectedSubject != null && !selectedSubject.trim().isEmpty()) {
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

                                    String sql = "SELECT b.book_id, b.title, b.book_cover_image, s.subject_name, "
                                            + "COUNT(t.transaction_id) AS issue_count "
                                            + "FROM book b "
                                            + "JOIN subject s ON s.subject_id = b.subject_id "
                                            + "JOIN book_copies bc ON bc.book_id = b.book_id "
                                            + "JOIN book_request br ON br.copy_id = bc.copy_id "
                                            + "JOIN transaction t ON t.request_id = br.request_id "
                                            + "WHERE t.issue_date IS NOT NULL AND s.subject_name = ? "
                                            + "GROUP BY b.book_id, b.title, b.book_cover_image, s.subject_name "
                                            + "ORDER BY issue_count DESC "
                                            + "LIMIT 9";

                                    ps = con.prepareStatement(sql);
                                    ps.setString(1, selectedSubject);
                                    rs = ps.executeQuery();
                        %>

                        <!--<div class="card-deck">-->
                        <%
                            while (rs.next()) {
                                int book_id_from_card = rs.getInt("book_id");
                                String title = rs.getString("title");
                                String cover = rs.getString("book_cover_image");
                                int issueCount = rs.getInt("issue_count");
                        %>

                        <div class="col">
                            <div class="card h-100 shadow-sm ">
                                <a href="book_details.jsp?book_id=<%=book_id_from_card%>">
                                    <img src="<%= cover%>" class="card-img-top" alt="<%= title%>" style="height: 200px; object-fit: contain;" />
                                </a>
                                <div class="card-body">
                                    <h5 class="card-title"><% // title %></h5>
                                    <p class="card-text">Read (<%= issueCount%>)</p>
                                    <%
                                        // Get available copies
                                        String availableSql = "SELECT COUNT(*) AS available_count FROM book_copies WHERE book_id = ? AND book_condition_status=1 AND book_reservation_status = 0";
                                        PreparedStatement psAvailable = con.prepareStatement(availableSql);
                                        psAvailable.setInt(1, book_id_from_card);
                                        ResultSet rsAvailable = psAvailable.executeQuery();
                                        int availableCount = 0;
                                        if (rsAvailable.next()) {
                                            availableCount = rsAvailable.getInt("available_count");
                                        }
                                        rsAvailable.close();
                                        psAvailable.close();
                                    %>

                                    <% if (availableCount > 0) {%>
                                    <p class="card-text text-success">Available (<%= availableCount%>)</p>
                                    <% } else {%>
                                    <form action="notify_request.jsp" method="post">
                                        <input type="hidden" name="book_id" value="<%= book_id_from_card%>">
                                        <button type="submit" class="btn btn-warning btn-sm">Notify Me</button>
                                    </form>
                                    <% } %>

                                </div>
                            </div>
                        </div>
                        <!---->
                        <!---->


                        <%
                            }
                        %>
                        <!--</div>-->

                        <%
                            } catch (Exception e) {
                                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                            } finally {
                                if (rs != null) {
                                    rs.close();
                                }
                                if (ps != null) {
                                    ps.close();
                                }

                            }
                        } else {
                        %>
                        <p>Please select a subject to view most issued books.</p>
                        <%
                            }
                        %>


                    </div>
                </div>
            </div>
            <!--cards-->
        </div>
        <!--</div>-->
        <!--</div>-->


        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        // Form submission validation
                                        document.querySelector("form").addEventListener("submit", function (event) {
                                            const title = document.getElementById("title").value.trim();
                                            const isbn = document.getElementById("isbn").value.trim();
                                            const author = document.getElementById("author").value.trim();
                                            const publisher = document.getElementById("publisher").value.trim();
                                            const subject = document.getElementById("subject").value.trim();

                                            if (!title && !isbn && !author && !publisher && !subject) {
                                                alert("Please fill at least one field to search.");
                                                event.preventDefault(); // Stop form submission
                                            }
                                        });

                                        // Clear form input values
                                        function clearForm() {
                                            document.getElementById("title").value = "";
                                            document.getElementById("isbn").value = "";
                                            document.getElementById("author").value = "";
                                            document.getElementById("publisher").value = "";
                                            document.getElementById("subject").value = "";
                                        }
        </script>

        <script>
            // Auto-submit form on subject change
            document.getElementById("subject").addEventListener("change", function () {
                document.getElementById("searchForm").submit();
            });
        </script>
        <script>
            function setFormAction() {
                document.getElementById("searchForm").action = "SearchBooksServlet";
            }
        </script>


    </body>
</html>