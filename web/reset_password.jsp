<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // सिक्योरिटी चेक: अगर कोई डायरेक्ट इस पेज पर आना चाहे तो उसे वापस भेज दो
    if(session.getAttribute("reset_email") == null) {
        response.sendRedirect("forgot_password.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FestHub - Reset Password</title>
    
    <!-- यूनिवर्सल CSS -->
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>

    <div class="login-wrapper">
        <div class="glass-box">
            <h2 style="margin-bottom: 15px;">Create New Password 🔐</h2>
            <p style="color: #dddddd; font-size: 14px; text-align: center; margin-bottom: 25px;">
                Enter a strong password for <strong><%= session.getAttribute("reset_email") %></strong>
            </p>
            
            <%
                String error = request.getParameter("error");
                if("mismatch".equals(error)) {
                    out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-size: 14px;'>⚠️ Passwords do not match! Please try again.</div>");
                } else if("server".equals(error)) {
                    out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-size: 14px;'>❌ Server error! Could not update password.</div>");
                }
            %>
            
            <!-- यह फॉर्म UpdatePasswordServlet पर जाएगा -->
            <form action="UpdatePasswordServlet" method="POST" onsubmit="return validatePasswords()">
                
                <input type="password" id="newPwd" name="new_password" placeholder="New Password (Strong)" 
                       pattern="^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])\S{8,}$" 
                       title="Must contain at least 8 characters, one uppercase, one lowercase, one number, one special character, and NO SPACES allowed" required>
                
                <input type="password" id="confirmPwd" name="confirm_password" placeholder="Confirm New Password" required>
                
                <button type="submit">Update Password</button>
            </form>
        </div>
    </div>

    <!-- JavaScript to check if both passwords match -->
    <script>
        function validatePasswords() {
            var pwd1 = document.getElementById("newPwd").value;
            var pwd2 = document.getElementById("confirmPwd").value;
            
            if (pwd1.indexOf(' ') >= 0 || pwd2.indexOf(' ') >= 0) {
                alert("Spaces are not allowed in the password!");
                return false;
            }
            if (pwd1 !== pwd2) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>