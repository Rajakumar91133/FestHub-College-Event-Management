<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check
    if (session.getAttribute("org_id") == null) {
        response.sendRedirect("org_login.jsp");
        return;
    }
    
    // find user role (Admin or Staff)from session
    String role = (String) session.getAttribute("org_role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Organizer Dashboard - FestHub</title>
    
    
    <link rel="stylesheet" type="text/css" href="css/style.css">
    
    
    <style>
        /* welcome.. */
        .welcome-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .welcome-card h2 { color: #ffffff; font-weight: 600; margin-bottom: 8px; font-size: 26px; }
        .welcome-card h2 span { color: #ffeb3b; /* for highlight name  */ } 
        .welcome-card p { color: #eeeeee; font-size: 16px; }

        
        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .action-card {
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 30px 25px;
            text-align: center;
            transition: 0.3s;
        }
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            background: rgba(0, 0, 0, 0.6);
        }
        .action-card h3 { color: #ffffff; margin-bottom: 12px; font-size: 20px; }
        .action-card p { color: #cccccc; font-size: 14px; margin-bottom: 25px; min-height: 42px; }
        
        .action-card a {
            display: inline-block;
            background: rgba(255, 255, 255, 0.9);
            color: #1e3c72;
            padding: 12px 25px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }
        .action-card a:hover {
            background: #ffffff;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        
        /* Logout Button Note */
        .logout-btn { color: #ffb3b3 !important; }
        .logout-btn:hover { color: #ffffff !important; text-decoration: underline; }
    </style>
</head>
<body>

    
    <nav class="glass-navbar">
        <h2>MGAHV - FestHub </h2>
        
        <div>
            <a href="org_dashboard.jsp">Dashboard</a>
            
            <!-- Navbar link change on the basis of role -->
            <% if("Admin".equals(role)) { %>
                <a href="view_events.jsp">Manage Events</a>
            <% } else if("Staff".equals(role)) { %>
                <a href="create_event.jsp">Create Event</a>
            <% } %>
            
            <a href="LogoutServlet?type=org" class="logout-btn">Logout</a>
        </div>
    </nav>

    
    <div class="dashboard-wrapper" style="max-width: 1000px; margin: 0 auto;">
        
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h2>Welcome, <span><%= session.getAttribute("org_name") %></span>!</h2>
            <p>Role: <strong><%= role %></strong> | Email: <%= session.getAttribute("org_email") %></p>
        </div>

        <!-- Action Grid -->
        <div class="action-grid">
            
            <!-- only Staff have the create event option -->
            <% if("Staff".equals(role)) { %>
            <div class="action-card">
                <h3>Create New Event</h3>
                <p>Host a new seminar, workshop, or cultural event for the students.</p>
                <a href="create_event.jsp">+ Create Event</a>
            </div>
            <% } %>
            
            <!-- only admin have the approval button -->
            <% if("Admin".equals(role)) { %>
            <div class="action-card">
                <h3>Manage / Approve Events</h3>
                <p>View pending events, check notices, and approve or reject them.</p>
                <a href="view_events.jsp">Manage Events</a>
            </div>
            <% } %>
            
            <!-- both able to see reports -->
            <div class="action-card">
                <h3>Student Reports</h3>
                <p>Export event participation lists and generate attendance reports.</p>
                <a href="event_reports.jsp">View Reports</a>
            </div>
            
        </div>
    </div>

</body>
</html>