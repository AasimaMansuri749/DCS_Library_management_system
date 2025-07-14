<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<%
    String book_id_String = (String) request.getParameter("book_id");
int bookId = 0;
if (book_id_String != null) {
    try {
        bookId = Integer.parseInt(book_id_String);
    } catch (NumberFormatException e) {
        out.println("<h4 class='text-danger'>Invalid Book ID format.</h4>");
        return;
    }
} else {
    out.println("<h4 class='text-danger'>Book ID not provided.</h4>");
    return;
}
    %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Book Detail Page</title>
<!--  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">-->
        <!--<title>Admin - DCS library</title>-->
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
  <style>
    body {
      font-family: 'Open Sans', sans-serif;
 
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
  </style>
<script>
function confirmResolve(copyId, bookId) {
    if (confirm("This copy is inactive. Do you want to resolve grievance and make it active?")) {
        window.location.href = "resolve_copy.jsp?copy_id=" + copyId + "&book_id=" + bookId;
    }
}
</script>


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
                    <% //
                        String userName = (String) session.getAttribute("admin_name");
//                        if (userName == null || userName.isEmpty()) {
//                            response.sendRedirect("admin_login.jsp");
//                            return;
//                        }
                    %>

<!--                    <div class="d-flex align-items-center ms-4 mb-4">
                        <div class="position-relative border-2">
                          </div>
                        <div class="ms-3">
                            <h6 class="mb-0">
                                <%= (userName != null && !userName.isEmpty()) ? userName : "Welcome Admin"%>
                            </h6>
                            <span><%= "admin"%></span>
                        </div>
                    </div>-->
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


                <!--new conctent-->



 <!--<a href="books.jsp" class="btn btn-lg btn-info my-3">Back to Book Management</a>-->
<%
    
int copyId;
String category;
String lcn;
int cupboardNo;
int rackNo;
int condition;
int reserveStatus;
String conditionText = "";
String reserveText = "";
String reserveColor = "";
    %>
<div class="container">
<%
//   book_id_String = request.getParameter("book_id");
//   bookId = Integer.parseInt(book_id_String);

  String title = "", isbn = "", subject = "", publisher = "", coverImage = "", authors = "";
  int edition = 0;
  Date addedDate; 
  int totalCopies = 0, pages = 0,book_id_db=0;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String formattedDate = "";
  try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      String url = "jdbc:mysql://localhost:3306/library_management_system";
      String user = "root";
      String pass = "";
      Connection con = DriverManager.getConnection(url, user, pass);

      String sql = "SELECT b.added_date, b.title, b.ISBN, b.edition, b.total_copies, b.page_count, b.book_cover_image, " +
             "s.subject_name AS subject, p.publisher_name AS publisher, " +
             "GROUP_CONCAT(a.author_name SEPARATOR ', ') AS authors " +
             "FROM book b " +
             "JOIN subject s ON b.subject_id = s.subject_id " +
             "JOIN publisher p ON b.publisher_id = p.publisher_id " +
             "JOIN book_author ba ON b.book_id = ba.book_id " +
             "JOIN author a ON ba.author_id = a.author_id " +
             "WHERE b.book_id = ? GROUP BY b.book_id";

//       String sql = "SELECT b.added_date, b.title, b.ISBN, b.edition, b.total_copies, b.page_count, b.book_cover_image, " +
//             "s.subject_name AS subject, p.publisher_name AS publisher " +
//             "FROM book b " +
//             "JOIN subject s ON b.subject_id = s.subject_id " +
//             "JOIN publisher p ON b.publisher_id = p.publisher_id " +
//             "WHERE b.book_id = ?";

PreparedStatement ps = con.prepareStatement(sql);
ps.setInt(1, bookId); // Now using the bookId from request
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
//          book_id_db = rs.getInt("book_id");
          title = rs.getString("title");
          isbn = rs.getString("isbn");
          edition = rs.getInt("edition");
          subject = rs.getString("subject");
          authors = rs.getString("authors");
          publisher = rs.getString("publisher");
          coverImage = rs.getString("book_cover_image");
          totalCopies = rs.getInt("total_copies");
          pages = rs.getInt("page_count");
//          authors = rs.getString("authors");
          addedDate = rs.getDate("added_date");

          formattedDate = sdf.format(addedDate);
//          out.println(rs.getString("title"));
//          out.println(rs.getString("isbn"));
          
      } else {
          out.println("<h4 class='text-danger'>Book not found.</h4>");
      }

      rs.close();
      ps.close();
      con.close();
  } catch (Exception e) {
      out.println("<p class='text-danger'>Error: " + e.getMessage() + "</p>");
  }
%>
  <div class="product-card">
    <div class="row g-4 align-items-center">
      <div class="col-lg-6 col-md-12">
        <div class="product-image">
          <img src="../<%= coverImage %>" alt="Book Image" class="img-fluid">
        </div>
      </div>
      <div class="col-lg-6 col-md-12">
        <h3 class="product-title">Book Id: <%= bookId %></h3>
        <h3 class="product-title"><%= title.toUpperCase() %></h3>
        <p class="product-description">Author: <%= authors %></p>
        <p class="product-description">ISBN: <%= isbn %></p>
        <p class="product-description">Edition: <%= edition %></p>
        <p class="product-description">Subject: <%= subject %></p>
        <p class="product-description">Total Copies: <%= totalCopies %></p>
        <p class="product-description">Pages: <%= pages %></p>
        <p class="product-description">Publisher: <%= publisher %></p>
        <p class="product-description">Added Date: <%= formattedDate %></p>

 <a href="book_copy_add.jsp?book_id=<%= bookId %>" class="btn btn-lg btn-info">Log New Book Copy</a>


         
        

      </div>
    </div>
  </div>
        
        <!--table--> 

    <h3 class="my-4 text-primary">All Copies of the Book</h3>

    <table class="table table-bordered table-hover table-striped">
        <thead class="table-dark">
        <tr>
            <th>Copy ID</th>
            <th>Category</th>
            <th>Classification Number</th>
            <th>Cupboard No</th>
            <th>Rack No</th>
            <th>Reservation Status</th>
            <th>Condition</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
        String bookIdParam = request.getParameter("book_id");
        if (bookIdParam != null) {
            bookId = Integer.parseInt(bookIdParam);
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");
                String query = "SELECT bc.*, c.category_name FROM book_copies bc JOIN category c ON bc.category_id = c.category_id WHERE bc.book_id = ?";
                ps = con.prepareStatement(query);
                ps.setInt(1, bookId);
                rs = ps.executeQuery();

                while (rs.next()) {
                    copyId = rs.getInt("copy_id");
                    category = rs.getString("category_name");
                    lcn = rs.getString("library_classification_number");
                    cupboardNo = rs.getInt("cupboard_no");
                    rackNo = rs.getInt("rack_no");
                    condition = rs.getInt("book_condition_status");
                    reserveStatus = rs.getInt("book_reservation_status");

                    conditionText = (condition == 1) ? "Active" : "Inactive";

//                    if (reserveStatus == 0) {
//                        reserveText = "Available";
//                    } else if (reserveStatus == 1) {
//                        reserveText = "Reserved";
//                    } else if (reserveStatus == 2) {
//                        reserveText = "Issued";
//                    } 

//  String reserveText = "";
     reserveColor = "";
    if (reserveStatus == 0) {
        reserveText = "Available";
        reserveColor = "green";
    } else if (reserveStatus == 1) {
        reserveText = "Reserved";
        reserveColor = "orange";
    } else if (reserveStatus == 2) {
        reserveText = "Issued";
        reserveColor = "blue";
    }

    %>
                    <tr>
                        <td><%= copyId %></td>
                        <td><%= category %></td>
                        <td><%= lcn %></td>
                        <td><%= cupboardNo %></td>
                        <td><%= rackNo %></td>
<td>
    <span class="badge" style="background-color: <%= reserveColor %>;">
        <%= reserveText %>
    </span>
</td>

                        <td>
    <span class="badge <%= "Active".equalsIgnoreCase(conditionText) ? "bg-success" : "bg-danger" %>">
        <%= conditionText %>
    </span>
</td>


                        
                            
                       <td>
<%
    if ("Inactive".equalsIgnoreCase(conditionText)) {
%>
    <button class="btn btn-warning btn-sm" onclick="confirmResolve('<%= copyId %>', '<%= bookId %>')"> Active</button>
<%
    } else {
%>
    <a href="edit_copy.jsp?copy_id=<%= copyId %>&book_id_h=<%= bookId %>" class="btn btn-primary btn-sm">Edit</a>
<%
    }
%>
</td>
  
                        

                    </tr>
    <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        } else {
            out.println("<tr><td colspan='7'>No book ID provided in query string.</td></tr>");
        }
    %>
        </tbody>
    </table>

        <!--table--> 
        
        
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


                <!--new conctent-->


                
                

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