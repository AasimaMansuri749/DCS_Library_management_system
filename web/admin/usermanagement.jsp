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
    </head>
    <style>
        .blurred-row {
    opacity: 0.5;
    filter: grayscale(100%);
    pointer-events: none; /* disables click events like edit/delete */
}

    </style>
    <body>
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
                        <a href="usermanagement.jsp" class="nav-item nav-link active"><i class="bi bi-people-fill me-2"></i>Users</a>
                        <a href="books.jsp" class="nav-item nav-link"><i class="bi bi-book me-2"></i>Books</a> 
                        <a href="subject.jsp" class="nav-item nav-link"><i class="bi bi-collection me-2"></i>Subjects</a> 
                        <a href="report.jsp" class="nav-item nav-link"><i class="bi bi-bar-chart-fill me-2"></i>Reports</a> </div>
<!--                    <a href="book_suggestion.jsp" class="nav-item nav-link">
                            <i class="bi bi-journal-plus me-2"></i>Book Suggestion
                        </a>-->
                </nav>
            </div>
            <div class="content">
                <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0 ">
                    <a href="#" class="sidebar-toggler flex-shrink-0">
                        <i class="fa fa-bars"></i>
                    </a>
                    <div class="navbar-nav align-items-center ms-auto">
                        <form action="logoutServlet" method="post">
                            <button class="btn btn-outline-primary" style="z-index: 1050;" type="button" data-bs-toggle="offcanvas" data-bs-target="#userFilterPanel" aria-controls="userFilterPanel">
                                <i class="bi bi-funnel-fill"></i> Filter
                            </button>
                           </form>
                         <form action="logout.jsp" method="post">
                            <!--                            <button class="btn btn-outline-primary " type="button" data-bs-toggle="offcanvas" data-bs-target="#filterPanel" aria-controls="filterPanel">
                                                            Filter  <i class="bi bi-funnel-fill"></i> 
                                                        </button>-->
                            <button type="submit" class="btn btn-outline-primary m-4">Logout<i class="bi bi-box-arrow-right ms-2"></i></button>
                        </form>
                    </div>
                </nav>

                <div class="card mb-3 shadow-sm border-0 bg-light mt-2">
                    <div class="card-body py-3 px-3">
                        <h6 class="card-title mb-3 text-primary">
                            <i class="bi bi-funnel-fill me-2"></i>Applied User Filters
                        </h6>
                        <div class="row g-2">

                            <div class="col-md-6" id="filterNameContainer" style="display: none;">
                                <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm w-100">
                                    <div><small><i class="bi bi-person me-1"></i><strong>Name:</strong></small></div>
                                    <span class="badge bg-primary" style="font-size: 0.75rem;" id="filterUserName">--</span>
                                </div>
                            </div>
                            <div class="col-md-6" id="filterRegNoContainer" style="display: none;">
                                <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm w-100">
                                    <div><small><i class="bi bi-card-list me-1"></i><strong>Reg No:</strong></small></div>
                                    <span class="badge bg-warning text-dark" style="font-size: 0.75rem;" id="filterRegNo">--</span>
                                </div>
                            </div>
                            <div class="col-md-6" id="filterEmailContainer" style="display: none;">
                                <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm w-100">
                                    <div><small><i class="bi bi-envelope me-1"></i><strong>Email:</strong></small></div>
                                    <span class="badge bg-info text-dark" style="font-size: 0.75rem;" id="filterEmail">--</span>
                                </div>
                            </div>
                            <div class="col-md-6" id="filterPhoneContainer" style="display: none;">
                                <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm w-100">
                                    <div><small><i class="bi bi-telephone me-1"></i><strong>Phone:</strong></small></div>
                                    <span class="badge bg-secondary" style="font-size: 0.75rem;" id="filterPhone">--</span>
                                </div>
                            </div>
                            <div class="col-md-6" id="filterUserStatusContainer" style="display: none;">
                                <div class="p-2 bg-white rounded border d-flex justify-content-between align-items-center shadow-sm w-100">
                                    <div><small><i class="bi bi-person-badge me-1"></i><strong>Role:</strong></small></div>
                                    <span class="badge bg-success" style="font-size: 0.75rem;" id="filterUserStatus">--</span>
                                </div>
                            </div>

                            <div class="col-12" id="noFiltersMessage" style="display: none;">
                                <div class="alert alert-info mt-2" role="alert">
                                    <i class="bi bi-info-circle-fill me-2"></i> Apply filters to see users and details.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--                 <button class="btn btn-outline-primary position-fixed top-0 end-0 m-3" style="z-index: 1050;" type="button" data-bs-toggle="offcanvas" data-bs-target="#userFilterPanel" aria-controls="userFilterPanel">
                                    <i class="bi bi-funnel-fill"></i> Filter
                                </button>-->

                <div class="offcanvas offcanvas-end" tabindex="-1" id="userFilterPanel" aria-labelledby="userFilterPanelLabel">
                    <div class="offcanvas-header">
                        <h5 class="offcanvas-title" id="userFilterPanelLabel">Filter Users</h5>
                        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                    </div>
                    <div class="offcanvas-body">
                        <form id="userFilterForm">
                            <div class="mb-2">
                                <label for="userName" class="form-label">Name (First / Last)</label>
                                <input type="text" class="form-control" id="userName" placeholder="Enter name">
                            </div>
                            <div class="mb-2">
                                <label for="regNo" class="form-label">Registration Number</label>
                                <input type="text" class="form-control" id="regNo" placeholder="Enter registration number">
                            </div>
                            <div class="mb-2">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" placeholder="Enter email address">
                            </div>
                            <div class="mb-2">
                                <label for="phone" class="form-label">Phone</label>
                                <input type="tel" class="form-control" id="phone" placeholder="Enter phone number"> 
                            </div>
                            <div class="mb-2">
                                <label for="userStatus" class="form-label">Status</label>
                                <select class="form-select" id="userStatus">

                                    <option value="student">Student</option>
                                    <option value="faculty">Faculty</option>

                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mt-3">Apply Filters</button>

                            <button type="button" id="clearFiltersButton" class="btn btn-outline-secondary w-100 mt-2">Clear Filters</button>
                        </form>
                    </div>
                </div>

                <div class="container p-4">
                    <div class="text-end mt-3">
                        <a href="customer_signup.jsp" >
                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">+ Add User</button>

                        </a>
                    </div>

                    <div class="tab-content mt-3" id="usersTabContent">
                        <div class="tab-pane fade show active" id="usersListPane" role="tabpanel">

                            <div class="table-container" id="userTableContainer" style="display: none;">
                                
                                
                                <%
                                    // 1. Get filter parameters
                                    String nameParam = request.getParameter("name");
                                    String regNoParam = request.getParameter("regNo");
                                    String emailParam = request.getParameter("email");
                                    String phoneParam = request.getParameter("phone");
                                    String statusParam = request.getParameter("status");
if (statusParam == null || statusParam.isEmpty()) {
    statusParam = "student";  // default value
}


                                    // 2. Check if ANY filter is applied (parameter exists and is not empty)
                                    boolean filtersApplied = (nameParam != null && !nameParam.trim().isEmpty())
                                            || (regNoParam != null && !regNoParam.trim().isEmpty())
                                            || (emailParam != null && !emailParam.trim().isEmpty())
                                            || (phoneParam != null && !phoneParam.trim().isEmpty())
                                            || (statusParam != null && !statusParam.isEmpty()); // Status only needs to be non-empty if selected

                                    // 3. Only proceed with DB query if filters ARE applied
                                    if (filtersApplied) {
                                        Connection con = null;
                                        PreparedStatement pst = null;
                                        ResultSet rs = null;
                                        boolean foundUsers = false; // Flag to check if query returned results

                                        try {
                                            Class.forName("com.mysql.cj.jdbc.Driver");

                                            // Create connection
                                            con = DriverManager.getConnection(
                                                    "jdbc:mysql://localhost:3306/library_management_system",
                                                    "root",
                                                    "");
                                            // Base SQL - Select necessary fields
                                            // Using 1=1 makes adding AND clauses easier
                                            StringBuilder sqlBuilder = new StringBuilder("SELECT u_id, fname, lname, email, registration_no, phone_num, role,status FROM user WHERE 1=1");

                                            List<String> orConditions = new ArrayList<>();
                                            List<Object> params = new ArrayList<>();

                                            if (nameParam != null && !nameParam.trim().isEmpty()) {
                                                String[] nameParts = nameParam.trim().split("\\s+");
                                                for (String part : nameParts) {
                                                    orConditions.add("(fname LIKE ? OR lname LIKE ?)");
                                                    params.add("%" + part + "%");
                                                    params.add("%" + part + "%");
                                                }
                                            }
                                            if (regNoParam != null && !regNoParam.trim().isEmpty()) {
                                                orConditions.add("registration_no LIKE ?");
                                                params.add("%" + regNoParam.trim() + "%");
                                            }
                                            if (emailParam != null && !emailParam.trim().isEmpty()) {
                                                orConditions.add("email LIKE ?");
                                                params.add("%" + emailParam.trim() + "%");
                                            }
                                            if (phoneParam != null && !phoneParam.trim().isEmpty()) {
                                                orConditions.add("phone_num LIKE ?");
                                                params.add("%" + phoneParam.trim() + "%");
                                            }

// Add OR conditions
                                            if (!orConditions.isEmpty()) {
                                                sqlBuilder.append(" AND (").append(String.join(" OR ", orConditions)).append(")");
                                            }

// Role must match exactly
                                            if (statusParam != null && !statusParam.isEmpty()) {
                                                sqlBuilder.append(" AND role = ?");
                                                params.add(statusParam.equalsIgnoreCase("student") ? 0 : 1);
                                            }

                                            pst = con.prepareStatement(sqlBuilder.toString());

                                            // Set parameters carefully
                                            for (int i = 0; i < params.size(); i++) {
                                                Object param = params.get(i);
                                                if (param instanceof String) {
                                                    pst.setString(i + 1, (String) param);
                                                } else if (param instanceof Integer) {
                                                    pst.setInt(i + 1, (Integer) param);
                                                }
                                                // Add other types if needed (e.g., Date, Double)
                                            }

                                            rs = pst.executeQuery();
                                %>
                                
                                
                                <h5>User List</h5>
                                <table class="table table-striped table-hover"> 
                                                <thead class="table-dark">
                                                    <tr>
                                                        <th>Name</th>
                                                        <th>Registration No</th>
                                                        <th>Email</th>
                                                        <th>phone Number </th>
                                                        <th>role</th> 
                                                        <th>status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                
                                                <tbody>
<%
    while (rs.next()) {
        foundUsers = true;

        int userId = rs.getInt("u_id");
        String firstName = rs.getString("fname");
        String lastName = rs.getString("lname");
        String userEmail = rs.getString("email");
        String phone_number = rs.getString("phone_num");
        String registrationNo = rs.getString("registration_no");
final int STATUS_ACTIVE = 1;
final int STATUS_INACTIVE = 0;

final int ROLE_STUDENT = 0;
final int ROLE_FACULTY = 1;

        // Role
        int userRole = rs.getInt("role");
        String userRoleDisplay = (userRole == ROLE_STUDENT) ? "Student" : 
                         (userRole == ROLE_FACULTY) ? "Faculty" : "Other";
        String roleBadgeClass = (userRole == 0) ? "bg-info text-dark" : (userRole == 1) ? "bg-warning text-dark" : "bg-secondary";

        // Status
        int userStatus = rs.getInt("status");
        String userStatusDisplay = (userStatus == 1) ? "Active" : "Inactive";
        String statusBadgeClass = (userStatus == 1) ? "bg-success" : "bg-danger";

        boolean isInactive = (userStatus == STATUS_INACTIVE);


%>
    <tr>
        <td><%= firstName %> <%= lastName %></td>
        <td><%= (registrationNo != null ? registrationNo : "N/A") %></td>
        <td><%= userEmail %></td>
        <td><%= phone_number %></td>

        <!-- Role Badge -->
        <td><span class="badge <%= roleBadgeClass %>"><%= userRoleDisplay %></span></td>

        <!-- Status Badge -->
        <td><span class="badge <%= statusBadgeClass %>"><%= userStatusDisplay %></span></td>

        <!-- Actions -->
        <td>
            
            <!-- Details Button -->
    <button class="btn btn-sm btn-info me-1"
        onclick="window.location.href='user_details.jsp?u_id=<%= userId %>'" title="View Details">
        Details
    </button>
            <button class="btn btn-sm btn-primary me-1"
                onclick="window.location.href='edit_user.jsp?u_id=<%= userId %>'" title="Edit User">
                Edit
            </button>
            <button class="btn btn-danger" <%= isInactive ? "disabled" : "" %>
                onclick="if(confirm('Are you sure you want to Inactivate this user?')) window.location.href='delete_user.jsp?u_id=<%= userId %>';">
                Inactive
            </button>
        </td>
    </tr>
<%
    }

    if (!foundUsers) {
%>
    <tr>
        <td colspan="7" class="text-center text-muted py-3">
            <i class="bi bi-exclamation-circle me-2"></i> No users found matching the applied filters.
        </td>
    </tr>
<%
    }
%>
</tbody>

                                                
                                                
                                            </table>
                                                <br><br>
                                <%
                                } catch (SQLException sqle) {
                                    // Log the error properly in a real application (e.g., using Log4j or java.util.logging)
                                    System.err.println("SQL Error fetching users: " + sqle.getMessage());
                                    sqle.printStackTrace();
                                %>
                                <div class="alert alert-danger" role="alert">
                                    Error retrieving user data. Please check the logs or contact support. (<%= sqle.getMessage()%>)
                                </div>
                                <%
                                } catch (Exception e) {
                                    System.err.println("General Error fetching users: " + e.getMessage());
                                    e.printStackTrace();
                                %>
                                <div class="alert alert-danger" role="alert">
                                    An unexpected error occurred. Please try again. (<%= e.getMessage()%>)
                                </div>
                                <%
                                        } finally {
                                            // Close resources in reverse order of creation
                                            if (rs != null) try {
                                                rs.close();
                                            } catch (SQLException e) {
                                                /* Log */ }
                                            if (pst != null) try {
                                                pst.close();
                                            } catch (SQLException e) {
                                                /* Log */ }
                                            if (con != null) try {
                                                con.close();
                                            } catch (SQLException e) {
                                                /* Log */ }
                                        }
                                    } // End if(filtersApplied)
                                    // ** No 'else' needed here, the initial state is handled by JS hiding the container **
%>
                            </div> </div> </div> </div> 
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
                                document.getElementById("filterUserStatus").innerText = "Student";
                                filterUserStatusContainer.style.display = "flex";
                                filtersAreSet = true;
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