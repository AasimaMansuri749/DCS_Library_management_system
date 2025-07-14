<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<%
    // Renamed book detail variables
    String bTitle = "", bIsbn = "", bImage = "", bSubject = "", bPublisher = "";
    int bPages = 0, bEdition = 0;
    String bAuthors = "";

    // Renamed copy detail variables
    int availableCopyId = -1;
    String libClassNo = "", bookCondition = "", cupboardNo = "", rackNo = "", bookCategory = "";

%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Book Detail Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
        <style>
            body {
                font-family: 'Open Sans', sans-serif;
                background:linear-gradient(to right, #a1c4fd, #c2e9fb);
            }
            .product-card {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                padding: 30px;
                margin-top: 30px;
            }
            .product-image img {
                width: 100%;
                max-height: 450px;
                object-fit: contain;
                border-radius: 8px;
            }
            .product-title {
                text-transform: uppercase;
                font-weight: 700;
                margin-bottom: 20px;
            }
            .product-description {
                margin-bottom: 12px;
                font-size: 16px;
            }
            .btn-request, .btn-wishlist {
                font-size: 1.1rem;
                padding: 16px 28px;
                width: 100%;
                max-width: 250px;
                margin-top: 10px;
            }
            .btn-request {
                background-color: #ff9f1a;
                border: none;
                color: #fff;
            }
            .btn-request:hover {
                background-color: #cc7a00;
            }
            .btn-wishlist {
                background-color: #0076ad;
                border: none;
                color: #fff;
            }
            .btn-wishlist:hover {
                background-color: #005f8a;
            }
            .btn-wishlist:hover {
                color: white; /* example: yellow */
            }

            .btn-wishlist.bg-warning:hover {
                color: white; /* example: black */
            }
        </style>
    </head>
    <body>

        <%    String msg = (String) session.getAttribute("wishlist_msg");
            if (msg != null) {
        %>
        <div class="position-fixed top-0 start-50 translate-middle-x mt-3" style="z-index: 1055; min-width: 300px;">
            <div class="alert alert-info alert-dismissible fade show shadow" role="alert">
                <%= msg%>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <%
                session.removeAttribute("wishlist_msg");
            }
        %>

        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg bg-dark navbar-dark">
            <div class="container">
                <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="#">DCS LIBRARY</a>
                <span class="navbar-text text-white ms-3">
                    <%
                        String fname = (String) session.getAttribute("fname");
                        String lname = (String) session.getAttribute("lname");
                        Integer userId = (Integer) session.getAttribute("u_id");
                        String userIdStr = String.valueOf(userId);

                        if (fname != null && lname != null && userIdStr != null) {
                    %>
                    <%= fname%> <%= lname%>
                    <%
                        }
                    %>

                </span>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navMenu">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <button class="btn btn-light dropdown-toggle ms-lg-3 mt-2 mt-lg-0" type="button" id="profileDropdown" data-bs-toggle="dropdown">
                                Profile
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="user_dashboard.jsp">home</a></li>
                                <li><a class="dropdown-item" href="wishlist.jsp">Wishlist</a></li>
                                <li><a class="dropdown-item" href="transaction_history.jsp">History</a></li>
                                <li><a class="dropdown-item" href="book_suggestion_form.jsp">Suggest Book</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">
            <%
                String book_id_String = request.getParameter("book_id");
                Integer bookId = Integer.parseInt(book_id_String);
                String title = "", isbn = "", subject = "", publisher = "", coverImage = "", authors = "";
                int edition = 0;
                int totalCopies = 0, pages = 0;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/library_management_system";
                    String user = "root";
                    String pass = "";
                    Connection con = DriverManager.getConnection(url, user, pass);

                    String sql = "SELECT b.title, b.ISBN, b.edition,b.book_id, b.total_copies, b.page_count, b.book_cover_image, "
                            + "s.subject_name AS subject, p.publisher_name AS publisher, "
                            + "GROUP_CONCAT(a.author_name SEPARATOR ', ') AS authors "
                            + "FROM book b "
                            + "JOIN subject s ON b.subject_id = s.subject_id "
                            + "JOIN publisher p ON b.publisher_id = p.publisher_id "
                            + "JOIN book_author ba ON b.book_id = ba.book_id "
                            + "JOIN author a ON ba.author_id = a.author_id "
                            + "WHERE b.book_id = ? GROUP BY b.book_id";

                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, bookId);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {

                        title = rs.getString("title");
                        isbn = rs.getString("isbn");
                        edition = rs.getInt("edition");
                        subject = rs.getString("subject");
                        publisher = rs.getString("publisher");
                        coverImage = rs.getString("book_cover_image");
                        totalCopies = rs.getInt("total_copies");
                        pages = rs.getInt("page_count");
                        authors = rs.getString("authors");
                    } else {
                        out.println("<h4 class='text-danger'>Book not found.</h4>");
                    }

                    rs.close();
                    ps.close();

                    // Now fetch available copies count
                    int availableCopiesCount = 0;
                    String sqlCount = "SELECT COUNT(*) AS available_count FROM book_copies WHERE book_id = ? AND book_condition_status=1 AND book_reservation_status = 0";
                    PreparedStatement psCount = con.prepareStatement(sqlCount);
                    psCount.setInt(1, bookId);
                    ResultSet rsCount = psCount.executeQuery();
                    if (rsCount.next()) {
                        availableCopiesCount = rsCount.getInt("available_count");
                    }
                    rsCount.close();
                    psCount.close();

                    con.close();
            %>

            <div class="product-card">
                <div class="row g-4 align-items-center">
                    <div class="col-lg-6 col-md-12">
                        <div class="product-image">
                            <img src="<%= coverImage%>" alt="Book Image" class="img-fluid">
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-12">
                        <h3 class="product-title"><%= title.toUpperCase()%></h3>
                        <p class="product-description">Author: <%= authors%></p>
                        <p class="product-description">ISBN: <%= isbn%></p>
                        <p class="product-description">Edition: <%= edition%></p>
                        <p class="product-description">Subject: <%= subject%></p>

                        <p class="product-description">Pages: <%= pages%></p>
                        <p class="product-description">Publisher: <%= publisher%></p>
                        <p class="product-description">Total Copies: <%= totalCopies%></p>
                        <p class="product-description">Available Copies: <%= availableCopiesCount%></p>
                        <div class="d-flex flex-wrap gap-3 mt-3">
                            <%
                                if (availableCopiesCount > 0) {
                            %>
                            <button type="button" class="btn btn-request flex-fill" style="max-width: 250px;" data-bs-toggle="modal" data-bs-target="#requestModal<%= bookId%>">
                                Request
                            </button>
                            <%
                            } else {
                            %>
                            <form action="NotifyMeServlet" method="post" id="notifyForm" class="flex-fill" style="max-width: 250px;">
                                <input type="hidden" name="book_id" value="<%= bookId%>">
                                <input type="hidden" name="user_id" value="<%= session.getAttribute("u_id")%>">
                                <button type="submit" class="btn btn-wishlist bg-warning w-100">Notify Me</button>
                            </form>


                            <%
                                }
                            %>

                            <form action="AddToWishlistServlet" method="post" class="flex-fill" style="max-width: 250px;">
                                <input type="hidden" name="book_id" value="<%= bookId%>">
                                <button type="submit" class="btn btn-wishlist w-100">Wishlist</button>
                            </form>
                        </div>


                        <!--MODAL-->
                        <div class="modal fade" id="requestModal<%= bookId%>" tabindex="-1" aria-labelledby="requestModalLabel<%= bookId%>" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content rounded-4 shadow">
                                    <div class="modal-header bg-primary text-white">
                                        <h5 class="modal-title" id="requestModalLabel<%= bookId%>">Confirm Book Request</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body text-center">
                                        <p>Are you sure you want to request the book <strong><%= title%></strong>?</p>
                                    </div>
                                    <div class="modal-footer justify-content-center">
                                        <form action="RequestBookServlet" method="post">
                                            <input type="hidden" name="book_id" value="<%= bookId%>">
                                            <input type="hidden" name="user_id" value="<%= session.getAttribute("u_id")%>">
                                            <button type="submit" class="btn btn-success">Yes, Request</button>
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--MODAL-->

                    </div>
                </div>
            </div>

            <%
                } catch (Exception e) {
                    out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
                }
            %>

        </div>

        <script>
            document.getElementById('notifyForm').addEventListener('submit', function () {
                // Disable the button when form is submitted
                document.getElementById('notifyBtn').disabled = true;
                // Optionally, change the button text
                document.getElementById('notifyBtn').innerText = 'Request Sent...';
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>