<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String bookIdParam = request.getParameter("book_id");
    int bookId = 0;
    boolean showForm = true;

    if (bookIdParam != null && !bookIdParam.isEmpty()) {
        try {
            bookId = Integer.parseInt(bookIdParam);
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>❌ Invalid book ID in query.</div>");
            showForm = false;
        }
    } else {
        out.println("<div class='alert alert-danger'>❌ Book ID is missing from URL.</div>");
        showForm = false;
    }

    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            int category_id = Integer.parseInt(request.getParameter("category_id"));
            String lcn = request.getParameter("library_classification_number").trim();
            int cupboard_no = Integer.parseInt(request.getParameter("cupboard_no"));
            int rack_no = Integer.parseInt(request.getParameter("rack_no"));

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO book_copies (book_id, category_id, library_classification_number, cupboard_no, rack_no, book_condition_status, book_reservation_status) VALUES (?, ?, ?, ?, ?, 1, 0)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setInt(1, bookId);
            ps.setInt(2, category_id);
            ps.setString(3, lcn);
            ps.setInt(4, cupboard_no);
            ps.setInt(5, rack_no);

            int i = ps.executeUpdate();
            if (i > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                int copyId = 0;
                if (generatedKeys.next()) {
                    copyId = generatedKeys.getInt(1);
                }
                generatedKeys.close();

                PreparedStatement catStmt = con.prepareStatement("SELECT category_name FROM category WHERE category_id = ?");
                catStmt.setInt(1, category_id);
                ResultSet catRs = catStmt.executeQuery();
                String categoryName = "";
                if (catRs.next()) {
                    categoryName = catRs.getString("category_name");
                }
                catRs.close();
                catStmt.close();

                if ("donated".equalsIgnoreCase(categoryName)) {
                    String donorName = request.getParameter("donor_name").trim();
                    if (donorName != null && !donorName.isEmpty()) {
                        PreparedStatement donorStmt = con.prepareStatement(
                            "INSERT INTO donor (name, copy_id, donation_date) VALUES (?, ?, CURDATE())"
                        );
                        donorStmt.setString(1, donorName);
                        donorStmt.setInt(2, copyId);
                        donorStmt.executeUpdate();
                        donorStmt.close();
                    }
                }

                PreparedStatement psUpdate = con.prepareStatement("UPDATE book SET total_copies = total_copies + 1 WHERE book_id = ?");
                psUpdate.setInt(1, bookId);
                psUpdate.executeUpdate();
                psUpdate.close();

                con.close();
                session.setAttribute("message", "✅ Book copy added successfully!");
                response.sendRedirect("book_all_details.jsp?book_id=" + bookId);
                return;
            } else {
                out.println("<div class='alert alert-danger'>❌ Failed to add book copy.</div>");
            }

            ps.close();
        }

    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>❌ Error: " + e.getMessage() + "</div>");
        showForm = false;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Book Copy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .form-label {
            font-weight: 500;
        }
        .form-section {
            margin-top: 2rem;
        }
        .btn-primary {
            width: 100%;
        }
    </style>
    <script>
        function handleCategoryChange(selectObj) {
            var selectedOption = selectObj.options[selectObj.selectedIndex];
            var selectedText = selectedOption.text.toLowerCase();
            var donorDiv = document.getElementById("donor-field");

            if (selectedText.includes("donated")) {
                donorDiv.style.display = "block";
                donorDiv.querySelector("input").required = true;
            } else {
                donorDiv.style.display = "none";
                donorDiv.querySelector("input").required = false;
            }
        }
    </script>
</head>
<body>
<div class="container form-section">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card border-0">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0"><i class="bi bi-plus-circle"></i> Add Book Copy</h4>
                </div>
                <div class="card-body">
                    <% if (showForm) { %>
                    <form method="post" action="">
                        <input type="hidden" name="book_id" value="<%= bookId %>">

                        <!-- Category -->
                        <div class="mb-3">
                            <label class="form-label">Category</label>
                            <select name="category_id" class="form-select" onchange="handleCategoryChange(this)" required>
                                <option value="" disabled selected>-- Select Category --</option>
                                <%
                                    Statement st = con.createStatement();
                                    ResultSet rs = st.executeQuery("SELECT category_id, category_name FROM category");
                                    while (rs.next()) {
                                        int catId = rs.getInt("category_id");
                                        String catName = rs.getString("category_name");
                                %>
                                <option value="<%= catId %>"><%= catName %></option>
                                <%
                                    }
                                    rs.close();
                                    st.close();
                                %>
                            </select>
                        </div>

                        <!-- LCN -->
                        <div class="mb-3">
                            <label class="form-label">Library Classification Number</label>
                            <input type="text" class="form-control" name="library_classification_number" maxlength="20" required>
                        </div>

                        <!-- Cupboard and Rack -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Cupboard No</label>
                                <input type="number" class="form-control" name="cupboard_no" min="1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Rack No</label>
                                <input type="number" class="form-control" name="rack_no" min="1" required>
                            </div>
                        </div>

                        <!-- Donor Field -->
                        <div class="mb-3" id="donor-field" style="display: none;">
                            <label class="form-label">Donor Name</label>
                            <input type="text" class="form-control" name="donor_name" maxlength="30">
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">➕ Add Book Copy</button>
                        </div>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap Icons CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</body>
</html>

<%
    if (con != null) con.close();
%>