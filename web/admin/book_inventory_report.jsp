<%@page import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String fromDate = request.getParameter("startDate");
    String toDate = request.getParameter("endDate");

    if (fromDate == null || !fromDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
        fromDate = "";
    }
    if (toDate == null || !toDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
        toDate = "";
    }
%>
<html>
<head>
    <title>Book Inventory Report</title>
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    
        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #eef2f3;
        }

        h2 {
            text-align: center;
            margin-top: 20px;
        }

        .print-button-container {
            text-align: center;
            margin-top: 20px;
        }

        .print-button {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
        }

        th, td {
            padding: 10px;
            border: 1px solid #bbb;
            text-align: left;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        @media print {
            .print-button-container {
                display: none;
            }

            body {
                background: white;
            }

            table {
                page-break-after: auto;
            }

            tr {
                page-break-inside: avoid;
                page-break-after: auto;
            }

            thead {
                display: table-header-group;
            }

            tfoot {
                display: table-footer-group;
            }
        }
        @media print {
    .d-print-block {
        display: block !important;
    }

    .d-none {
        display: none !important;
    }
}

        
    </style>
</head>
<body>

<h2>Library Book Inventory Report</h2>
<!--<h2>Library Book Inventory Report</h2>-->

<!-- Dates shown only in print (PDF), as plain lines -->
<div class="d-print-block d-none text-start mb-3" style="margin-left: 40px;">
    <p>Start Date: <%= fromDate %></p>
    <p>End Date: <%= toDate %></p>
</div>


 <div class="row g-3 align-items-end mb-4 no-print">
        <div class="col-md-5">
            <label class="form-label">Start Date:</label>
            <input type="date" class="form-control" value="<%= fromDate %>" disabled>
        </div>
        <div class="col-md-5">
            <label class="form-label">End Date:</label>
            <input type="date" class="form-control" value="<%= toDate %>" disabled>
        </div>
        <div class="col-md-2 d-grid">
<a href="report.jsp" class="btn btn-primary d-print-none">Back</a>
        </div>
    </div>
<!-- Print/Download as PDF Button -->
<div class="print-button-container">
    <button class="print-button" onclick="window.print()">Download PDF</button>
</div>

<table>
    <thead>
    <tr>
        <th>No</th>
        <th>ISBN</th>
        <th>Title</th>
        <th>Edition</th>
        <th>Subject</th>
        <th>Total Copies</th>
        <th>Added Date</th>
        <th>Page Count</th>
        <th>Publisher</th>
    </tr>
    </thead>
    <tbody>
<%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    int index = 1;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        String query = "SELECT b.book_id, b.ISBN, b.title, b.edition, s.subject_name, b.total_copies, b.added_date, b.page_count, p.publisher_name " +
                       "FROM book b " +
                       "LEFT JOIN subject s ON b.subject_id = s.subject_id " +
                       "LEFT JOIN publisher p ON b.publisher_id = p.publisher_id";

        st = con.createStatement();
        rs = st.executeQuery(query);

        while (rs.next()) {
%>
    <tr>
        <td><%= index++ %></td>
        <td><%= rs.getString("ISBN") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("edition") %></td>
        <td><%= rs.getString("subject_name") != null ? rs.getString("subject_name") : "N/A" %></td>
        <td><%= rs.getInt("total_copies") %></td>
        <td><%= rs.getDate("added_date") %></td>
        <td><%= rs.getInt("page_count") %></td>
        <td><%= rs.getString("publisher_name") != null ? rs.getString("publisher_name") : "N/A" %></td>
    </tr>
<%
        }
    } catch(Exception e) {
        out.println("<tr><td colspan='9' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(st != null) st.close(); } catch(Exception e) {}
        try { if(con != null) con.close(); } catch(Exception e) {}
    }
%>
    </tbody>
</table>

</body>
</html>