package com.servlet;

import com.utility.EmailUtility;
import java.io.IOException;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GenerateOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1.to get all data form form
        String name = request.getParameter("name");
        String regNo = request.getParameter("registration_no");

        if (!regNo.matches("^\\d{4}/\\d{2}/\\d{3}/\\d{3}$")) {
            // Agar format galat hai toh wapas register page par bhej dein
            response.sendRedirect("register.jsp?error=invalid_reg_format");
            return;
        }

        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String course = request.getParameter("course");
        String password = request.getParameter("password");

        // 2. 4 digit opt generate 
        Random random = new Random();
        int otp = 1000 + random.nextInt(9000);
        String otpString = String.valueOf(otp);

        // 3. Saving the data in the session (so that it can be inserted into MySQL after OTP verification)
        HttpSession session = request.getSession();
        session.setAttribute("temp_name", name);
        session.setAttribute("temp_regNo", regNo);
        session.setAttribute("temp_email", email);
        session.setAttribute("temp_department", department);
        session.setAttribute("temp_course", course);
        session.setAttribute("temp_password", password);

        // Save the OTP in the session too so we can match it later
        session.setAttribute("generated_otp", otpString);

        // 4. EmailUtility का उपयोग करके ईमेल भेजना
        boolean isEmailSent = EmailUtility.sendOTP(email, otpString);

        if (isEmailSent) {
            // If the email went through successfully, send it to the OTP verification page
            response.sendRedirect("verify_otp.jsp");
        } else {
            // If the email fails, send back to the registration page
            response.sendRedirect("register.jsp?error=email_failed");
        }
    }
}
