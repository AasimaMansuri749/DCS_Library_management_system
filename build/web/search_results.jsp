<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
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
<html>
    <head>
        <meta charset="UTF-8">
        <title>DCS Library - Search Results</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .navbar {
                background-color: #212529;
            }
            .navbar-brand, .navbar-nav .nav-link, .dropdown-toggle {
                color: #fff !important;
            }
            .card-img-top {
                height: 200px;
                object-fit: contain;
            }
            .filter-pill {
                margin: 0 10px 10px 0;
                padding: 5px 12px;
                border-radius: 20px;
                display: inline-block;
                font-size: 14px;
            }
            .card {
                height: 100%;
            }
            .btn-group-custom {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            /* Responsive Enhancements */
            @media (max-width: 767.98px) {
                .row.g-2 {
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .row.g-2 > .col-md-4 {
                    width: 100% !important;
                    max-width: 100%;
                }

                .p-2.bg-white.rounded.border.d-flex {
                    flex-direction: column !important;
                    align-items: flex-start !important;
                    padding: 10px !important;
                }

                .p-2.bg-white .badge {
                    margin-top: 5px;
                    align-self: flex-start;
                }

                .card.mb-3.shadow-sm.border-0.bg-light {
                    margin-left: 10px;
                    margin-right: 10px;
                }
            }

            .p-2.bg-white.rounded.border.d-flex {
                gap: 6px;
            }

            .card-body h6.card-title {
                font-size: 1rem;
            }

            #profileDropdown {
                color: black !important;
            }

            .btn-outline-danger {
                border-color: #dc3545;
                color: #dc3545;
            }

            .btn-outline-danger:hover {
                background-color: #dc3545;
                color: white;
            }

            .btn-danger {
                background-color: #dc3545;
                color: white;
            }

            /* Disabled button style */
            .btn:disabled {
                background-color: #f5c6cb;
                border-color: #f5c6cb;
                color: #6c757d;
                cursor: not-allowed;
            }

            /* Optional: Add a custom class to modify button text */
            .wishlist-btn {
                font-weight: bold;
                font-size: 1rem;
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
                </span>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
                    <div class="dropdown">
                        <button class="btn btn-light dropdown-toggle" type="button" id="profileDropdown"
                                data-bs-toggle="dropdown" aria-expanded="false">
                            Profile
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                            <li><a class="dropdown-item" href="user_dashboard.jsp">home</a></li>
                            <li><a class="dropdown-item" href="wishlist.jsp">Wishlist</a></li>
                            <li><a class="dropdown-item" href="transaction_history.jsp">History</a></li>
                            <li><a class="dropdown-item" href="book_suggestion_form.jsp">Suggest Book</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
                            <!--<li><a class="dropdown-item text-primary" href="admin/index.jsp">Admin</a></li>-->
                        </ul>
                    </div>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <h2 class="text-center mb-4">Book List</h2>

            <%
                String title = request.getParameter("title") != null ? request.getParameter("title") : "";
                String isbn = request.getParameter("isbn") != null ? request.getParameter("isbn") : "";
                String author = request.getParameter("author") != null ? request.getParameter("author") : "";
                String publisher = request.getParameter("publisher") != null ? request.getParameter("publisher") : "";
                String subject = request.getParameter("subject") != null ? request.getParameter("subject") : "";

            %>

            <!-- Filter Summary Section -->
            <div class="card mb-3 shadow-sm border-0 bg-light">
                <div class="card-body py-3 px-3">
                    <h5 class="fw-bold mb-3 text-primary"><i class="bi bi-funnel"></i> Applied Filters</h5>
                    <div class="row g-2">
                        <% if (title != null && !title.isEmpty()) {%>
                        <div class="col-12 col-md-4">
                            <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                <div><small><i class="bi bi-book me-1"></i><strong>Title:</strong></small></div>
                                <span class="badge bg-dark" style="font-size: 0.75rem;"><%= title%></span>
                            </div>
                        </div>
                        <% } %>

                        <% if (isbn != null && !isbn.isEmpty()) {%>
                        <div class="col-12 col-md-4">
                            <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                <div><small><i class="bi bi-upc-scan me-1"></i><strong>ISBN:</strong></small></div>
                                <span class="badge bg-warning text-dark" style="font-size: 0.75rem;"><%= isbn%></span>
                            </div>
                        </div>
                        <% } %>

                        <% if (author != null && !author.isEmpty()) {%>
                        <div class="col-12 col-md-4">
                            <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                <div><small><i class="bi bi-person me-1"></i><strong>Author:</strong></small></div>
                                <span class="badge bg-primary" style="font-size: 0.75rem;"><%= author%></span>
                            </div>
                        </div>
                        <% } %>

                        <% if (publisher != null && !publisher.isEmpty()) {%>
                        <div class="col-12 col-md-4">
                            <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                <div><small><i class="bi bi-building me-1"></i><strong>Publisher:</strong></small></div>
                                <span class="badge bg-success" style="font-size: 0.75rem;"><%= publisher%></span>
                            </div>
                        </div>
                        <% } %>

                        <% if (subject != null && !subject.isEmpty()) {%>
                        <div class="col-12 col-md-4">
                            <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm">
                                <div><small><i class="bi bi-tag me-1"></i><strong>Subject:</strong></small></div>
                                <span class="badge bg-info text-dark" style="font-size: 0.75rem;"><%= subject%></span>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Book Cards Section -->
            <div class="row justify-content-center g-2">
                <%
                    List<Map<String, String>> bookList = (List<Map<String, String>>) request.getAttribute("bookList");
                    List<String> wishlistBookIds = (List<String>) session.getAttribute("wishlistBookIds");

                    if (bookList != null && !bookList.isEmpty()) {
                        for (Map<String, String> book : bookList) {
                            String bookId = book.get("book_id");
                            boolean inWishlist = wishlistBookIds != null && wishlistBookIds.contains(bookId);
                %>
                <div class="col-md-6 col-lg-4 d-flex justify-content-center mb-3">
                    <div class="card shadow-sm rounded-4 border-0" style="max-width: 350px; width: 100%;">
                        <a href="book_details.jsp?book_id=<%= book.get("book_id")%>">
                            <img src="<%= book.get("book_cover_image")%>" alt="Book Image" class="card-img-top p-3">
                        </a>

                        <!-- Corrected link and image -->
                  <!--            <a href="BookDetailsServlet?book_id=<%= book.get("book_id")%>">
                                  <img src="images/<%= book.get("book_cover_image")%>" width="120" height="160" />
                              </a>-->

                        <div class="card-body text-center">
                            <h5 class="card-title fw-bold"><%= book.get("title")%></h5>
                            <p class="card-text mb-1">
                                <strong>Author:</strong> <%= book.get("author")%><br>
                                <strong>Pages:</strong> <%= book.get("page_count")%><br>
<!--                                <strong>Total Copies</strong> <%= book.get("total_copies")%><br>
                                <strong>Available Copies</strong> <%= book.get("available_copies")%><br>
                                -->
                            </p>
                        </div>
                        <div class="card-footer bg-white border-top-0">
                            <div class="d-flex justify-content-center gap-2">
                                <form action="AddToWishlistServlet" method="post" >
                                    <input type="hidden" name="book_id" value="<%= bookId%>">
                                    <button type="submit" class="btn 
                                            <%= inWishlist ? "btn-danger" : "btn-outline-danger"%> wishlist-btn" 
                                            <%= inWishlist ? "disabled" : ""%>>
                                        <%= inWishlist ? "Wishlisted" : "Wishlist"%>
                                    </button>


                                </form>
                                <form action="RequestBookServlet" method="post">
                                    <input type="hidden" name="book_id" value="<%= bookId%>">
                                    <!-- Modal Trigger -->
                                    <!--<button type="button" class="btn btn-primary custom-btn" data-bs-toggle="modal" data-bs-target="#requestModal<%= bookId%>">
                                        Request
                                    </button>-->
                                    <!-- Request Modal -->
                                    <div class="modal fade" id="requestModal<%= bookId%>" tabindex="-1" aria-labelledby="requestModalLabel<%= bookId%>" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content rounded-4 shadow">
                                                <div class="modal-header bg-primary text-white">
                                                    <h5 class="modal-title" id="requestModalLabel<%= bookId%>">Confirm Book Request</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body text-center">
                                                    <p>Are you sure you want to request the book <strong><%= book.get("title")%></strong>?</p>
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

                                </form>
                            </div>
                        </div>

                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="col-12">
                    <%
                        String msg = (String) request.getAttribute("msg");
                        String errorMessage = (String) request.getAttribute("errorMessage");

                        if ("request_success".equals(msg)) {
                    %>
                    <div class="alert alert-success text-center">Book request successful!</div>
                    <%
                    } else if ("request_failed".equals(msg)) {
                    %>
                    <div class="alert alert-danger text-center">Book request failed. Please try again.</div>
                    <%
                    } else if ("error".equals(msg) && errorMessage != null) {
                    %>
                    <div class="alert alert-danger text-center">Error: <%= errorMessage%></div>
                    <%
                    } else {
                    %>
                    <div class="alert alert-info text-center">No books found. Please try another search.</div>
                    <%
                        }
                    %>
                </div>

                <% }%>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>