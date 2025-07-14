<%@ page import="java.sql.*, java.util.*, java.io.*, java.nio.file.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="jakarta.servlet.annotation.MultipartConfig" %>
<%@ page import="jakarta.servlet.annotation.WebServlet" %>
<%@ page import="jakarta.servlet.*" %>

<%
    String message = "";
    String msgType = "danger";

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            request.setCharacterEncoding("UTF-8");

            String isbn = request.getParameter("isbn");
            String title = request.getParameter("title");
            String editionStr = request.getParameter("edition");
            String subjectIdStr = request.getParameter("subject_id");
            String pageStr = request.getParameter("page_count");
            String publisherIdStr = request.getParameter("publisher_id");
            String bookCoverImagePath = request.getParameter("book_cover_image");
            String newSubject = request.getParameter("new_subject");
            String newPublisher = request.getParameter("new_publisher");

            if (isbn == null || isbn.isEmpty() || !isbn.matches("\\d{13}")) {
                message = "❌ ISBN must be exactly 13 digits.";
            } else {
                // Check if ISBN already exists
                PreparedStatement checkIsbn = con.prepareStatement("SELECT COUNT(*) FROM book WHERE ISBN = ?");
                checkIsbn.setString(1, isbn);
                ResultSet rsIsbn = checkIsbn.executeQuery();
                if (rsIsbn.next() && rsIsbn.getInt(1) > 0) {
                    message = "❌ ISBN already exists. Please use a unique ISBN.";
                    rsIsbn.close();
                    checkIsbn.close();
                    throw new Exception(message);
                }
                rsIsbn.close();
                checkIsbn.close();

                if (title == null || title.isEmpty()
                        || editionStr == null || editionStr.isEmpty()
                        || pageStr == null || pageStr.isEmpty()
                        || bookCoverImagePath == null || bookCoverImagePath.isEmpty()) {
                    message = "❌ All fields are required.";
                } else {
                    int edition = Integer.parseInt(editionStr);
                    int pageCount = Integer.parseInt(pageStr);
                    int subjectId = 0;
                    int publisherId = 0;

                    // Subject
                    if (newSubject != null && !newSubject.trim().isEmpty()) {
                        PreparedStatement psSub = con.prepareStatement("INSERT INTO subject (subject_name) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
                        psSub.setString(1, newSubject.trim());
                        psSub.executeUpdate();
                        ResultSet rsSub = psSub.getGeneratedKeys();
                        if (rsSub.next()) {
                            subjectId = rsSub.getInt(1);
                        }
                        rsSub.close();
                        psSub.close();
                    } else if (subjectIdStr != null && !subjectIdStr.trim().isEmpty()) {
                        subjectId = Integer.parseInt(subjectIdStr);
                    } else {
                        message = "❌ Please select or enter a subject.";
                        throw new Exception(message);
                    }

                    // Publisher
                    if (newPublisher != null && !newPublisher.trim().isEmpty()) {
                        PreparedStatement psPub = con.prepareStatement("INSERT INTO publisher (publisher_name) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
                        psPub.setString(1, newPublisher.trim());
                        psPub.executeUpdate();
                        ResultSet rsPub = psPub.getGeneratedKeys();
                        if (rsPub.next()) {
                            publisherId = rsPub.getInt(1);
                        }
                        rsPub.close();
                        psPub.close();
                    } else if (publisherIdStr != null && !publisherIdStr.trim().isEmpty()) {
                        publisherId = Integer.parseInt(publisherIdStr);
                    } else {
                        message = "❌ Please select or enter a publisher.";
                        throw new Exception(message);
                    }

                    // Author IDs from multiple select
                    String[] selectedAuthorIds = request.getParameterValues("author_id[]");
                    List<Integer> authorIds = new ArrayList<>();

                    if (selectedAuthorIds != null) {
                        for (String id : selectedAuthorIds) {
                            if (id != null && !id.trim().isEmpty()) {
                                authorIds.add(Integer.parseInt(id.trim()));
                            }
                        }
                    }

                    // New authors
                    String[] newAuthors = request.getParameterValues("new_author[]");
                    if (newAuthors != null) {
                        for (String name : newAuthors) {
                            if (name != null && !name.trim().isEmpty()) {
                                PreparedStatement psAuth = con.prepareStatement("INSERT INTO author (author_name) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
                                psAuth.setString(1, name.trim());
                                psAuth.executeUpdate();
                                ResultSet rsAuth = psAuth.getGeneratedKeys();
                                if (rsAuth.next()) {
                                    authorIds.add(rsAuth.getInt(1));
                                }
                                rsAuth.close();
                                psAuth.close();
                            }
                        }
                    }

                    if (authorIds.isEmpty()) {
                        message = "❌ Please select or enter at least one author.";
                        throw new Exception(message);
                    }

                    // Save book with generated keys
                    String imagePath = "images/" + bookCoverImagePath;

                    PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO book (ISBN, title, edition, subject_id, page_count, book_cover_image, publisher_id, total_copies) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                            Statement.RETURN_GENERATED_KEYS);
                    ps.setString(1, isbn);
                    ps.setString(2, title);
                    ps.setInt(3, edition);
                    ps.setInt(4, subjectId);
                    ps.setInt(5, pageCount);
                    ps.setString(6, imagePath);
                    ps.setInt(7, publisherId);
                    ps.setInt(8, 0);

                    int result = ps.executeUpdate();

                    if (result > 0) {
                        ResultSet rsBookId = ps.getGeneratedKeys();
                        if (rsBookId.next()) {
                            int bookId = rsBookId.getInt(1);

                            PreparedStatement psBA = con.prepareStatement("INSERT INTO book_author (book_id, author_id) VALUES (?, ?)");
                            for (int authorId : authorIds) {
                                psBA.setInt(1, bookId);
                                psBA.setInt(2, authorId);
                                psBA.executeUpdate();
                            }
                            psBA.close();
                        }
                        rsBookId.close();

                        message = "✅ Book added successfully!";
                        msgType = "success";
                        response.sendRedirect("books.jsp");
                        return;
                    } else {
                        message = "❌ Failed to add book.";
                    }
                    ps.close();
                }
            }

        } catch (Exception e) {
            if (!message.startsWith("❌")) {
                message = "❌ Error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Add Book</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-4">
            <div class="row">
                <!-- Left Side: Add Subject -->
                <div class="col-md-4">
                    <div class="card p-3">
                        <h5 class="mb-3">Add New Subject</h5>
                        <form action="add_subject.jsp" method="post">
                            <div class="mb-2">
                                <input type="text" name="new_subject_name" class="form-control" placeholder="Enter subject name" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Add Subject</button>
                        </form>

                    </div>

                    <div class="card p-3 mt-4">
                        <!-- Add Publisher Form -->
                        <h5 class="mb-3">Add New Publisher</h5>
                        <form action="add_publisher.jsp" method="post">
                            <div class="mb-2">
                                <input type="text" name="new_publisher_name" class="form-control" placeholder="Enter publisher name" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Add Publisher</button>
                        </form>
                    </div>


                    <div class="card p-3 mt-4">
                        <!-- Add Author Form -->
                        <h5 class="mb-3">Add New Author</h5>
                        <form action="add_author.jsp" method="post">
                            <div class="mb-2">
                                <input type="text" name="new_author_name" class="form-control" placeholder="Enter author name" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Add Author</button>
                        </form>
                    </div>

                </div>

                <!-- Right Side: Main Form -->
                <div class="col-md-8">
                    <div class="card shadow-lg rounded-4">
                        <div class="card-header text-black text-center fs-4">
                            Add New Book
                        </div>
                        <div class="card-body p-4">
                            <% if (!message.isEmpty()) {%>
                            <div class="alert alert-<%= msgType%> text-center"><%= message%></div>
                            <% }%>

                            <form method="post" action="">
                                <div class="mb-3">
                                    <label class="form-label">ISBN</label>
                                    <input type="text" class="form-control" name="isbn" maxlength="13" 
                                           value="<%= request.getParameter("isbn") != null ? request.getParameter("isbn") : ""%>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Title</label>
                                    <input type="text" class="form-control" name="title" maxlength="70" 
                                           value="<%= request.getParameter("title") != null ? request.getParameter("title") : ""%>" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Edition</label>
                               
                                    <input type="number" class="form-control" name="edition" min="1"
                                           value="<%= request.getParameter("edition") != "1" ? request.getParameter("edition") : ""%>">
                                </div>


                                <!-- Subject Dropdown -->
                                <div class="mb-3">
                                    <label class="form-label">Subject</label>
                                    <select class="form-select" name="subject_id" required>
                                        <option value="">-- Select Subject --</option>
                                        <%
                                            Statement st1 = con.createStatement();
                                            ResultSet rs1 = st1.executeQuery("SELECT subject_id, subject_name FROM subject ORDER BY subject_name ASC");

                                            while (rs1.next()) {
                                        %>
                                        <option value="<%= rs1.getInt("subject_id")%>">
                                            <%= rs1.getString("subject_name")%>
                                        </option>
                                        <%
                                            }
                                            rs1.close();
                                            st1.close();
                                        %>
                                    </select>
                                </div>


                                <div class="mb-3">
                                    <label class="form-label">Page Count</label>
                                    <input type="number" class="form-control" name="page_count" min="1" required>
                                </div>

                                <!-- Publisher Dropdown -->
                                <div class="mb-3">
                                    <label class="form-label">Publisher</label>
                                    <select class="form-select" name="publisher_id" required>
                                        <option value="">-- Select Publisher --</option>
                                        <%
                                            Statement st2 = con.createStatement();
                                            ResultSet rs2 = st2.executeQuery("SELECT publisher_id, publisher_name FROM publisher ORDER BY publisher_name ASC");
                                            while (rs2.next()) {
                                        %>
                                        <option value="<%= rs2.getInt("publisher_id")%>"><%= rs2.getInt("publisher_id")%> - <%= rs2.getString("publisher_name")%></option>
                                        <%
                                            }
                                            rs2.close();
                                            st2.close();
                                        %>
                                    </select>
                                </div>


                                <!-- Author Dropdown with multiple select -->
                                <div class="mb-3">
                                    <label class="form-label">Author(s)</label>
                                    <select class="form-select" name="author_id[]" multiple required>
                                        <%
                                            Statement st3 = con.createStatement();
                                            ResultSet rs3 = st3.executeQuery("SELECT author_id, author_name FROM author ORDER BY author_name ASC");
                                            while (rs3.next()) {
                                        %>
                                        <option value="<%= rs3.getInt("author_id")%>">
                                            <%= rs3.getInt("author_id")%> - <%= rs3.getString("author_name")%>
                                        </option>
                                        <%
                                            }
                                            rs3.close();
                                            st3.close();
                                        %>
                                    </select>
                                    <small class="text-muted">Hold Ctrl (Windows) or Command (Mac) to select multiple authors.</small>
                                </div>


                                <div class="mb-3">
                                    <label class="form-label">Book Cover Image (File Path)</label>
                                    <input type="text" class="form-control" name="book_cover_image" required>
                                    <small class="text-muted">Enter the image filename in "images/" folder (e.g., cover1.jpg).</small>
                                </div>

                                <button type="submit" class="btn btn-success w-100">Add Book</button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </div>



    <script>
        function toggleSubjectInput() {
            var input = document.getElementById('new_subject_input');
            input.classList.toggle('d-none');
        }

        function togglePublisherInput() {
            var input = document.getElementById('new_publisher_input');
            input.classList.toggle('d-none');
        }


        function toggleAuthorInput() {
            var container = document.getElementById('new_author_container');
            var addBtn = document.getElementById('add_author_btn');
            if (container.classList.contains('d-none')) {
                container.classList.remove('d-none');
                addBtn.classList.remove('d-none');
            } else {
                container.classList.add('d-none');
                addBtn.classList.add('d-none');
            }
        }

        function addAuthorField() {
            var container = document.getElementById('new_author_container');
            var input = document.createElement('input');
            input.type = 'text';
            input.name = 'new_author[]';
            input.className = 'form-control mb-2';
            input.placeholder = 'Enter new author name';
            container.appendChild(input);
        }
    </script>

    <%
        // Close connection here after all DB uses
        if (con != null && !con.isClosed()) {
            con.close();
        }
    %>
</body>
</html>