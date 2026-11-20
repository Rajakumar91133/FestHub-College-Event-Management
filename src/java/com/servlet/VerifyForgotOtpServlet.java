package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class VerifyForgotOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // यूज़र ने जो OTP फॉर्म में डाला है
        String userOtp = request.getParameter("user_otp");
        
        // जो OTP हमने सेशन (Session) में सेव किया था
        HttpSession session = request.getSession();
        String generatedOtp = (String) session.getAttribute("forgot_otp");
        
        // दोनों OTP मैच करें
        if (generatedOtp != null && generatedOtp.equals(userOtp)) {
            // SUCCESS: OTP सही है! अब यूज़र को नया पासवर्ड बनाने वाले पेज पर भेज दें
            response.sendRedirect("reset_password.jsp");
        } else {
            // ERROR: OTP गलत है
            response.sendRedirect("verify_forgot_otp.jsp?error=invalid");
        }
    }
}