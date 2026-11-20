<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: if session does not contain user name then go back to login page 
    if (session.getAttribute("user_name") == null) {
        response.sendRedirect("login.jsp");
        return; // Yeh zaroori hai taaki aage ka code execute na ho
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FestHub - Student Dashboard </title>
    
    
    <link rel="stylesheet" type="text/css" href="css/style.css">
    
   
    <style>
       
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
        .welcome-card h2 { color: #ffffff; font-weight: 600; margin-bottom: 8px; font-size: 26px; text-shadow: 1px 1px 3px rgba(0,0,0,0.5); }
        .welcome-card h2 span { color: #ffeb3b;  } 
        .welcome-card p { color: #eeeeee; font-size: 16px; }

        /* Profile Details Glass Panel */
        .profile-panel {
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }
        
        .profile-panel h3 {
            color: #ffffff;
            margin-bottom: 25px;
            font-size: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 10px;
        }

        /* Profile Grid Layout */
        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .detail-item {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            transition: 0.3s;
        }
        .detail-item:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }
        
        .detail-item strong {
            display: block;
            font-size: 13px;
            color: #b3d4ff;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        .detail-item span {
            display: block;
            font-size: 16px;
            color: #ffffff;
            font-weight: 500;
        }

        /* Logout Button Note */
        .logout-btn { color: #ffb3b3 !important; }
        .logout-btn:hover { color: #ffffff !important; text-decoration: underline; }
    </style>
</head>
<body>

    
    <nav class="glass-navbar">
        <h2>MGAHV - FestHub <br> Raja Kumar</h2>
        <div>
            <a href="student_dashboard.jsp">Home</a>
            <a href="view_available_events.jsp">Events</a>
            <a href="my_registrations.jsp">My Registrations</a>
            <a href="LogoutServlet" class="logout-btn">Logout</a>
        </div>
    </nav>

    <!-- Dashboard Content Wrapper -->
    <div class="dashboard-wrapper" style="max-width: 900px; margin: 0 auto;">
        
        <!-- Welcome Section -->
        <div class="welcome-card">
            <h2>Welcome back, <span><%= session.getAttribute("user_name") %></span>!</h2>
            <p>You have successfully logged in to the MGAHV FestHub dashboard.</p>
        </div>

        <!-- Profile Details Section -->
        <div class="profile-panel">
            <h3>Your Profile Information</h3>
            <div class="details-grid">
                <div class="detail-item">
                    <strong>Full Name</strong>
                    <span><%= session.getAttribute("user_name") %></span>
                </div>
                <div class="detail-item">
                    <strong>Registration Number</strong>
                    <span><%= session.getAttribute("user_regno") %></span>
                </div>
                <div class="detail-item">
                    <strong>Email Address</strong>
                    <span><%= session.getAttribute("user_email") %></span>
                </div>
                <div class="detail-item">
                    <strong>Course</strong>
                    <span><%= session.getAttribute("user_course") %></span>
                </div>
                <div class="detail-item" style="grid-column: 1 / -1;">
                    <strong>Department</strong>
                    <span><%= session.getAttribute("user_department") %></span>
                </div>
            </div>
        </div>

    </div>

</body>
</html>