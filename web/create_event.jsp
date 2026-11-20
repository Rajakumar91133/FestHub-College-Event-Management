<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security check: for organiser
    if (session.getAttribute("org_id") == null) {
        response.sendRedirect("org_login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>FestHub - Create New Event </title>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        
        
        <style>
            .glass-panel label {
                font-weight: 500;
                font-size: 14px;
                color: #eeeeee;
            }
            .glass-panel input, .glass-panel textarea {
                width: 100%; padding: 12px 15px; margin-top: 8px; margin-bottom: 20px;
                background: rgba(255, 255, 255, 0.2); 
                border: 1px solid rgba(255, 255, 255, 0.5);
                border-radius: 6px; color: white; outline: none; font-size: 15px;
            }
            .glass-panel input::placeholder, .glass-panel textarea::placeholder {
                color: #dddddd;
            }
            .glass-panel input[type="file"] {
                padding: 9px 15px;
                background: rgba(255, 255, 255, 0.1);
            }
            .glass-panel button {
                width: 100%; background: rgba(255, 255, 255, 0.9);
                color: #1e3c72; padding: 14px; border: none;
                border-radius: 6px; font-size: 16px; font-weight: 600;
                cursor: pointer; transition: 0.3s; margin-top: 10px;
            }
            .glass-panel button:hover {
                background: #ffffff;
                box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0px 20px;
            }
            .full-width {
                grid-column: span 2;
            }
            .msg-box {
                padding: 10px; border-radius: 5px; margin-bottom: 20px; font-weight: 500;
            }
        </style>
    </head>
    <body>

       
        <nav class="glass-navbar">
            <h2>MGAHV - FestHub </h2>
            <div>
                <a href="org_dashboard.jsp">Back to Dashboard</a>
            </div>
        </nav>

       
        <div class="dashboard-wrapper">
            <div class="glass-panel" style="max-width: 800px; margin: 0 auto;">
                
                <h2 style="margin-bottom: 20px; text-align: center;">Host a New Event</h2>

                <!-- Messages -->
                <%
                    String msg = request.getParameter("msg");
                    if ("success".equals(msg)) {
                        out.print("<div class='msg-box' style='background: rgba(40, 167, 69, 0.2); border: 1px solid #28a745; color: #a3ffb4;'>Event Created Successfully! It is currently Pending Approval.</div>");
                    } else if ("error".equals(msg)) {
                        out.print("<div class='msg-box' style='background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; color: #ffb3b3;'>Failed to create event. Please try again.</div>");
                    }
                %>

                <!-- Create Event Form -->
                <form action="CreateEventServlet" method="POST" enctype="multipart/form-data">

                    <div class="form-grid">

                        <div class="full-width">
                            <label>Event Title / Name</label>
                            <input type="text" name="title" placeholder="e.g., Annual Tech Fest 2026" required>
                        </div>

                        <div>
                            <label>Event Date</label>
                            
                            <input type="date" name="event_date" required style="color-scheme: dark;">
                        </div>

                        <div>
                            <label>Event Time</label>
                            <input type="time" name="event_time" required style="color-scheme: dark;">
                        </div>

                        <div class="full-width">
                            <label>Venue (Location)</label>
                            <input type="text" name="venue" placeholder="e.g., Main Auditorium, MGAHV" required>
                        </div>

                        <div class="full-width">
                            <label>Chief Guest (Optional)</label>
                            <input type="text" name="chief_guest" placeholder="Name of the Chief Guest">
                        </div>

                        <div class="full-width">
                            <label>Special Note / Message (Optional)</label>
                            <textarea name="event_message" rows="3" placeholder="Any special instructions or note for students..." style="resize: none;"></textarea>
                        </div>

                        <div>
                            <label>Coordinator Contact No.</label>
                            <input type="text" name="contact_no" placeholder="e.g., 9876543210" pattern="[0-9]{10}" title="Enter 10 digit mobile number" maxlength="10" oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                        </div>

                        <div>
                            <!-- Placeholder div for spacing in grid -->
                        </div>

                        <div>
                            <label>Event Banner (Image)</label>
                            <input type="file" name="banner" accept="image/*">
                        </div>

                        <div>
                            <label>Permission Notice (PDF) *</label>
                            <input type="file" name="notice" accept="application/pdf" required>
                        </div>

                    </div> <!-- End Grid -->

                    <button type="submit">Submit Event Details</button>

                </form>
            </div>
        </div>

    </body>
</html>