<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.db.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: student login important.
    if (session.getAttribute("user_name") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FestHub - My Registrations </title>
    
    <!-- universal CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
    
    <!-- to make this page like a glass them ,custom css -->
    <style>
        /* Table Styling */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; color: white; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.2); }
        th { background: rgba(0, 0, 0, 0.4); font-weight: 500; text-transform: uppercase; font-size: 13px; }
        tr:hover { background: rgba(255, 255, 255, 0.05); }
        
        /* Role Badge Styling  */
        .role-badge {
            background: rgba(255, 255, 255, 0.2); color: #ffffff; padding: 4px 10px; 
            border-radius: 12px; font-size: 12px; font-weight: 500; 
            border: 1px solid rgba(255,255,255,0.4); display: inline-block;
        }
        
        .date-text { font-size: 13px; color: #dddddd; margin-top: 4px; }
        .empty-state { text-align: center; color: #eeeeee; padding: 30px; font-size: 15px; }
        
        /* Logout Button Note */
        .logout-btn { color: #ffb3b3 !important; }
        .logout-btn:hover { color: #ffffff !important; text-decoration: underline; }
    </style>
</head>
<body>

    <!-- new Glassmorphism Navbar -->
    <nav class="glass-navbar">
        <h2>MGAHV _ FestHub</h2>
        <div>
            <a href="student_dashboard.jsp">Dashboard</a>
            <a href="view_available_events.jsp">Events</a>
            <a href="my_registrations.jsp">My Registrations</a>
            <a href="LogoutServlet" class="logout-btn">Logout</a>
        </div>
    </nav>

    <!--New Dashboard Wrapper -->
    <div class="dashboard-wrapper">
        <div class="glass-panel">
            <h2 style="margin-bottom: 25px;">My Event Registrations</h2>
            
            <%
                String userName = (String) session.getAttribute("user_name");
                String regNo = "";
                boolean hasRecords = false;

                try {
                    Connection conn = DBConnection.getConnection();
                    
                    // 1. get first student registration number
                    String getRegSql = "SELECT registration_no FROM students WHERE name = ?";
                    PreparedStatement psReg = conn.prepareStatement(getRegSql);
                    psReg.setString(1, userName);
                    ResultSet rsReg = psReg.executeQuery();
                    
                    if(rsReg.next()) {
                        regNo = rsReg.getString("registration_no");
                    }
                    
                    // 2. with the help of INNER JOIN find the events and students details 
                    String sql = "SELECT e.title, e.event_date, e.venue, p.activity_role, p.applied_at " +
                                 "FROM event_participants p " +
                                 "INNER JOIN events e ON p.event_id = e.event_id " +
                                 "WHERE p.registration_no = ? ORDER BY p.applied_at DESC";
                                 
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, regNo);
                    ResultSet rs = pstmt.executeQuery();
            %>
            
            <div style="overflow-x:auto;">
                <table>
                    <thead>
                        <tr>
                            <th>Event Title</th>
                            <th>Event Date & Venue</th>
                            <th>My Role</th>
                            <th>Registered On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            while(rs.next()) {
                                hasRecords = true;
                        %>
                        <tr>
                            <!-- use white color font so easily visible on dark background -->
                            <td style="font-weight: 600;"><%= rs.getString("title") %></td>
                            <td>
                                <div><%= rs.getString("event_date") %></div>
                                <div class="date-text"><%= rs.getString("venue") %></div>
                            </td>
                            <td><span class="role-badge"><%= rs.getString("activity_role") %></span></td>
                            <td class="date-text"><%= rs.getString("applied_at") %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
                
                <%
                    if(!hasRecords) {
                %>
                    <div class="empty-state">
                        You haven't registered for any events yet. <br><br>
                        <a href="view_available_events.jsp" style="color: #66b3ff; text-decoration: none; font-weight: 600; text-shadow: 1px 1px 2px rgba(0,0,0,0.5);">Browse Available Events</a>
                    </div>
                <%
                    }
                %>
                
            </div>
            
            <%
                } catch (Exception e) {
                    out.print("<div class='empty-state' style='color:#ffb3b3;'>Error fetching details: " + e.getMessage() + "</div>");
                    e.printStackTrace();
                }
            %>

        </div>
    </div>

</body>
</html>