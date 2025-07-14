<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String bookId = request.getParameter("book_id");
    if (bookId == null || bookId.isEmpty()) {
        response.sendRedirect("books.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

    PreparedStatement ps = con.prepareStatement("SELECT * FROM book WHERE book_id = ?");
    ps.setInt(1, Integer.parseInt(bookId));
    ResultSet rs = ps.executeQuery();

    if (!rs.next()) {
        response.sendRedirect("books.jsp");
        return;
    }

    String isbn = rs.getString("ISBN");
    String title = rs.getString("title");
    int edition = rs.getInt("edition");
    int subjectId = rs.getInt("subject_id");
    int pageCount = rs.getInt("page_count");
    String image = rs.getString("book_cover_image");
    int publisherId = rs.getInt("publisher_id");
//    int author_Id = rs.getInt("author_id[]");
String[] authorIds = request.getParameterValues("author_id[]");

    rs.close();
    ps.close();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="row">
        <!-- Left: Dropdowns -->
        <div class="col-md-4">
            <div class="card p-3 mb-4">
                <h5 class="mb-3">Subject List</h5>
                <form method="post" action="add_subject.jsp">
                    <input type="text" name="new_subject_name" class="form-control mb-2" placeholder="Enter subject name">
                    <button type="submit" class="btn btn-primary">Add</button>
                </form>
            </div>

            <div class="card p-3 mb-4">
                <h5 class="mb-3">Publisher List</h5>
                <form method="post" action="add_publisher.jsp">
                    <input type="text" name="new_publisher_name" class="form-control mb-2" placeholder="Enter publisher name">
                    <button type="submit" class="btn btn-primary">Add</button>
                </form>
            </div>

            <div class="card p-3">
                <h5 class="mb-3">Author List</h5>
                <form method="post" action="add_author.jsp">
                    <input type="text" name="new_author_name" class="form-control mb-2" placeholder="Enter author name">
                    <button type="submit" class="btn btn-primary">Add</button>
                </form>
            </div>
        </div>

        <!-- Right: Edit Form -->
        <div class="col-md-8">
            <div class="card shadow-lg rounded-4">
                <div class="card-header text-center fs-4">Edit Book</div>
                <div class="card-body p-4">
                    <form method="post" action="update_book.jsp">
                        <input type="hidden" name="book_id" value="<%= bookId %>">

                        <div class="mb-3">
                            <label class="form-label">ISBN</label>
                            <input type="text" name="isbn" class="form-control" maxlength="13" value="<%= isbn %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Title</label>
                            <input type="text" name="title" class="form-control" maxlength="70" value="<%= title %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Edition</label>
                            <input type="number" name="edition" class="form-control" min="1" value="<%= edition %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Subject</label>
                            <select class="form-select" name="subject_id" required>
                                <option value="">-- Select Subject --</option>
                                <%
                                    Statement st1 = con.createStatement();
                                    ResultSet rs1 = st1.executeQuery("SELECT subject_id, subject_name FROM subject ORDER BY subject_name ASC");
                                    while (rs1.next()) {
                                        int sid = rs1.getInt("subject_id");
                                        String sname = rs1.getString("subject_name");
                                %>
                                    <option value="<%= sid %>" <%= sid == subjectId ? "selected" : "" %>><%= sname %></option>
                                <%
                                    }
                                    rs1.close();
                                    st1.close();
                                %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Page Count</label>
                            <input type="number" name="page_count" class="form-control" min="1" value="<%= pageCount %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Publisher</label>
                            <select class="form-select" name="publisher_id" required>
                                <option value="">-- Select Publisher --</option>
                                <%  
                                    Statement st2 = con.createStatement();
                                    ResultSet rs2 = st2.executeQuery("SELECT publisher_id, publisher_name FROM publisher ORDER BY publisher_name ASC");
                                    while (rs2.next()) {
                                        int pid = rs2.getInt("publisher_id");
                                        String pname = rs2.getString("publisher_name");
                                %>
                                    <option value="<%= pid %>" <%= pid == publisherId ? "selected" : "" %>><%= pname %></option>
                                <%
                                    }
                                    rs2.close();
                                    st2.close();
                                %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Book Cover Image Path</label>
                            <input type="text" name="book_cover_image" class="form-control" value="<%= image %>" readonly>
                        </div>

                        <!-- Author multiselect and selected -->
                        <div class="mb-3">
                            <label class="form-label">Author(s)</label>
                            <select class="form-select" name="author_id[]" multiple required>
                                <%
                                    List<Integer> selectedAuthors = new ArrayList<>();
                                    PreparedStatement pa = con.prepareStatement("SELECT author_id FROM book_author WHERE book_id = ?");
                                    pa.setInt(1, Integer.parseInt(bookId));
                                    ResultSet rsa = pa.executeQuery();
                                    while (rsa.next()) {
                                        selectedAuthors.add(rsa.getInt("author_id"));
                                    }
                                    rsa.close();
                                    pa.close();

                                    Statement sa = con.createStatement();
                                    ResultSet allAuthors = sa.executeQuery("SELECT author_id, author_name FROM author ORDER BY author_name ASC");
                                    while (allAuthors.next()) {
                                        int aid = allAuthors.getInt("author_id");
                                        String aname = allAuthors.getString("author_name");
                                %>
                                <option value="<%= aid %>" <%= selectedAuthors.contains(aid) ? "selected" : "" %>>
                                     <%= aname %>
                                </option>
                                <%
                                    }
                                    allAuthors.close();
                                    sa.close();
                                %>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-success w-100">Update Book</button>
                        <a href="books.jsp" class="btn btn-secondary ms-2">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<%
    if (con != null && !con.isClosed()) {
        con.close();
    }
%>
</body>
</html>