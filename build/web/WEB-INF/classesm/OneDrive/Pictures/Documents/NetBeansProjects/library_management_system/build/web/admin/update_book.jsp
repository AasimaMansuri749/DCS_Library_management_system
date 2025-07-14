f<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");

    String bookId = request.getParameter("book_id");
    String isbn = request.getParameter("isbn");
    String title = request.getParameter("title");
    int edition = Integer.parseInt(request.getParameter("edition"));
    int subjectId = Integer.parseInt(request.getParameter("subject_id"));
    int pageCount = Integer.parseInt(request.getParameter("page_count"));
    int publisherId = Integer.parseInt(request.getParameter("publisher_id"));
    String bookCoverImage = request.getParameter("book_cover_image");
//    String[] authorIds = request.getParameterValues("author_id");
String[] authorIds = request.getParameterValues("author_id[]");

    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");
        con.setAutoCommit(false);

        PreparedStatement updateBook = con.prepareStatement("UPDATE book SET ISBN=?, title=?, edition=?, subject_id=?, page_count=?, book_cover_image=?, publisher_id=? WHERE book_id=?");
        updateBook.setString(1, isbn);
        updateBook.setString(2, title);
        updateBook.setInt(3, edition);
        updateBook.setInt(4, subjectId);
        updateBook.setInt(5, pageCount);
        updateBook.setString(6, bookCoverImage);
        updateBook.setInt(7, publisherId);
        updateBook.setInt(8, Integer.parseInt(bookId));
        updateBook.executeUpdate();
        updateBook.close();

        PreparedStatement deleteAuthors = con.prepareStatement("DELETE FROM book_author WHERE book_id = ?");
        deleteAuthors.setInt(1, Integer.parseInt(bookId));
        deleteAuthors.executeUpdate();
        deleteAuthors.close();

        if (authorIds != null) {
            PreparedStatement insertAuthor = con.prepareStatement("INSERT INTO book_author (book_id, author_id) VALUES (?, ?)");
            for (String aid : authorIds) {
                insertAuthor.setInt(1, Integer.parseInt(bookId));
                insertAuthor.setInt(2, Integer.parseInt(aid));
                insertAuthor.addBatch();
            }
            insertAuthor.executeBatch();
            insertAuthor.close();
        }

        con.commit();
        response.sendRedirect("books.jsp?update=success");
    } catch (Exception e) {
        if (con != null) con.rollback();
        e.printStackTrace();
        response.sendRedirect("books.jsp?update=fail");
    } finally {
        if (con != null) con.close();
    }
%>