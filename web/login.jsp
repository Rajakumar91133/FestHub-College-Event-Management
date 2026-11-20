<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>FestHub - Student Login</title>
        <link rel="stylesheet" type="text/css" href="css/style.css">

    <center>  
        <br>
        <h1 style="color: #04046E;">महात्मा गांधी अंतरराष्ट्रीय हिंदी विश्वविद्यालय, वर्धा</h1>
        <h2 style="color: appworkspace">Mahatma Gandhi Antarrashtriya Hindi VishwaVidyalaya,Wardha</h2>
    </center> 

</head>
<body>

    <div class="login-wrapper">
        <div class="glass-box">
            <h2>FestHub - Sign In</h2>

            <%
                // सभी वेरिएबल्स सिर्फ एक बार यहाँ डिक्लेअर किए गए हैं
                String error = request.getParameter("error");
                String msg = request.getParameter("msg");

                // 1. ERROR MESSAGES
                if ("invalid".equals(error)) {
                    out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-weight: 500; font-size: 14px;'>⚠️ Account does not exist or Invalid Password! Please create an account.</div>");
                }

                // 2. SUCCESS MESSAGES
                if ("registered".equals(msg)) {
                    out.print("<div style='color: #a3ffb4; background: rgba(40, 167, 69, 0.2); border: 1px solid #28a745; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-weight: 500; font-size: 14px;'>🎉 Account Created Successfully! Please login.</div>");
                } else if ("password_updated".equals(msg)) {
                    out.print("<div style='color: #a3ffb4; background: rgba(40, 167, 69, 0.2); border: 1px solid #28a745; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-weight: 500; font-size: 14px;'>✅ Password updated successfully! Please login with your new password.</div>");
                }
            %>

            <form action="LoginServlet" method="post">
                <input type="email" name="email" placeholder="Enter Email Address" required>
                <input type="password" name="password" placeholder="Enter Password" required>
                <button type="submit">Login</button>

                <div style="text-align: right; margin-top: -2px; margin-bottom: 15px;">
                    <a href="forgot_password.jsp" style="color: #ffeb3b; text-decoration: none; font-size: 13px; font-weight: 500;">Forgot Password?</a>
                </div> 

            </form>

            <div class="register-link">
                Don't have an account? <a href="register.jsp">Register Here</a>
            </div>
        </div>
    </div>

</body>
</html>