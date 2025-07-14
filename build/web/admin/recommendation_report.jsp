<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>

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
        <title>Grievance Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            @media print {
                .no-print {
                    display: none !important;
                }
            }
             .print-only {
    display: none;
  }

  @media print {
    .print-only {
      display: block !important;
    }
  }
  
   @media print {
    .table-responsive {
      overflow: visible !important;
    }
  }
        </style>
    </head>

    <body style="background: linear-gradient(135deg, #f2f2f2, #e6e6e6);">
        
        <div class="container mt-5">
            <h2 class="text-center mb-4">Book Recommendation Report</h2>

            <%
    String formattedFromDate = fromDate;
    String formattedToDate = toDate;

    try {
        SimpleDateFormat dbFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat displayFormat = new SimpleDateFormat("dd-MM-yyyy");

        if (!fromDate.isEmpty()) {
//            Date from = dbFormat.parse(fromDate);
java.util.Date from = dbFormat.parse(fromDate);

            formattedFromDate = displayFormat.format(from);
        }
        if (!toDate.isEmpty()) {
            java.util.Date to = dbFormat.parse(toDate);

            formattedToDate = displayFormat.format(to);
        }
    } catch (Exception e) {
        formattedFromDate = fromDate;
        formattedToDate = toDate;
    }
%>

            <!-- Date Display (PDF friendly, no input fields) -->
<div class="row g-3 mb-4 text-center print-only">
    <div class="col-md-6">
        <p class="fw-bold mb-0">Start Date: <%= formattedFromDate %></p>
        <!--<p></p>-->
        <p class="fw-bold mb-0">End Date: <%= formattedToDate %></p>
    </div>
</div>

            
            
            <!-- Date Inputs & Back Button (hidden when printing) -->
            <div class="row g-3 align-items-end mb-4 no-print">
                <div class="col-md-5">
                    <label for="from_date" class="form-label">Start Date:</label>
                    <input type="date" id="from_date" value="<%= fromDate%>" class="form-control" disabled>
                </div>
                <div class="col-md-5">
                    <label for="to_date" class="form-label">End Date:</label>
                    <input type="date" id="to_date" value="<%= toDate%>" class="form-control" disabled>
                </div>
                <div class="col-md-2 d-grid">
                    <a href="report.jsp" class="btn btn-primary w-100">Back</a>
                </div>
            </div>

            <!-- PDF Button (hidden when printing) -->
            <div class="text-center mb-4 no-print">
                <button class="btn btn-danger" onclick="window.print()">
                    <i class="bi bi-file-earmark-pdf-fill"></i> Download PDF
                </button>
            </div>

            <%
                if (!fromDate.isEmpty() && !toDate.isEmpty()) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection(
                                "jdbc:mysql://localhost:3306/library_management_system", "root", "");

String sql = "SELECT * FROM book_suggestions WHERE DATE(suggested_date) BETWEEN ? AND ? ORDER BY suggested_date DESC";



                        PreparedStatement pst = con.prepareStatement(sql);
                        pst.setString(1, fromDate);
                        pst.setString(2, toDate);
                        ResultSet rs = pst.executeQuery();

                        if (rs.isBeforeFirst()) {
            %>
            <div class="table-responsive mt-4">
    <table class="table table-bordered table-striped align-middle mt-4">
        <thead class="table-primary">
            <tr>
                <th>#</th>
                <th>Title</th>
                <th>Author</th>
                <th>Edition</th>
                <th>ISBN</th>
                <th>Publisher</th>
                <!--<th>Status</th>-->
                <th>Suggested Date</th>
            </tr>
        </thead>
        <tbody>
            <%
                int count = 1;
                while (rs.next()) {
                    String title = rs.getString("title");
                    String author = rs.getString("author");
                    String edition = rs.getString("edition");
                    String isbn = rs.getString("isbn");
                    String publisher = rs.getString("publisher");
//                    int status = rs.getInt("status");
                    String suggestedDate = rs.getString("suggested_date");
                    
                    String statusText = "Unknown";
//                    switch (status) {
//                        case 0: statusText = "Pending"; break;
//                        case 1: statusText = "Reviewed"; break;
//                        case 2: statusText = "Added"; break;
//                        case 3: statusText = "Rejected"; break;
//                    }
            %>
            <tr>
                <td><%= count++ %></td>
                <td><%= title %></td>
                <td><%= author %></td>
                <td><%= (edition != null && !edition.isEmpty()) ? edition : "-" %></td>
                <td><%= (isbn != null && !isbn.isEmpty()) ? isbn : "-" %></td>
                <td><%= (publisher != null && !publisher.isEmpty()) ? publisher : "-" %></td>
                <!--<td><span class="badge bg-secondary"><%= statusText %></span></td>-->
                <td><%= suggestedDate %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>
            <%
                        } else {
            %>
            <div class="alert alert-warning mt-4 text-center">
                No records found in the selected date range.
            </div>
            <%
                        }
                        rs.close();
                        pst.close();
                        con.close();
                    } catch (Exception e) {
            %>
            <div class="alert alert-danger mt-4 text-center">Error: <%= e.getMessage() %></div>
            <%
                    }
                } else {
            %>
            <div class="alert alert-info mt-4 text-center">Please select a valid start and end date.</div>
            <%
                }
            %>
        </div>
    </body>
</html>