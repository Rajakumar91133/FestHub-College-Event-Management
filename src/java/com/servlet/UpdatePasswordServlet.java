package com.servlet;

import com.db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdatePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // फॉर्म से नया पासवर्ड लें
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");
        
        // सेशन से यूज़र का ईमेल लें (जिसका पासवर्ड बदलना है)
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("reset_email");
        
        // सर्वर साइड पर भी एक बार चेक कर लें कि दोनों पासवर्ड सेम हैं या नहीं
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            response.sendRedirect("reset_password.jsp?error=mismatch");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            
            // डेटाबेस में नया पासवर्ड अपडेट करने की Query
            String sql = "UPDATE students SET password = ? WHERE email = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);
            
            int i = pstmt.executeUpdate();
            
            if (i > 0) {
                // SUCCESS: पासवर्ड बदल गया! सेशन से ईमेल डिलीट करें और लॉगिन पर भेजें
                session.removeAttribute("reset_email");
                session.removeAttribute("forgot_otp");
                response.sendRedirect("login.jsp?msg=password_updated");
            } else {
                // ERROR: अपडेट नहीं हो पाया
                response.sendRedirect("reset_password.jsp?error=server");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reset_password.jsp?error=server");
        }
    }
}