<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Inactive Users Report</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
  <style>
    @media print {
      .no-print {
        display: none !important;
      }
      .table th:last-child,
      .table td:last-child {
        display: none !important;
      }
    }
  </style>
</head>
<body style="background: linear-gradient(135deg, #f2f2f2, #e6e6e6);">

<%
    String fromDate = request.getParameter("from");
    String toDate = request.getParameter("to");

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management_system", "root", "");

        String sql = "SELECT u.*, lt.last_transaction_date " +
                     "FROM user u " +
                     "LEFT JOIN ( " +
                     "  SELECT br.u_id, MAX(t.issue_date) AS last_transaction_date " +
                     "  FROM transaction t " +
                     "  JOIN book_request br ON t.request_id = br.request_id " +
                     "  GROUP BY br.u_id " +
                     ") lt ON u.u_id = lt.u_id " +
                     "WHERE u.u_id NOT IN ( " +
                     "  SELECT DISTINCT br.u_id " +
                     "  FROM transaction t " +
                     "  JOIN book_request br ON t.request_id = br.request_id " +
                     "  WHERE t.issue_date BETWEEN ? AND ? " +
                     ")";
                     
        pst = con.prepareStatement(sql);
        pst.setString(1, fromDate);
        pst.setString(2, toDate);

        rs = pst.executeQuery();
%>

<div class="container my-5">
  <h2 class="text-center mb-4">Inactive Users Report</h2>

  <!-- PDF Button -->
  <div class="text-center mb-3 no-print">
    <button class="btn btn-danger" onclick="window.print()">
      <i class="bi bi-file-earmark-pdf-fill"></i> Download PDF
    </button>
  </div>

  <div class="card shadow-sm">
<!--    <div class="card-header bg-dark text-white">
      <h5 class="mb-0">Users Without Activity Between <%= fromDate %> and <%= toDate %></h5>
    </div>-->
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-striped table-hover mb-0">
          <thead class="table-dark">
            <tr>
<!--              <th>User ID</th>-->
              <th>Name</th>
              <th>Email</th>
              <th>Last Transaction</th>
              <th>Status</th>
              <th class="no-print">Action</th>
            </tr>
          </thead>
          <tbody>
          <%
            while (rs.next()) {
                int uid = rs.getInt("u_id");
                String name = rs.getString("fname") + " " + rs.getString("lname");
                String email = rs.getString("email");
                int status = rs.getInt("status");
                java.sql.Date lastTransaction = rs.getDate("last_transaction_date");
          %>
            <tr>
<!--              <td><%= uid %></td>-->
              <td><%= name %></td>
              <td><%= email %></td>
              <td><%= (lastTransaction != null ? lastTransaction.toString() : "Never") %></td>
              <td>
                <span class="badge <%= (status == 1 ? "bg-success" : "bg-secondary") %>">
                  <%= (status == 1 ? "Active" : "Inactive") %>
                </span>
              </td>
              <td class="no-print">
                <% if (status == 1) { %>
                  <form action="MarkInactiveServlet" method="post" class="d-inline">
                    <input type="hidden" name="u_id" value="<%= uid %>">
                    <button type="submit" class="btn btn-danger btn-sm">Mark Inactive</button>
                  </form>
                <% } else { %>
                  <span class="text-muted">Already Inactive</span>
                <% } %>
              </td>
            </tr>
          <%
            }
          %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<%
    } catch (Exception e) {
        out.println("<div class='alert alert-danger m-4'>Error: " + e.getMessage() + "</div>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pst != null) pst.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>

</body>
</html>