package com.servlet;

import com.db.DBConnection;
import com.utility.EmailUtility; // आपकी Utility क्लास इम्पोर्ट कर ली
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SendForgotOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM students WHERE email = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // 4-digit OTP जनरेट करें 
                Random rand = new Random();
                int otp = 1000 + rand.nextInt(9000); 
                String generatedOtp = String.valueOf(otp);

                HttpSession session = request.getSession();
                session.setAttribute("forgot_otp", generatedOtp);
                session.setAttribute("reset_email", email);

                // ==========================================
                // आपकी EmailUtility का उपयोग करके सीधे ईमेल भेजें
                // ==========================================
                boolean isEmailSent = EmailUtility.sendOTP(email, generatedOtp);
                
                if (isEmailSent) {
                    // ईमेल सेंड होने के बाद OTP पेज पर भेजें
                    response.sendRedirect("verify_forgot_otp.jsp");
                } else {
                    response.sendRedirect("forgot_password.jsp?error=server");
                }
                
            } else {
                response.sendRedirect("forgot_password.jsp?error=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgot_password.jsp?error=server");
        }
    }
}