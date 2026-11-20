<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.db.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: Organizer login 
    if (session.getAttribute("org_id") == null) {
        response.sendRedirect("org_login.jsp");
        return;
    }
    String role = (String) session.getAttribute("org_role");
    
    // URL se selected event ki ID lena (agar select ki gayi ho)
    String selectedEventId = request.getParameter("event_id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FestHub - Student Reports & Downloads </title>
    
   
    <link rel="stylesheet" type="text/css" href="css/style.css">
    
   
    <style>
        .glass-panel .filter-form {
            display: flex; align-items: center; gap: 15px; margin-bottom: 20px;
        }
        .glass-panel label { font-weight: 500; font-size: 15px; color: #eeeeee; }
        
        .glass-panel select {
            padding: 10px 15px; width: 300px;
            background: rgba(255, 255, 255, 0.2); border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 6px; color: white; outline: none; font-size: 14px;
        }
        .glass-panel select option { background: #2a5298; color: white; }
        
        .btn-search {
            background: rgba(255, 255, 255, 0.9); color: #1e3c72; padding: 10px 20px;
            border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: 0.3s;
        }
        .btn-search:hover { background: #ffffff; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        
        .btn-download {
            background: rgba(40, 167, 69, 0.8); color: white; padding: 10px 20px;
            border: 1px solid #28a745; border-radius: 6px; font-weight: 600; cursor: pointer; 
            transition: 0.3s; margin-bottom: 15px; display: inline-block;
        }
        .btn-download:hover { background: rgba(40, 167, 69, 1); box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        
        /* Table Styling */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; color: white; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.2); }
        th { background: rgba(0, 0, 0, 0.4); font-weight: 500; text-transform: uppercase; font-size: 13px; }
        tr:hover { background: rgba(255, 255, 255, 0.05); }
        
        .empty-msg { text-align: center; color: #ffb3b3; font-style: italic; padding: 20px !important; }
        
        /* Logout Button Note */
        .logout-btn { color: #ffb3b3 !important; }
        .logout-btn:hover { color: #ffffff !important; }
    </style>
</head>
<body>

    
    <nav class="glass-navbar">
        <h2>MGAHV - FestHub Reports</h2>
        <div>
            <a href="org_dashboard.jsp">Dashboard</a>
            <% if("Admin".equals(role)) { %> <a href="view_events.jsp">Manage Events</a> <% } %>
            <% if("Staff".equals(role)) { %> <a href="create_event.jsp">Create Event</a> <% } %>
            <a href="LogoutServlet?type=org" class="logout-btn">Logout</a>
        </div>
    </nav>

  
    <div class="dashboard-wrapper">
        <div class="glass-panel">
            <h2 style="margin-bottom: 25px;">Participant Reports</h2>

            <!-- Event Select Form -->
            <form action="event_reports.jsp" method="GET" class="filter-form">
                <label>Select Event: </label>
                <select name="event_id" required>
                    <option value="" disabled selected>-- Choose an Event --</option>
                    <%
                        try {
                            Connection conn = DBConnection.getConnection();
                            String sqlEvents = "SELECT event_id, title, event_date FROM events ORDER BY event_id DESC";
                            PreparedStatement psE = conn.prepareStatement(sqlEvents);
                            ResultSet rsE = psE.executeQuery();
                            while(rsE.next()) {
                                int eId = rsE.getInt("event_id");
                                String selected = (selectedEventId != null && selectedEventId.equals(String.valueOf(eId))) ? "selected" : "";
                    %>
                    <option value="<%= eId %>" <%= selected %>><%= rsE.getString("title") %> (<%= rsE.getString("event_date") %>)</option>
                    <%
                            }
                        } catch(Exception e) { e.printStackTrace(); }
                    %>
                </select>
                <button type="submit" class="btn-search">View Students</button>
            </form>

            <!-- if any event is selected then show the table -->
            <% if(selectedEventId != null) { %>
                
                <button class="btn-download" onclick="downloadCSV()">📥 Download as Excel (CSV)</button>

                <!-- Is table ka ID 'dataTable' rakha hai taki JS isey download kar sake -->
                <div style="overflow-x:auto;">
                    <table id="dataTable">
                        <thead>
                            <tr>
                                <th>Reg. No.</th>
                                <th>Student Name</th>
                                <th>Course & Dept</th>
                                <th>Phone Number</th>
                                <th>Activity Role</th>
                                <th>Applied On</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                boolean hasData = false;
                                try {
                                    Connection conn = DBConnection.getConnection();
                                    String sqlData = "SELECT s.registration_no, s.name, s.course, s.department, p.phone_number, p.activity_role, p.applied_at " +
                                                     "FROM event_participants p " +
                                                     "INNER JOIN students s ON p.registration_no = s.registration_no " +
                                                     "WHERE p.event_id = ? ORDER BY p.applied_at DESC";
                                    PreparedStatement psData = conn.prepareStatement(sqlData);
                                    psData.setString(1, selectedEventId);
                                    ResultSet rsData = psData.executeQuery();

                                    while(rsData.next()) {
                                        hasData = true;
                            %>
                            <tr>
                                <td><%= rsData.getString("registration_no") %></td>
                                <td style="font-weight:600;"><%= rsData.getString("name") %></td>
                                <td><%= rsData.getString("course") %> (<%= rsData.getString("department") %>)</td>
                                <td><%= rsData.getString("phone_number") %></td>
                                <td>
                                    <span style="background: rgba(255, 255, 255, 0.2); color: #ffffff; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 500; border: 1px solid rgba(255,255,255,0.4);">
                                        <%= rsData.getString("activity_role") %>
                                    </span>
                                </td>
                                <td><%= rsData.getString("applied_at") %></td>
                            </tr>
                            <%
                                    }
                                } catch(Exception e) { e.printStackTrace(); }

                                if(!hasData) {
                            %>
                            <tr>
                                <td colspan="6" class="empty-msg">No students have applied for this event yet.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>

        </div>
    </div>

    <!-- JavaScript - Table ko Excel (CSV) me convert karne ke liye (No Changes) -->
    <script>
        function downloadCSV() {
            var csv = [];
            var rows = document.querySelectorAll("#dataTable tr");
            
            for (var i = 0; i < rows.length; i++) {
                var row = [], cols = rows[i].querySelectorAll("td, th");
                
                for (var j = 0; j < cols.length; j++) {
                    var data = cols[j].innerText.replace(/"/g, '""');
                    row.push('"' + data + '"');
                }
                csv.push(row.join(",")); 
            }

            var csvFile = new Blob([csv.join("\n")], {type: "text/csv"});
            var downloadLink = document.createElement("a");
            
            downloadLink.download = "Event_Participants_List.csv";
            downloadLink.href = window.URL.createObjectURL(csvFile);
            downloadLink.style.display = "none";
            
            document.body.appendChild(downloadLink);
            downloadLink.click(); 
        }
    </script>

</body>
</html>