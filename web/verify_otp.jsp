<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Verify OTP - FestHub</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    
   
    <div class="login-wrapper">
        <div class="glass-box">
            
            <h2 style="margin-bottom: 10px;">Email Verification</h2>
            <p style="color: #eeeeee; font-size: 14px; margin-bottom: 25px;">
                We've sent a 4-digit OTP to your email.<br>Please enter it below.
            </p>
            
            <!-- error message design -->
            <%
                String error = request.getParameter("error");
                if(error != null && error.equals("invalid_otp")) {
                    out.print("<div style='color: #ff4d4d; font-size: 14px; margin-bottom: 15px; font-weight: 500;'>Invalid OTP. Please try again!</div>");
                }
            %>
            
            <form action="VerifyOtpServlet" method="POST">
                <input type="text" name="user_otp" placeholder="Enter 4-Digit OTP" maxlength="4" required pattern="\d{4}" title="Please enter exactly 4 digits" style="text-align: center; letter-spacing: 5px; font-size: 18px; font-weight: bold;">
                
                <button type="submit">Verify & Register</button>
            </form>
            
        </div>
    </div>
    
</body>
</html>