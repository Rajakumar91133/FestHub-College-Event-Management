<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // सिक्योरिटी चेक: अगर सेशन में ईमेल नहीं है, तो वापस भेज दो
    if(session.getAttribute("reset_email") == null) {
        response.sendRedirect("forgot_password.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FestHub - Verify OTP</title>
    
    <!-- यूनिवर्सल CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>

    <div class="login-wrapper">
        <div class="glass-box">
            <h2 style="margin-bottom: 15px;">Enter OTP 📩</h2>
            <p style="color: #dddddd; font-size: 14px; text-align: center; margin-bottom: 25px;">
                An OTP has been sent to <strong><%= session.getAttribute("reset_email") %></strong>.
            </p>
            
            <%
                String error = request.getParameter("error");
                if("invalid".equals(error)) {
                    out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-size: 14px;'>⚠️ Invalid OTP! Please try again.</div>");
                }
            %>
            
            <!-- यह फॉर्म VerifyForgotOtpServlet पर जाएगा -->
            <form action="VerifyForgotOtpServlet" method="POST">
                
                <input type="text" name="user_otp" placeholder="Enter 4-digit OTP" required maxlength="4">
                
                <button type="submit">Verify OTP</button>
                
            </form>
        </div>
    </div>

</body>
</html>