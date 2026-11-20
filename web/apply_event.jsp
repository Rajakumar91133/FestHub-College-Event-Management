<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security Check: student login important.
    if (session.getAttribute("user_name") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    //  get Event ID from url
    String eventId = request.getParameter("event_id");
    if(eventId == null || eventId.trim().isEmpty()) {
        response.sendRedirect("view_available_events.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Registration Form - FestHub</title>
    
    <!-- universal CSS  -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
    
    <!-- custom design for dropdown and Cancel button -->
    <style>
        .glass-box select {
            width: 100%; padding: 12px 15px; margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.2); 
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 6px; color: white; outline: none; font-size: 15px;
        }
        .glass-box select option {
            background: #2a5298;
            color: white;
        }
        
        .cancel-link {
            display: inline-block;
            margin-top: 15px;
            color: #ffb3b3;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
        }
        .cancel-link:hover {
            color: #ffffff;
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <!-- new Glassmorphism   -->
    <div class="login-wrapper">
        <div class="glass-box">
            
            <h2 style="margin-bottom: 10px;">Event Registration</h2>
            <p style="color: #eeeeee; font-size: 14px; margin-bottom: 25px;">
                Please provide additional details to join the event.
            </p>
            
            <!-- form data send by POST method to Servlet -->
            <form action="ApplyEventServlet" method="POST">
                <!-- send Event ID hidden  -->
                <input type="hidden" name="event_id" value="<%= eventId %>">
                
                <!-- remove from label and shift in placeholder-->
                <input type="text" name="phone_number" placeholder="WhatsApp / Phone Number" required pattern="[0-9]{10}" title="Please enter a valid 10-digit number">
                
                <select name="activity_role" required>
                    <option value="" disabled selected>-- Select your Role --</option>
                    <option value="Audience">Audience </option>
                    <option value="Volunteer">Event Volunteer</option>
                    <option value="Performer">Performer / Participant</option>
                    <option value="Anchor">Anchor / Host</option>
                </select>
                
                <button type="submit">Confirm Registration</button>
                
                <a href="view_available_events.jsp" class="cancel-link">Cancel</a>
            </form>
            
        </div>
    </div>

</body>
</html>