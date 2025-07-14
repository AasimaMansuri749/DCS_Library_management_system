<%@ page import="java.util.*, java.sql.*" %>
<%@ page session="true" %>
<%
    // Session check
    Integer u_id = (Integer) session.getAttribute("u_id");
    if (u_id == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>DCS Library - Wishlist</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <style>
            /*    body{
                     background:linear-gradient(to right, #a1c4fd, #c2e9fb);
            
                }*/

            .btn-small {
                font-size: 14px;
                padding: 5px 12px;
                height: auto;
                width: auto;
                min-width: 100px;
                border-radius: 10px;
                font-weight: 600;
            }

            .btn-wishlist {
                background-color: white;
                color: #dc3545;
                border: 1.5px solid #dc3545;
            }

            .btn-wishlist:hover {
                background-color: #dc3545;
                color: white;
            }

            .btn-request {
                background-color: #007bff;
                color: white;
                border: none;
            }

            .btn-request:hover {
                background-color: #0056b3;
            }

            .btn-group-center {
                display: flex;
                justify-content: center;
                gap: 10px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>

        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg bg-dark navbar-dark">
            <div class="container">
                <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="#">
                    DCS LIBRARY
                </a>
                <span class="navbar-text text-white ms-3">
                    <%
                        String fname = (String) session.getAttribute("fname");
                        String lname = (String) session.getAttribute("lname");
                        if (fname != null && lname != null) {
                    %>
                    <%= fname%> <%= lname%>
                    <%
                        }
                    %>
                </span>      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
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

        <!-- Wishlist Page Content -->
        <div class="container my-4">
            <h2 class="text-center mb-4">My Wishlist</h2>
            <%
                String wishlist_msg = (String) session.getAttribute("wishlist_msg");
                if (wishlist_msg != null) {
            %>
            <div class="alert alert-info text-center"><%= wishlist_msg%></div>
            <%
                    session.removeAttribute("wishlist_msg");
                }
            %>


            <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4">
                <%
                    boolean hasBooks = false;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

          //          String query = "SELECT b.book_id, b.title, a.author_name AS author, b.page_count, b.book_cover_image " +
          //                         "FROM wishlist w " +
          //                         "JOIN book b ON w.book_id = b.book_id " +
          //                         "LEFT JOIN book_author ba ON b.book_id = ba.book_id " +
          //                         "LEFT JOIN author a ON ba.author_id = a.author_id " +
          //                         "WHERE w.u_id = ? group by book_id";
                        String query = "SELECT b.book_id, b.title, GROUP_CONCAT(a.author_name SEPARATOR ', ') AS authors, "
                                + "b.page_count, b.book_cover_image "
                                + "FROM wishlist w "
                                + "JOIN book b ON w.book_id = b.book_id "
                                + "LEFT JOIN book_author ba ON b.book_id = ba.book_id "
                                + "LEFT JOIN author a ON ba.author_id = a.author_id "
                                + "WHERE w.u_id = ? "
                                + "GROUP BY b.book_id, b.title, b.page_count, b.book_cover_image";

                        PreparedStatement ps = conn.prepareStatement(query);
                        ps.setInt(1, u_id);
                        ResultSet rs = ps.executeQuery();

                        while (rs.next()) {
                            hasBooks = true;

                            String title = rs.getString("title");
                            String author = rs.getString("authors");
                            if (author == null) {
                                author = "Unknown";
                            }

                            int pages = rs.getInt("page_count");
                            String image = rs.getString("book_cover_image");
                            if (image == null || image.trim().isEmpty()) {
                                image = "admin/img/testimonial-1.jpg";
                            }

                            int bookId = rs.getInt("book_id");
                %>

                <!-- Book Card -->
                <div class="col">
                    <div class="card h-100 border rounded-4 shadow-sm">
                        <a href="book_details.jsp?book_id=<%= bookId%>">
                            <img src="<%= image%>" class="card-img-top" alt="Book Image" style="height:250px; object-fit:contain; padding: 1rem;">
                        </a>
                        <div class="card-body">
                            <h5 class="card-title fw-semibold mb-2"><%= title%></h5>
                            <p class="card-text mb-3" style="font-size: 0.9rem;">
                                <strong>Author:</strong> <%= author%><br>
                                <strong>Pages:</strong> <%= pages%>
                            </p>
                        </div>

                        <div class="card-footer bg-white border-0">
                            <div class="btn-group-center">
                                <form action="RemoveFromWishlistServlet" method="post">
                                    <input type="hidden" name="book_id" value="<%= bookId%>">
                                    <button type="submit" class="btn btn-small btn-wishlist">remove</button>
                                </form>


                            </div>
                        </div>



                    </div>
                </div>

                <%
                    } // end while

                    if (!hasBooks) {
                %>
                <div class="col-12 text-center">
                    <p class="text-muted">No books in your wishlist yet.</p>
                </div>
                <%
                        }

                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<div class='text-danger text-center'>Error loading wishlist: " + e.getMessage() + "</div>");
                    }
                %>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>