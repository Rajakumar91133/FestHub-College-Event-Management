<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>FestHub - Admin/Organizer Login</title>
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
                String error = request.getParameter("error");
                if ("invalid".equals(error)) {
                    out.print("<div style='color: #ff4d4d; font-size: 14px; margin-bottom: 15px; font-weight: 500;'>Invalid Email or Password!</div>");
                }
            %>

            <form action="OrgLoginServlet" method="POST">

                <input type="email" name="email" placeholder="Enter staff email" required>

                <input type="password" name="password" placeholder="Enter password" required>

                <button type="submit">Login</button>
            </form>

        </div>
    </div>

</body>
</html>