<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Edit book copy</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%
    String copyId = request.getParameter("copy_id");

    int categoryId = 0;
    String lcn = "";
    int cupboardNo = 0, rackNo = 0,book_id_hidden= 0;
    int reservationStatus = 0, condition = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        PreparedStatement ps = con.prepareStatement("SELECT * FROM book_copies WHERE copy_id = ?");
        ps.setString(1, copyId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            categoryId = rs.getInt("category_id");
            lcn = rs.getString("library_classification_number");
            cupboardNo = rs.getInt("cupboard_no");
            book_id_hidden = rs.getInt("book_id");
            rackNo = rs.getInt("rack_no");
            reservationStatus = rs.getInt("book_reservation_status");
            condition = rs.getInt("book_condition_status");
        }

        PreparedStatement psCat = con.prepareStatement("SELECT * FROM category");
        ResultSet rsCat = psCat.executeQuery();
%>
<div class="container mt-5 w-50">
        <div class="card shadow-lg rounded-4">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">Edit Book Copy</h4>
            </div>
            <div class="card-body">

<form action="update_copy.jsp" method="post" class="p-4 border rounded shadow-sm bg-light">
    <input type="hidden" name="copy_id" value="<%= copyId %>">
    <input type="hidden" name="book_id_h" value="<%= book_id_hidden %>">

    <div class="mb-3">
        <label for="category_id" class="form-label">Category</label>
        <!-- Show the category in a disabled dropdown -->
<select class="form-select" disabled>
    <% while (rsCat.next()) {
        int catId = rsCat.getInt("category_id");
        String catName = rsCat.getString("category_name");
    %>
    <option value="<%= catId %>" <%= (catId == categoryId ? "selected" : "") %>><%= catName %></option>
    <% } %>
</select>

<!-- Actually submit the category_id using a hidden input -->
<input type="hidden" name="category_id" value="<%= categoryId %>">

    </div>

    <div class="mb-3">
        <label for="lcn" class="form-label"> Library Classification Number</label>
        <input type="text" class="form-control" name="lcn" id="lcn" value="<%= lcn %>">
    </div>

    <div class="mb-3">
        <label for="cupboard_no" class="form-label">Cupboard No</label>
        <input type="number" class="form-control" name="cupboard_no" id="cupboard_no" value="<%= cupboardNo %>">
    </div>

    <div class="mb-3">
        <label for="rack_no" class="form-label">Rack No</label>
        <input type="number" class="form-control" name="rack_no" id="rack_no" value="<%= rackNo %>">
    </div>

    <div class="mb-3">
        <label for="condition" class="form-label">Condition</label>
        <select name="condition" id="condition" class="form-select" onchange="toggleGrievance()">
            <option value="1" <%= condition == 1 ? "selected" : "" %>>Active</option>
            <option value="0" <%= condition == 0 ? "selected" : "" %>>Inactive</option>
        </select>
    </div>

    <div id="grievanceDiv" class="mb-3" style="display: none;">
        <label for="grievance" class="form-label">Grievance Reason</label>
        <input type="text" class="form-control" name="grievance" id="grievance">
    </div>

    <button type="submit" class="btn btn-primary">Update</button>
    <a href="book_all_details.jsp?book_id=<%=book_id_hidden%>" class="btn btn-secondary ms-2">Cancel</a>

</form>


<script>
    function toggleGrievance() {
        const condition = document.getElementById("condition").value;
        const grievanceDiv = document.getElementById("grievanceDiv");
        const grievanceInput = document.getElementById("grievance");

        if (condition == "0") { // Inactive
            grievanceDiv.style.display = "block";
            grievanceInput.required = true;
        } else {
            grievanceDiv.style.display = "none";
            grievanceInput.required = false;
        }
    }

    // Call once on load in case "Inactive" is preselected
    window.onload = toggleGrievance;
</script>

<%
    } catch (Exception e) {
        out.println("Error: " + e);
    }
%>

 </div>
        </div>
    </div>
</body>
</html>