<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>FestHub - Student Registration</title>

        <link rel="stylesheet" type="text/css" href="css/style.css">


        <style>
            .glass-box select {
                width: 100%; padding: 12px 15px; margin-bottom: 20px;
                background: rgba(255, 255, 255, 0.2); 
                border: 1px solid rgba(255, 255, 255, 0.5);
                border-radius: 6px; color: white; outline: none; font-size: 15px;
            }
            .glass-box select option, .glass-box select optgroup {
                background: #2a5298; 
                color: white;
            }
            .hidden-input { display: none; }
        </style>
    </head>
    <body>


        <div class="login-wrapper">
            <div class="glass-box">

                <h2 style="margin-bottom: 25px;">Student Registration</h2>

                <%
                    String error = request.getParameter("error");
                    if ("duplicate".equals(error)) {
                        out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-weight: 500;'>⚠️ Account already exists with this Email or Registration Number!</div>");
                    } else if ("server".equals(error)) {
                        out.print("<div style='color: #ffb3b3; background: rgba(220, 53, 69, 0.2); border: 1px solid #dc3545; padding: 12px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-weight: 500;'>❌ Server Error! Please try again later.</div>");
                    }
                %>

                <form action="GenerateOtpServlet" method="POST" onsubmit="return validatePassword()">


                    <input type="text" name="name" placeholder="Full Name" required>

                    <input type="text" name="registration_no" placeholder="Registration Number" pattern="\d{4}/\d{2}/\d{3}/\d{3}" title="Format should be exactly like: 2025/00/000/000" required>

                    <input type="email" name="email" placeholder="Email Address" required>

                    <!-- DEPARTMENT SECTION -->
                    <select name="department" id="deptSelect" onchange="checkDepartment(this)" required>
                        <option value="" disabled selected>Select your department</option>

                        <optgroup label="School of Language">
                            <option value="Department of Linguistics">Department of Linguistics</option>
                            <option value="Language Technology and Language Engineering">Language Technology and Language Engineering</option>
                            <option value="Department of English and Foreign Language Studies">Department of English and Foreign Language Studies</option>
                            <option value="Department of Indian Language Studies">Department of Indian Language Studies</option>
                        </optgroup>

                        <optgroup label="School of Literature">
                            <option value="Department of Hindi Literature">Department of Hindi Literature</option>
                            <option value="Department of Performing Arts">Department of Performing Arts</option>
                            <option value="Department of Cinema Studies">Department of Cinema Studies</option>
                            <option value="Department of Sanskrit Literature">Department of Sanskrit Literature</option>
                            <option value="Department of Marathi Literature">Department of Marathi Literature</option>
                        </optgroup>

                        <optgroup label="School of Culture">
                            <option value="Department of Gandhi and Peace Studies">Department of Gandhi and Peace Studies</option>
                            <option value="Department of Women Studies">Department of Women Studies</option>
                            <option value="Centre for Dr. B.S.A.S.K.M.D.T.S.">Centre for Dr. B.S.A.S.K.M.D.T.S.</option>
                            <option value="Centre for Dr. B.A.K.Buddhist Studies">Centre for Dr. B.A.K.Buddhist Studies</option>
                            <option value="Department of Philosophy and Culture">Department of Philosophy and Culture</option>
                        </optgroup>

                        <optgroup label="School of Translation & Interpretation">
                            <option value="Centre for Advanced Research and Knowledge Creation">Centre for Advanced Research and Knowledge Creation</option>
                            <option value="Department of Comparative Literature">Department of Comparative Literature</option>
                            <option value="Department of Translation Studies">Department of Translation Studies</option>
                            <option value="Department of Shri Chamanlal Migration & Diaspora Studies">Department of Shri Chamanlal Migration & Diaspora Studies</option>
                        </optgroup>

                        <optgroup label="School of Humanities & Social Sciences">
                            <option value="Department of Mass Communication">Department of Mass Communication</option>
                            <option value="Department of Anthropology">Department of Anthropology</option>
                            <option value="Department of History">Department of History</option>
                            <option value="Department of Political Science">Department of Political Science</option>
                            <option value="Department of Sociology">Department of Sociology</option>
                        </optgroup>

                        <optgroup label="School of Education">
                            <option value="Department of Education">Department of Education</option>
                            <option value="Department of Psychology">Department of Psychology</option>
                        </optgroup>

                        <optgroup label="School of Management">
                            <option value="Department of Commerce & Management">Department of Commerce & Management</option>
                        </optgroup>

                        <optgroup label="School of Law">
                            <option value="Department of Law">Department of Law</option>
                        </optgroup>

                        <!-- OTHER OPTION -->
                        <option value="Other" style="font-weight:bold; color:#ffb3b3;">Other (Type your Department)</option>
                    </select>

                    <input type="text" id="otherDeptInput" class="hidden-input" placeholder="Type your Department name">

                    <!-- COURSE SECTION -->
                    <select name="course" id="courseSelect" onchange="checkCourse(this)" required>
                        <option value="" disabled selected>Select your course</option>
                        <option value="MCA">MCA</option>
                        <option value="BCA">BCA</option>
                        <option value="MBA">MBA</option>
                        <option value="B.Ed">B.Ed</option>
                        <option value="M.A.">M.A.</option>
                        <option value="B.A.">B.A.</option>
                        <!-- OTHER OPTION -->
                        <option value="Other" style="font-weight:bold; color:#ffb3b3;">Other (Type your Course)</option>
                    </select>

                    <input type="text" id="otherCourseInput" class="hidden-input" placeholder="Type your Course name">

                    <!-- PASSWORD SECTION -->
                    <input type="password" id="passwordField" name="password" placeholder="Create Password (Strong & No spaces)" 
                           pattern="^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])\S{8,}$" 
                           title="Must contain at least 8 characters, one uppercase, one lowercase, one number, one special character, and NO SPACES allowed" 
                           onkeydown="if (event.keyCode === 32)
                                   return false;" 
                           oninput="this.value = this.value.replace(/\s/g, '');"
                           required>

                    <button type="submit">Send OTP to Email</button>

                    <div style="margin-top: 20px; font-size: 14px; color: #eeeeee;">
                        Already have an account? <a href="login.jsp" style="color: blue; text-decoration: none; font-weight: 600; text-shadow: 1px 1px 2px rgba(0,0,0,0.5);">Login here</a>
                    </div>

                </form>
            </div>
        </div>

        <!-- JavaScript Logic (Same as before) -->
        <script>
            function checkDepartment(selectObj) {
                var otherInput = document.getElementById("otherDeptInput");
                if (selectObj.value === "Other") {
                    otherInput.style.display = "block";
                    otherInput.name = "department";
                    selectObj.name = "";
                    otherInput.required = true;
                } else {
                    otherInput.style.display = "none";
                    selectObj.name = "department";
                    otherInput.name = "";
                    otherInput.required = false;
                }
            }

            function checkCourse(selectObj) {
                var otherInput = document.getElementById("otherCourseInput");
                if (selectObj.value === "Other") {
                    otherInput.style.display = "block";
                    otherInput.name = "course";
                    selectObj.name = "";
                    otherInput.required = true;
                } else {
                    otherInput.style.display = "none";
                    selectObj.name = "course";
                    otherInput.name = "";
                    otherInput.required = false;
                }
            }

            function validatePassword() {
                var pwd = document.getElementById("passwordField").value;
                if (pwd.indexOf(' ') >= 0) {
                    alert("Spaces are not allowed in the password!");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>