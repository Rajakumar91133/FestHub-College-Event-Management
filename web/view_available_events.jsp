<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.db.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: send to login page, if student not login
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
        <title>FestHub - Available Events </title>
        
       
        <link rel="stylesheet" type="text/css" href="css/style.css">
        
        <style>
            .event-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
                gap: 25px;
                margin-top: 20px;
            }
            
            .event-card {
                background: rgba(0, 0, 0, 0.4);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 12px;
                overflow: hidden;
                transition: 0.3s;
                display: flex;
                flex-direction: column;
            }
            
            .event-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.3);
                background: rgba(0, 0, 0, 0.6);
            }
            
            .event-banner {
                width: 100%;
                height: 180px;
                object-fit: cover;
                border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            }
            
            .event-content {
                padding: 20px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }
            
            .event-title {
                color: #ffffff;
                font-size: 20px;
                margin-bottom: 15px;
                font-weight: 600;
            }
            
            .event-detail {
                color: #eeeeee;
                font-size: 14px;
                margin-bottom: 8px;
            }
            .event-detail strong {
                color: #b3d4ff; 
            }
            
            .special-note {
                background: rgba(255, 255, 255, 0.1);
                padding: 10px;
                border-radius: 6px;
                font-size: 13px;
                color: #ffeb3b;
                margin-top: 10px;
                margin-bottom: 15px;
                border-left: 3px solid #ffeb3b;
            }
            
            .action-btns {
                display: flex;
                gap: 10px;
                margin-top: auto; 
                padding-top: 15px;
            }
            
            .btn-apply {
                flex: 1;
                background: rgba(255, 255, 255, 0.9);
                color: #1e3c72;
                text-align: center;
                padding: 10px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                transition: 0.3s;
            }
            .btn-apply:hover {
                background: #ffffff;
                box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            }
            
            .btn-notice {
                flex: 1;
                background: rgba(0, 0, 0, 0.5);
                color: #ffffff;
                text-align: center;
                padding: 10px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                border: 1px solid rgba(255, 255, 255, 0.3);
                transition: 0.3s;
            }
            .btn-notice:hover {
                background: rgba(255, 255, 255, 0.2);
            }
            
            .no-events {
                text-align: center;
                padding: 40px;
                color: #eeeeee;
                font-size: 16px;
                grid-column: 1 / -1;
            }

            .logout-btn { color: #ffb3b3 !important; }
            .logout-btn:hover { color: #ffffff !important; text-decoration: underline; }
            
            .msg-box { padding: 15px; border-radius: 5px; text-align: center; margin-bottom: 20px; font-weight: 500; }
        </style>
    </head>
    <body>

        
        <nav class="glass-navbar">
            <h2>MGAHV - FestHub Events</h2>
            <div>
                <a href="student_dashboard.jsp">Dashboard</a>
                <a href="view_available_events.jsp">Events</a>
                <a href="my_registrations.jsp">My Registrations</a>
                <a href="LogoutServlet" class="logout-btn">Logout</a>
            </div>
        </nav>

        
        <div class="dashboard-wrapper">
            <div class="glass-panel">
                <h2 style="margin-bottom: 25px;">Upcoming Approved Events</h2>

                
                <%
                    String msg = request.getParameter("msg");
                    if ("success".equals(msg)) {
                        out.print("<div class='msg-box' style='background: rgba(40, 167, 69, 0.2); border: 1px solid #28a745; color: #a3ffb4;'>🎉 Successfully Applied for the Event!</div>");
                    } else if ("already_applied".equals(msg)) {
                        out.print("<div class='msg-box' style='background: rgba(255, 193, 7, 0.2); border: 1px solid #ffc107; color: #ffeeba;'>⚠️ You have already registered for this event.</div>");
                    } else if ("error".equals(msg)) {
                        out.print("<div class='msg-box' style='background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; color: #ffb3b3;'>❌ Error processing your request. Please try again.</div>");
                    }
                %>

                <div class="event-grid">

                    <%
                        try {
                            Connection conn = DBConnection.getConnection();

                            // SABSE ZARURI LINE: Sirf wahi events dikhao jinka status 'Approved' hai!
                            String sql = "SELECT * FROM events WHERE status = 'Approved' AND event_date >= CURDATE() ORDER BY event_date ASC";

                            PreparedStatement pstmt = conn.prepareStatement(sql);
                            ResultSet rs = pstmt.executeQuery();

                            boolean found = false;

                            while (rs.next()) {
                                found = true;

                                // Data nikalna
                                int eventId = rs.getInt("event_id");
                                String title = rs.getString("title");
                                String eventDate = rs.getString("event_date");
                                String eventTime = rs.getString("event_time");
                                String venue = rs.getString("venue");
                                String chiefGuest = rs.getString("chief_guest");
                                String message = rs.getString("message");
                                String contactNo = rs.getString("contact_no");
                                String bannerPath = rs.getString("banner_path");
                                String noticePath = rs.getString("notice_path");

                                // Agar image nahi daali thi, toh ek default image dikhayein
                                if (bannerPath == null || bannerPath.trim().isEmpty()) {
                                    bannerPath = "https://via.placeholder.com/400x200?text=No+Banner+Available";
                                }
                    %>

                  
                    <div class="event-card">
                        <img src="<%= bannerPath%>" alt="Event Banner" class="event-banner">

                        <div class="event-content">
                            <h3 class="event-title"><%= title%></h3>

                            <div class="event-detail">
                                <strong>Date:</strong> <span><%= eventDate%></span>
                            </div>
                            <div class="event-detail">
                                <strong>Time:</strong> <span><%= eventTime%></span>
                            </div>
                            <div class="event-detail">
                                <strong>Venue:</strong> <span><%= venue%></span>
                            </div>

                            <% if (chiefGuest != null && !chiefGuest.trim().isEmpty()) {%>
                            <div class="event-detail">
                                <strong>Chief Guest:</strong> <span><%= chiefGuest%></span>
                            </div>
                            <% } %>

                            <% if (contactNo != null && !contactNo.trim().isEmpty()) {%>
                            <div class="event-detail">
                                <strong>Contact:</strong> <span>📞 <%= contactNo%></span>
                            </div>
                            <% } %>

                            <!-- Special Note/Message box -->
                            <% if (message != null && !message.trim().isEmpty()) {%>
                            <div class="special-note">
                                <strong>Note:</strong> <%= message%>
                            </div>
                            <% }%>

                            <div class="action-btns">
                                <a href="apply_event.jsp?event_id=<%= eventId%>" class="btn-apply">Apply Now</a>
                                <a href="<%= noticePath%>" target="_blank" class="btn-notice">View Notice</a>
                            </div>
                        </div>
                    </div>

                    <%
                        } // While loop end

                        // Agar koi 'Approved' event nahi mila
                        if (!found) {
                    %>
                    <div class="no-events">
                        No upcoming events available at the moment. Please check back later.
                    </div>
                    <%
                            }

                        } catch (Exception e) {
                            out.print("<div class='no-events' style='color:#ffb3b3;'>Error loading events: " + e.getMessage() + "</div>");
                        }
                    %>

                </div>
            </div>
        </div>

    </body>
</html>