<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FestHub - Forgot Password</title>
    
    <!-- यूनिवर्सल CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>

    <div class="login-wrapper">
        <div class="glass-box">
            <h2 style="margin-bottom: 15px;">Forgot Password? 🔒</h2>
            <p style="color: #dddddd; font-size: 14px; text-align: center; margin-bottom: 25px;">
                Enter your registered email address below. We'll send you an OTP to reset your password.
            </p>
            
            <%
                String error = request.getParameter("error");
                if("not_found".equals(error)) {
                    out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-size: 14px;'>⚠️ Email not registered! Please check again.</div>");
                } else if("server".equals(error)) {
                    out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-size: 14px;'>❌ Server error! Could not send OTP.</div>");
                }
            %>
            
            <form action="SendForgotOtpServlet" method="POST">
                
                <input type="email" name="email" placeholder="Enter Registered Email" required>
                
                <button type="submit">Send OTP</button>
                
                <div style="margin-top: 20px; font-size: 14px; color: #eeeeee; text-align: center;">
                    Remembered your password? <br>
                    <a href="login.jsp" style="color: blue; text-decoration: none; font-weight: 600; display: inline-block; margin-top: 5px;">Back to Login</a>
                </div>
                
            </form>
        </div>
    </div>

</body>
</html>