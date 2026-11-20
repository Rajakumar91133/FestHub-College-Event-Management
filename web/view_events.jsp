<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.db.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security Check: able to see only login organiser.
    if (session.getAttribute("org_id") == null) {
        response.sendRedirect("org_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FestHub - Admin Panel</title>
    
   
    <link rel="stylesheet" type="text/css" href="css/style.css">
    
    
    <style>
        /* Table Styling */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; color: white; }
        th, td { padding: 15px 12px; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.2); font-size: 14px; }
        th { background: rgba(0, 0, 0, 0.4); font-weight: 500; text-transform: uppercase; font-size: 13px; }
        tr:hover { background: rgba(255, 255, 255, 0.05); }

        /* Status Badges */
        .badge {
            padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; display: inline-block;
        }
        .badge-pending { background: rgba(255, 193, 7, 0.2); color: #ffeb3b; border: 1px solid #ffc107; }
        .badge-approved { background: rgba(40, 167, 69, 0.2); color: #a3ffb4; border: 1px solid #28a745; }
        .badge-rejected { background: rgba(220, 53, 69, 0.2); color: #ffb3b3; border: 1px solid #dc3545; }

        /* Action Buttons (Approve/Reject) */
        .btn {
            padding: 6px 12px; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600; 
            transition: 0.3s; display: inline-block; margin-right: 5px; margin-bottom: 5px;
        }
        .btn-approve { background: rgba(40, 167, 69, 0.8); color: white; border: 1px solid #28a745; }
        .btn-approve:hover { background: rgba(40, 167, 69, 1); box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
        
        .btn-reject { background: rgba(220, 53, 69, 0.8); color: white; border: 1px solid #dc3545; }
        .btn-reject:hover { background: rgba(220, 53, 69, 1); box-shadow: 0 4px 10px rgba(0,0,0,0.3); }

        /* Attachment Links */
        .attach-link {
            padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500; text-decoration: none;
            display: inline-block; margin-bottom: 5px; transition: 0.3s; color: white;
        }
        .attach-banner { background: rgba(243, 156, 18, 0.8); border: 1px solid #f39c12; }
        .attach-notice { background: rgba(52, 152, 219, 0.8); border: 1px solid #3498db; }
        .attach-link:hover { filter: brightness(1.2); }

        .msg-success { background: rgba(40, 167, 69, 0.2); border: 1px solid #28a745; color: #a3ffb4; padding: 15px; border-radius: 5px; text-align: center; margin-bottom: 20px; font-weight: 500; }
        
        .logout-btn { color: #ffb3b3 !important; }
        .logout-btn:hover { color: #ffffff !important; text-decoration: underline; }
    </style>
</head>
<body>

  
    <nav class="glass-navbar">
        <h2>MGAHV - FestHub Events</h2>
        <div>
            <a href="org_dashboard.jsp">Dashboard</a>
            <a href="LogoutServlet?type=org" class="logout-btn">Logout</a>
        </div>
    </nav>

    <!-- Dashboard Wrapper -->
    <div class="dashboard-wrapper">
        <div class="glass-panel">
            <h2 style="margin-bottom: 20px;">Manage Events (Approve / Reject)</h2>
            
            <%
                String msg = request.getParameter("msg");
                if("updated".equals(msg)) {
                    out.print("<div class='msg-success'>Event status updated successfully!</div>");
                }
            %>

            <div style="overflow-x:auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Event Title</th>
                            <th>Date & Venue</th>
                            <th>Status</th>
                            <th>Attachments</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Connection conn = DBConnection.getConnection();
                                //all event ,but new one on the top
                                String sql = "SELECT * FROM events ORDER BY event_id DESC";
                                PreparedStatement pstmt = conn.prepareStatement(sql);
                                ResultSet rs = pstmt.executeQuery();
                                
                                while(rs.next()) {
                                    int id = rs.getInt("event_id");
                                    String status = rs.getString("status");
                                    
                                    // get path of banner and notice from database 
                                    String bannerPath = rs.getString("banner_path");
                                    String noticePath = rs.getString("notice_path");
                                    
                                    // Date Formatting
                                    String eventDate = rs.getString("event_date");
                                    String venue = rs.getString("venue");
                        %>
                        <tr>
                            <td style="font-weight: 600; color: #b3d4ff;">#<%= id %></td>
                            <td style="font-weight: 500;"><%= rs.getString("title") %></td>
                            <td>
                                <div><%= eventDate %></div>
                                <div style="font-size:12px; color:#dddddd; margin-top:3px;"><%= venue %></div>
                            </td>
                            <td>
                                <!-- according to Status visible color Badge  -->
                                <% if("Pending".equals(status)) { %>
                                    <span class="badge badge-pending">Pending</span>
                                <% } else if("Approved".equals(status)) { %>
                                    <span class="badge badge-approved">Approved</span>
                                <% } else { %>
                                    <span class="badge badge-rejected">Rejected</span>
                                <% } %>
                            </td>
                            
                            <!-- Attachments  -->
                            <td>
                                <% if(bannerPath != null && !bannerPath.trim().isEmpty()) { %>
                                    <a href="<%= bannerPath %>" target="_blank" class="attach-link attach-banner">🖼️ Banner</a><br>
                                <% } else { %>
                                    <span style="font-size:12px; color:#999999; display:block; margin-bottom:4px;">No Banner</span>
                                <% } %>

                                <% if(noticePath != null && !noticePath.trim().isEmpty()) { %>
                                    <a href="<%= noticePath %>" target="_blank" class="attach-link attach-notice">📄 Notice</a>
                                <% } else { %>
                                    <span style="font-size:12px; color:#999999; display:block;">No Notice</span>
                                <% } %>
                            </td>

                            <!-- Action -->
                            <td>
                                <!-- if Status Pending then show Approve/Reject button,other wise not -->
                                <% if("Pending".equals(status)) { %>
                                    <!-- this link UpdateStatusServlet ko ID or Action send karega  -->
                                    <a href="UpdateStatusServlet?id=<%= id %>&action=Approve" class="btn btn-approve">Approve</a>
                                    <a href="UpdateStatusServlet?id=<%= id %>&action=Reject" class="btn btn-reject">Reject</a>
                                <% } else { %>
                                    <span style="color:#aaaaaa; font-size:12px; font-style:italic;">No Action Needed</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            } catch(Exception e) {
                                out.print("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>