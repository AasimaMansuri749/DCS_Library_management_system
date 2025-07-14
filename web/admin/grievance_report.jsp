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
            <h2 class="text-center mb-4">Book Grievance Report</h2>

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

String sql = "SELECT " +
             "b.title, " +
             "b.ISBN, " +
             "bc.library_classification_number, " +
             "g.grievance_reason, " +
             "g.grievance_date, " +
             "g.resolved_status, " +
             "g.resolved_date " +
             "FROM grievances g " +
             "JOIN book_copies bc ON g.copy_id = bc.copy_id " +
             "JOIN book b ON bc.book_id = b.book_id " +
             "WHERE DATE(g.grievance_date) BETWEEN ? AND ? " +
             "ORDER BY g.grievance_date DESC";


                        PreparedStatement pst = con.prepareStatement(sql);
                        pst.setString(1, fromDate);
                        pst.setString(2, toDate);
                        ResultSet rs = pst.executeQuery();

                        if (rs.isBeforeFirst()) {
            %>
            <div class="table-responsive mt-4">
                <!--<table class="table table-bordered table-hover table-striped">-->
                    <table class="table table-bordered table-striped mt-4">
  <thead class="thead-dark">
    <tr>
      <th>Book Title</th>
      <th>ISBN</th>
      <th>Library Classification</th>
      <th>Grievance Reason</th>
      <th>Grievance Date</th>
      <th>Resolved?</th>
      <th>Resolved Date</th>
    </tr>
  </thead>
  <tbody>
    <%
      while(rs.next()) {
          String resolved = rs.getInt("resolved_status") == 1 ? "Yes" : "No";
          String resolvedDate = rs.getTimestamp("resolved_date") != null ? rs.getTimestamp("resolved_date").toString() : "—";
    %>
    <tr>
      <td><%= rs.getString("title") %></td>
      <td><%= rs.getString("ISBN") %></td>
      <td><%= rs.getString("library_classification_number") %></td>
      <td><%= rs.getString("grievance_reason") %></td>
      <td><%= rs.getTimestamp("grievance_date") %></td>
      <td><%= resolved %></td>
      <td><%= resolvedDate %></td>
    </tr>
    <% } %>
  </tbody>
</table>

                <!--</table>-->
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